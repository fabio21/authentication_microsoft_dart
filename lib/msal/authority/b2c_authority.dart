
import 'aad_authority.dart';
import 'authority.dart';
import 'authority_type.dart';

class B2CAuthority extends Authority {

    static const _AUTHORIZATION_ENDPOINT = "/oauth2/v2.0/authorize";
    static const _TOKEN_ENDPOINT = "/oauth2/v2.0/token";

    static const _B2C_AUTHORIZATION_ENDPOINT_FORMAT = "https://%s/%s/%s" + _AUTHORIZATION_ENDPOINT;
    static const _B2C_TOKEN_ENDPOINT_FORMAT = "https://%s/%s" + _TOKEN_ENDPOINT + "?p=%s";
    String policy;

    B2CAuthority(final Uri authorityUrl) : super(authorityUrl, AuthorityType.B2C){
        setAuthorityProperties();
    }

    void validatePathSegments(List<String> segments){
        if(segments.length < 3){
            throw new Exception(
                    "B2C 'authority' Uri should have at least 3 segments in the path " +
                            "(i.e. https://<host>/tfp/<tenant>/<policy>/...)");
        }
    }

    void setAuthorityProperties() {
        var segments = canonicalAuthorityUrl.path.substring(1).split("/");

        validatePathSegments(segments);

        policy = segments[2];

        final String b2cAuthorityFormat = "https://%s/%s/%s/%s/";
        this.authority = S.format(b2cAuthorityFormat, [
                canonicalAuthorityUrl.authority,segments[0],segments[1], segments[2]]);

        this.authorizationEndpoint = S.format(_B2C_AUTHORIZATION_ENDPOINT_FORMAT, [host, tenant, policy]);
        this.tokenEndpoint = S.format(_B2C_TOKEN_ENDPOINT_FORMAT,[ host, tenant, policy]);
        this.selfSignedJwtAudience = this.tokenEndpoint;
    }
}
