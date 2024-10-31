class UserProfile {
  UserProfile(
      {required this.userInfo,
      required this.subsidiaryInfo,
      required this.accountTypeInfo});

  UserInfo userInfo;
  SubsidiaryInfo subsidiaryInfo;
  List<AccountTypeInfo>? accountTypeInfo;

  UserProfile copyWith(
          {UserInfo? userInfo,
          SubsidiaryInfo? subsidiaryInfo,
          List<AccountTypeInfo>? accountTypeInfo}) =>
      UserProfile(
        userInfo: userInfo ?? this.userInfo,
        subsidiaryInfo: subsidiaryInfo ?? this.subsidiaryInfo,
        accountTypeInfo: accountTypeInfo ?? this.accountTypeInfo,
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userInfo: UserInfo.fromJson(json["userInfo"]),
        subsidiaryInfo: json["subsidiaryInfo"] == null
            ? SubsidiaryInfo()
            : SubsidiaryInfo.fromJson(json["subsidiaryInfo"]),
        accountTypeInfo: json["accountTypeInfo"] == null
            ? null
            : List<AccountTypeInfo>.from(json["accountTypeInfo"]
                .map((x) => AccountTypeInfo.fromJson(x))),
      );
}

class SubsidiaryInfo {
  SubsidiaryInfo(
      {this.subsidiaryId,
      this.subsidiaryName,
      this.divisionCode,
      this.divisionDesc,
      this.deptCode,
      this.deptDesc,
      this.language,
      this.email,
      this.mobile,
      this.tel,
      this.gender});

  String? subsidiaryId;
  String? subsidiaryName;
  String? divisionCode;
  String? divisionDesc;
  String? deptCode;
  String? deptDesc;
  String? language;
  String? email;
  String? mobile;
  dynamic tel;
  String? gender;

 

  factory SubsidiaryInfo.fromJson(Map<String, dynamic> json) => SubsidiaryInfo(
      subsidiaryId: json["subsidiaryId"],
      subsidiaryName: json["subsidiaryName"],
      divisionCode: json["divisionCode"],
      divisionDesc: json["divisionDesc"],
      deptCode: json["deptCode"],
      deptDesc: json["deptDesc"],
      language: json["language"],
      email: json["email"],
      mobile: json["mobile"],
      tel: json["tel"],
      gender: json["gender"]);
}

class UserInfo {
  UserInfo({
    this.employeeId,
    this.employeeName,
    this.isUse,
    this.loginName,
    this.firstName,
    this.lastName,
    this.dateofJoin,
    this.dob,
    this.address,
    this.employeeStatus,
    this.gender,
    this.tel,
    this.mobile,
    this.email,
    this.createDate,
    this.createUser,
    this.updateDate,
    this.updateUser,
    this.isActive,
    this.employeeCode,
    this.language,
    this.leaveDate,
    this.avartarThumbnail,
    this.workingLocation,
    this.createUserName,
    this.updateUserName,
    this.remark
  });

  int? employeeId;
  String? employeeName;
  String? isUse;
  String? loginName;
  String? firstName;
  String? lastName;
  int? dateofJoin;
  int? dob;
  String? address;
  String? employeeStatus;
  String? gender;
  dynamic tel;
  String? mobile;
  String? email;
  int? createDate;
  int? createUser;
  int? updateDate;
  int? updateUser;
  String? isActive;
  String? employeeCode;
  String? language;
  dynamic leaveDate;
  String? avartarThumbnail;
  String? workingLocation;
  String? createUserName;
  String? updateUserName;
  dynamic remark;
  UserInfo copyWith(
          {int? employeeId,
          String? employeeName,
          String? isUse,
          String? loginName,
          String? firstName,
          String? lastName,
          int? dateofJoin,
          int? dob,
          String? address,
          String? employeeStatus,
          String? gender,
          String? idType,
          String? idNo,
          dynamic tel,
          String? mobile,
          String? email,
          dynamic isGroupAccount,
          dynamic empTimeSheetCode,
          int? createDate,
          int? createUser,
          int? updateDate,
          int? updateUser,
          String? isActive,
          dynamic idrNo,
          String? employeeCode,
          String? pwd,
          String? language,
          String? designation,
          dynamic employeeNote,
          String? employementType,
          dynamic leaveDate,
          String? grade,
          dynamic pwdNextCloud,
          dynamic englishName,
          String? avartarThumbnail,
          String? leftReason,
          dynamic failedCountLogin,
          String? vehicle,
          String? vehicleNo,
          String? workingLocation,
          String? createUserName,
          String? updateUserName,
          dynamic remark}) =>
      UserInfo(
          employeeId: employeeId ?? this.employeeId,
          employeeName: employeeName ?? this.employeeName,
          isUse: isUse ?? this.isUse,
          loginName: loginName ?? this.loginName,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          dateofJoin: dateofJoin ?? this.dateofJoin,
          dob: dob ?? this.dob,
          address: address ?? this.address,
          employeeStatus: employeeStatus ?? this.employeeStatus,
          gender: gender ?? this.gender,
          tel: tel ?? this.tel,
          mobile: mobile ?? this.mobile,
          email: email ?? this.email,
          createDate: createDate ?? this.createDate,
          createUser: createUser ?? this.createUser,
          updateDate: updateDate ?? this.updateDate,
          updateUser: updateUser ?? this.updateUser,
          isActive: isActive ?? this.isActive,
          employeeCode: employeeCode ?? this.employeeCode,
          language: language ?? this.language,
          leaveDate: leaveDate ?? this.leaveDate,
          avartarThumbnail: avartarThumbnail ?? this.avartarThumbnail,
          workingLocation: workingLocation ?? this.workingLocation,
          createUserName: createUserName ?? this.createUserName,
          updateUserName: updateUserName ?? this.updateUserName,
          remark: remark ?? this.remark);

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        employeeId: json["employeeId"],
        employeeName: json["employeeName"],
        isUse: json["isUse"],
        loginName: json["loginName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dateofJoin: json["dateofJoin"],
        dob: json["dob"],
        address: json["address"],
        employeeStatus: json["employeeStatus"],
        gender: json["gender"],
        tel: json["tel"],
        mobile: json["mobile"],
        email: json["email"],
        createDate: json["createDate"],
        createUser: json["createUser"],
        updateDate: json["updateDate"],
        updateUser: json["updateUser"],
        isActive: json["isActive"],
        employeeCode: json["employeeCode"],
        language: json["language"],
        leaveDate: json["leaveDate"],
        avartarThumbnail: json["avartarThumbnail"],
        workingLocation: json["workingLocation"],
        createUserName: json["createUserName"],
        updateUserName: json["updateUserName"],
        remark: json["remark"],
      );
}

class AccountTypeInfo {
  AccountTypeInfo(
      {this.accountType,
      this.employeeId,
      this.accountId,
      this.pwd,
      this.isExternal,
      this.link});

  String? accountType;
  int? employeeId;
  String? accountId;
  String? pwd;
  bool? isExternal;
  dynamic link;

  factory AccountTypeInfo.fromJson(Map<String, dynamic> json) =>
      AccountTypeInfo(
          accountType: json["accountType"],
          employeeId: json["employeeId"],
          accountId: json["accountId"],
          pwd: json["pwd"],
          isExternal: json["isExternal"],
          link: json["link"]);
}
