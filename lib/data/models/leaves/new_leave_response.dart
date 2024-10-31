class NewLeaveResponse {
  NewLeaveResponse({this.payload});

  String? payload;

  factory NewLeaveResponse.fromJson(Map<String, dynamic> json) =>
      NewLeaveResponse(payload: json["payload"]);
}
