
import 'package:microsoft_authentication/msal/abstract/abstract_client_application_base.dart';
import 'package:microsoft_authentication/msal/abstract/abstract_msal_authorization_grant.dart';
import 'package:microsoft_authentication/msal/authorization/code_parameters.dart';
import 'package:microsoft_authentication/msal/msal/msal_request.dart';

class AuthorizationCodeRequest extends MsalRequest {

    AuthorizationCodeRequest(AuthorizationCodeParameters parameters,
                             AbstractClientApplicationBase application,
                             RequestContext requestContext) : super(application, createMsalGrant(parameters), requestContext){
        //super(application, createMsalGrant(parameters), requestContext);
    }

    static AbstractMsalAuthorizationGrant createMsalGrant(AuthorizationCodeParameters parameters){

        AuthorizationGrant authorizationGrant;
        if(parameters.codeVerifier() != null){
            authorizationGrant = new AuthorizationCodeGrant(
                    new AuthorizationCode(parameters.authorizationCode()),
                    parameters.redirectUri(),
                    new CodeVerifier(parameters.codeVerifier()));

        } else {
            authorizationGrant = new AuthorizationCodeGrant(
                    new AuthorizationCode(parameters.authorizationCode),parameters.redirectUri);
        }

        return new OAuthAuthorizationGrant(authorizationGrant, parameters.scopes, parameters.claims());
    }
}
