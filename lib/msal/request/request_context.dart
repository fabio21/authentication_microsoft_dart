
import 'package:microsoft_authentication/msal/abstract/abstract_client_application_base.dart';
import 'package:microsoft_authentication/msal/client/i_api_parameters.dart';
import 'package:microsoft_authentication/msal/client/i_application_base.dart';
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

class RequestContext {

     String telemetryRequestId;
     String clientId;
     String correlationId;
     PublicApi publicApi;
     String applicationName;
     String applicationVersion;
     String authority;
     IApiParameters apiParameters;
     IClientApplicationBase clientApplication;

    RequestContext(AbstractClientApplicationBase clientApplication,
                          PublicApi publicApi,
                          IApiParameters apiParameters) {
        this.clientApplication = clientApplication as IClientApplicationBase;

        this.clientId = StringHelper.isBlank(clientApplication.clientId) ?
                "unset_client_id" :
                clientApplication.clientId;
        this.correlationId = StringHelper.isBlank(clientApplication.idCorrelation) ?
                generateNewCorrelationId() :
                clientApplication.idCorrelation;

        this.applicationVersion = clientApplication.applicationVersion;
        this.applicationName = clientApplication.applicationName;
        this.publicApi = publicApi;
        this.authority = clientApplication.authority;
        this.apiParameters = apiParameters;
    }

     static String generateNewCorrelationId() {
        return UUID.randomUUID().toString();
    }
}