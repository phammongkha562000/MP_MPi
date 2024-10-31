import 'dart:convert';

extension DateTimeExtension on DateTime {
  DateTime get findFirstDateOfTheWeek => subtract(Duration(days: weekday - 1));

  DateTime get findLastDateOfTheWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday));

  String get convertToDayName {
    dynamic dayData =
        '{ "1" : "2", "2" : "3", "3" : "4", "4" : "5", "5" : "6", "6" : "7", "7" : "CN" }';

    return json.decode(dayData)['$weekday'];
  }

  DateTime get findFirstDateOfPreviousWeek {
    final lastWeek = subtract(const Duration(days: 7));
    return lastWeek.subtract(Duration(days: lastWeek.weekday - 1));
  }

  DateTime get findLastDateOfPreviousWeek {
    final DateTime lastWeek = subtract(const Duration(days: 7));
    return lastWeek
        .add(Duration(days: DateTime.daysPerWeek - lastWeek.weekday));
  }

  DateTime get findFirstDateOfNextWeek {
    final nextWeek = add(const Duration(days: 7));
    return nextWeek.subtract(Duration(days: nextWeek.weekday - 1));
  }

  DateTime get findLastDateOfNextWeek {
    final nextWeek = add(const Duration(days: 7));
    return nextWeek
        .add(Duration(days: DateTime.daysPerWeek - nextWeek.weekday));
  }

  DateTime get firstDayOfMonth => DateTime(year, month, 1);

  DateTime get lastDayOfMonth =>
      month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isDate(String str) {
    try {
      DateTime.parse(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  String get convertToDayName2 {
    dynamic dayData =
        '{ "1" : "Thứ 2", "2" : "Thứ 3", "3" : "Thứ 4", "4" : "Thứ 5", "5" : "Thứ 6", "6" : "Thứ 7", "7" : "Chủ nhật" }';

    return json.decode(dayData)['$weekday'];
  }
}
