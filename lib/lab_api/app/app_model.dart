class App {
  String appType;
  String appName;
  String appId;
  String redirectUri;
  String authority;
  String labName;
  String clientSecret;

  App(
      {this.appType,
      this.appName,
      this.appId,
      this.redirectUri,
      this.authority,
      this.labName,
      this.clientSecret,
      });

  factory App.fromJson(Map<String, dynamic> json){
    return App(
      appType: json['appType'],
      appName: json['appName'],
      appId: json['appId'],
      redirectUri: json['redirectUri'],
      authority: json['authority'],
      labName: json['labName'],
      clientSecret: json['clientSecret'],
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['appName'] = this.appName;
    data['appType'] = this.appType;
    data['appId'] = this.appId;
    data['redirectUri'] = this.redirectUri;
    data['authority'] = this.authority;
    data['labName'] = this.labName;
    data['clientSecret'] = this.clientSecret;
    return data;
  }
}
