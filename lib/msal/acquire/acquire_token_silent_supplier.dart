

import 'package:microsoft_authentication/msal/abstract/abstract_client_application_base.dart';
import 'package:microsoft_authentication/msal/authority/authority.dart';
import 'package:microsoft_authentication/msal/authority/authority_type.dart';
import 'package:microsoft_authentication/msal/msal/msal_client_exception.dart';
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

import 'acquire_token_by_authorization_grantSupplier.dart';

class AcquireTokenSilentSupplier extends AuthenticationResultSupplier {

     SilentRequest silentRequest;
     AbstractClientApplicationBase clientApplication;

    AcquireTokenSilentSupplier(AbstractClientApplicationBase clientApplication, SilentRequest silentRequest) {
        this.silentRequest = silentRequest;
        this.clientApplication = clientApplication;
    }

    @Override
    AuthenticationResult execute(){
        Authority requestAuthority = silentRequest.requestAuthority();
        if (requestAuthority.authorityType != AuthorityType.B2C) {
            requestAuthority =
                    getAuthorityWithPrefNetworkHost(silentRequest.requestAuthority().authority());
        }

        AuthenticationResult res;

        if (silentRequest.parameters().account() == null) {
            res = clientApplication.tokenCache.getCachedAuthenticationResult(
                    requestAuthority,
                    silentRequest.parameters().scopes(),
                    clientApplication.clientId);
        } else {
            res = clientApplication.tokenCache.getCachedAuthenticationResult(
                    silentRequest.parameters().account(),
                    requestAuthority,
                    silentRequest.parameters().scopes(),
                    clientApplication.clientId);

            if (res == null) {
                throw new MsalClientException(message: AuthenticationErrorMessage.NO_TOKEN_IN_CACHE, errorCode: AuthenticationErrorCode.CACHE_MISS);
            }

            if (!StringHelper.isBlank(res.accessToken())) {
                clientApplication.getServiceBundle().getServerSideTelemetry().incrementSilentSuccessfulCount();
            }

            //Determine if the current token needs to be refreshed according to the refresh_in value
            int currTimeStampSec = new Date().getTime() / 1000;
            bool afterRefreshOn = res.refreshOn() != null && res.refreshOn() > 0 &&
                    res.refreshOn() < currTimeStampSec && res.expiresOn() >= currTimeStampSec;

            if (silentRequest.parameters().forceRefresh() || afterRefreshOn || StringHelper.isBlank(res.accessToken())) {
                if (!StringHelper.isBlank(res.refreshToken())) {
                    RefreshTokenRequest refreshTokenRequest = new RefreshTokenRequest(
                            RefreshTokenParameters.builder(silentRequest.parameters().scopes(), res.refreshToken()).build(),
                            silentRequest.application(),
                            silentRequest.requestContext(),
                            silentRequest);

                    AcquireTokenByAuthorizationGrantSupplier acquireTokenByAuthorisationGrantSupplier =
                            new AcquireTokenByAuthorizationGrantSupplier(clientApplication, refreshTokenRequest, requestAuthority);

                    try {
                        res = acquireTokenByAuthorisationGrantSupplier.execute();
                    } catch (ex) {
                        //If the token refresh attempt threw a MsalServiceException but the refresh attempt was done
                        // only because of refreshOn, then simply return the existing cached token
                        if (afterRefreshOn && !(silentRequest.parameters().forceRefresh() || StringHelper.isBlank(res.accessToken()))) {
                            return res;
                        }
                        else throw ex;
                    }
                } else {
                    res = null;
                }
            }
        }
        if (res == null || StringHelper.isBlank(res.accessToken())) {
            throw new MsalClientException(message: AuthenticationErrorMessage.NO_TOKEN_IN_CACHE, errorCode: AuthenticationErrorCode.CACHE_MISS);
        }

        return res;
    }
}
