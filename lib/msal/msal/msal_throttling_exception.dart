
import 'msal_service_exception.dart';

class MsalThrottlingException extends MsalServiceException {

     int _retryInMs;

      MsalThrottlingException(int retryInMs) : super("Request was throttled according to instructions from STS. Retry in " + retryInMs + " ms.",
    AuthenticationErrorCode.THROTTLED_REQUEST) {

        this._retryInMs = _retryInMs;
    }
}
