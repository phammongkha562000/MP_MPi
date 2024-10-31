class UpdateImgResponse {
  UpdateImgResponse({
    this.success,
    required this.payload,
    this.error,
  });

  bool? success;
  List<ImagePayload> payload;
  ErrorImg? error;

  factory UpdateImgResponse.fromMap(Map<String, dynamic> json) =>
      UpdateImgResponse(
        success: json["success"],
        payload: List<ImagePayload>.from(
            json["payload"].map((x) => ImagePayload.fromMap(x))),
        error: ErrorImg.fromMap(json["error"]),
      );
}

class ErrorImg {
  ErrorImg({
    this.errorCode,
    this.errorMessage,
  });

  dynamic errorCode;
  dynamic errorMessage;

  factory ErrorImg.fromMap(Map<String, dynamic> json) => ErrorImg(
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );
}

class ImagePayload {
  ImagePayload({
    this.docNo,
    this.filePath,
  });

  int? docNo;
  String? filePath;

  factory ImagePayload.fromMap(Map<String, dynamic> json) => ImagePayload(
        docNo: json["docNo"],
        filePath: json["filePath"],
      );
}
