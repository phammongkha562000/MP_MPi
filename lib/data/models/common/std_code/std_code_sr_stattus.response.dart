class StdCodeSrStatusTypePayload {
  StdCodeSrStatusTypePayload(
      {this.codeType,
      this.codeDesc,
      this.codeId,
      this.isUse,
      this.tagVariant,
      this.numericVariant,
      this.seqNo});

  String? codeType;
  String? codeDesc;
  String? codeId;
  String? isUse;
  String? tagVariant;
  double? numericVariant;
  int? seqNo;

  factory StdCodeSrStatusTypePayload.fromJson(Map<String, dynamic> json) =>
      StdCodeSrStatusTypePayload(
        codeType: json["codeType"],
        codeDesc: json["codeDesc"],
        codeId: json["codeId"],
        isUse: json["isUse"],
        tagVariant: json["tagVariant"],
        numericVariant: json["numericVariant"],
        seqNo: json["seqNo"],
      );
}
