
class MsalException implements Exception {

    String _errorCode;

    MsalException({final NullThrownError throwable, final String message, String errorCode }){
        this._errorCode = errorCode;
    }

}
