class FileDocumentResponse {
  FileDocumentResponse({
    this.dSGetDocumentResult,
    this.filestream,
  });

  DSGetDocumentResult? dSGetDocumentResult;
  String? filestream;

  factory FileDocumentResponse.fromJson(Map<String, dynamic> json) =>
      FileDocumentResponse(
        dSGetDocumentResult: json["dS_GetDocument_Result"] == null
            ? null
            : DSGetDocumentResult.fromJson(json["dS_GetDocument_Result"]),
        filestream: json["filestream"],
      );
}

class DSGetDocumentResult {
  DSGetDocumentResult(
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

  factory DSGetDocumentResult.fromJson(Map<String, dynamic> json) =>
      DSGetDocumentResult(
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

  Map<String, dynamic> toJson() => {
        "dFileName": dFileName,
        "docRefType": docRefType,
        "refNoType": refNoType,
        "refNoValue": refNoValue,
        "filePath": filePath,
        "fileType": fileType,
        "fileSize": fileSize,
        "createDate": createDate,
        "createUser": createUser,
        "updateDate": updateDate,
        "updateUser": updateUser,
        "docNo": docNo,
      };
}
