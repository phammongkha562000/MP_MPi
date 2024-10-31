import 'package:flutter/material.dart';
import 'package:mpi_new/data/data.dart';

class GetColorByType {
  static Color status({required String typeStatus}) {
    switch (typeStatus) {
      case TypeStatus.sttNew:
        return MyColor.textBlue;
      case TypeStatus.sttReply:
        return MyColor.defaultColor;
      case TypeStatus.sttCancel:
        return MyColor.outerSpace;
      case TypeStatus.sttClose:
      case TypeStatus.sttApprovalClos:
      case TypeStatus.sttApprovalDROP:
        return MyColor.textRed;
      case TypeStatus.sttRECL:
        return MyColor.textDarkBlue;
      case TypeStatus.sttRECO:
        return MyColor.textDarkBlue;
      case TypeStatus.sttREOP:
        return MyColor.textDarkBlue;
      case TypeStatus.sttREQU:
        return MyColor.textDarkBlue;
      case TypeStatus.sttINPR:
        return MyColor.defaultColor;

      default:
    }

    return MyColor.defaultColor;
  }
}
