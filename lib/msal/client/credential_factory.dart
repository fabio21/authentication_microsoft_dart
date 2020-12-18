

import 'dart:io';

import 'assertion.dart';
import 'certificate.dart';

///
///Factory for creating client credentials used in confidential client flows. For more details, see
///https://aka.ms/msal4j-client-credentials
///
class ClientCredentialFactory {

    ///
    ///Static method to create a {@link ClientSecret} instance from a client secret
    ///@param secret secret of application requesting a token
    ///@return {@link ClientSecret}
  ///
   static IClientSecret createFromSecret(String secret){
        return new ClientSecret(secret);
    }

    ///
    ///Static method to create a {@link ClientCertificate} instance from a certificate
    ///@param pkcs12Certificate InputStream containing PCKS12 formatted certificate
    ///@param password certificate password
    ///@return {@link ClientCertificate}
    ///@throws CertificateException
    ///@throws UnrecoverableKeyException
    ///@throws NoSuchAlgorithmException
    ///@throws KeyStoreException
    ///@throws NoSuchProviderException
    ///@throws IOException
  ///
    static IClientCertificate createFromCertificate(final InputStream pkcs12Certificate, final String password) {
        return ClientCertificate.create(pkcs12Certificate, password);
    }

    ///
    ///Static method to create a {@link ClientCertificate} instance.
    ///@param key  RSA private key to sign the assertion.
    ///@param publicKeyCertificate x509 public certificate used for thumbprint
    ///@return {@link ClientCertificate}
  ///
    static IClientCertificate createFromCertificate(final PrivateKey key, final X509Certificate publicKeyCertificate) {
        validateNotNull("publicKeyCertificate", publicKeyCertificate);

        return ClientCertificate.create(key, publicKeyCertificate);
    }

    ///
    ///Static method to create a {@link ClientCertificate} instance.
    ///@param key  RSA private key to sign the assertion.
    ///@param publicKeyCertificateChain ordered with the user's certificate first followed by zero or more certificate authorities
    ///@return {@link ClientCertificate}
  ///
    static IClientCertificate createFromCertificateChain(PrivateKey key, List<X509Certificate> publicKeyCertificateChain) {
        if(key == null || publicKeyCertificateChain == null || publicKeyCertificateChain.length == 0){
            throw new Exception("null or empty input parameter");
        }
        return new ClientCertificate(key, publicKeyCertificateChain);
    }

    ///
    ///Static method to create a {@link ClientAssertion} instance.
    ///@param clientAssertion Jwt token encoded as a base64 URL encoded string
    ///@return {@link ClientAssertion}
  ///
    static IClientAssertion createFromClientAssertion(String clientAssertion){
        return new ClientAssertion(clientAssertion);
    }
}
