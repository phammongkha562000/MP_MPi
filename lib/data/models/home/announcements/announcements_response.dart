class AnnouncementsResponse {
  int? annId;
  String? annType;
  String? subject;
  String? contents;
  int? expireDate;
  int? createDate;
  String? createUser;
  int? updateDate;
  int? updateUser;
  String? isUse;

  AnnouncementsResponse(
      {this.annId,
      this.annType,
      this.subject,
      this.contents,
      this.expireDate,
      this.createDate,
      this.createUser,
      this.updateDate,
      this.updateUser,
      this.isUse});

  factory AnnouncementsResponse.fromJson(Map<String, dynamic> json) =>
      AnnouncementsResponse(
          annId: json["annId"],
          annType: json["annType"],
          subject: json["subject"],
          contents: json["contents"],
          expireDate: json["expireDate"],
          createDate: json["createDate"],
          createUser: json["createUser"],
          updateDate: json["updateDate"],
          updateUser: json["updateUser"],
          isUse: json["isUse"]);
}
