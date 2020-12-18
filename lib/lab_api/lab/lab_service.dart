import 'dart:convert';

import 'package:microsoft_authentication/lab_api/app/app_model.dart';
import 'package:microsoft_authentication/lab_api/lab/lab_constants.dart';
import 'package:microsoft_authentication/lab_api/user/user_model.dart';
import 'package:microsoft_authentication/lab_api/user/user_query_parameters.dart';
import 'package:microsoft_authentication/lab_api/user/user_secret.dart';
import 'package:microsoft_authentication/src/test_constants.dart';

import '../federation_provider.dart';
import '../http_claint_helper.dart';
import '../key_vault_secrets_provider.dart';

class LabService {

  static ConfidentialClientApplication labApp;

  static ObjectMapper mapper = new ObjectMapper()
      .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

  static const mapper = jsonDecode(De)

  // //static <T> T convertJsonToObject(final String json, final Class<T> clazz) {
  // try {
  // return mapper.readValue(json, clazz);
  // } catch (e) {
  // throw new Exception("JSON processing error: " + e.getMessage(), e);
  // }
  // }

  static void initLabApp() {
  KeyVaultSecretsProvider keyVaultSecretsProvider = new KeyVaultSecretsProvider();

  String appID = keyVaultSecretsProvider.getSecret(LabConstants.APP_ID_KEY_VAULT_SECRET);
  String appSecret = keyVaultSecretsProvider.getSecret(LabConstants.APP_PASSWORD_KEY_VAULT_SECRET);

  labApp = ConfidentialClientApplication.builder(
  appID, ClientCredentialFactory.createFromSecret(appSecret)).
  authority(TestConstants.MICROSOFT_AUTHORITY).
  build();
  }

  static String getLabAccessToken() {
  if(labApp == null){
  initLabApp();
  }
  return labApp.acquireToken(ClientCredentialParameters
      .builder(Collections.singleton(TestConstants.MSIDLAB_DEFAULT_SCOPE))
      .build()).
  get().accessToken();
  }

  User getUser(UserQueryParameters query){
  try {
  Map<String, String> queryMap = query.parameters;
  String result = HttpClientHelper.sendRequestToLab(LabConstants.LAB_USER_ENDPOINT, queryMap, getLabAccessToken());

  Object list = jsonDecode(result);
  List<User> users = (list as List).map((e) => User.fromJson(e)).toList();  //convertJsonToObject(result, App[].class);

  User user = users[0];
  user.password =  getSecret(user.labName);

  if (query.parameters.containsKey(UserQueryParameters.FEDERATION_PROVIDER)) {
  user.federationProvider = query.parameters.get(UserQueryParameters.FEDERATION_PROVIDER);
  } else {
  user.federationProvider = FederationProvider.NONE;
  }
  return user;
  } catch (ex) {
  throw new Exception("Error getting user from lab: " + ex.getMessage());
  }
  }

static App getApp(String appId){
  try {
  String result = HttpClientHelper.sendRequestToLab(LabConstants.LAB_APP_ENDPOINT, appId, getLabAccessToken());
  Object list = jsonDecode(result);
  List<App> apps = (list as List).map((e) => App.fromJson(e)).toList();  //convertJsonToObject(result, App[].class);
  return apps[0];
  } catch (ex) {
  throw new Exception("Error getting app from lab: " + ex.getMessage());
  }
  }

 static Lab getLab(String labId) {
  String result;
  try {
  result = HttpClientHelper.sendRequestToLab(
  LabConstants.LAB_LAB_ENDPOINT, labId, getLabAccessToken());
  Lab[] labs = convertJsonToObject(result, Lab[].class);
  return labs[0];
  } catch (ex) {
  throw new Exception("Error getting lab from lab: " + ex.getMessage());
  }
  }

  static String getSecret(String labName){
  String result;
  try {
  Map<String, dynamic> queryMap = new Map<String, dynamic>();
  queryMap["secret"] = labName;

  result = HttpClientHelper.sendRequestToLab(
  LabConstants.LAB_USER_SECRET_ENDPOINT, queryMap, getLabAccessToken());

  return UserSecret.fromJson(jsonDecode(result)).value;
  //return convertJsonToObject(result, UserSecret.class).value;
  } catch (ex) {
  throw new Exception("Error getting user secret from lab: " + ex.getMessage());
  }
  }
}
