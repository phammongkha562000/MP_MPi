import 'package:flutter/material.dart';
import 'package:mpi_new/presentations/common/colors.dart';

class StatusEnum {
  const StatusEnum._(this._code);

  final String _code;
  String get code => _code;

  static const StatusEnum undefined = StatusEnum._('');
  static const StatusEnum manualPost = StatusEnum._('MANUALPOST');
  static const StatusEnum cancel = StatusEnum._('CAN');
  static const StatusEnum newStt = StatusEnum._('NEW');
  static const StatusEnum inprogress = StatusEnum._('INPR');

  static const StatusEnum closed = StatusEnum._('CLOS');
  static const StatusEnum closed2 = StatusEnum._('CLOSED');
  static const StatusEnum dropped = StatusEnum._('DROP');
  static const StatusEnum draftSave = StatusEnum._('DRAF');
  static const StatusEnum reply = StatusEnum._('REPLY');

  static const StatusEnum recl = StatusEnum._("RECL");
  static const StatusEnum requ = StatusEnum._("REQU");
  static const StatusEnum reco = StatusEnum._("RECO");
  static const StatusEnum reop = StatusEnum._("REOP");

  factory StatusEnum.from(String code) {
    switch (code) {
      case 'MANUALPOST':
        return manualPost;
      case 'CAN':
        return cancel;
      case 'NEW':
        return newStt;
      case 'INPR':
        return inprogress;
      case 'CLOS':
      case 'CLOSED':
        return closed;
      case 'DROP':
        return dropped;
      case 'DRAF':
        return draftSave;
      case 'REPLY':
        return reply;
      case 'RECL':
        return recl;
      case 'REQU':
        return requ;
      case 'RECO':
        return reco;
      case 'REOP':
        return reop;
      default:
        return undefined;
    }
  }

  Color toColor() {
    switch (_code) {
      case 'MANUALPOST':
        return MyColor.aliceBlue;
      case 'CAN':
        return MyColor.outerSpace;
      case 'NEW':
        return MyColor.textBlue;
      case 'INPR':
      case 'REPLY':
        return MyColor.defaultColor;
      case 'CLOS':
        return MyColor.textRed;
      case 'DROP':
        return MyColor.outerSpace;
      case 'DRAF':
        return MyColor.outerSpace;
      case 'RECL':
      case 'REQU':
      case 'RECO':
      case 'REOP':
        return MyColor.outerSpace;

      default:
        return Colors.transparent;
    }
  }
}
