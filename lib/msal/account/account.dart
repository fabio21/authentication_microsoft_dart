
import 'iaccount.dart';

class Account implements IAccount {

   final String homeAccountIdStr;
   final String environmentStr;
   final String usernameStr;

  Account(this.homeAccountIdStr, this.environmentStr, this.usernameStr);

  @override
  String environment() {
    // TODO: implement environment
    throw UnimplementedError();
  }

  @override
  Map<String, ITenantProfile> getTenantProfiles() {
      return this.tenantProfilesStr;
  }

  @override
  String homeAccountId() {
      return homeAccountIdStr;
  }

  @override
  String username() {
      return this.usernameStr;
  }


    // Map<String, ITenantProfile> tenantProfiles;
    //
    // public Map<String, ITenantProfile> getTenantProfiles() {
    //     return tenantProfiles;
    // }
}
