
class ClientCredentialParameters implements IApiParameters {

    ///
    /// Scopes for which the application is requesting access to.
   ///

   Set<String> scopes;

   ///
   /// Claims to be requested through the OIDC claims request parameter, allowing requests for standard and custom claims
   ///
   ClaimsRequest claims;

   static ClientCredentialParametersBuilder builder() {

        return new ClientCredentialParametersBuilder();
    }

    ///
    /// Builder for {@link ClientCredentialParameters}
    /// @param scopes scopes application is requesting access to
    /// @return builder that can be used to construct ClientCredentialParameters
   ///
   static ClientCredentialParametersBuilder builder(Set<String> scopes) {

        validateNotEmpty("scopes", scopes);

        return builder().scopes(scopes);
    }
}
