
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

import 'i_assertion.dart';

class ClientAssertion implements IClientAssertion {

    static final String assertionType = JWTAuthentication.CLIENT_ASSERTION_TYPE;
    String assertionB;


    ClientAssertion(final String assertion) {
        if (StringHelper.isBlank(assertion)) {
            throw new Exception("assertion");
        }
        this.assertionB = assertion;
    }

  @override
  String assertion() {
    return assertionB;
  }
}