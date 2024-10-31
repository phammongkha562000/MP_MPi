import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/enum/status_enum.dart';

class TextByTypeStatus extends StatelessWidget {
  const TextByTypeStatus({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Text(
      fromCodetoString(status).toLowerCase().tr().toUpperCase(),
      style: TextStyle(
        color: StatusEnum.from(status).toColor(),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }

  String fromCodetoString(String code) {
    switch (code) {
      case 'MANUALPOST':
        return 'manualpost';
      case 'CAN':
        return 'mbcan';
      case 'NEW':
        return 'new';
      case 'INPR':
        return 'mbinpr';
      case 'CLOS':
      case 'CLOSED':
        return 'mbclos';
      case 'DROP':
        return 'drop';
      case 'DRAF':
        return 'draf';
      case 'REPLY':
        return 'reply';
      case 'RECL':
        return 'recl';
      case 'REQU':
        return 'requ';
      case 'RECO':
        return 'reco';
      case 'REOP':
        return 'reop';
      default:
        return 'undefined';
    }
  }
}
