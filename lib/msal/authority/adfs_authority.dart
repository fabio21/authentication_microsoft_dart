

import 'aad_authority.dart';
import 'authority.dart';
import 'authority_type.dart';

class ADFSAuthority extends Authority {

    static const AUTHORIZATION_ENDPOINT = "oauth2/authorize";
    static const TOKEN_ENDPOINT = "oauth2/token";
    static const DEVICE_CODE_ENDPOINT = "oauth2/devicecode";

     static const _ADFS_AUTHORITY_FORMAT = "https://%s/%s/";
     static const _DEVICE_CODE_ENDPOINT_FORMAT = _ADFS_AUTHORITY_FORMAT + DEVICE_CODE_ENDPOINT;

    ADFSAuthority(final Uri authorityUrl) :super(authorityUrl, AuthorityType.ADFS) {
        this.authority = S.format(_ADFS_AUTHORITY_FORMAT, [host, tenant]);
        this.authorizationEndpoint = authority + AUTHORIZATION_ENDPOINT;
        this.tokenEndpoint = authority + TOKEN_ENDPOINT;
        this.selfSignedJwtAudience = this.tokenEndpoint;
        this.deviceCodeEndpoint = S.format(_DEVICE_CODE_ENDPOINT_FORMAT, [host, tenant]);
    }


}
