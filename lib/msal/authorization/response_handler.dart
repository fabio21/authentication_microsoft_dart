
import 'package:dio/dio.dart';
import 'package:microsoft_authentication/msal/authorization/result.dart';
import 'package:microsoft_authentication/msal/msal/msal_client_exception.dart';

class AuthorizationResponseHandler implements HttpHandler {

  //   final static Logger LOG = LoggerFactory.getLogger(AuthorizationResponseHandler.class);

    static const DEFAULT_SUCCESS_MESSAGE = "<html><head><title>Authentication Complete</title></head>"+
            "  <body> Authentication complete. You can close the browser and return to the application."+
            "  </body></html>" ;

    static const DEFAULT_FAILURE_MESSAGE = "<html><head><title>Authentication Failed</title></head> " +
            "<body> Authentication failed. You can return to the application. Feel free to close this browser tab. " +
            "</br></br></br></br> Error details: error {0} error_description: {1} </body> </html>";

     BlockingQueue<AuthorizationResult> authorizationResultQueue;
     SystemBrowserOptions systemBrowserOptions;

    AuthorizationResponseHandler(BlockingQueue<AuthorizationResult> authorizationResultQueue,
                                 SystemBrowserOptions systemBrowserOptions){
        this.authorizationResultQueue = authorizationResultQueue;
        this.systemBrowserOptions = systemBrowserOptions;
    }


    void handle(HttpExchange httpExchange) {
        try{
            if(!httpExchange.getRequestURI().getPath().equalsIgnoreCase("/")){
                httpExchange.sendResponseHeaders(200, 0);
                return;
            }
            String responseBody = new BufferedReader(new InputStreamReader(
                    httpExchange.getRequestBody())).lines().collect(Collectors.joining("\n"));

            AuthorizationResult result = AuthorizationResult.fromResponseBody(responseBody);
            sendResponse(httpExchange, result);
            authorizationResultQueue.put(result);
            
        } catch (ex){
            print("Error reading response from socket: " + ex.getMessage());
            throw new MsalClientException(throwable: ex);
        } finally {
            httpExchange.close();
        }
    }

     void sendResponse(HttpExchange httpExchange, AuthorizationResult result) {

        switch (result.status){
            case Success:
                sendSuccessResponse(httpExchange, getSuccessfulResponseMessage());
                break;
            case ProtocolError:
            case UnknownError:
                sendErrorResponse(httpExchange, getErrorResponseMessage());
                break;
        }
    }

     void sendSuccessResponse(HttpExchange httpExchange, String response) {
        if (systemBrowserOptions == null || systemBrowserOptions.browserRedirectSuccess() == null) {
            send200Response(httpExchange, response);
        } else {
            send302Response(httpExchange, systemBrowserOptions().browserRedirectSuccess().toString());
        }
    }

     void sendErrorResponse(HttpExchange httpExchange, String response)  {
        if(systemBrowserOptions == null || systemBrowserOptions.browserRedirectError() == null){
            send200Response(httpExchange, response);
        } else {
            send302Response(httpExchange, systemBrowserOptions().browserRedirectError().toString());
        }
    }

     void send302Response(HttpExchange httpExchange, String redirectUri){
        Headers responseHeaders = httpExchange.getResponseHeaders();
        responseHeaders.set("Location", redirectUri);
        httpExchange.sendResponseHeaders(302, 0);
    }

     void send200Response(HttpExchange httpExchange, String response) {
        httpExchange.sendResponseHeaders(200, response.length);
        OutputStream os = httpExchange.getResponseBody();
        os.write(response.codeUnits);
        os.close();
    }

     String getSuccessfulResponseMessage(){
        if(systemBrowserOptions == null || systemBrowserOptions.htmlMessageSuccess() == null) {
            return DEFAULT_SUCCESS_MESSAGE;
        }
        return systemBrowserOptions().htmlMessageSuccess();
    }

     String getErrorResponseMessage(){
        if(systemBrowserOptions == null || systemBrowserOptions.htmlMessageError() == null) {
            return DEFAULT_FAILURE_MESSAGE;
        }
        return systemBrowserOptions().htmlMessageSuccess();
    }
}
