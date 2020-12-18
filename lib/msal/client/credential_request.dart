import 'package:microsoft_authentication/msal/msal/msal_request.dart';

import 'credential_parameters.dart';

class ClientCredentialRequest extends MsalRequest {
  ClientCredentialRequest(ClientCredentialParameters parameters,
      ConfidentialClientApplication application, RequestContext requestContext)
      : super(application, createMsalGrant(parameters), requestContext) {}

  static OAuthAuthorizationGrant createMsalGrant(
      ClientCredentialParameters parameters) {
    return new OAuthAuthorizationGrant(
        new ClientCredentialsGrant(), parameters.scopes, parameters.claims());
  }
}
