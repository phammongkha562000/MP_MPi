import '../../../common/common.dart';

String getImage(String menuId) {
  switch (menuId) {
    case "GN005":
      return MyAssets.oldBooking;
    case "GN006":
      return MyAssets.oldEmployee;
    case "ITSR0002":
      return MyAssets.oldItServices;
    case "SS0004":
      return MyAssets.icServiceRequest;
    case "GN0002":
      return MyAssets.icLeave;
    case "Clock":
      return MyAssets.oldCheckInOut;
    case "Historyinout":
      return MyAssets.oldHistoryCheckInOut;
    case "TimeSheets":
      return MyAssets.oldTimeSheet;
    default:
      return MyAssets.oldCheckInOut;
  }
}
