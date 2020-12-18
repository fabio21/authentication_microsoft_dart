import 'package:microsoft_authentication/lab_api/app/app_credential_provider.dart';
import 'package:microsoft_authentication/lab_api/azure_environment.dart';
import 'package:webdriver/async_core.dart';

import 'test_constants.dart';

class Config
{
  String organizationsAuthority;
  String tenantSpecificAuthority;
  String graphDefaultScope;
  AppCredentialProvider appProvider;
  String azureEnvironment;

  Config(String azureEnvironment)
  {
    this.azureEnvironment = azureEnvironment;
    switch (azureEnvironment) {
      case AzureEnvironment.AZURE:
        organizationsAuthority = TestConstants.ORGANIZATIONS_AUTHORITY;
        tenantSpecificAuthority = TestConstants.TENANT_SPECIFIC_AUTHORITY;
        graphDefaultScope = TestConstants.GRAPH_DEFAULT_SCOPE;
        appProvider = new AppCredentialProvider(azureEnvironment);
        break;
      case AzureEnvironment.AZURE_US_GOVERNMENT:
        organizationsAuthority = TestConstants.ARLINGTON_ORGANIZATIONS_AUTHORITY;
        tenantSpecificAuthority = TestConstants.ARLINGTON_TENANT_SPECIFIC_AUTHORITY;
        graphDefaultScope = TestConstants.ARLINGTON_GRAPH_DEFAULT_SCOPE;
        appProvider = new AppCredentialProvider(azureEnvironment);
        break;
      default:
        throw new UnsupportedOperationException(500, ("Azure Environment - " + azureEnvironment) + " unsupported");
    }
  }
}