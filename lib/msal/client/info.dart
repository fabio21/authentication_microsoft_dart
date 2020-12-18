
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

class ClientInfo {

    //@JsonProperty("uid")
    String uniqueIdentifier;

   // @JsonProperty("utid")
    String uniqueTenantIdentifier;

    static ClientInfo createFromJson(String clientInfoJsonBase64Encoded){
        if(StringHelper.isBlank(clientInfoJsonBase64Encoded)){
            return null;
        }

        byte[] decodedInput = Base64.getUrlDecoder().decode(clientInfoJsonBase64Encoded.getBytes(StandardCharset.UTF_8));

        return JsonHelper.convertJsonToObject(new String(decodedInput, StandardCharset.UTF_8), ClientInfo.class);
    }

    String toAccountIdentifier(){
        return uniqueIdentifier + POINT_DELIMITER + uniqueTenantIdentifier;
    }
}
