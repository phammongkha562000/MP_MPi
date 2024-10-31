import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../presentations.dart';

class DatePreviousNextView extends StatefulWidget {
  const DatePreviousNextView(
      {super.key,
      required this.fromDate,
      required this.toDate,
      required this.onTapPrevious,
      required this.onTapNext,
      required this.onPickFromDate,
      required this.onPickToDate});
  final DateTime fromDate;
  final DateTime toDate;
  final VoidCallback onTapPrevious;
  final VoidCallback onTapNext;
  final Function(DateTime) onPickFromDate;
  final Function(DateTime) onPickToDate;

  @override
  State<DatePreviousNextView> createState() => _DatePreviousNextViewState();
}

class _DatePreviousNextViewState extends State<DatePreviousNextView> {
  @override
  Widget build(BuildContext context) {
    Color colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    return Container(
      margin: LayoutCustom.paddingDateTimePicker,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: const [
            BoxShadow(
              color: MyColor.pastelGray,
              blurRadius: 1,
              offset: Offset(1, 3),
            )
          ],
          color: Theme.of(context).colorScheme.onPrimaryContainer),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
                onTap: widget.onTapPrevious,
                child: Icon(
                  Icons.arrow_left,
                  size: 42,
                  color: colorPanel,
                )),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border:
                    Border.symmetric(vertical: BorderSide(color: colorPanel)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        pickDate(
                            context: context,
                            date: widget.fromDate,
                            lastDate: widget.toDate,
                            function: (selectedDate) =>
                                widget.onPickFromDate(selectedDate));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: colorPanel,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            DateFormat(MyConstants.ddMMyyyySlash)
                                .format(widget.fromDate),
                            style: TextStyle(
                                color: colorPanel, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  Text(
                    ' - ',
                    style: TextStyle(
                        color: colorPanel,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  InkWell(
                    onTap: () {
                      pickDate(
                          context: context,
                          date: widget.toDate,
                          firstDate: widget.fromDate,
                          function: (selectedDate) =>
                              widget.onPickToDate(selectedDate));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat(MyConstants.ddMMyyyySlash)
                              .format(widget.toDate),
                          style: TextStyle(
                              color: colorPanel, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.calendar_month_rounded,
                          color: colorPanel,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
                onTap: widget.onTapNext,
                child: Icon(
                  Icons.arrow_right,
                  size: 42,
                  color: colorPanel,
                )),
          ),
        ],
      ),
    );
  }

  Future pickDate({
    required BuildContext context,
    required DateTime date,
    DateTime? firstDate,
    DateTime? lastDate,
    required function,
  }) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      currentDate: DateTime.now(),
      firstDate: firstDate ?? DateTime(DateTime.now().year - 5),
      lastDate: lastDate ?? DateTime(DateTime.now().year + 5),
    );
    if (selectedDate != null) {
      function(selectedDate);
    }
  }
}
