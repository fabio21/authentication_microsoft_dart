import 'package:microsoft_authentication/lab_api/lab/lab_constants.dart';
import 'package:microsoft_authentication/lab_api/lab/lab_service.dart';
import 'package:webdriver/async_io.dart';

import '../azure_environment.dart';
import '../key_vault_secrets_provider.dart';

class AppCredentialProvider {
  KeyVaultSecretsProvider keyVaultSecretsProvider;
  String labVaultClientId;
  String labVaultPassword;
  String clientId;
  String oboClientId;
  String oboAppIdURI;
  String oboPassword;

  AppCredentialProvider(String azureEnvironment)
  {
    keyVaultSecretsProvider = new KeyVaultSecretsProvider();
    labVaultClientId = keyVaultSecretsProvider.getSecret(LabConstants.APP_ID_KEY_VAULT_SECRET);
    labVaultPassword = keyVaultSecretsProvider.getSecret(LabConstants.APP_PASSWORD_KEY_VAULT_SECRET);
    switch (azureEnvironment) {
      case AzureEnvironment.AZURE:
        clientId = "c0485386-1e9a-4663-bc96-7ab30656de7f";
        oboClientId = "f4aa5217-e87c-42b2-82af-5624dd14ee72";
        oboAppIdURI = "api://f4aa5217-e87c-42b2-82af-5624dd14ee72";
        oboPassword = keyVaultSecretsProvider.getSecret(LabConstants.OBO_APP_PASSWORD_URL);
        break;
      case AzureEnvironment.AZURE_US_GOVERNMENT:
        clientId = LabConstants.ARLINGTON_APP_ID;
        oboClientId = LabConstants.ARLINGTON_OBO_APP_ID;
        oboAppIdURI = "https://arlmsidlab1.us/IDLABS_APP_Confidential_Client";
        oboPassword = keyVaultSecretsProvider.getSecret(LabService.getApp(oboClientId).clientSecret);
        break;
      default:
        throw new UnsupportedOperationException(500, ("Azure Environment - " + azureEnvironment) + " unsupported");
    }
  }

  String getAppId()
  {
    return clientId;
  }

  String getOboAppId()
  {
    return oboClientId;
  }

  String getOboAppIdURI()
  {
    return oboAppIdURI;
  }

  String getOboAppPassword()
  {
    return oboPassword;
  }

  String getLabVaultAppId()
  {
    return labVaultClientId;
  }

  String getLabVaultPassword()
  {
    return labVaultPassword;
  }
}