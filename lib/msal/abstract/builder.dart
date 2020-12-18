import 'dart:io';

import 'package:microsoft_authentication/msal/aad/aad_instance_discovery_provider.dart';
import 'package:microsoft_authentication/msal/aad/aad_instance_discovery_response.dart';
import 'package:microsoft_authentication/msal/abstract/abstract_client_application_base.dart';
import 'package:microsoft_authentication/msal/authority/aad_authority.dart';
import 'package:microsoft_authentication/msal/authority/adfs_authority.dart';
import 'package:microsoft_authentication/msal/authority/authority.dart';
import 'package:microsoft_authentication/msal/authority/authority_type.dart';
import 'package:microsoft_authentication/msal/authority/b2c_authority.dart';
import 'package:microsoft_authentication/msal/msal/msal_client_exception.dart';

abstract class Builder<T extends Builder<T>> {
  // Required parameters
  String clientId;

  // Optional parameters - initialized to default values
  String authority = DEFAULT_AUTHORITY;
  Authority authenticationAuthority = createDefaultAADAuthority();
  bool isValidateAuthority = true;
  String idCorrelation;
  bool isLogPii = false;
  ExecutorService _executorService;
  Proxy proxy;
  SSLSocketFactory sslSocketFactory;
  HttpClient httpClient;
  Consumer<List<Map<String, String>>> telemetryConsumer;
  bool onlySendFailureTelemetry = false;
  String applicationName;
  String applicationVersion;
  ITokenCacheAccessAspect tokenCacheAccessAspect;
  AadInstanceDiscoveryResponse aadInstanceDiscoveryResponse;
  String clientCapabilities;
  int connectTimeoutForDefaultHttpClient;
  int readTimeoutForDefaultHttpClient;


  ///
  /// Constructor to create instance of Builder of client application
  ///
  /// @param clientId Client ID (Application ID) of the application as registered
  /// in the application registration portal (portal.azure.com)
  ///
  Builder({String clientId}) {
    validateNotBlank("clientId", clientId);
    this.clientId = clientId;
  }

  ///
  /// Set URL of the authenticating authority or security token service (STS) from which MSAL
  /// will acquire security tokens.
  /// The default value is {@link AbstractClientApplicationBase#DEFAULT_AUTHORITY}
  ///
  /// @param val a string value of authority
  /// @return instance of the Builder on which method was called
  /// @throws MalformedURLException if val is malformed URL
  ///
  authorityBuilder(String val) {
    this.authority = AbstractClientApplicationBase.enforceTrailingSlash(val);

    Uri authorityURL = new Uri.directory(this.authority);
    Authority.validateAuthority(authorityURL);

    switch (Authority.detectAuthorityType(authorityURL)) {
      case AuthorityType.AAD:
        authenticationAuthority = new AADAuthority(authorityURL);
        break;
      case AuthorityType.ADFS:
        authenticationAuthority = new ADFSAuthority(authorityURL);
        break;
      default:
        throw new Exception("Unsupported authority type.");
    }

    return this;
  }

  b2cAuthority(String val) {
    this.authority = AbstractClientApplicationBase.enforceTrailingSlash(val);

    Uri authorityURL = new Uri.directory(this.authority);
    Authority.validateAuthority(authorityURL);

    if (Authority.detectAuthorityType(authorityURL) != AuthorityType.B2C) {
      throw new Exception(
          "Unsupported authority type. Please use B2C authority");
    }
    authenticationAuthority = new B2CAuthority(authorityURL);

    isValidateAuthority = false;
    return this;
  }

  ///
  /// Set a bool value telling the application if the authority needs to be verified
  /// against a list of known authorities. Authority is only validated when:
  /// 1 - It is an Azure Active Directory authority (not B2C or ADFS)
  /// 2 - Instance discovery metadata is not set via {@link AbstractClientApplicationBase#aadAadInstanceDiscoveryResponse}
  ///
  /// The default value is true.
  ///
  /// @param val a bool value for validateAuthority
  /// @return instance of the Builder on which method was called

  validateAuthority(Uri val) {
    isValidateAuthority = val.hasAuthority;
    return this;
  }


  /// Set optional correlation id to be used by the API.
  /// If not provided, the API generates a random UUID.
  ///
  /// @param val a string value of correlation id
  /// @return instance of the Builder on which method was called
  correlationId(String val) {
    validateNotBlank("correlationId", val);

    idCorrelation = val;
    return this;
  }

  /// Set logPii - bool value, which determines
  /// whether Pii (personally identifiable information) will be logged in.
  /// The default value is false.
  ///
  /// @param val a bool value for logPii
  /// @return instance of the Builder on which method was called
  T logPii(bool val) {
    isLogPii = val;
    return this;
  }


  /// Sets ExecutorService to be used to execute the requests.
  /// Developer is responsible for maintaining the lifecycle of the ExecutorService.
  ///
  /// @param val an instance of ExecutorService
  /// @return instance of the Builder on which method was called
  T executorService(ExecutorService val) {
    validateNotNull("executorService", val);

    _executorService = val;
    return this;
  }

  /// Sets Proxy configuration to be used by the client application (MSAL4J by default uses
  /// {@link javax.net.ssl.HttpsURLConnection}) for all network communication.
  /// If no proxy value is passed in, system defined properties are used. If HTTP client is set on
  /// the client application (via ClientApplication.builder().httpClient()),
  /// proxy configuration should be done on the HTTP client object being passed in,
  /// and not through this method.
  ///
  /// @param val an instance of Proxy
  /// @return instance of the Builder on which method was called
  proxy(Proxy val) {
    validateNotNull("proxy", val);

    proxy = val;
    return this;
  }

  /// Sets HTTP client to be used by the client application for all HTTP requests. Allows for fine
  /// grained configuration of HTTP client.
  ///
  /// @param val Implementation of {@link IHttpClient}
  /// @return instance of the Builder on which method was called
  T httpClientBuilder(HttpClient val) {
    validateNotNull("httpClient", val);

    httpClient = val;
    return this;
  }

  /// Sets SSLSocketFactory to be used by the client application for all network communication.
  /// If HTTP client is set on the client application (via ClientApplication.builder().httpClient()),
  /// any configuration of SSL should be done on the HTTP client and not through this method.
  ///
  /// @param val an instance of SSLSocketFactory
  /// @return instance of the Builder on which method was called
  T sslSocketFactoryBuilder(SSLSocketFactory val) {
    validateNotNull("sslSocketFactory", val);

    sslSocketFactory = val;
    return sthis;
  }

  /// Sets the connect timeout value used in HttpsURLConnection connections made by {@link DefaultHttpClient},
  /// and is not needed if using a custom HTTP client
  ///
  /// @param val timeout value in milliseconds
  /// @return instance of the Builder on which method was called
  T connectTimeoutForDefaultHttpClientBuilder(int val) {
    validateNotNull("connectTimeoutForDefaultHttpClient", val);

    connectTimeoutForDefaultHttpClient = val;
    return this;
  }

  /// Sets the read timeout value used in HttpsURLConnection connections made by {@link DefaultHttpClient},
  /// and is not needed if using a custom HTTP client
  ///
  /// @param val timeout value in milliseconds
  /// @return instance of the Builder on which method was called
  T readTimeoutForDefaultHttpClientBuilder(int val) {
    validateNotNull("readTimeoutForDefaultHttpClient", val);

    readTimeoutForDefaultHttpClient = val;
    return this;
  }

  T telemetryConsumerBuilder(Consumer<List<Map<String, String>>> val) {
    validateNotNull("telemetryConsumer", val);

    telemetryConsumer = val;
    return this;
  }

  T onlySendFailureTelemetryBuilder(bool val) {
    onlySendFailureTelemetry = val;
    return this;
  }

  /// Sets application name for telemetry purposes
  ///
  /// @param val application name
  /// @return instance of the Builder on which method was called
  T applicationNameBuilder(String val) {
    validateNotNull("applicationName", val);

    applicationName = val;
    return this;
  }


  /// Sets application version for telemetry purposes
  ///
  /// @param val application version
  /// @return instance of the Builder on which method was called
  T applicationVersionBuilder(String val) {
    validateNotNull("applicationVersion", val);

    applicationVersion = val;
    return this;
  }

  /// Sets ITokenCacheAccessAspect to be used for cache_data persistence.
  ///
  /// @param val an instance of ITokenCacheAccessAspect
  /// @return instance of the Builder on which method was called
  T setTokenCacheAccessAspect(ITokenCacheAccessAspect val) {
    validateNotNull("tokenCacheAccessAspect", val);

    tokenCacheAccessAspect = val;
    return this;
  }


  /// Sets instance discovery response data which will be used for determining tenant discovery
  /// endpoint and authority aliases.
  ///
  /// Note that authority validation is not done even if {@link AbstractClientApplicationBase#validateAuthority}
  /// is set to true.
  ///
  /// For more information, see
  /// https://aka.ms/msal4j-instance-discovery
  /// @param val JSON formatted value of response from AAD instance discovery endpoint
  /// @return instance of the Builder on which method was called

  T aadInstanceDiscoveryResponseBuilder(String val) {
    validateNotNull("aadInstanceDiscoveryResponse", val);

    aadInstanceDiscoveryResponse =
        AadInstanceDiscoveryProvider.parseInstanceDiscoveryMetadata(val);

    return this;
  }

  static Authority createDefaultAADAuthority() {
    Authority authority;
    try {
      authority = new AADAuthority(new Uri.directory(DEFAULT_AUTHORITY));
    }
    catch (e){
    throw new MsalClientException();
    }
    return
    authority;
  }

  T clientCapabilitiesBuilder(Set<String> capabilities) {
    clientCapabilities = JsonHelper.formCapabilitiesJson(capabilities);

    return this;
  }

}