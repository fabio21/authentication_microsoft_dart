

import 'package:microsoft_authentication/msal/msal/msal_client_exception.dart';
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

import 'acquire_token_by_authorization_grantSupplier.dart';

class AcquireTokenByInteractiveFlowSupplier extends AuthenticationResultSupplier {

    //private final static Logger LOG = LoggerFactory.getLogger(AcquireTokenByAuthorizationGrantSupplier);

    PublicClientApplication clientApplication;
    InteractiveRequest interactiveRequest;

    BlockingQueue<AuthorizationResult> authorizationResultQueue;
    HttpListener httpListener;

    AcquireTokenByInteractiveFlowSupplier(PublicClientApplication clientApplication, InteractiveRequest request){
        super(clientApplication, request);
        this.clientApplication = clientApplication;
        this.interactiveRequest = request;
    }

    @Override
    AuthenticationResult execute() {
        AuthorizationResult authorizationResult = getAuthorizationResult();
        validateState(authorizationResult);
        return acquireTokenWithAuthorizationCode(authorizationResult);
    }

    AuthorizationResult getAuthorizationResult(){

        AuthorizationResult result;
        try {
            SystemBrowserOptions systemBrowserOptions =
                    interactiveRequest.interactiveRequestParameters().systemBrowserOptions();

            authorizationResultQueue = new LinkedBlockingQueue<>();
            AuthorizationResponseHandler authorizationResponseHandler =
                    new AuthorizationResponseHandler(
                            authorizationResultQueue,
                            systemBrowserOptions);

            startHttpListener(authorizationResponseHandler);

            if (systemBrowserOptions != null && systemBrowserOptions.openBrowserAction() != null) {
                interactiveRequest.interactiveRequestParameters().systemBrowserOptions().openBrowserAction()
                        .openBrowser(interactiveRequest.authorizationUrl());
            } else {
                openDefaultSystemBrowser(interactiveRequest.authorizationUrl());
            }

             result = getAuthorizationResultFromHttpListener();
        } finally {
            if(httpListener != null){
                httpListener.stopListener();
            }
        }
        return result;
    }

    void validateState(AuthorizationResult authorizationResult){
        if(StringHelper.isBlank(authorizationResult.state()) ||
                !authorizationResult.state().equals(interactiveRequest.state())){

            throw new MsalClientException(message:"State returned in authorization result is blank or does " +
                    "not match state sent on outgoing request",
                    errorCode: AuthenticationErrorCode.INVALID_AUTHORIZATION_RESULT);
        }
    }

    void startHttpListener(AuthorizationResponseHandler handler){
        // if port is unspecified, set to 0, which will cause socket to find a free port
        int port = interactiveRequest.interactiveRequestParameters().redirectUri().getPort() == -1 ?
                0 :
                interactiveRequest.interactiveRequestParameters().redirectUri().getPort();

        httpListener = new HttpListener();
        httpListener.startListener(port, handler);

        //If no port is passed, http listener finds a free one. We should update redirect URL to
        // point to this port.
        if(port != httpListener.port()){
            updateRedirectUrl();
        }
    }

    void updateRedirectUrl(){
        try {
            Uri updatedRedirectUrl = new Uri.directory("http://localhost:" + httpListener.port());
            interactiveRequest.interactiveRequestParameters().redirectUri(updatedRedirectUrl);
            print("Redirect URI updated to" + updatedRedirectUrl.toString());
        } catch (ex){
            throw new MsalClientException(message:"Error updating redirect URI. Not a valid URI format",
                    errorCode: AuthenticationErrorCode.INVALID_REDIRECT_URI);
        }
    }

    void openDefaultSystemBrowser(Uri uri){
        try{
            if (Desktop.isDesktopSupported() && Desktop.getDesktop().isSupported(Desktop.Action.BROWSE)) {
                Desktop.getDesktop().browse(uri);
                print("Opened default system browser");
            } else {
                throw new MsalClientException(message: "Unable to open default system browser",
                        errorCode: AuthenticationErrorCode.DESKTOP_BROWSER_NOT_SUPPORTED);
            }
        } catch (e) {
            throw new MsalClientException(throwable: e);
        }
    }

    AuthorizationResult getAuthorizationResultFromHttpListener(){
        AuthorizationResult result = null;
        try {
            print("Listening for authorization result");
            int expirationTime = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis()) + 120;

            while(result == null && !interactiveRequest.futureReference().get().isCancelled() &&
                    TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis()) < expirationTime) {

                result = authorizationResultQueue.poll(100, TimeUnit.MILLISECONDS);
            }
        } catch(e){
            throw new MsalClientException(throwable: e);
        }

        if (result == null || StringHelper.isBlank(result.code())) {
            throw new MsalClientException(message: "No Authorization code was returned from the server",
                    errorCode: AuthenticationErrorCode.INVALID_AUTHORIZATION_RESULT);
        }
        return result;
    }

    AuthenticationResult acquireTokenWithAuthorizationCode(AuthorizationResult authorizationResult) {
        AuthorizationCodeParameters parameters = AuthorizationCodeParameters
                .builder(authorizationResult.code(), interactiveRequest.interactiveRequestParameters().redirectUri())
                .scopes(interactiveRequest.interactiveRequestParameters().scopes())
                .codeVerifier(interactiveRequest.verifier())
                .claims(interactiveRequest.interactiveRequestParameters().claims())
                .build();

        AuthorizationCodeRequest authCodeRequest = new AuthorizationCodeRequest(
                parameters,
                clientApplication,
                clientApplication.createRequestContext(PublicApi.ACQUIRE_TOKEN_BY_AUTHORIZATION_CODE, parameters));

        AcquireTokenByAuthorizationGrantSupplier acquireTokenByAuthorizationGrantSupplier =
            new AcquireTokenByAuthorizationGrantSupplier(
                    clientApplication,
                    authCodeRequest,
                    clientApplication.authenticationAuthority);

        return acquireTokenByAuthorizationGrantSupplier.execute();
    }
}