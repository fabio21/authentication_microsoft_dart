
import 'package:microsoft_authentication/msal/request/requested_claim.dart';
import 'package:microsoft_authentication/msal/request/requested_claim_additional_info.dart';

///
 /// Represents the claims request parameter as an object
 ///
 /// @see <a href="https://openid.net/specs/openid-connect-core-1_0-final.html#ClaimsParameter">https://openid.net/specs/openid-connect-core-1_0-final.html#ClaimsParameter</a>
///
 class ClaimsRequest {


    List<RequestedClaim> idTokenRequestedClaims = [];
    List<RequestedClaim> userInfoRequestedClaims = [];
    List<RequestedClaim> accessTokenRequestedClaims = [];

    ///
     /// Inserts a claim into the list of claims to be added to the "id_token" section of an OIDC claims request
     ///
     /// @param claim the name of the claim to be requested
     /// @param requestedClaimAdditionalInfo additional information about the claim being requested
    ///
     void requestClaimInIdToken(String claim, RequestedClaimAdditionalInfo requestedClaimAdditionalInfo) {
        idTokenRequestedClaims.add(new RequestedClaim(claim, requestedClaimAdditionalInfo));
    }

    ///
     /// Inserts a claim into the list of claims to be added to the "access_token" section of an OIDC claims request
     ///
     /// @param claim the name of the claim to be requested
     /// @param requestedClaimAdditionalInfo additional information about the claim being requested
    ///
   void requestClaimInAccessToken(String claim, RequestedClaimAdditionalInfo requestedClaimAdditionalInfo) {
        accessTokenRequestedClaims.add(new RequestedClaim(claim, requestedClaimAdditionalInfo));
    }

    ///
     /// Converts the ClaimsRequest object to a JSON-formatted String which follows the specification for the OIDC claims request parameter
     ///
     /// @return a String following JSON formatting
    ///
    String formatAsJSONString() {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode rootNode = mapper.createObjectNode();

        if (idTokenRequestedClaims.isNotEmpty) {
            rootNode.set("id_token", _convertClaimsToObjectNode(idTokenRequestedClaims));
        }
        if (userInfoRequestedClaims.isNotEmpty) {
            rootNode.set("userinfo", _convertClaimsToObjectNode(userInfoRequestedClaims));
        }
        if (accessTokenRequestedClaims.isNotEmpty) {
            rootNode.set("access_token", _convertClaimsToObjectNode(accessTokenRequestedClaims));
        }

        return mapper.valueToTree(rootNode).toString();
    }

      _convertClaimsToObjectNode(List<RequestedClaim> claims) {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode claimsNode = mapper.createObjectNode();

        for (RequestedClaim claim: claims) {
            claimsNode.setAll((ObjectNode) mapper.valueToTree(claim));
        }
        return claimsNode;
    }
}
