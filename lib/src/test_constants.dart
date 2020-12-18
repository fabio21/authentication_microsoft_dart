class TestConstants
{
  static const String KEYVAULT_DEFAULT_SCOPE = "https://vault.azure.net/.default";
  static const String MSIDLAB_DEFAULT_SCOPE = "https://msidlab.com/.default";
  static const String GRAPH_DEFAULT_SCOPE = "https://graph.windows.net/.default";
  static const String USER_READ_SCOPE = "user.read";
  static const String B2C_LAB_SCOPE = "https://msidlabb2c.onmicrosoft.com/msaapp/user_impersonation";
  static const String B2C_CONFIDENTIAL_CLIENT_APP_SECRETID = "MSIDLABB2C-MSAapp-AppSecret";
  static const String B2C_CONFIDENTIAL_CLIENT_LAB_APP_ID = "MSIDLABB2C-MSAapp-AppID";
  static const String MICROSOFT_AUTHORITY_HOST = "https://login.microsoftonline.com/";
  static const String ARLINGTON_MICROSOFT_AUTHORITY_HOST = "https://login.microsoftonline.us/";
  static const String ORGANIZATIONS_AUTHORITY = (MICROSOFT_AUTHORITY_HOST + "organizations/");
  static const String COMMON_AUTHORITY = (MICROSOFT_AUTHORITY_HOST + "common/");
  static const String MICROSOFT_AUTHORITY = (MICROSOFT_AUTHORITY_HOST + "microsoft.onmicrosoft.com");
  static const String TENANT_SPECIFIC_AUTHORITY = (MICROSOFT_AUTHORITY_HOST + "msidlab4.onmicrosoft.com");
  static const String ARLINGTON_ORGANIZATIONS_AUTHORITY = (ARLINGTON_MICROSOFT_AUTHORITY_HOST + "organizations/");
  static const String ARLINGTON_COMMON_AUTHORITY = (ARLINGTON_MICROSOFT_AUTHORITY_HOST + "common/");
  static const String ARLINGTON_TENANT_SPECIFIC_AUTHORITY = (ARLINGTON_MICROSOFT_AUTHORITY_HOST + "arlmsidlab1.onmicrosoft.us");
  static const String ARLINGTON_GRAPH_DEFAULT_SCOPE = "https://graph.microsoft.us/.default";
  static const String B2C_AUTHORITY = "https://msidlabb2c.b2clogin.com/tfp/msidlabb2c.onmicrosoft.com/";
  static const String B2C_AUTHORITY_URL = "https://msidlabb2c.b2clogin.com/msidlabb2c.onmicrosoft.com/";
  static const String B2C_ROPC_POLICY = "B2C_1_ROPC_Auth";
  static const String B2C_SIGN_IN_POLICY = "B2C_1_SignInPolicy";
  static const String B2C_AUTHORITY_SIGN_IN = (B2C_AUTHORITY + B2C_SIGN_IN_POLICY);
  static const String B2C_AUTHORITY_ROPC = (B2C_AUTHORITY + B2C_ROPC_POLICY);
  static const String B2C_READ_SCOPE = "https://msidlabb2c.onmicrosoft.com/msidlabb2capi/read";
  static const String B2C_MICROSOFTLOGIN_AUTHORITY = "https://login.microsoftonline.com/tfp/msidlabb2c.onmicrosoft.com/";
  static const String B2C_MICROSOFTLOGIN_ROPC = (B2C_MICROSOFTLOGIN_AUTHORITY + B2C_ROPC_POLICY);
  static const String LOCALHOST = "http://localhost:";
  static const String LOCAL_FLAG_ENV_VAR = "MSAL_JAVA_RUN_LOCAL";
  static const String ADFS_AUTHORITY = "https://fs.msidlab8.com/adfs/";
  static const String ADFS_SCOPE = USER_READ_SCOPE;
  static const String ADFS_APP_ID = "PublicClientId";
  static const String CLAIMS = "{\"id_token\":{\"auth_time\":{\"essential\":true}}}";
  static  List<String> CLIENT_CAPABILITIES_EMPTY = new List<String>();
  static  List<String> CLIENT_CAPABILITIES_LLT = new List<String>();
}