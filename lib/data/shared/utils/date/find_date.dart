// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';

class FindDate {
  // * yyyy/MM/dd
  static firstDateOfMonth_yyyyMMdd({required DateTime today}) {
    var firstDate = DateTime(today.year, today.month, 1);
    var formatFirstDate = DateFormat("yyyy/MM/dd", "en").format(firstDate);
    return formatFirstDate;
  }

  // * yyyy/MM/dd
  static lastDateOfMonth_yyyyMMdd({required DateTime today}) {
    var lastDate = DateTime(today.year, today.month + 1, 0);

    var formatLastDate = DateFormat("yyyy/MM/dd", "en").format(lastDate);
    return formatLastDate;
  }

  // * dd/MM/yyyy
  static firstDateOfMonth_ddMMyyyy({required DateTime today}) {
    var firstDate = DateTime(today.year, today.month, 1);
    var formatFirstDate = DateFormat("dd/MM/yyyy", "en").format(firstDate);
    return formatFirstDate;
  }

  static lastDateOfMonth_ddMMyyyy({required DateTime today}) {
    var lastDate = DateTime(today.year, today.month + 1, 0);

    var formatLastDate = DateFormat("dd/MM/yyyy", "en").format(lastDate);
    return formatLastDate;
  }

  static convertDateyyyyMMdd({required DateTime today}) {
    var firstDate = today;
    var formatFirstDate = DateFormat("yyyy/MM/dd", "en").format(firstDate);
    return formatFirstDate;
  }
}
