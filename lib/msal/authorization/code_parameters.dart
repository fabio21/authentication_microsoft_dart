
///
/// Object containing parameters for authorization code flow. Can be used as parameter to
/// {@link PublicClientApplication#acquireToken(AuthorizationCodeParameters)} or to
/// {@link ConfidentialClientApplication#acquireToken(AuthorizationCodeParameters)}
///

 class AuthorizationCodeParameters implements IApiParameters {

    ///
    /// Authorization code acquired in the first step of OAuth2.0 authorization code flow. For more
    /// details, see https://aka.ms/msal4j-authorization-code-flow
    ///
    String authorizationCode;

    ///
    /// Redirect URI registered in the Azure portal, and which was used in the first step of OAuth2.0
    /// authorization code flow. For more details, see https://aka.ms/msal4j-authorization-code-flow
    ///

    Uri redirectUri;

    ///
    /// Scopes to which the application is requesting access
    ///
    Set<String> scopes;

    ///
    /// Claims to be requested through the OIDC claims request parameter, allowing requests for standard and custom claims
    ///
    ClaimsRequest claims;

    ///
    /// Code verifier used for PKCE. For more details, see https://tools.ietf.org/html/rfc7636
    ///
    String codeVerifier;

    static AuthorizationCodeParametersBuilder builder() {

        return new AuthorizationCodeParametersBuilder();
    }

    ///
    /// Builder for {@link AuthorizationCodeParameters}
    /// @param authorizationCode code received from the service authorization endpoint
    /// @param redirectUri URI where authorization code was received
    /// @return builder object that can be used to construct {@link AuthorizationCodeParameters}
    ///
    static AuthorizationCodeParametersBuilder builder(String authorizationCode, Uri redirectUri) {

        validateNotBlank("authorizationCode", authorizationCode);

        return builder()
                .authorizationCode(authorizationCode)
                .redirectUri(redirectUri);
    }
}
