class ActivityResponse {
  int? id;
  int? type;
  int? date;
  String? createdate;
  String? activity;
  String? wifi;
  String? userId;
  String? username;
  ActivityResponse(
      {this.id,
      this.type,
      this.date,
      this.createdate,
      this.activity,
      this.wifi,
      this.userId,
      this.username});

  factory ActivityResponse.fromMap(Map<String, dynamic> map) {
    return ActivityResponse(
        id: map['id'] != null ? map['id'] as int : null,
        type: map['type'] != null ? map['type'] as int : null,
        date: map['date'] != null ? map['date'] as int : null,
        createdate:
            map['createdate'] != null ? map['createdate'] as String : null,
        activity: map['activity'] != null ? map['activity'] as String : null,
        wifi: map['wifi'] != null ? map['wifi'] as String : null,
        userId: map['userId'] != null ? map['userId'] as String : null,
        username: map['username'] != null ? map['username'] as String : null);
  }
}
