import '../../data/data.dart';

class MyConstants {
  static const prod = "PROD";
  static const dev = "DEV";
  static const qa = "QA";

  static const caseProfile = "MB001";
  static const caseTripRecord = "MB002";
  static const caseTodoList = "MB003";
  static const caseCheckList = "MB004";
  static const caseCheckListQC = "MB005";
  static const caseCheckListTechnical = "MB006";

// * default
  static const String copyRight = "All right reserved 2023";

//menu
  static const caseCheckInOut = "Clock";
  static const caseHistoryCheckInOut = "Historyinout";
  static const caseTimeSheets = "TimeSheets";

  static const caseEmployee = "GN006";
  static const caseBookingRoom = "GN005";
  static const caseITService = "ITSR0002";
  static const caseLeave = "GN0002";
  static const caseServiceRequest = "SS0004";
  static const caseServiceApproval = "GN003";
  static const caseLeaveApproval = "PAP003";
  static const caseTimesheetApproval = "PAP004";

  static const ticksFormSinceEpoch = (621355968000000000 + 252000000000);
  static const toMiliseconds = 10000;

  static const systemID = 'WB_MPI';
  static const systemIDMB = 'MB_MPI';

  static const ddMMyyyy = 'ddMMyyyy';
  static const yyyyMMdd = 'yyyy/MM/dd';
  static const ddMMyyyySlash = 'dd/MM/yyyy';

  static const yyyyMMddHHmmss = 'yyyy-MM-dd HH:mm:ss';
  static const yyyyMMddHHmmssSlash = 'yyyy/MM/dd HH:mm:ss';

  static const androidAppId = 'com.mpl.mpi_new';
  static const iOSAppId = "6446984050";

  //inbox
  static const inboxRead = 'READ';
  static const inboxNew = 'NEW';
  static const inboxNotification = 'NOTIFICATION';

  static const languageDefault = LanguageHelper.vi;

  static const facilityGroup = 'MTROOM';

  //store
  static const urlGooglePlay = "https://play.google.com/store/apps/details?id=";
  static const urlAppStore = "https://apps.apple.com/app/id";
  static const urlCHPlay = 'https://play.google.com/store/apps';

//office
  static const urlGGExcel =
      'https://play.google.com/store/apps/details?id=com.microsoft.office.excel';
  static const urlGGWord =
      'https://play.google.com/store/apps/details?id=com.microsoft.office.word';

  static const camera = "CAMERA";
  static const photos = "PHOTOS";

  static const pagingSize = 20; //20 hardcode
}
