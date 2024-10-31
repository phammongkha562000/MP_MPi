class DivisionResponse {
  DivisionResponse(
      {this.divisionCode,
      this.divisionDesc,
      this.subsidiaryId,
      this.hodEmployeeId,
      this.seqNo});

  String? divisionCode;
  String? divisionDesc;
  String? subsidiaryId;
  String? hodEmployeeId;
  int? seqNo;

  factory DivisionResponse.fromJson(Map<String, dynamic> json) =>
      DivisionResponse(
          divisionCode: json["divisionCode"],
          divisionDesc: json["divisionDesc"],
          subsidiaryId: json["subsidiaryId"],
          hodEmployeeId: json["hodEmployeeId"],
          seqNo: json["seqNo"]);
}
