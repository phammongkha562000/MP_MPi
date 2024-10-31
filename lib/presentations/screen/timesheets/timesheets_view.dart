import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mpi_new/businesses_logics/bloc/timesheet/timesheets/timesheets_bloc.dart';
import 'package:mpi_new/data/services/injection/injection_mpi.dart';
import 'package:mpi_new/data/services/navigator/navigation_service.dart';
import 'package:mpi_new/data/shared/utils/date/date_format/datetime_format.dart';
import 'package:mpi_new/data/shared/utils/date/format_date_local.dart';
import 'package:mpi_new/data/shared/utils/date_time_extension.dart';
import 'package:mpi_new/presentations/presentations.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:mpi_new/presentations/widgets/date_previous_next/date_previous_next.dart';
import 'package:mpi_new/presentations/widgets/dot_line/dot_line_widget.dart';
import 'package:mpi_new/presentations/widgets/loading/paging_loading.dart';

import '../../../data/services/navigator/route_path.dart';

class TimesheetsView extends StatefulWidget {
  const TimesheetsView({super.key});

  @override
  State<TimesheetsView> createState() => _TimesheetsViewState();
}

class _TimesheetsViewState extends State<TimesheetsView> {
  final _navigationService = getIt<NavigationService>();
  final ScrollController _scrollController = ScrollController();
  late TimesheetsBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<TimesheetsBloc>(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("paging");
        _bloc.add(TimesheetsPaging());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(context, title: "timesheets"),
      body: BlocListener<TimesheetsBloc, TimesheetsState>(
        listener: (context, state) {
          if (state is TimesheetsFailure) {
            if (state.errorCode == MyError.errCodeNoInternet) {
              MyDialog.showError(
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                  },
                  whenComplete: () {
                    _bloc.add(const TimesheetsViewLoaded());
                  });
            } else {
              MyDialog.showError(
                  text: 'close'.tr(),
                  context: context,
                  messageError: state.message,
                  pressTryAgain: () {
                    Navigator.pop(context);
                    _bloc.add(const TimesheetsViewLoaded());
                  });
            }
          }
        },
        child: BlocBuilder<TimesheetsBloc, TimesheetsState>(
          builder: (context, state) {
            if (state is TimesheetsSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatePreviousNextView(
                    fromDate: state.fromDate,
                    toDate: state.toDate,
                    onTapPrevious: () {
                      _bloc.add(TimesheetsChangeDate(
                        fromDate:
                            state.fromDate.subtract(const Duration(days: 1)),
                      ));
                    },
                    onPickFromDate: (selectedDate) {
                      _bloc.add(TimesheetsChangeDate(
                        fromDate: selectedDate,
                      ));
                    },
                    onPickToDate: (selectedDate) {
                      _bloc.add(TimesheetsChangeDate(
                        toDate: selectedDate,
                      ));
                    },
                    onTapNext: () {
                      _bloc.add(TimesheetsChangeDate(
                        toDate: state.toDate.add(const Duration(days: 1)),
                      ));
                    },
                  ),
                  ColoredBox(
                    color: MyColor.outerSpace,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        children: [
                          _buildText(
                              text: "date".tr(),
                              flex: 4,
                              isTitle: true,
                              color: MyColor.textWhite),
                          _buildText(
                              text: 'checkin'.tr(),
                              isTitle: true,
                              color: MyColor.textWhite),
                          _buildText(
                              text: 'checkout'.tr(),
                              isTitle: true,
                              color: MyColor.textWhite),
                          _buildText(
                              text: 'afterjoin'.tr(),
                              isTitle: true,
                              color: MyColor.textWhite),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _bloc.add(const TimesheetsChangeDate());
                      },
                      child: state.isLoading
                          ? const ItemLoading()
                          : state.timesheetsList.isEmpty
                              ? ListView(children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.8,
                                      child: const EmptyWidget())
                                ])
                              : ListView.separated(
                                  controller: _scrollController,
                                  padding: EdgeInsets.only(bottom: 48.h),
                                  itemCount: state.timesheetsList.length,
                                  itemBuilder: (context, index) {
                                    final item = state.timesheetsList[index];
                                    return InkWell(
                                      onTap: () async {
                                        final result = await _navigationService
                                            .navigateAndDisplaySelection(
                                                MyRoute.timesheetsDetailRoute,
                                                args: {
                                              KeyParams.timesheets: item
                                            });
                                        if (result != null) {
                                          _bloc.add(TimesheetsViewLoaded(
                                              fromDate: state.fromDate,
                                              toDate: state.toDate));
                                        }
                                      },
                                      child: ColoredBox(
                                        color: index % 2 == 1
                                            ? MyColor.outerSpace
                                                .withOpacity(0.1)
                                            : Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.h),
                                          child: Row(
                                            children: [
                                              _buildText(
                                                flex: 4,
                                                text: FormatDateLocal
                                                    .format_dd_MM_yyyy(
                                                  item.createDate.toString(),
                                                ),
                                              ),
                                              _buildText(
                                                text: FormatDateConstants
                                                    .convertUTCTime(
                                                        item.startTime ?? 0),
                                              ),
                                              _buildText(
                                                text: FormatDateConstants
                                                    .convertUTCTime(
                                                        item.endTime ?? 0),
                                              ),
                                              _buildText(
                                                  text:
                                                      item.workHour.toString(),
                                                  isTitle: true,
                                                  color: FormatDateConstants
                                                                  .convertUTCtoDateTime(item
                                                                      .startTime!)
                                                              .convertToDayName ==
                                                          'CN'
                                                      ? Colors.black
                                                      : FormatDateConstants
                                                                      .convertUTCtoDateTime(item
                                                                          .endTime!)
                                                                  .convertToDayName ==
                                                              '7'
                                                          ? (item.workHour! < 4
                                                              ? Colors.red
                                                              : Colors.black)
                                                          : item.workHour! < 8
                                                              ? Colors.red
                                                              : Colors.black),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return DottedLine(
                                      dashWidth: 5,
                                      dashSpace: 2.0,
                                      color:
                                          MyColor.outerSpace.withOpacity(0.5),
                                    );
                                  },
                                ),
                    ),
                  ),
                  state.isPagingLoading
                      ? const PagingLoading()
                      : const SizedBox()
                ],
              );
            }
            return const ItemLoading();
          },
        ),
      ),
    );
  }

  Widget _buildText(
      {required String text, int? flex, bool? isTitle, Color? color}) {
    return Expanded(
      flex: flex ?? 3,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: isTitle ?? false ? FontWeight.bold : FontWeight.normal,
            color: color ?? MyColor.textBlack),
      ),
    );
  }

  String getFromTodate(DateTime date) {
    return '${date.day > 9 ? date.day.toString() : '0${date.day}'} ${convertMonth(date.month)} ${date.year}';
  }

  String convertMonth(int month) {
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

  Future pickDate({
    required BuildContext context,
    required DateTime date,
    bool? isMonth,
    required function,
  }) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      currentDate: DateTime.now(),
      firstDate: date,
      lastDate: date.add(const Duration(days: 5)),
    );
    if (selectedDate != null) {
      function(selectedDate);
    }
  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker({
    required DateTime currentTime,
    required DateTime minTime,
    required DateTime maxTime,
    required LocaleType locale,
  }) : super(
          locale: locale,
          minTime: minTime,
          maxTime: maxTime,
          currentTime: currentTime,
        );

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
