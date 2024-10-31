class ClockInOutRequest {
  final int employeeId;
  final String lat;
  final String lon;
  final String wifiSSID;
  final String actionDate;
  final String actionType;
  final String macAddressWifi;
  final String method;
  final String deviceId;
  ClockInOutRequest(
      {required this.employeeId,
      required this.lat,
      required this.lon,
      required this.wifiSSID,
      required this.actionDate,
      required this.actionType,
      required this.macAddressWifi,
      required this.method,
      required this.deviceId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employeeId': employeeId,
      'lat': lat,
      'lon': lon,
      'wifiSSID': wifiSSID,
      'actionDate': actionDate,
      'actionType': actionType,
      'macAddressWifi': macAddressWifi,
      'method': method,
      'deviceId': deviceId
    };
  }
}
