

import 'i_credential.dart';

///
 /// Representation of client credential containing a secret in string format
 ///
 /// For more details, see https://aka.ms/msal4j-client-credentials
 ///
abstract class IClientSecret extends IClientCredential{

    ///
     /// @return secret secret of application requesting a token
    ///
    String clientSecret();
}
