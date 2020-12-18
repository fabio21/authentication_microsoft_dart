
import 'package:dio/dio.dart';
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

import 'msal_interaction_required_exception.dart';
import 'msal_service_exception.dart';

class MsalServiceExceptionFactory {

    MsalServiceExceptionFactory();


    static MsalServiceException fromHttpResponse(ResponseBody httpResponse) {

        String responseContent = httpResponse.;
        if (responseContent == null || StringHelper.isBlank(responseContent)) {
            return new MsalServiceException(
                    "Unknown Service Exception",
                    AuthenticationErrorCode.UNKNOWN);
        }

        ErrorResponse errorResponse = JsonHelper.convertJsonToObject(responseContent, ErrorResponse.class);

        errorResponse.statusCode(httpResponse.statusCode);
        errorResponse.statusMessage(httpResponse..statusMessage);

        if (errorResponse.error() != null &&
                errorResponse.error().equalsIgnoreCase(AuthenticationErrorCode.INVALID_GRANT)) {

            if (isInteractionRequired(errorResponse.subError)) {
                return new MsalInteractionRequiredException(errorResponse, httpResponse.headers);
            }
        }

        return new MsalServiceException(errorResponse, httpResponse.statusMessage);
    }

    static bool isInteractionRequired(String subError) {

        var nonUiSubErrors = {"client_mismatch", "protection_policy_required"};
        Set<String> set = nonUiSubErrors.toSet();

        if (StringHelper.isBlank(subError)) {
            return true;
        }

        return !set.contains(subError);
    }
}
