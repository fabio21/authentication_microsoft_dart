
import 'package:http/http.dart';
import 'package:microsoft_authentication/msal/abstract/abstract_client_application_base.dart';
import 'package:microsoft_authentication/msal/abstract/abstract_msal_authorization_grant.dart';
import 'package:microsoft_authentication/msal/authentication/authentication_result_supplier.dart';
import 'package:microsoft_authentication/msal/authority/authority.dart';
import 'package:microsoft_authentication/msal/authority/authority_type.dart';
import 'package:microsoft_authentication/msal/msal/msal_client_exception.dart';
import 'package:microsoft_authentication/msal/msal/msal_interaction_required_exception.dart';
import 'package:microsoft_authentication/msal/msal/msal_request.dart';

class AcquireTokenByAuthorizationGrantSupplier extends AuthenticationResultSupplier {

     Authority _requestAuthority;
     MsalRequest _msalRequest;
     AbstractClientApplicationBase _clientApplication;

    AcquireTokenByAuthorizationGrantSupplier(AbstractClientApplicationBase clientApplication,
                                             MsalRequest msalRequest,
                                             Authority authority) : super(clientApplication,  null) {
        this._msalRequest = msalRequest;
        this._requestAuthority = authority;
        this._clientApplication = clientApplication;
    }

    AuthenticationResult execute()  {
        AbstractMsalAuthorizationGrant authGrant = _msalRequest.msalAuthorizationGrant;

        if (IsUiRequiredCacheSupported()) {
            MsalInteractionRequiredException cachedEx =
                    InteractonRequiredCache.getCachedInteractionRequiredException(
                            (RefreshTokenRequest) _msalRequest).getFullThumbprint());
            if (cachedEx != null) {
                throw cachedEx;
            }
        }

        if (authGrant is OAuthAuthorizationGrant) {
            _msalRequest.msalAuthorizationGrant =
                    processPasswordGrant((OAuthAuthorizationGrant) authGrant);
        }

        if (authGrant is IntegratedWindowsAuthorizationGrant) {
            IntegratedWindowsAuthorizationGrant integratedAuthGrant =
                    (IntegratedWindowsAuthorizationGrant) authGrant;
            _msalRequest.msalAuthorizationGrant =
                    new OAuthAuthorizationGrant(getAuthorizationGrantIntegrated(
                            integratedAuthGrant.getUserName()), integratedAuthGrant.getScopes(), integratedAuthGrant.getClaims());
        }

        if (_requestAuthority == null) {
            _requestAuthority = _clientApplication.authenticationAuthority;
        }

        if (_requestAuthority.authorityType == AuthorityType.AAD) {
            _requestAuthority = getAuthorityWithPrefNetworkHost(_requestAuthority.authority);
        }

        try {
            return _clientApplication.acquireTokenCommon(_msalRequest, _requestAuthority);
        } catch (ex) {
            if (IsUiRequiredCacheSupported()) {
                InteractionRequiredCache.set(((RefreshTokenRequest) _msalRequest).getFullThumbprint(), ex);
            }
            throw ex;
        }
    }

     bool IsUiRequiredCacheSupported() {
        return _msalRequest is RefreshTokenRequest &&
                _clientApplication is PublicClientApplication;
    }

     OAuthAuthorizationGrant processPasswordGrant(OAuthAuthorizationGrant authGrant)  {

        if (!(authGrant.getAuthorizationGrant() is ResourceOwnerPasswordCredentialsGrant)) {
            return authGrant;
        }

        if (_msalRequest.application.authenticationAuthority.authorityType != AuthorityType.AAD) {
            return authGrant;
        }

        ResourceOwnerPasswordCredentialsGrant grant =
                (ResourceOwnerPasswordCredentialsGrant) authGrant.getAuthorizationGrant();

        UserDiscoveryResponse userDiscoveryResponse = UserDiscoveryRequest.execute(
                this.clientApplication.authenticationAuthority.getUserRealmEndpoint(grant.getUsername()),
                _msalRequest.headers,
                _msalRequest.requestContext,
                this._clientApplication.getServiceBundle());

        if (userDiscoveryResponse.isAccountFederated()) {
            WSTrustResponse response = WSTrustRequest.execute(
                    userDiscoveryResponse.federationMetadataUrl(),
                    grant.getUsername(),
                    grant.getPassword().getValue(),
                    userDiscoveryResponse.cloudAudienceUrn(),
                    _msalRequest.requestContext(),
                    this._clientApplication.getServiceBundle(),
                    this._clientApplication.logPii);

            AuthorizationGrant updatedGrant = getSAMLAuthorizationGrant(response);

            authGrant = new OAuthAuthorizationGrant(updatedGrant, authGrant.getCustomParameters());
        }
        return authGrant;
    }

     AuthorizationGrant getSAMLAuthorizationGrant(WSTrustResponse response) {
        AuthorizationGrant updatedGrant;
        if (response.isTokenSaml2()) {
            updatedGrant = new SAML2BearerGrant(new Base64URL(
                    Base64.getEncoder().encodeToString(response.getToken().getBytes(StandardCharsets.UTF_8))));
        } else {
            updatedGrant = new SAML11BearerGrant(new Base64URL(
                    Base64.getEncoder().encodeToString(response.getToken()
                            .getBytes(StandardCharsets.UTF_8))));
        }
        return updatedGrant;
    }

    AuthorizationGrant getAuthorizationGrantIntegrated(String userName)  {
        AuthorizationGrant updatedGrant;

        String userRealmEndpoint = this._clientApplication.authenticationAuthority.
                getUserRealmEndpoint(URLEncoder.encode(userName, StandardCharsets.UTF_8.name()));

        // Get the realm information
        UserDiscoveryResponse userRealmResponse = UserDiscoveryRequest.execute(
                userRealmEndpoint,
                _msalRequest.headers,
                _msalRequest.requestContext(),
                this._clientApplication.getServiceBundle());

        if (userRealmResponse.isAccountFederated() &&
                "WSTrust".contains(userRealmResponse.federationProtocol())) {

            String mexURL = userRealmResponse.federationMetadataUrl();
            String cloudAudienceUrn = userRealmResponse.cloudAudienceUrn();

            // Discover the policy for authentication using the Metadata Exchange Url.
            // Get the WSTrust Token (Web Service Trust Token)
            WSTrustResponse wsTrustResponse = WSTrustRequest.execute(
                    mexURL,
                    cloudAudienceUrn,
                    _msalRequest.requestContext(),
                    this._clientApplication.getServiceBundle(),
                    this._clientApplication.logPii);

            updatedGrant = getSAMLAuthorizationGrant(wsTrustResponse);
        } else if (userRealmResponse.isAccountManaged()) {
            throw new MsalClientException(
                    message: "Password is required for managed user",
                    errorCode:  AuthenticationErrorCode.PASSWORD_REQUIRED_FOR_MANAGED_USER);
        } else {
            throw new MsalClientException(
                message: "User Realm request failed",
                errorCode: AuthenticationErrorCode.USER_REALM_DISCOVERY_FAILED);
        }

        return updatedGrant;
    }
}
