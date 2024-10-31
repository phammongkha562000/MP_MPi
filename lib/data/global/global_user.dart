class GlobalUser {
  int? employeeId;
  get getEmployeeId => employeeId;
  set setEmployeeId(value) => employeeId = value;

  String? employeeCode;
  get getEmployeeCode => employeeCode;
  set setEmployeeCode(value) => employeeCode = value;

  String? username;
  get getUsername => username;
  set setUsername(value) => username = value;

  int? dateofJoin;
  int? get getdateofJoin => dateofJoin;
  set setDateofJoin(int? value) => dateofJoin = value;
}

GlobalUser globalUser = GlobalUser();
