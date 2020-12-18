import 'i_credential.dart';

///
/// Credential type containing X509 public certificate and RSA private key.
///
///  For more details, see https://aka.ms/msal4j-client-credentials
///
abstract class IClientCertificate extends IClientCredential {
  ///
  /// Returns private key of the credential.
  ///
  /// @return private key.
  ///
  PrivateKey privateKey();

  ///
  /// Base64 encoded hash of the the public certificate.
  ///
  /// @return base64 encoded string
  /// @throws CertificateEncodingException if an encoding error occurs
  /// @throws NoSuchAlgorithmException if requested algorithm is not available in the environment
  ///
  String publicCertificateHash();

  ///
  /// Base64 encoded public certificate.
  ///
  /// @return base64 encoded string
  /// @throws CertificateEncodingException if an encoding error occurs
  ///
  List<String> getEncodedPublicKeyCertificateChain();
}
