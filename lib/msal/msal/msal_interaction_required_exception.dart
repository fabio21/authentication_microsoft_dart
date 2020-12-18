

import 'msal_service_exception.dart';

class MsalInteractionRequiredException extends MsalServiceException {

  InteractionRequiredExceptionReason _reason;

  MsalInteractionRequiredException(ErrorResponse errorResponse, Map<String,List<String>> headerMap) {
        _reason = InteractionRequiredExceptionReason.fromSubErrorString(errorResponse.subError);
    }
}
