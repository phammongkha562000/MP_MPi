import 'package:easy_localization/easy_localization.dart';
import 'package:mpi_new/data/data.dart';

class GetTextByType {
  static String status({required String typeStatus}) {
    switch (typeStatus) {
      case TypeStatus.sttNew:
        return "new".tr();
      case TypeStatus.sttReply:
        return "reply".tr();
      case TypeStatus.sttCancel:
        return "cancel".tr();
      // *Clos
      case TypeStatus.sttClose:
      case TypeStatus.sttApprovalClos:
        return "close".tr();
      // * clos
      case TypeStatus.sttRECL:
        return "recl".tr();
      case TypeStatus.sttRECO:
        return "reco".tr();
      case TypeStatus.sttREOP:
        return "reop".tr();
      case TypeStatus.sttREQU:
        return "requ".tr();
      case TypeStatus.sttINPR:
        return "in_progress".tr();
      case TypeStatus.sttApprovalDROP:
        return "drop".tr();
      default:
        return "";
    }
  }
}
