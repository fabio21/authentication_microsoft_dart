import 'aad_authority.dart';
import 'adfs_authority.dart';
import 'authority_type.dart';
import 'b2c_authority.dart';

abstract class Authority {
  static const String _ADFS_PATH_SEGMENT = "adfs";
  static const String _B2C_PATH_SEGMENT = "tfp";

  static const String _USER_REALM_ENDPOINT = "common/userrealm";
  static const String _userRealmEndpointFormat =
      "https://%s/" + _USER_REALM_ENDPOINT + "/%s?api-version=1.0";

  String authority;
  Uri canonicalAuthorityUrl;
  AuthorityType authorityType;
  String selfSignedJwtAudience;

  String host;
  String tenant;
  bool isTenantless;

  String authorizationEndpoint;
  String tokenEndpoint;

  String deviceCodeEndpoint;

  Uri tokenEndpointUrl() {
    return Uri.directory(tokenEndpoint);
  }

  Authority(Uri canonicalAuthorityUrl, AuthorityType authorityType) {
    this.canonicalAuthorityUrl = canonicalAuthorityUrl;
    this.authorityType = authorityType;
    setCommonAuthorityProperties();
  }

  void setCommonAuthorityProperties() {
    this.tenant = getTenant(canonicalAuthorityUrl, authorityType);
    this.host = canonicalAuthorityUrl.authority;
  }

  static Authority createAuthority(Uri authorityUrl) {
    validateAuthority(authorityUrl);

    AuthorityType authorityType = detectAuthorityType(authorityUrl);
    if (authorityType == AuthorityType.AAD) {
      return new AADAuthority(authorityUrl);
    } else if (authorityType == AuthorityType.B2C) {
      return new B2CAuthority(authorityUrl);
    } else if (authorityType == AuthorityType.ADFS) {
      return new ADFSAuthority(authorityUrl);
    } else {
      throw new Exception("Unsupported Authority Type");
    }
  }

  static AuthorityType detectAuthorityType(Uri authorityUrl) {
    if (authorityUrl == null) {
      throw new Exception("canonicalAuthorityUrl");
    }

    final String path = authorityUrl.path.substring(1);
    if (path.isEmpty) {
      throw new Exception(
          "authority Uri should have at least one segment in the path (i.e. https://<host>/<path>/...)");
    }

    final String firstPath = path.substring(0, path.indexOf("/"));

    if (_isB2CAuthority(firstPath)) {
      return AuthorityType.B2C;
    } else if (_isAdfsAuthority(firstPath)) {
      return AuthorityType.ADFS;
    } else {
      return AuthorityType.AAD;
    }
  }

  static void validateAuthority(Uri authorityUrl) {
    if (!authorityUrl.authority.startsWith("https", 4)) {
      throw new Exception("authority should use the 'https' scheme");
    }

    if (authorityUrl.toString().contains("#")) {
      throw new Exception("authority is invalid format (contains fragment)");
    }

    if (authorityUrl.query.isNotEmpty) {
      throw new Exception("authority cannot contain query parameters");
    }

    final String path = authorityUrl.path;

    if (path.length == 0) {
      throw new Exception();
    }

    var segments = path.substring(1).split("/");

    if (segments.length == 0) {
      throw new Exception();
    }

    for (String segment in segments) {
      if (segment.isEmpty) {
        throw new Exception();
      }
    }
  }

  static String getTenant(Uri authorityUrl, AuthorityType authorityType) {
    var segments = authorityUrl.path.substring(1).split("/");
    if (authorityType == AuthorityType.B2C) {
      return segments[1];
    }
    return segments[0];
  }

  String getUserRealmEndpoint(String username) {
     return S.format(_userRealmEndpointFormat,[ host, username]);
  }

  static bool _isAdfsAuthority(final String firstPath) {
    return firstPath.contains(_ADFS_PATH_SEGMENT);
    //return firstPath.compareToIgnoreCase(_ADFS_PATH_SEGMENT) == 0;
  }

  static bool _isB2CAuthority(final String firstPath) {
    return firstPath.contains(_B2C_PATH_SEGMENT);
    //return firstPath.compareToIgnoreCase(_B2C_PATH_SEGMENT) == 0;
  }

// static deviceCodeEndpoint(){
//      return deviceCodeEndpoint;
//  }
}
