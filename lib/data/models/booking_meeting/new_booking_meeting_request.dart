class NewBookingMeetingRequest {
  final String bookDateStart;
  final String bookDateTo;
  final String bookMemo;
  final String bookSubject;
  final int createUser;
  final String facilityCode;
  final String id;
  NewBookingMeetingRequest(
      {required this.bookDateStart,
      required this.bookDateTo,
      required this.bookMemo,
      required this.bookSubject,
      required this.createUser,
      required this.facilityCode,
      required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'BookDateStart': bookDateStart,
      'BookDateTo': bookDateTo,
      'BookMemo': bookMemo,
      'BookSubject': bookSubject,
      'CreateUser': createUser,
      'FacilityCode': facilityCode,
      'Id': id
    };
  }
}
