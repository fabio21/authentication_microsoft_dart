class Lab {
  String labName;
  String domain;
  String tenantId;
  String federationProvider;
  String azureEnvironment;
  String authority;

  Lab({
    this.labName,
    this.authority,
    this.azureEnvironment,
    this.domain,
    this.federationProvider,
    this.tenantId,
  });

  factory Lab.fromJson(Map<String, dynamic> json){
    return Lab(
      labName: json['labName'],
      domain: json['domain'],
      tenantId: json['tenantId'],
      federationProvider: json['federationProvider'],
      authority: json['authority'],
      azureEnvironment: json['azureEnvironment'],
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['labName'] = this.labName;
    data['domain'] =  this.domain;
    data['tenantId'] = this.tenantId;
    data['federationProvider'] = this.federationProvider;
    data['authority'] =  this.authority;
    data['azureEnvironment'] =  this.azureEnvironment;
    return data;
  }
}
