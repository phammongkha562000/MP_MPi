import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FormatDateConstants {
  static String convertUTCTime(int date) {
    var result = formatDate(
        DateTime.fromMicrosecondsSinceEpoch(date * 1000)
            .add(const Duration(hours: -7)),
        [HH, ':', nn]);
    return result;
  }

  static String convertUTCDateTimeShort2(int date) {
    var result = formatDate(
        DateTime.fromMicrosecondsSinceEpoch(date * 1000)
            .add(const Duration(hours: -7)),
        [yyyy, '/', mm, '/', dd]);
    return result;
  }

  static String convertUTCTime2(int date) {
    var result = formatDate(
        DateTime.fromMicrosecondsSinceEpoch(date * 1000)
            .add(const Duration(hours: -7)),
        [HH, ':', nn, ":", ss]);
    return result;
  }

  static String convertUTCDateTimeShortDate(int date) {
    var result = formatDate(
        DateTime.fromMicrosecondsSinceEpoch(date * 1000)
            .add(const Duration(hours: -7)),
        [yyyy, '-', mm, '-', dd]);
    return result;
  }

  static String convertddMMyyyy(String strDate) {
    var inputFormat = DateFormat('yyyy-MM-dd', "en").parse(strDate);
    var date = DateFormat("dd/MM/yyyy", "en").format(inputFormat);
    return date;
  }

  static String convertddMMMMyyyy(DateTime dateTime, String lang) {
    var date = DateFormat("EEEE, dd MMMM yyyy", lang).format(dateTime);
    return date;
  }

  static DateTime convertUTCtoDateTime(int date) {
    return DateTime.fromMicrosecondsSinceEpoch(date * 1000)
        .add(const Duration(hours: -7));
  }

  static TimeOfDay addTimeOfDay(TimeOfDay time) {
    return TimeOfDay(hour: time.hour, minute: time.minute + 15);
  }

  static String converthhmm(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String convertddMMyyyyFromDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String convertUTCDateTimeToyyyyyMMdd(int date) {
    var result = formatDate(
        DateTime.fromMicrosecondsSinceEpoch(date * 1000)
            .add(const Duration(hours: -7)),
        [yyyy, '-', mm, '-', dd]);
    return result;
  }

  static String convertMonth(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return month.toString();
    }
  }
}
