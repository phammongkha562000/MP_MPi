class FacilitiesResponse {
  FacilitiesResponse(
      {this.facilityCode,
      this.facilityDesc,
      this.facilityNote,
      this.facilityGroup,
      this.colorCode});

  String? facilityCode;
  String? facilityDesc;
  String? facilityNote;
  String? facilityGroup;
  String? colorCode;

  factory FacilitiesResponse.fromJson(Map<String, dynamic> json) =>
      FacilitiesResponse(
          facilityCode: json["facilityCode"],
          facilityDesc: json["facilityDesc"],
          facilityNote: json["facilityNote"],
          facilityGroup: json["facilityGroup"],
          colorCode: json["colorCode"]);
}
