
abstract class AbstractMsalAuthorizationGrant {

     Map<String, List<String>> toParameters();

    static const SCOPE_PARAM_NAME = "scope";
    static const SCOPES_DELIMITER = " ";

    static const SCOPE_OPEN_ID = "openid";
    static const SCOPE_PROFILE = "profile";
    static const SCOPE_OFFLINE_ACCESS = "offline_access";

    static const COMMON_SCOPES_PARAM = SCOPE_OPEN_ID + SCOPES_DELIMITER +
            SCOPE_PROFILE + SCOPES_DELIMITER +
            SCOPE_OFFLINE_ACCESS;

    String scopes;

    String getScopes() {
        return scopes;
    }

    ClaimsRequest claims;

    ClaimsRequest getClaims() {
        return claims;
    }
}
