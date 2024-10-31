class DocumentInterview {
  String? dFileName;
  String? docRefType;
  String? refNoType;
  String? refNoValue;
  String? filePath;
  String? fileType;
  double? fileSize;
  int? createDate;
  int? createUser;
  dynamic updateDate;
  dynamic updateUser;
  int? docNo;

  DocumentInterview(
      {this.dFileName,
      this.docRefType,
      this.refNoType,
      this.refNoValue,
      this.filePath,
      this.fileType,
      this.fileSize,
      this.createDate,
      this.createUser,
      this.updateDate,
      this.updateUser,
      this.docNo});

  factory DocumentInterview.fromJson(Map<String, dynamic> json) =>
      DocumentInterview(
          dFileName: json["dFileName"],
          docRefType: json["docRefType"],
          refNoType: json["refNoType"],
          refNoValue: json["refNoValue"],
          filePath: json["filePath"],
          fileType: json["fileType"],
          fileSize: json["fileSize"],
          createDate: json["createDate"],
          createUser: json["createUser"],
          updateDate: json["updateDate"],
          updateUser: json["updateUser"],
          docNo: json["docNo"]);
}
