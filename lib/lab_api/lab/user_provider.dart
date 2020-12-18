
import 'package:microsoft_authentication/lab_api/lab/lab_service.dart';
import 'package:microsoft_authentication/lab_api/user/user_model.dart';
import 'package:microsoft_authentication/lab_api/user/user_query_parameters.dart';
import 'package:microsoft_authentication/lab_api/user/user_type.dart';

import '../azure_environment.dart';
import '../key_vault_secrets_provider.dart';

class LabUserProvider {

  static LabUserProvider instance = LabUserProvider._internal();

   KeyVaultSecretsProvider _keyVaultSecretsProvider;
   LabService _labService;
   Map<UserQueryParameters, User> _userCache;

  LabUserProvider._internal(){
    _keyVaultSecretsProvider = new KeyVaultSecretsProvider();
    _labService = new LabService();
    _userCache = new Map();
  }


    User getDefaultUser({String azureEnvironment = AzureEnvironment.AZURE}) {
    UserQueryParameters query;
    query.parameters[UserQueryParameters.AZURE_ENVIRONMENT] =  azureEnvironment;
    return getLabUser(query);
  }


   User getFederatedAdfsUser(String federationProvider, {String azureEnvironment = AzureEnvironment.AZURE}){
    UserQueryParameters query;
    query.parameters[UserQueryParameters.AZURE_ENVIRONMENT] = azureEnvironment;
    query.parameters[UserQueryParameters.FEDERATION_PROVIDER] =  federationProvider;
    query.parameters[UserQueryParameters.USER_TYPE] =  UserType.FEDERATED;

    return getLabUser(query);
  }

   User getOnPremAdfsUser(String federationProvider){
    UserQueryParameters query;
    query.parameters[UserQueryParameters.FEDERATION_PROVIDER] = federationProvider;
    query.parameters[UserQueryParameters.USER_TYPE] =  UserType.ON_PREM;

    return getLabUser(query);
  }


   User getB2cUser(String b2cProvider,{String azureEnvironment = AzureEnvironment.AZURE}) {

    UserQueryParameters query;
    query.parameters[UserQueryParameters.AZURE_ENVIRONMENT] =  azureEnvironment;
    query.parameters[UserQueryParameters.USER_TYPE] = UserType.B2C;
    query.parameters[UserQueryParameters.B2C_PROVIDER] = b2cProvider;

    return getLabUser(query);
  }

  User getUserByAzureEnvironment(String azureEnvironment) {

    UserQueryParameters query;
    query.parameters[UserQueryParameters.AZURE_ENVIRONMENT] =  azureEnvironment;

    return getLabUser(query);
  }

  User getLabUser(UserQueryParameters userQuery){
    if(_userCache.containsKey(userQuery)){
      return _userCache[userQuery];
    }
    User response = _labService.getUser(userQuery);
    _userCache[userQuery] = response;
    return response;
  }
}
