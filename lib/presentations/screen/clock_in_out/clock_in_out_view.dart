import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/data.dart';

class ClockInOutView2 extends StatefulWidget {
  const ClockInOutView2({super.key});

  @override
  State<ClockInOutView2> createState() => _ClockInOutView2State();
}

class _ClockInOutView2State extends State<ClockInOutView2>
    with WidgetsBindingObserver {
  final _navigationService = getIt<NavigationService>();

  late ClockInOutBloc clockInOutBloc;
  late AppBloc appBloc;
  Color primaryColor = MyColor.defaultColor;
  Color foregroundColor = Colors.white;

  String _timeString = '';
  Timer? _timer;
  @override
  void initState() {
    super.initState();

    appBloc = BlocProvider.of<AppBloc>(context);
    if (appBloc.wifi.isEmpty) {
      appBloc.add(GetWifiEvent());
    }
    clockInOutBloc = BlocProvider.of<ClockInOutBloc>(context)
      ..add(ClockInOutViewLoaded(appBloc: appBloc));
    _timeString = _formatCurrentTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy Timer khi widget bị dispose
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _timeString = _formatCurrentTime();
    });
  }

  String _formatCurrentTime() {
    final DateTime now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    primaryColor = Theme.of(context).primaryColor;
    foregroundColor =
        Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarCustom(
          context,
          title: "clock",
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ClockInOutBloc, ClockInOutState>(
              listener: (context, state) {
                if (state is ClockInOutSuccessfully) {
                  MyDialog.showSuccess(
                      message: 'updatesuccess'.tr(),
                      context: context,
                      pressContinue: () {},
                      whenComplete: () {
                        clockInOutBloc
                            .add(ClockInOutGetTimesheetToday(appBloc: appBloc));
                      });
                }

                if (state is ClockInOutFailure) {
                  if (state.errorCode != null) {
                    switch (state.errorCode) {
                      case MyError.errCodeNoInternet:
                        MyDialog.showError(
                            context: context,
                            messageError: state.message,
                            pressTryAgain: () {
                              Navigator.pop(context);
                            },
                            whenComplete: () {
                              clockInOutBloc
                                  .add(ClockInOutViewLoaded(appBloc: appBloc));
                            });
                        break;
                      case MyError.errCodeDevice:
                        MyDialog.showError(
                            context: context,
                            messageError: state.message,
                            pressTryAgain: () {
                              Navigator.pop(context);
                            },
                            whenComplete: () {});
                        break;

                      case MyError.errCodeLocation:
                        MyDialog.showWarning(
                            context: context,
                            message: state.message,
                            pressOk: () {
                              Navigator.pop(context);
                            },
                            turnOffCancel: true,
                            whenComplete: () {});
                        break;
                      case MyError.errCodeEnableLocation:
                        MyDialog.showWarning(
                          context: context,
                          pressOk: () async {
                            LocationHelper.settingLocation();
                            Navigator.pop(context);
                          },
                          turnOffCancel: true,
                          message: state.message.tr(),
                          whenComplete: () async {
                            _navigationService.pushNamed(MyRoute.homePageRoute);
                          },
                        );
                        break;

                      default:
                        MyDialog.showError(
                            context: context,
                            messageError: state.message.toString(),
                            pressTryAgain: () {
                              Navigator.pop(context);
                            },
                            whenComplete: () {});
                    }
                  } else {
                    MyDialog.showError(
                        context: context,
                        messageError: state.message.toString(),
                        text: 'close',
                        pressTryAgain: () {
                          Navigator.pop(context);
                          clockInOutBloc
                              .add(ClockInOutViewLoaded(appBloc: appBloc));
                        },
                        whenComplete: () {});
                  }
                }
              },
            ),
            BlocListener<AppBloc, AppState>(listener: (context, state) {
              if (state is GetWifiCompanyFail) {
                MyDialog.showWarning(
                    context: context,
                    message: state.message,
                    pressOk: () {
                      Navigator.pop(context);
                    },
                    turnOffCancel: true,
                    whenComplete: () {});
              }
            }),
          ],
          child: BlocBuilder<ClockInOutBloc, ClockInOutState>(
            builder: (context, state) {
              if (state is ClockInOutSuccess) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: (appBloc.timesheetToday == null ||
                              ((FormatDateConstants.convertUTCtoDateTime(appBloc
                                              .timesheetToday!.startTime!)
                                          .hour ==
                                      0) &&
                                  (FormatDateConstants.convertUTCtoDateTime(
                                              appBloc
                                                  .timesheetToday!.startTime!)
                                          .minute ==
                                      0)))
                          ? [
                              _buildGoodday(),
                              _buildIcon(),
                              _buildBtnCheckInOut(type: 0),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildClock1(),
                                    _buildDate(),
                                  ],
                                )),
                              ),
                            ]
                          : [
                              _buildHi(),
                              // Text('Collected Hours',
                              //     style: TextStyle(color: MyColor.btnGreyDisable)),

                              _buildCardClockInOut(),
                              _buildIconClockOut(),

                              _buildBtnCheckInOut(type: 1),

                              Expanded(
                                child: SizedBox(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildClock1(),
                                    _buildDate(),
                                  ],
                                )),
                              ),
                            ]),
                );
              }
              return _buildLoading() /* buildLoading(context) */;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardClockInOut() {
    return Expanded(
      flex: 2,
      child: SizedBox(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: MyColor.sapGreen.withOpacity(0.05),
                  border: Border.all(color: MyColor.sapGreen)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'checkin'.tr(),
                    style: const TextStyle(
                        color: MyColor.greenRYB, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    FormatDateConstants.convertUTCTime2(
                            appBloc.timesheetToday!.startTime ?? 0)
                        .toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${'mbstartwork'.tr()} 08:00:00',
                        style: const TextStyle(color: MyColor.btnGreyDisable),
                      ),
                    ],
                  )
                ],
              ),
            ),
            //* Checkout card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.symmetric(vertical: 12.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: MyColor.frenchBistre.withOpacity(0.05),
                  border: Border.all(color: MyColor.frenchBistre)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'checkout'.tr(),
                    style: const TextStyle(
                        color: MyColor.lightFrenchBeige,
                        fontWeight: FontWeight.w600),
                  ),
                  FormatDateConstants.convertUTCtoDateTime(
                                  appBloc.timesheetToday!.endTime ?? 0)
                              .hour ==
                          0
                      ? Text('dontforgetclockinout'.tr(),
                          style: const TextStyle(color: MyColor.textBlack))
                      : Text(
                          FormatDateConstants.convertUTCTime2(
                                  appBloc.timesheetToday!.endTime ?? 0)
                              .toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${'mbendwork'.tr()} 17:30:00',
                        style: const TextStyle(color: MyColor.btnGreyDisable),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoodday() {
    return Expanded(
      flex: 1,
      child: Center(
        child: Text('${'goodday'.tr()} ${appBloc.userInfo?.firstName ?? ''}',
            style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: MyColor.sapGreen)),
      ),
    );
  }

  Widget _buildHi() {
    return Expanded(
      flex: 1,
      child: Center(
        child: Text('${'mbhi'.tr()}, ${appBloc.userInfo?.firstName ?? ''}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: MyColor.frenchBistre,
            )),
      ),
    );
  }

  Widget _buildBtnCheckInOut({required int type}) {
    return Expanded(
      flex: 2,
      child: Center(
        child: InkWell(
          onTap: () => clockInOutBloc.add(ClockInOutUpdate(
            appBloc: appBloc,
            type: type,
          )),
          child: DecoratedBox(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 0.5,
                    color: type == 0 ? MyColor.sapGreen : MyColor.frenchBistre,
                    style: BorderStyle.solid)),
            child: Container(
              margin: const EdgeInsets.all(16),
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: type == 0 ? MyColor.sapGreen : MyColor.frenchBistre),
                gradient: LinearGradient(
                  // Bạn có thể dùng LinearGradient nếu muốn
                  colors: (type == 0
                      ? [
                          MyColor.greenRYB, // Màu bắt đầu
                          MyColor.sapGreen, // Màu kết thúc
                        ]
                      : [
                          MyColor.lightFrenchBeige, // Màu bắt đầu
                          MyColor.frenchBistre, // Màu kết thúc
                        ]),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (type == 0 ? MyColor.sapGreen : MyColor.frenchBistre)
                        .withOpacity(0.7), // Màu của đổ bóng (có độ mờ)
                    spreadRadius: 10, // Mức độ lan của đổ bóng
                    blurRadius: 10, // Độ mờ của đổ bóng
                    offset:
                        const Offset(0, 0), // Độ dịch chuyển của đổ bóng (X, Y)
                  ),
                ],
              ),
              child: Text(
                (type == 0 ? "btnclockin" : "btnclockout").tr().toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Expanded(
      flex: 2,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'tapclockin'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 60,
              color: MyColor.btnGreyDisable.withOpacity(0.4),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 60,
              color: MyColor.btnGreyDisable.withOpacity(0.4),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 60,
              color: MyColor.btnGreyDisable.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconClockOut() {
    return Expanded(
      flex: 1,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'tapclockin'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 60,
              color: MyColor.btnGreyDisable.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClock1() {
    return /*  Container(
        width: MediaQuery.sizeOf(context).width / 2,
        height: 80.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //       color: primaryColor,
            //       blurRadius: 10.0,
            //       spreadRadius: 5.0,
            //       offset: const Offset(1.0, 1.0))
            // ],
            color: Colors.white,
            // border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(16.r)),
        child: */
        Center(
      child: Text(
        _timeString,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(
              offset: Offset(3.0, 3.0), // Khoảng cách đổ bóng
              blurRadius: 5.0, // Độ mờ của bóng
              color: Colors.grey, // Màu của bóng
            ),
          ],
        ),
      ),
    ) /* ) */;
  }

  Widget _buildDate() {
    String defaultLang = EasyLocalization.of(context)!.currentLocale.toString();

    return Text(
      FormatDateConstants.convertddMMMMyyyy(DateTime.now(), defaultLang),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: MyColor.bgDrawerColor,
      highlightColor: MyColor.textGrey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Expanded(flex: 5, child: SizedBox()),
          Expanded(
            flex: 1,
            child: SizedBox(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildClock1(),
                _buildDate(),
              ],
            )),
          ),
        ]),
      ),
    );
  }
  /* DecoratedBox _buildClock() {
    return DecoratedBox(
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 15.0,
              spreadRadius: 10.0,
              offset: Offset(
                5.0,
                5.0,
              ),
            ),
          ],
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [Colors.black, primaryColor])),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AnalogClock(
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          width: 200.0,
          height: 200,
          isLive: true,
          hourHandColor: Colors.black,
          minuteHandColor: Colors.black,
          showSecondHand: true,
          numberColor: Colors.black,
          showNumbers: true,
          showAllNumbers: true,
          textScaleFactor: 1.4,
          showTicks: true,
          showDigitalClock: true,
          digitalClockColor: Colors.black,
          datetime: DateTime.now(),
        ),
      ),
    );
  } */

  /* Widget _buildClockInOUt(
    BuildContext context, {
    required bool isAllow,
    required int type,
    required IconData icon,
  }) {
    return DefaultButton(
      paddingTop: true,
      buttonText: type == 0 ? "btnclockin".tr() : "btnclockout".tr(),
      onPressed: isAllow
          ? () {
              clockInOutBloc.add(ClockInOutUpdate(
                appBloc: appBloc,
                type: type,
              )); //0?In:Out
            }
          : null,
      sizeHeight: 80,
      borderRadius: 64,
      buttonColor: isAllow ? null : MyColor.textGrey,
      textColor: foregroundColor,
      isCustomOnButton: true,
      widgetRight:
          type == 1 ? Icon(icon, color: foregroundColor) : const SizedBox(),
      widgetLeft:
          type == 0 ? Icon(icon, color: foregroundColor) : const SizedBox(),
    );
  } */

  // Widget buildLoading(BuildContext context) {
  //   return SizedBox(
  //     child: Shimmer.fromColors(
  //       baseColor: MyColor.bgDrawerColor,
  //       highlightColor: MyColor.textGrey,
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16.w),
  //         child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               _buildClockInOUt(context,
  //                   isAllow: true, type: 0, icon: Icons.login),
  //               _buildClock(),
  //               _buildClockInOUt(context,
  //                   isAllow: true, type: 1, icon: Icons.logout),
  //             ]),
  //       ),
  //     ),
  //   );
  // }
}
