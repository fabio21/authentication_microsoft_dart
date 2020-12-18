
 import 'package:microsoft_authentication/msal/request/requested_claim_additional_info.dart';
import 'package:microsoft_authentication/msal/utils/collections.dart';

class RequestedClaim {

    String name;
    String claim;

    RequestedClaimAdditionalInfo requestedClaimAdditionalInfo;

    RequestedClaim(String claim, RequestedClaimAdditionalInfo requestedClaimAdditionalInfo){
        this.claim = claim;
        this.requestedClaimAdditionalInfo = requestedClaimAdditionalInfo;
    }

    Map<String, dynamic> any() {
        return Collections.singletonMap(name, requestedClaimAdditionalInfo);
    }
}
