class RequestServiceResponse {
  String? svrServiceType;
  String? applicationDesc;
  int? cnt;

  RequestServiceResponse({this.svrServiceType, this.applicationDesc, this.cnt});

  RequestServiceResponse copyWith(
          {String? svrServiceType, String? applicationDesc, int? cnt}) =>
      RequestServiceResponse(
          svrServiceType: svrServiceType ?? this.svrServiceType,
          applicationDesc: applicationDesc ?? this.applicationDesc,
          cnt: cnt ?? this.cnt);

  factory RequestServiceResponse.fromJson(Map<String, dynamic> json) =>
      RequestServiceResponse(
          svrServiceType: json["svrServiceType"],
          applicationDesc: json["applicationDesc"],
          cnt: json["cnt"]);
}
