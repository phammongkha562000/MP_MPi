class EmployeeSearchRequest {
  EmployeeSearchRequest(
      {required this.employeeName,
      required this.mobile,
      required this.subsidary,
      required this.division,
      required this.department,
      required this.employeecode,
      required this.designation,
      required this.isLeftEmployee,
      required this.emplStatus,
      required this.pageNumber,
      required this.rowNumber});

  String employeeName;
  String mobile;
  String subsidary;
  String division;
  String department;
  String employeecode;
  String designation;
  String isLeftEmployee;
  String emplStatus;
  int pageNumber;
  int rowNumber;

  Map<String, dynamic> toJson() => {
        "employeeName": employeeName,
        "mobile": mobile,
        "subsidary": subsidary,
        "division": division,
        "department": department,
        "employeecode": employeecode,
        "designation": designation,
        "isLeftEmployee": isLeftEmployee,
        "emplStatus": emplStatus,
        "pageNumber":pageNumber,
        "rowNumber": rowNumber
      };
}
