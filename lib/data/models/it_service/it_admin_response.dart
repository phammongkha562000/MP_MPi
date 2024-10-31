class ITAdminResponse {
  ITAdminResponse({this.itAdmin, this.employeeName, this.isSelected});

  int? itAdmin;
  String? employeeName;
  bool? isSelected;

  ITAdminResponse copyWith(
          {int? itAdmin, String? employeeName, bool? isSelected}) =>
      ITAdminResponse(
          itAdmin: itAdmin ?? this.itAdmin,
          employeeName: employeeName ?? this.employeeName,
          isSelected: isSelected ?? this.isSelected);

  factory ITAdminResponse.fromJson(Map<String, dynamic> json) =>
      ITAdminResponse(
          itAdmin: json["itAdmin"],
          employeeName: json["employeeName"],
          isSelected: false);
}
