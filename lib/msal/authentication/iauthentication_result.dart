import 'package:microsoft_authentication/msal/account/iaccount.dart';
import 'package:intl/intl.dart';

///
/// Interface representing the results of token acquisition operation.
///
abstract class IAuthenticationResult {
  ///
  /// @return access token
  ///
  String accessToken();

  ///
  /// @return id token
  ///
  String idToken();

  ///
  /// @return user account
  ///
  IAccount account();

  ///
  /// @return tenant profile
  ///
  ITenantProfile tenantProfile();

  ///
  /// @return environment
  ///
  String environment();

  ///
  /// @return granted scopes values returned by the service
  ///
  String scopes();

  ///
  /// @return access token expiration date
  ///
  DateTime expiresOnDate();
}
