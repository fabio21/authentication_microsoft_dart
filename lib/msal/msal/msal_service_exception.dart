
import 'dart:collection';

import 'package:microsoft_authentication/msal/aad/aad_instance_discovery_response.dart';
import 'msal_exception.dart';

class MsalServiceException extends MsalException {

   int _statusCode;
   String _statusMessage;
   String _correlationId;
   String _claims;
   Map<String, List<String>> headers;
   String _subError;

     MsalServiceException(final String message, final String error) ;


     MsalServiceException({final ErrorResponse errorResponse, final Map<String, List<String>> httpHeaders, final AadInstanceDiscoveryResponse discoveryResponse}) {

       // super(errorResponse.errorDescription, errorResponse.error());
         if(discoveryResponse != null){
             this._correlationId = discoveryResponse.correlationId;
         }else {
             this._statusCode = errorResponse.statusCode();
             this._statusMessage = errorResponse.statusMessage();
             this._subError = errorResponse.subError();
             this._correlationId = errorResponse.correlation_id();
             this._claims = errorResponse.claims();
             this.headers = Map.unmodifiable(httpHeaders);
         }

    }

}
