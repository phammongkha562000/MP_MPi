class BookingMeetingRequest {
  BookingMeetingRequest(
      {required this.userId,
      required this.bookDateF,
      required this.bookDateT,
      required this.facilityCode,
      required this.facilityGroup,
      required this.subsidiaryId});

  int userId;
  String bookDateF;
  String bookDateT;
  String facilityCode;
  String facilityGroup;
  String subsidiaryId;

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "BookDateF": bookDateF,
        "BookDateT": bookDateT,
        "FacilityCode": facilityCode,
        "FacilityGroup": facilityGroup,
        "SubsidiaryId": subsidiaryId
      };
}
