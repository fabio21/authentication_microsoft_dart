
import 'dart:typed_data';

import 'authority.dart';
import 'authority_type.dart';

class AADAuthority extends Authority {

    static const String TENANTLESS_TENANT_NAME = "common";
    static const String AUTHORIZATION_ENDPOINT = "oauth2/v2.0/authorize";
    static const String TOKEN_ENDPOINT = "oauth2/v2.0/token";
    static const String DEVICE_CODE_ENDPOINT = "oauth2/v2.0/devicecode";

    static const String AAD_AUTHORITY_FORMAT = "https://%s/%s/";
    static const String AAD_AUTHORIZATION_ENDPOINT_FORMAT = AAD_AUTHORITY_FORMAT + AUTHORIZATION_ENDPOINT;
    static const String AAD_TOKEN_ENDPOINT_FORMAT = AAD_AUTHORITY_FORMAT + TOKEN_ENDPOINT;
    static const String DEVICE_CODE_ENDPOINT_FORMAT = AAD_AUTHORITY_FORMAT + DEVICE_CODE_ENDPOINT;

    AADAuthority(final Uri authorityUrl) : super(authorityUrl, AuthorityType.AAD) {
        _setAuthorityProperties();
        this.authority =  S.format(AAD_AUTHORITY_FORMAT, [host, tenant]);
    }

     void _setAuthorityProperties() {
        this.authorizationEndpoint = "$AAD_AUTHORIZATION_ENDPOINT_FORMAT $host $tenant";
        this.tokenEndpoint = S.format(AAD_TOKEN_ENDPOINT_FORMAT, [host, tenant]);
        this.deviceCodeEndpoint = S.format(DEVICE_CODE_ENDPOINT_FORMAT, [host, tenant]);

        this.isTenantless = TENANTLESS_TENANT_NAME.contains(tenant);
        this.selfSignedJwtAudience = this.tokenEndpoint;
    }


}

extension S on String{

static String format(String form, List<String> args /*XXX*/) {
    String str = "";
    args.forEach((element) {
       form
           .replaceFirst("%a", element) //floating point (except BigDecimal) returns Hex output of floating point number
           .replaceFirst("%b", element) //Any type “true” if non-null, “false” if null
           .replaceFirst("%c", element) //character  Unicode character
           .replaceFirst("%d", element) //integer (incl. byte, short, int, long, bigint) Decimal Integer
           .replaceFirst("%e", element) //floating point decimal number in scientific notation
           .replaceFirst("%f", element) //floating point decimal number
           .replaceFirst("%g", element) //floating point decimal number, possibly in scientific notation depending on the precision and value.
           .replaceFirst("%h", element) //any type Hex String of value from hashCode() method.
           .replaceFirst("%n", element) //none Platform-specific line separator.
           .replaceFirst("%o", element) //integer (incl. byte, short, int, long, bigint) Octal number
           .replaceFirst("%s", element) //any type String value
           .replaceFirst("%t", element) //Date/Time (incl. long, Calendar, Date and TemporalAccessor) %t is the prefix for Date/Time conversions. More formatting flags are needed after this. See Date/Time conversion below.
           .replaceFirst("%x", element); //integer (incl. byte, short, int, long, bigint) Hex string.
        str = form;
    });
    return str;
}
}