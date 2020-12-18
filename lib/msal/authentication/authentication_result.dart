
 import 'package:microsoft_authentication/msal/account/account_cache_entity.dart';
import 'package:microsoft_authentication/msal/account/iaccount.dart';
import 'package:microsoft_authentication/msal/utils/string_helper.dart';

class AuthenticationResult implements IAuthenticationResult {


    final String accessToken;
    final int expiresOn;
    final int extExpiresOn;
    final String refreshToken;
    final int refreshOn;
    final String familyId;
    final String idToken;
    final IdToken idTokenObject = getIdTokenObj();

    final AccountCacheEntity accountCacheEntity;
    final IAccount account = getAccount();
    final ITenantProfile tenantProfile = getTenantProfile();

  AuthenticationResult(this.accessToken, this.expiresOn, this.extExpiresOn, this.refreshToken, this.refreshOn, this.familyId, this.idToken, this.accountCacheEntity, this.scopes);

    IdToken getIdTokenObj() {
        if (StringHelper.isBlank(idToken)) {
            return null;
        }
        try {
            String idTokenJson = JWTParser.parse(idToken).getParsedParts()[1].decodeToString();

            return JsonHelper.convertJsonToObject(idTokenJson, IdToken.class);
        } catch (e) {
            e.printStackTrace();
        }
        return null;
    }

     IAccount getAccount() {
        if (accountCacheEntity == null) {
            return null;
        }
        return accountCacheEntity.toAccount();
    }


    ITenantProfile getTenantProfile() {
        if (idToken == null) {
            return null;
        }

        try {
            return new TenantProfile(JWTParser.parse(idToken).getJWTClaimsSet().getClaims());
        } catch (e) {
            throw new MsalClientException("Cached JWT could not be parsed: " + e.getMessage(), AuthenticationErrorCode.INVALID_JWT);
        }
    }

    String environment;

    final Date expiresOnDate = new Date(expiresOn * 1000);

    final String scopes;
}
