import 'i_credential.dart';

///
///Credential type containing an assertion of type
///"urn:ietf:params:oauth:token-type:jwt".
///
/// For more details, see https://aka.ms/msal4j-client-credentials
///
abstract class IClientAssertion extends IClientCredential {
  ///
  /// @return Jwt token encoded as a base64 URL encoded string
  ///
  String assertion();
}
