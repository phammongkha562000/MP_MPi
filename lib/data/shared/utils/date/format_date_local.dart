// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';

class FormatDateLocal {
  static String format_dd_MM_yyyy(String date) {
    if (date == 'null') {
      return '';
    }

    return DateFormat("dd/MM/yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)).toUtc());
  }
    static String format_dd_MM_yyyy1(String date) {
    if (date == 'null') {
      return '';
    }

    return DateFormat("dd/MM/yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)).toUtc());
  }

  static String format_dd_MM_yyyy_HH_mm(String date) {
    if (date == 'null') {
      return '';
    }

    return DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)).toUtc());
  }

  static String format_HH_mm(String date) {
    if (date == 'null') {
      return '';
    }

    return DateFormat("HH:mm")
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)).toUtc());
  }

  //? DT = DateTime
  // * Format dd/MM/yyyy
  static String DT_format_dd_MM_yyyy(DateTime date) {
    return DateFormat("dd/MM/yyyy", "en").format(date);
  }

  static DateTime parseDateFromString(String dateString) {
    List<String> dateParts = dateString.split('/');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  static String parseDateTimeToyyyyMMddHHmm(String strDate) {
    final date = DateTime.parse(strDate);
    return DateFormat('HH:mm yyyy-MM-dd').format(date);
  }
}
