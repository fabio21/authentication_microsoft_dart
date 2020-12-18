

import 'dart:io';

import 'package:microsoft_authentication/lab_api/key_vault_secrets_provider.dart';

class CertificateHelper
{

  static KeyStore createKeyStore()
  {
    String os = SystemUtils.OS_NAME;
    if (os.contains("Mac")) {
      return KeyStore_.getInstance("KeychainStore");
    } else {
      return KeyStore_.getInstance("Windows-MY", "SunMSCAPI");
    }
  }

  static IClientCertificate getClientCertificate()
  {
    KeyStore keystore = createKeyStore();
    keystore.load(null, null);
    PrivateKey key = keystore.getKey(KeyVaultSecretsProvider.CERTIFICATE_ALIAS, null);
    X509Certificate publicCertificate = keystore.getCertificate(KeyVaultSecretsProvider.CERTIFICATE_ALIAS);
    return ClientCredentialFactory.createFromCertificate(key, publicCertificate);
  }
}