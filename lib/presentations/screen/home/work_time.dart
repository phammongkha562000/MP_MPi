// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkTimeCalculator extends StatefulWidget {
  const WorkTimeCalculator({Key? key, required this.workStartTime})
      : super(key: key);

  final DateTime workStartTime;

  @override
  State<WorkTimeCalculator> createState() => _WorkTimeCalculatorState();
}

class _WorkTimeCalculatorState extends State<WorkTimeCalculator> {
  late DateTime _startTime;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.workStartTime;
    _currentTime = DateTime.now();
    // Lắng nghe sự thay đổi thời gian mỗi giây
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = _currentTime.difference(_startTime);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    var format = DateFormat.Hm().format(DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day, hours, minutes));
    return Text(format);
  }
}
