class User {
  final String appId;
  final String objectId;
  final String userType;
  final String displayName;
  final String licenses;
  final String upn;
  final String mfa;
  final String protectionPolicy;
  final String homeDomain;
  final String homeUPN;
  final String b2cProvider;
  final String labName;
  final String lastUpdatedBy;
  final String lastUpdatedDate;

  String password;

  String federationProvider;

  User({
    this.appId,
    this.objectId,
    this.userType,
    this.displayName,
    this.licenses,
    this.upn,
    this.mfa,
    this.protectionPolicy,
    this.homeDomain,
    this.homeUPN,
    this.b2cProvider,
    this.labName,
    this.lastUpdatedBy,
    this.lastUpdatedDate,
    this.password,
    this.federationProvider,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      appId: json["appId"],
      objectId: json["objectId"],
      userType: json["userType"],
      displayName: json["displayName"],
      licenses: json["licenses"],
      upn: json["upn"],
      mfa: json["mfa"],
      protectionPolicy: json["protectionPolicy"],
      homeDomain: json["homeDomain"],
      homeUPN: json["homeUPN"],
      b2cProvider: json["b2cProvider"],
      labName: json["labName"],
      lastUpdatedBy: json["lastUpdatedBy"],
      lastUpdatedDate: json["lastUpdatedDate"],
      password: json["password"],
      federationProvider: json["federationProvider"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["appId"] = this.appId;
    data["objectId"] = this.objectId;
    data["userType"] = this.userType;
    data["displayName"] = this.displayName;
    data["licenses"] = this.licenses;
    data["upn"] = this.upn;
    data["mfa"] = this.mfa;
    data["protectionPolicy"] = this.protectionPolicy;
    data["homeDomain"] = this.homeDomain;
    data["homeUPN"] = this.homeUPN;
    data["b2cProvider"] = this.b2cProvider;
    data["labName"] = this.labName;
    data["lastUpdatedBy"] = this.lastUpdatedBy;
    data["lastUpdatedDate"] = this.lastUpdatedDate;
    data["password"] = this.password;
    data["federationProvider"] = this.federationProvider;
    return data;
  }
}
