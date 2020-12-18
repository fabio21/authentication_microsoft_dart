
import 'package:microsoft_authentication/msal/aad/aad_instance_discovery_provider.dart';
import 'package:microsoft_authentication/msal/aad/aad_instance_discovery_response.dart';
import 'package:microsoft_authentication/msal/abstract/builder.dart';
import 'package:microsoft_authentication/msal/authority/authority.dart';
import 'package:microsoft_authentication/msal/authority/authority_type.dart';
import 'package:microsoft_authentication/msal/msal/msal_request.dart';


abstract class AbstractClientApplicationBase implements IClientApplicationBase {

     Authority authenticationAuthority;
     ServiceBundle serviceBundle;
     String clientId;
     String authority;
     bool isValidateAuthority;
     String idCorrelation;
     bool logPii;
     Consumer<List<Map<String, String>>> telemetryConsumer;
     Proxy proxy;
     SSLSocketFactory sslSocketFactory;
     int connectTimeoutForDefaultHttpClient;
     int readTimeoutForDefaultHttpClient;
     TokenCache tokenCache;
     String applicationName;
     String applicationVersion;
     AadInstanceDiscoveryResponse aadAadInstanceDiscoveryResponse;
     ClientAuthentication clientAuthentication();
     String clientCapabilities;


    CompletableFuture<IAuthenticationResult> acquireToken(AuthorizationCodeParameters parameters) {
        validateNotNull("parameters", parameters);
        AuthorizationCodeRequest authorizationCodeRequest = new AuthorizationCodeRequest(
                parameters,
                this,
                createRequestContext(PublicApi.ACQUIRE_TOKEN_BY_AUTHORIZATION_CODE, parameters));
        return this.executeRequest(authorizationCodeRequest);
    }


    CompletableFuture<IAuthenticationResult> acquireToken(RefreshTokenParameters parameters) {
      validateNotNull("parameters", parameters);
      RefreshTokenRequest refreshTokenRequest = new RefreshTokenRequest(
                parameters,
                this,
                createRequestContext(PublicApi.ACQUIRE_TOKEN_BY_REFRESH_TOKEN, parameters));
        return executeRequest(refreshTokenRequest);
    }

    CompletableFuture<IAuthenticationResult> executeRequest(MsalRequest msalRequest) {
        AuthenticationResultSupplier supplier = getAuthenticationResultSupplier(msalRequest);
        ExecutorService executorService = serviceBundle.getExecutorService();
        CompletableFuture<IAuthenticationResult> future = executorService != null ?
                CompletableFuture.supplyAsync(supplier, executorService) :
                CompletableFuture.supplyAsync(supplier);
        return future;
    }


    CompletableFuture<IAuthenticationResult> acquireTokenSilently(SilentParameters parameters)
            throws MalformedURLException {
        validateNotNull("parameters", parameters);
        SilentRequest silentRequest = new SilentRequest(
                parameters,
                this,
                createRequestContext(PublicApi.ACQUIRE_TOKEN_SILENTLY, parameters));
        return executeRequest(silentRequest);
    }

    CompletableFuture<Set<IAccount>> getAccounts() {
        MsalRequest msalRequest =
                new MsalRequest(this, null,
                        createRequestContext(PublicApi.GET_ACCOUNTS, null)){};
        AccountsSupplier supplier = new AccountsSupplier(this, msalRequest);
        CompletableFuture<Set<IAccount>> future =
                serviceBundle.getExecutorService() != null ? CompletableFuture.supplyAsync(supplier, serviceBundle.getExecutorService())
                        : CompletableFuture.supplyAsync(supplier);
        return future;
    }

   CompletableFuture removeAccount(IAccount account) {
        MsalRequest msalRequest = new MsalRequest(this, null,
                        createRequestContext(PublicApi.REMOVE_ACCOUNTS, null)){};

        RemoveAccountRunnable runnable = new RemoveAccountRunnable(msalRequest, account);

        CompletableFuture<Void> future =
                serviceBundle.getExecutorService() != null ? CompletableFuture.runAsync(runnable, serviceBundle.getExecutorService())
                        : CompletableFuture.runAsync(runnable);
        return future;
    }

     Uri getAuthorizationRequestUrl(AuthorizationRequestUrlParameters parameters) {

        validateNotNull("parameters", parameters);

        parameters.requestParameters.put("client_id", Collections.singletonList(this.clientId));

        //If the client application has any client capabilities set, they must be merged into the claims parameter
        if (this.clientCapabilities != null) {
            if (parameters.requestParameters.containsKey("claims")) {
                String claims = parameters.requestParameters.get("claims").get(0).toString();
               // String mergedClaimsCapabilities = JsonHelper.mergeJSONString(claims, this.clientCapabilities);
               // parameters.requestParameters.put("claims", Collections.singletonList(mergedClaimsCapabilities));
            } else {
               // parameters.requestParameters.put("claims", Collections.singletonList(this.clientCapabilities));
            }
        }

        return parameters.createAuthorizationURL(
                this.authenticationAuthority,
                parameters.requestParameters());
    }

    AuthenticationResult acquireTokenCommon(MsalRequest msalRequest, Authority requestAuthority) {

        HttpHeaders headers = msalRequest.headers();

        if (logPii) {
            log.debug(LogHelper.createMessage(
                    String.format("Using Client Http Headers: %s", headers),
                    headers.getHeaderCorrelationIdValue()));
        }

        TokenRequestExecutor requestExecutor = new TokenRequestExecutor(
                requestAuthority,
                msalRequest,
                serviceBundle);

        AuthenticationResult result = requestExecutor.executeTokenRequest();

        if(authenticationAuthority.authorityType.equals(AuthorityType.AAD)){
            InstanceDiscoveryMetadataEntry instanceDiscoveryMetadata =
                    AadInstanceDiscoveryProvider.getMetadataEntry(
                            requestAuthority.canonicalAuthorityUrl(),
                            validateAuthority,
                            msalRequest,
                            serviceBundle);

            tokenCache.saveTokens(requestExecutor, result, instanceDiscoveryMetadata.preferredCache);
        } else {
            tokenCache.saveTokens(requestExecutor, result, authenticationAuthority.host);
        }

        return result;
    }

    AuthenticationResultSupplier getAuthenticationResultSupplier(MsalRequest msalRequest) {

        AuthenticationResultSupplier supplier;
        if (msalRequest instanceof DeviceCodeFlowRequest) {
            supplier = new AcquireTokenByDeviceCodeFlowSupplier(
                    (PublicClientApplication) this,
                    (DeviceCodeFlowRequest) msalRequest);
        } else if (msalRequest instanceof SilentRequest) {
            supplier = new AcquireTokenSilentSupplier(this, (SilentRequest) msalRequest);
        } else if(msalRequest instanceof  InteractiveRequest){
            supplier = new AcquireTokenByInteractiveFlowSupplier(
                    (PublicClientApplication) this,
                    (InteractiveRequest) msalRequest);
        } else {
            supplier = new AcquireTokenByAuthorizationGrantSupplier(
                    this,
                    msalRequest, null);
        }
        return supplier;
    }

    RequestContext createRequestContext(PublicApi publicApi, IApiParameters apiParameters) {
        return new RequestContext(this, publicApi, apiParameters);
    }

    ServiceBundle getServiceBundle() {
        return serviceBundle;
    }

     static String enforceTrailingSlash(String authority) {
        authority = authority.toLowerCase();

        if (!authority.endsWith("/")) {
            authority += "/";
        }
        return authority;
    }


    AbstractClientApplicationBase(Builder builder) {
        clientId = builder.clientId;
        authority = builder.authority;
        isValidateAuthority = builder.isValidateAuthority;
        idCorrelation = builder.idCorrelation;
        logPii = builder.isLogPii;
        applicationName = builder.applicationName;
        applicationVersion = builder.applicationVersion;
        telemetryConsumer = builder.telemetryConsumer;
        proxy = builder.proxy;
        sslSocketFactory = builder.sslSocketFactory;
        connectTimeoutForDefaultHttpClient = builder.connectTimeoutForDefaultHttpClient;
        readTimeoutForDefaultHttpClient = builder.readTimeoutForDefaultHttpClient;
        authenticationAuthority = builder.authenticationAuthority;
        tokenCache = new TokenCache(builder.tokenCacheAccessAspect);
        aadAadInstanceDiscoveryResponse = builder.aadInstanceDiscoveryResponse;
        clientCapabilities = builder.clientCapabilities;

        serviceBundle = new ServiceBundle(
                builder.executorService,
                builder.httpClient == null ?
                        new DefaultHttpClient(builder.proxy, builder.sslSocketFactory, builder.connectTimeoutForDefaultHttpClient, builder.readTimeoutForDefaultHttpClient) :
                        builder.httpClient,
                new TelemetryManager(telemetryConsumer, builder.onlySendFailureTelemetry));


        if(aadAadInstanceDiscoveryResponse != null){
            AadInstanceDiscoveryProvider.cacheInstanceDiscoveryMetadata(
                    authenticationAuthority.host,
                    aadAadInstanceDiscoveryResponse);
        }
    }
}