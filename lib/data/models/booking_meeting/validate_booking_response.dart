class ValidateBookMeetingResponse {
  int? fbId;
  int? bookDateStart;
  int? bookDateTo;
  int? createDate;
  int? createUser;
  String? createName;
  dynamic updateDate;
  dynamic updateUser;
  dynamic updateName;
  String? bookSubject;
  String? bookMemo;
  String? facilityCode;
  String? facilityDesc;

  ValidateBookMeetingResponse(
      {this.fbId,
      this.bookDateStart,
      this.bookDateTo,
      this.createDate,
      this.createUser,
      this.createName,
      this.updateDate,
      this.updateUser,
      this.updateName,
      this.bookSubject,
      this.bookMemo,
      this.facilityCode,
      this.facilityDesc});

  factory ValidateBookMeetingResponse.fromJson(Map<String, dynamic> json) =>
      ValidateBookMeetingResponse(
        fbId: json["fbId"],
        bookDateStart: json["bookDateStart"],
        bookDateTo: json["bookDateTo"],
        createDate: json["createDate"],
        createUser: json["createUser"],
        createName: json["createName"],
        updateDate: json["updateDate"],
        updateUser: json["updateUser"],
        updateName: json["updateName"],
        bookSubject: json["bookSubject"],
        bookMemo: json["bookMemo"],
        facilityCode: json["facilityCode"],
        facilityDesc: json["facilityDesc"],
      );
}
