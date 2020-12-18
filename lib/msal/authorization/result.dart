import 'dart:io';
import 'package:microsoft_authentication/msal/authentication/authentication_error_code.dart';
import 'package:microsoft_authentication/msal/authority/aad_authority.dart';
import 'package:microsoft_authentication/msal/msal/msal_client_exception.dart';
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

enum AuthorizationStatus {
  Success,
  ProtocolError,
  UnknownError
}

class AuthorizationResult {

    String code;
    String state;
    AuthorizationStatus status;
    String error;
    String errorDescription;

    static AuthorizationResult fromResponseBody(String responseBody){

        if(StringHelper.isBlank(responseBody)){
            return new AuthorizationResult(
                status: AuthorizationStatus.UnknownError,
                error:   AuthenticationErrorCode.INVALID_AUTHORIZATION_RESULT,
                errorDescription:   "The authorization server returned an invalid response: response " +
                            "is null or empty");
        }

        Map<String, String > queryParameters = parseParameters(responseBody);

    if (queryParameters.containsKey("error")) {
      return new AuthorizationResult(
          status: AuthorizationStatus.ProtocolError,
          error: queryParameters["error"],
          errorDescription:
              !StringHelper.isBlank(queryParameters["error_description"])
                  ? queryParameters["error_description"]
                  : null);
    }

    if(!queryParameters.containsKey("code")){
            return new AuthorizationResult(
                status:  AuthorizationStatus.UnknownError,
                error:    AuthenticationErrorCode.INVALID_AUTHORIZATION_RESULT,
                errorDescription:  "Authorization result response does not contain authorization code");
        }

        AuthorizationResult result = new AuthorizationResult();
        result.code = queryParameters["code"];
        result.status = AuthorizationStatus.Success;

        if(queryParameters.containsKey("state")){
            result.state = queryParameters["state"];
        }

        return result;
    }

    AuthorizationResult({AuthorizationStatus status, String error, String errorDescription}){
        this.status = status;
        this.error = error;
        this.errorDescription = errorDescription;
    }

    static Map<String, String> parseParameters(String serverResponse) {
        Map<String, String> query_pairs = new Map();
        try {
            var pairs = serverResponse.split("&");
            for (String pair in pairs) {
                int idx = pair.indexOf("=");
                String key = Uri.decodeQueryComponent(pair.substring(0, idx));
                String value = Uri.decodeQueryComponent(pair.substring(idx + 1));
                query_pairs[key] = value;
            }
        } catch(ex){
            throw new MsalClientException(
                   message: AuthenticationErrorCode.INVALID_AUTHORIZATION_RESULT,
                   errorCode:  S.format("Error parsing authorization result:  %s", ex.getMessage()));
        }

        return query_pairs;
    }
}
