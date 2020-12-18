class RequestedClaimAdditionalInfo {

  bool essential;
  String value;
  List<String> values;

  RequestedClaimAdditionalInfo({this.essential, this.value, this.values});

  factory RequestedClaimAdditionalInfo.fromJson(Map<String, dynamic> data){
    return RequestedClaimAdditionalInfo(
      essential: data['essential'],
      value: data['value'],
      values: data['values'],);
  }
}
