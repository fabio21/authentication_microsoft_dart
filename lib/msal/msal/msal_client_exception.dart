
 import 'msal_exception.dart';

class MsalClientException implements MsalException {

  String message;
  String errorCode;

    MsalClientException({final NullThrownError throwable, final String message, final String errorCode});

}
