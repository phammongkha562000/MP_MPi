class ApplicationResponse {
  ApplicationResponse(
      {this.applicationCode, this.appGroup, this.applicationDesc});

  String? applicationCode;
  String? appGroup;
  String? applicationDesc;

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) =>
      ApplicationResponse(
          applicationCode: json["applicationCode"],
          appGroup: json["appGroup"],
          applicationDesc: json["applicationDesc"]);
}
