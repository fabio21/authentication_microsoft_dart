import 'dart:io';

import 'package:microsoft_authentication/src/test_constants.dart';

class KeyVaultSecretsProvider {

  KeyVaultClient _keyVaultClient;
  static const CLIENT_ID = "55e7e5af-ca53-482d-9aa3-5cb1cc8eecb5";
  static const CERTIFICATE_ALIAS = "MsalJavaAutomationRunner";

  static const WIN_KEYSTORE = "Windows-MY";
  static const KEYSTORE_PROVIDER = "SunMSCAPI";

  static const MAC_KEYSTORE = "KeychainStore";
  static Map<String, String> cache;

  KeyVaultSecretsProvider() {
    _keyVaultClient = getAuthenticatedKeyVaultClient();
    cache = Map();
  }


  String getSecret(String secretUrl) {
    if (cache.containsKey(secretUrl)) {
      return cache[secretUrl];
    }
    String secret = _keyVaultClient.getSecret(secretUrl).value();
    cache[secretUrl] = secret;

    return secret;
  }

 KeyVaultClient getAuthenticatedKeyVaultClient() {
    return new KeyVaultClient(new KeyVaultCredentials() {
      @Override
      public String doAuthenticate(String authorization, String resource, String scope) {
      return requestAccessTokenForAutomation();
      }
    });
  }

  String requestAccessTokenForAutomation() {
    IAuthenticationResult result;
    try {
      ConfidentialClientApplication cca = ConfidentialClientApplication.builder(CLIENT_ID, getClientCredentialFromKeyStore()).
      authority(TestConstants.MICROSOFT_AUTHORITY).
      build();
      result = cca.acquireToken(ClientCredentialParameters
          .builder(Collections.singleton(TestConstants.KEYVAULT_DEFAULT_SCOPE))
          .build()).
      get();
    }
    catch(e){
    throw new Exception("Error acquiring token from Azure AD: " + e.getMessage());
    }
    if(result != null){
    return result.accessToken();
    } else {
    throw new Exception("Authentication result is null");
    }
  }

  IClientCredential getClientCredentialFromKeyStore() {
    PrivateKey key;
    X509Certificate publicCertificate;
    try {
      String os = System.getProperty("os.name");

      KeyStore keystore;
      if (os.toLowerCase().contains("windows")) {
        keystore = KeyStore.getInstance(WIN_KEYSTORE, KEYSTORE_PROVIDER);
      }
      else {
        keystore = KeyStore.getInstance(MAC_KEYSTORE);
      }

      keystore.load(null, null);

      key = (PrivateKey as  keystore.getKey(CERTIFICATE_ALIAS, null));
      publicCertificate = (X509Certificate as keystore.getCertificate(CERTIFICATE_ALIAS));
    }
    catch(e){
    throw new Exception("Error getting certificate from keystore: " + e.getMessage());
    }
    return ClientCredentialFactory.createFromCertificate(key, publicCertificate);
  }
}
