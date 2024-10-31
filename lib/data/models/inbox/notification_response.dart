class NotificationResponse {
  List<NotificationItem>? result;
  int? totalPage;
  int? totalRecord;

  NotificationResponse({this.result, this.totalPage, this.totalRecord});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        result: json["Result"] == null
            ? []
            : List<NotificationItem>.from(
                json["Result"]!.map((x) => NotificationItem.fromJson(x))),
        totalPage: json["TotalPage"],
        totalRecord: json["TotalRecord"],
      );
}

class NotificationItem {
  int? reqId;
  DateTime? requestDate;
  String? requestUser;
  String? requestMessage;
  String? requestTitle;
  String? gateWayCode;
  String? messageType;
  int? templateId;
  String? sendStatus;
  dynamic finalSendDate;
  String? finalStatusMessage;
  String? isUse;
  String? sourceType;
  String? sourceKeyRefNo;
  String? attachmentPath;
  String? receiver;
  bool? isSelected = false;

  NotificationItem(
      {this.reqId,
      this.requestDate,
      this.requestUser,
      this.requestMessage,
      this.requestTitle,
      this.gateWayCode,
      this.messageType,
      this.templateId,
      this.sendStatus,
      this.finalSendDate,
      this.finalStatusMessage,
      this.isUse,
      this.sourceType,
      this.sourceKeyRefNo,
      this.attachmentPath,
      this.receiver,
      this.isSelected});

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
          reqId: json["ReqId"],
          requestDate: json["RequestDate"] == null
              ? null
              : DateTime.parse(json["RequestDate"]),
          requestUser: json["RequestUser"],
          requestMessage: json["RequestMessage"],
          requestTitle: json["RequestTitle"],
          gateWayCode: json["GateWayCode"],
          messageType: json["MessageType"],
          templateId: json["TemplateId"],
          sendStatus: json["SendStatus"],
          finalSendDate: json["FinalSendDate"],
          finalStatusMessage: json["FinalStatusMessage"],
          isUse: json["IsUse"],
          sourceType: json["SourceType"],
          sourceKeyRefNo: json["SourceKeyRefNo"],
          attachmentPath: json["AttachmentPath"],
          receiver: json["Receiver"]);

  NotificationItem copyWith(
      {int? reqId,
      DateTime? requestDate,
      String? requestUser,
      String? requestMessage,
      String? requestTitle,
      String? gateWayCode,
      String? messageType,
      int? templateId,
      String? sendStatus,
      dynamic finalSendDate,
      String? finalStatusMessage,
      String? isUse,
      String? sourceType,
      String? sourceKeyRefNo,
      String? attachmentPath,
      String? receiver,
      bool? isSelected}) {
    return NotificationItem(
        reqId: reqId ?? this.reqId,
        requestDate: requestDate ?? this.requestDate,
        requestUser: requestUser ?? this.requestUser,
        requestMessage: requestMessage ?? this.requestMessage,
        requestTitle: requestTitle ?? this.requestTitle,
        gateWayCode: gateWayCode ?? this.gateWayCode,
        messageType: messageType ?? this.messageType,
        templateId: templateId ?? this.templateId,
        sendStatus: sendStatus ?? this.sendStatus,
        finalSendDate: finalSendDate ?? this.finalSendDate,
        finalStatusMessage: finalStatusMessage ?? this.finalStatusMessage,
        isUse: isUse ?? this.isUse,
        sourceType: sourceType ?? this.sourceType,
        sourceKeyRefNo: sourceKeyRefNo ?? this.sourceKeyRefNo,
        attachmentPath: attachmentPath ?? this.attachmentPath,
        receiver: receiver ?? this.receiver,
        isSelected: isSelected ?? this.isSelected);
  }
}
