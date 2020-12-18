

import 'package:microsoft_authentication/msal/authority/authority.dart';
import 'package:microsoft_authentication/msal/msal/msal_client_exception.dart';

import 'acquire_token_by_authorization_grantSupplier.dart';
import 'acquire_token_by_interactive_flow_supplier.dart';

class AcquireTokenByDeviceCodeFlowSupplier extends AuthenticationResultSupplier {

   DeviceCodeFlowRequest deviceCodeFlowRequest;
   PublicClientApplication clientApplication;

        AcquireTokenByDeviceCodeFlowSupplier(PublicClientApplication clientApplication,
                                             DeviceCodeFlowRequest deviceCodeFlowRequest) {
        this.deviceCodeFlowRequest = deviceCodeFlowRequest;
        this._clientApplication = clientApplication;
    }

    AuthenticationResult execute() {
        Authority requestAuthority = clientApplication.authenticationAuthority;
        requestAuthority = getAuthorityWithPrefNetworkHost(requestAuthority.authority());

        DeviceCode deviceCode = getDeviceCode(requestAuthority);

        return acquireTokenWithDeviceCode(deviceCode, requestAuthority);
    }

     DeviceCode getDeviceCode(Authority requestAuthority) {

        DeviceCode deviceCode = deviceCodeFlowRequest.acquireDeviceCode(
                requestAuthority.deviceCodeEndpoint,
                clientApplication.clientId(),
                deviceCodeFlowRequest.headers().getReadonlyHeaderMap(),
                this.clientApplication.getServiceBundle());

        deviceCodeFlowRequest.parameters().deviceCodeConsumer().accept(deviceCode);

        return deviceCode;
    }

     AuthenticationResult acquireTokenWithDeviceCode(DeviceCode deviceCode, Authority requestAuthority) {
        deviceCodeFlowRequest.createAuthenticationGrant(deviceCode);
        int expirationTimeInSeconds = getCurrentSystemTimeInSeconds() + deviceCode.expiresIn();

        AcquireTokenByAuthorizationGrantSupplier acquireTokenByAuthorisationGrantSupplier =
                new AcquireTokenByAuthorizationGrantSupplier(
                        clientApplication,
                        deviceCodeFlowRequest,
                        requestAuthority);

        while (getCurrentSystemTimeInSeconds() < expirationTimeInSeconds) {
            if (deviceCodeFlowRequest.futureReference().get().isCancelled()) {
                throw new Exception("Acquire token Device Code Flow was interrupted");
            }
            try {
                return acquireTokenByAuthorisationGrantSupplier.execute();
            } catch (ex) {
                if (ex.errorCode() != null && ex.errorCode().equals(AUTHORIZATION_PENDING)) {
                    TimeUnit.SECONDS.sleep(deviceCode.interval());
                } else {
                    throw ex;
                }
            }
        }
        throw new MsalClientException(message: "Expired Device code", errorCode: AuthenticationErrorCode.CODE_EXPIRED);
    }

     int getCurrentSystemTimeInSeconds(){
        return TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
    }
}
