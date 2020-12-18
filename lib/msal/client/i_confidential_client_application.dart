
import 'package:microsoft_authentication/msal/authentication/iauthentication_result.dart';

import 'credential_parameters.dart';
import 'i_application_base.dart';

///
 /// Interface representing a confidential client application (Web App, Web API, Daemon App).
 /// Confidential client applications are trusted to safely store application secrets, and therefore
 /// can be used to acquire tokens in then name of either the application or an user.
 /// For details see https://aka.ms/msal4jclientapplications
///
abstract class IConfidentialClientApplication extends IClientApplicationBase {
    ///
     /// @return a boolean value which determines whether x5c claim (public key of the certificate)
     /// will be sent to the STS.
    ///
    bool sendX5c();

    ///
     /// Acquires tokens from the authority configured in the application, for the confidential client
     /// itself
     /// @param parameters instance of {@link ClientCredentialParameters}
     /// @return {@link CompletableFuture} containing an {@link IAuthenticationResult}
    ///
    Future<IAuthenticationResult> acquireToken(ClientCredentialParameters parameters);

    ///
     /// Acquires an access token for this application (usually a Web API) from the authority configured
     /// in the application, in order to access another downstream protected Web API on behalf of a user
     /// using the On-Behalf-Of flow. This confidential client application was itself called with a token
     /// which will be provided in the {@link UserAssertion} to the {@link OnBehalfOfParameters}
     /// @param parameters instance of {@link OnBehalfOfParameters}
     /// @return {@link CompletableFuture} containing an {@link IAuthenticationResult}
    ///
    Future<IAuthenticationResult> acquireToken(OnBehalfOfParameters parameters);
}
