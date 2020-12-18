abstract class UserQueryParameters {

  static const String USER_TYPE = "usertype";
  static const String MFA = "mfa";
  static const String PROTECTION_POLICEY = "protectionpolicy";
  static const String HOME_DOMAIN = "homedomain";
  static const String HOME_UPN = "homeupn";
  static const String B2C_PROVIDER = "b2cprovider";
  static const String FEDERATION_PROVIDER = "federationprovider";
  static const String AZURE_ENVIRONMENT = "azureenvironment";
  static const String SIGN_IN_AUDIENCE = "signinaudience";
   Map<String, String> parameters =  Map();
}
