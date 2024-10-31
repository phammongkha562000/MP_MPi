import 'package:easy_localization/easy_localization.dart';

class MyError {
  static String erNullUserName =
      "errnullusername".tr(); //Please enter user name
  static String erNullPassword =
      "errnullpassword".tr(); //Please enter your password
  static String erInformation =
      "errincorrectinformation".tr(); //Incorrect Information

  static String erNullFirstName =
      "errnullfirstname".tr(); //Please enter first name
  static String erNullSecondName =
      "errnullsecondname".tr(); //Please enter second name
  static String erNullPhone =
      "errnullphone".tr(); // Please enter your number phone
  static String erNullEmail = "errnullemail".tr(); // Please enter your email
  static String erPassNotMatch =
      "errpasswordnomatch".tr(); //Password don't match
  static String erPasswordShort = "passshort".tr();

  static const String messError = "messerror";

  static String internetDisconnect =
      "internetdisconnect".tr(); //Internet is Disconnect
  static String internetConnected =
      "internetconnected".tr(); //Internet is Connected

  static String errNullDateType = "errnulltypedate".tr();
  static String errNullChooseSession = "errnullsession".tr();
  static String errNullReason = "errnullreason".tr();
  static String errNullHandover = "errnullhandover".tr();
  static String errNullHandoverEmp = "errnullhandoveremp".tr();

  static String errVersionOld = "infoupdate".tr();
  static String errChangeLocation = "changedlocation".tr();
  static String errEnableLocation = "disablelocation".tr();

// *Error Code
  static const String errToken = "999";
  static const int errCodeNoInternet = 1001;
  static const int errCodeOldVersion = 1002;
  static const int errCodeDevice = 1003;
  static const int errCodeLocation = 1004;
  static const int errCodeEnableLocation = 1005;
  static const int errCodeNewLeave = 1006;

  //* IT Service
  static String errNullSubject = 'errnullsubject'.tr();
  static String errNullITservice = "nullitservice".tr();
  static String errNullServiceType = "nullservicetype".tr();
  static String errNullPriority = "nullpriority".tr();
  static String errNullDescription = "nulldescription".tr();

  //401
  static const int err401 = 401;
  static String errString401 = "401".tr();
  //
  static String errInitLogin = "loginuserpassword".tr();
  static const String errFirstAccLoginWithBiometrics =
      "Tài khoản hiện tại khác với tài khoản bạn đăng nhập trước đó\nVui lòng đăng nhập lại";
  static const int errCodeInitLogin = 1007;

  static const String errBiometrics = "Xác thực lỗi";
  static const int errCodeBiometrics = 1008;
  //400
  static const int err400 = 400;
  static String errMess400 = 'mbmess400'.tr();
  static String errMess401 = 'mbmess401'.tr();
}
