import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mpi_new/businesses_logics/bloc/booking_meeting/booking_meeting/booking_meeting_bloc.dart';
import 'package:mpi_new/data/global/global_user.dart';
import 'package:mpi_new/data/models/booking_meeting/booking_meeting_response.dart';
import 'package:mpi_new/data/services/injection/injection_mpi.dart';
import 'package:mpi_new/data/services/navigator/navigation_service.dart';
import 'package:mpi_new/data/services/navigator/route_path.dart';
import 'package:mpi_new/data/shared/utils/date/date_format/datetime_format.dart';
import 'package:mpi_new/presentations/presentations.dart';

class BookingMeetingView extends StatefulWidget {
  const BookingMeetingView({super.key});

  @override
  State<BookingMeetingView> createState() => _BookingMeetingViewState();
}

class _BookingMeetingViewState extends State<BookingMeetingView> {
  final _navigationService = getIt<NavigationService>();
  late BookingMeetingBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<BookingMeetingBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        context,
        title: 'facilitybooking',
      ),
      body: BlocListener<BookingMeetingBloc, BookingMeetingState>(
          listener: (context, state) {
        if (state is BookingMeetingFailure) {
          MyDialog.showError(
              context: context,
              messageError: state.message,
              pressTryAgain: () {
                _bloc.add(BookingMeetingViewLoaded(date: DateTime.now()));
              });
        }
        if (state is BookingMeetingDeleteSuccess) {
          _bloc.add(BookingMeetingViewLoaded(date: DateTime.now()));
        }
      }, child: BlocBuilder<BookingMeetingBloc, BookingMeetingState>(
              builder: (context, state) {
        String defaultLang =
            EasyLocalization.of(context)!.currentLocale.toString();
        if (state is BookingMeetingSuccess) {
          return Column(children: [
            SizedBox(
              height: 170.h,
              child: CalendarCarousel<Event>(
                  onDayPressed: (DateTime date, List<Event> events) {
                    _bloc.add(BookingMeetingChangeDate(date: date));
                  },
                  showWeekDays: true,
                  selectedDayButtonColor: MyColor.defaultColor,
                  selectedDayBorderColor: Colors.transparent,
                  todayBorderColor: Colors.transparent,
                  weekendTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  weekdayTextStyle: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                  iconColor: Colors.black,
                  headerTextStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                  thisMonthDayBorderColor: Colors.white,
                  locale: defaultLang,
                  customDayBuilder: (bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day) {
                    return null;
                  },
                  weekFormat: true,
                  selectedDateTime: state.date,
                  daysHaveCircularBorder: false),
            ),
            Expanded(
                child: state.isLoading
                    ? const ItemLoading()
                    : RefreshIndicator(
                        onRefresh: () async {
                          _bloc.add(BookingMeetingViewLoaded(date: state.date));
                        },
                        child: ListView.builder(
                            itemCount: 11,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  leading: Text(
                                      "${index < 2 ? '0' : ''}${index + 8}:00",
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                  title: state.bookList.isEmpty
                                      ? const SizedBox()
                                      : _buildBooking(
                                          datas: state.bookList, index: index));
                            })))
          ]);
        }
        return const ItemLoading();
      })),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final result = await _navigationService
                .navigateAndDisplaySelection(MyRoute.addBookingMeetingRoute);
            if (result != null) {
              _bloc.add(BookingMeetingViewLoaded(date: result as DateTime));
            }
          }),
    );
  }

  Widget _buildBooking(
      {required List<BookingMeetingResponse> datas, required int index}) {
    bool isExits = false;
    var dateCurrent = index + 8;
    List<BookingMeetingResponse> items = [];
    for (var i = 0; i < datas.length; i++) {
      var getdate =
          DateTime.fromMicrosecondsSinceEpoch(datas[i].bookDateStart! * 1000)
              .add(const Duration(hours: -7));
      if (dateCurrent == getdate.hour) {
        isExits = true;
        items.add(datas[i]);
      }
    }
    return !isExits
        ? const SizedBox()
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) => InkWell(
                  onDoubleTap: items[index].createUser == globalUser.employeeId
                      ? () {
                          Platform.isIOS
                              ? showCupertinoModalPopup<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                    title: Text('cancelbooking'.tr()),
                                    content: Text('confirmcancelbooking'.tr()),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('close'.tr()),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          _bloc.add(BookingMeetingDelete(
                                              fbId: items[index].fbId!));
                                          Navigator.pop(context);
                                        },
                                        child: Text('cancelbooking'.tr()),
                                      ),
                                    ],
                                  ),
                                )
                              : showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: Text('cancelbooking'.tr(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      content:
                                          Text('confirmcancelbooking'.tr()),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge),
                                          child: Text(
                                            'close'.tr(),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: Text(
                                            'cancelbooking'.tr(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                          onPressed: () {
                                            _bloc.add(BookingMeetingDelete(
                                                fbId: items[index].fbId!));
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                        }
                      : null,
                  child: Card(
                      elevation: 10,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.r),
                              bottomRight: Radius.circular(16.r))),
                      child: IntrinsicHeight(
                          child: Row(children: [
                        Container(
                          width: 8.w,
                          decoration: BoxDecoration(
                            color: items[index].colorCode == 'gray'
                                ? Colors.grey
                                : MyColor.getColor(
                                    items[index].colorCode ?? ''),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  '[${items[index].facilityDesc}]',
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                          TextSpan(
                                              text:
                                                  ' ${items[index].bookSubject}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))
                                        ]),
                                      ),
                                      items[index].bookMemo != null &&
                                              items[index].bookMemo!.isNotEmpty
                                          ? Text(items[index].bookMemo ?? '')
                                          : const SizedBox(),
                                      Text(items[index].createName ?? ''),
                                      Text(
                                          "${FormatDateConstants.convertUTCTime(items[index].bookDateStart ?? 0)} - ${FormatDateConstants.convertUTCTime(items[index].bookDateTo ?? 0)}"),
                                    ])))
                      ]))),
                ));
  }
}
