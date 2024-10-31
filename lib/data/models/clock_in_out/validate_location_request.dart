class ValidationLocationRequest {
  ValidationLocationRequest(
      {required this.employeeId, required this.lat, required this.lon});

  int employeeId;
  String lat;
  String lon;

  Map<String, dynamic> toJson() =>
      {"employeeid": employeeId, "lat": lat, "lon": lon};
}
