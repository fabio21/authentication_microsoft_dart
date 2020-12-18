
import 'package:microsoft_authentication/lab_api/azure_environment.dart';

class EnvironmentsProvider {

    static createData(){
      return [
        { AzureEnvironment.AZURE },
        { AzureEnvironment.AZURE_US_GOVERNMENT }
      ];
    }
}
