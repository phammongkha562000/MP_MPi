class PendingApprovalResponse {
  String? type;
  int? assignedUser;
  int? count;
  String? link;

  PendingApprovalResponse(
      {this.type, this.assignedUser, this.count, this.link});

  PendingApprovalResponse copyWith(
          {String? type, int? assignedUser, int? count, String? link}) =>
      PendingApprovalResponse(
          type: type ?? this.type,
          assignedUser: assignedUser ?? this.assignedUser,
          count: count ?? this.count,
          link: link ?? this.link);

  factory PendingApprovalResponse.fromJson(Map<String, dynamic> json) =>
      PendingApprovalResponse(
          type: json["type"],
          assignedUser: json["assignedUser"],
          count: json["count"],
          link: json["link"]);
}
