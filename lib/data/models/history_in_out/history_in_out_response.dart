class HistoryInOutResponse {
  HistoryInOutResponse(
      {this.id,
      this.timeSheetCode,
      this.actionDate,
      this.type,
      this.machineNo,
      this.cardNo,
      this.createdOn,
      this.createdBy,
      this.address});

  int? id;
  String? timeSheetCode;
  int? actionDate;
  String? type;
  String? machineNo;
  String? cardNo;
  int? createdOn;
  String? createdBy;
  String? address;

  factory HistoryInOutResponse.fromJson(Map<String, dynamic> json) =>
      HistoryInOutResponse(
        id: json["id"],
        timeSheetCode: json["timeSheetCode"],
        actionDate: json["actionDate"],
        type: json["type"],
        machineNo: json["machineNo"],
        cardNo: json["cardNo"],
        createdOn: json["createdOn"],
        createdBy: json["createdBy"],
        address: json["address"],
      );
}
