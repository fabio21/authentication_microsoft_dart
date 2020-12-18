class UserSecret {
  String secret;
  String value;

  UserSecret({this.secret, this.value});

  factory UserSecret.fromJson(Map<String, dynamic> json) {
    return UserSecret(
      secret: json['secret'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['secret'] = this.secret;
    data['value'] = this.value;
    return data;
  }
}
