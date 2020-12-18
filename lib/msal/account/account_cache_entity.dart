
import 'package:microsoft_authentication/msal/authority/authority.dart';
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

import 'account.dart';
import 'iaccount.dart';

class AccountCacheEntity {

    static const MSSTS_ACCOUNT_TYPE = "MSSTS";
    static const  ADFS_ACCOUNT_TYPE = "ADFS";

    //@JsonProperty("home_account_id")
     String homeAccountId;
    //@JsonProperty("environment")
    String environment;
    //@JsonProperty("realm")
    String realm;
    //@JsonProperty("local_account_id")
    String localAccountId;
    //@JsonProperty("username")
    String username;
    //@JsonProperty("name")
    String name;
    //@JsonProperty("client_info")
    String clientInfoStr;
    //@JsonProperty("authority_type")
    String authorityType;

    ClientInfo clientInfo() {
        return ClientInfo.createFromJson(clientInfoStr);
    }



    String getKey() {

        List<String> keyParts = [];

        keyParts.add(homeAccountId);
        keyParts.add(environment);
        keyParts.add(StringHelper.isBlank(realm) ? "" : realm);

        return String.join(Constants.CACHE_KEY_SEPARATOR, keyParts).toLowerCase();
    }

    static AccountCacheEntity create(String clientInfoStr, Authority requestAuthority, IdToken idToken, String policy) {

        AccountCacheEntity account = new AccountCacheEntity();
        account.authorityType = MSSTS_ACCOUNT_TYPE;
        account.clientInfoStr = clientInfoStr;

        account.homeAccountId = policy != null ? account.clientInfo().toAccountIdentifier() + Constants.CACHE_KEY_SEPARATOR + policy :
                account.clientInfo().toAccountIdentifier();
        account.environment = requestAuthority.host;
        account.realm = requestAuthority.tenant;

        if (idToken != null) {
            String localAccountId = !StringHelper.isBlank(idToken.objectIdentifier)
                    ? idToken.objectIdentifier : idToken.subject;
            account.localAccountId = localAccountId;
            account.username = idToken.preferredUsername;
            account.name = idToken.name;
        }

        return account;
    }

    static AccountCacheEntity createADFSAccount(Authority requestAuthority, IdToken idToken) {

        AccountCacheEntity account = new AccountCacheEntity();
        account.authorityType = ADFS_ACCOUNT_TYPE;
        account.homeAccountId = idToken.subject;

        account.environment = requestAuthority.host;

        account.username = idToken.upn;
        account.name = idToken.uniqueName;

        return account;
    }

    static AccountCacheEntity create(String clientInfoStr, Authority requestAuthority, IdToken idToken){
        return create(clientInfoStr, requestAuthority, idToken, null);
    }

     toAccount(){
        return new Account(homeAccountId, environment, username);
    }
}
