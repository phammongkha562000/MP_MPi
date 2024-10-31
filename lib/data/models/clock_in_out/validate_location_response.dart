class ValidationLocationResponse {
  ValidationLocationResponse(
      {this.employeeId,
      this.lon,
      this.lat,
      this.distance,
      this.distanceAllow,
      this.isValid,
      this.locationName});

  int? employeeId;
  double? lon;
  double? lat;
  int? distance;
  int? distanceAllow;
  bool? isValid;
  String? locationName;

  factory ValidationLocationResponse.fromJson(Map<String, dynamic> json) =>
      ValidationLocationResponse(
          employeeId: json["employeeId"],
          lon: json["lon"],
          lat: json["lat"],
          distance: json["distance"],
          distanceAllow: json["distanceAllow"],
          isValid: json["isValid"],
          locationName: json["locationName"]);
}
