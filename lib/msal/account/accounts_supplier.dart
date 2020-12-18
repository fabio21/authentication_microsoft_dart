
import 'package:microsoft_authentication/msal/aad/aad_instance_discovery_provider.dart';
import 'package:microsoft_authentication/msal/aad/instance_discovery_metadata_entry.dart';
import 'package:microsoft_authentication/msal/abstract/abstract_client_application_base.dart';
import 'package:microsoft_authentication/msal/account/iaccount.dart';
import 'package:microsoft_authentication/msal/msal/msal_request.dart';

class AccountsSupplier  {

    AbstractClientApplicationBase clientApplication;
    MsalRequest msalRequest;

    AccountsSupplier(AbstractClientApplicationBase clientApplication, MsalRequest msalRequest) {

        this.clientApplication = clientApplication;
        this.msalRequest = msalRequest;
    }

    Set<IAccount> get() {
        try {
            InstanceDiscoveryMetadataEntry instanceDiscoveryData =
                    AadInstanceDiscoveryProvider.getMetadataEntry(
                        new Uri.https(clientApplication.authority, ""),
                        clientApplication.isValidateAuthority,
                        msalRequest,
                        clientApplication.getServiceBundle()
                    );

            return clientApplication.tokenCache.getAccounts
                    (clientApplication.clientId, instanceDiscoveryData.aliases);

        } catch (ex) {

            clientApplication.log.error(
                    LogHelper.createMessage("Execution of " + this + " failed.",
                            msalRequest.headers().getHeaderCorrelationIdValue()), ex);

            throw new CompletionException(ex);
        }
    }
}
