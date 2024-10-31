class WifiResponse {
  WifiResponse(
      {this.id,
      this.locationName,
      this.locationAddress,
      this.starTime,
      this.endTime,
      this.workingTime,
      this.locationType,
      this.wifissid,
      this.lat,
      this.lon,
      this.macAddressWifi,
      this.wifiName});

  int? id;
  String? locationName;
  String? locationAddress;
  int? starTime;
  int? endTime;
  String? workingTime;
  String? locationType;
  dynamic wifissid;
  String? lat;
  String? lon;
  String? macAddressWifi;
  dynamic wifiName;

  factory WifiResponse.fromJson(Map<String, dynamic> json) => WifiResponse(
      id: json["id"],
      locationName: json["locationName"],
      locationAddress: json["locationAddress"],
      starTime: json["starTime"],
      endTime: json["endTime"],
      workingTime: json["workingTime"],
      locationType: json["locationType"],
      wifissid: json["wifissid"],
      lat: json["lat"],
      lon: json["lon"],
      macAddressWifi: json["macAddressWifi"],
      wifiName: json["wifiName"]);
}
