
import 'dart:io';

import 'package:microsoft_authentication/msal/abstract/abstract_client_application_base.dart';
import 'package:microsoft_authentication/msal/abstract/abstract_msal_authorization_grant.dart';

abstract class MsalRequest {

     AbstractMsalAuthorizationGrant msalAuthorizationGrant;
     AbstractClientApplicationBase application;
     RequestContext requestContext;
     HttpHeaders headers = new HttpHeaders(_requestContext);

    MsalRequest(AbstractClientApplicationBase clientApplicationBase,
                AbstractMsalAuthorizationGrant abstractMsalAuthorizationGrant,
                RequestContext requestContext){
        this.application = clientApplicationBase;
        this.msalAuthorizationGrant = abstractMsalAuthorizationGrant;
        this.requestContext = requestContext;

        CurrentRequest currentRequest = new CurrentRequest(requestContext.publicApi());
        application.getServiceBundle().getServerSideTelemetry().setCurrentRequest(currentRequest);
    }
}
