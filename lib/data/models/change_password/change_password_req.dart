class ChangePasswordReq {
  String employeeId;
  String ipAddress;
  String systemId;
  String updateUser;
  String confirmPassword;
  String currentPassword;
  String password;

  ChangePasswordReq(
      {required this.employeeId,
      required this.ipAddress,
      required this.systemId,
      required this.updateUser,
      required this.confirmPassword,
      required this.currentPassword,
      required this.password});

  Map<String, dynamic> toJson() => {
        "EmployeeId": employeeId,
        "IpAddress": ipAddress,
        "SystemId": systemId,
        "UpdateUser": updateUser,
        "confirmPassword": confirmPassword,
        "currentPassword": currentPassword,
        "password": password
      };
}
