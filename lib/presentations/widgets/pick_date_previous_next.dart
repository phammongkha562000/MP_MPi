import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as date_picker_plus;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../presentations.dart';

class PickDatePreviousNextWidget extends StatefulWidget {
  const PickDatePreviousNextWidget(
      {Key? key,
      required this.onTapPrevious,
      required this.onTapNext,
      required this.onTapPick,
      required this.stateDate,
      this.child,
      this.quantityText,
      this.isMonth,
      this.childFilter,
      this.lstChild})
      : super(key: key);
  final VoidCallback onTapPrevious;
  final VoidCallback onTapNext;
  final dynamic onTapPick;
  final DateTime stateDate;
  final Widget? child;
  final Widget? childFilter;
  final String? quantityText;
  final bool? isMonth;
  final List<Widget>? lstChild;
  @override
  State<PickDatePreviousNextWidget> createState() =>
      _PickDatePreviousNextMaterialState();
}

class _PickDatePreviousNextMaterialState
    extends State<PickDatePreviousNextWidget> {
  Color colorPanel = MyColor.defaultColor;
  @override
  Widget build(BuildContext context) {
    Color backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: LayoutCustom.paddingDateTimePicker,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              // boxShadow: const [
              //   // BoxShadow(
              //   //   color: MyColor.pastelGray,
              //   //   blurRadius: 1,
              //   //   offset: Offset(1, 3),
              //   // )
              // ],
              color: backgroundPanel),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconButton(
                iconData: Icons.arrow_left,
                onTap: widget.onTapPrevious,
              ),
              _iconButton(
                onTap: () => pickDate(
                    context: context,
                    isMonth: widget.isMonth,
                    date: widget.stateDate,
                    function: (selectedDate) => widget.onTapPick(selectedDate)),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                        vertical: BorderSide(color: colorPanel)),
                  ),
                  child: Text(
                      DateFormat(widget.isMonth ?? false
                              ? 'MM/yyyy'
                              : MyConstants.ddMMyyyySlash)
                          .format(widget.stateDate),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: colorPanel)),
                ),
              ),
              _iconButton(
                iconData: Icons.arrow_right,
                onTap: widget.onTapNext,
              )
            ],
          ),
        ),
        widget.childFilter ?? const SizedBox(),
        widget.quantityText != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: Text(
                  widget.quantityText ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : const SizedBox(),
        widget.child ?? const SizedBox(),
        ...widget.lstChild ?? []
      ],
    );
  }

  Widget _iconButton(
      {required VoidCallback onTap, IconData? iconData, Widget? child}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: iconData != null
            ? Icon(iconData, size: 42, color: colorPanel)
            : child,
      ),
    );
  }
}

Future pickDate(
    {required BuildContext context,
    required DateTime date,
    bool? isMonth,
    required function,
    DateTime? firstDate,
    DateTime? lastDate}) async {
  String defaultLang = EasyLocalization.of(context)!.currentLocale.toString();
  date_picker_plus.LocaleType localeType = defaultLang == 'vi'
      ? date_picker_plus.LocaleType.vi
      : date_picker_plus.LocaleType.en;
  final DateTime? selectedDate = isMonth ?? false
      ? await date_picker_plus.DatePicker.showPicker(
          // ignore: use_build_context_synchronously
          context,
          locale: localeType,
          pickerModel: CustomMonthPicker(
              minTime: firstDate ?? DateTime(DateTime.now().year - 10, 12),
              maxTime: lastDate ?? DateTime(DateTime.now().year + 10, 12),
              currentTime: date,
              locale: localeType),
          theme: date_picker_plus.DatePickerTheme(
            cancelStyle: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
            doneStyle: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
            // ignore: use_build_context_synchronously
            headerColor: Theme.of(context).primaryColor,
            itemStyle: TextStyle(
                fontSize: 16,
                // ignore: use_build_context_synchronously
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500),
          ),
        )
      : await showDatePicker(
          // ignore: use_build_context_synchronously
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

Future pickTime(
    {required BuildContext context,
    required function,
    required String? initTime}) async {
  TimeOfDay initTimeTOD = TimeOfDay(
      hour: int.parse(initTime!.split(":")[0]),
      minute: int.parse(initTime.split(":")[1]));
  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: initTimeTOD,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child ?? const SizedBox(),
      );
    },
  );
  if (selectedTime != null) {
    function(selectedTime);
  }
}
