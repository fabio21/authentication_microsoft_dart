

import 'package:microsoft_authentication/msal/utils/string_helper.dart';

class ClientSecret implements IClientSecret {

    String clientSecret;

     ///
     /// Constructor to create credential with client id and secret
     ///
     /// @param clientSecret
     ///            Secret of the client requesting the token.
     ///
    ClientSecret(this.clientSecret) {
        if (StringHelper.isBlank(clientSecret)) {
            throw new Exception("clientSecret is null or empty");
        }
        this.clientSecret = clientSecret;
    }
}
