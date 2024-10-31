import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/data/data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mpi_new/presentations/widgets/dialog/dialog_platform.dart';
import '../../../businesses_logics/application_bloc/app_bloc.dart';
import '../../../data/services/firebase_cloud_message/firebase_cloud_message.dart';

String tokenfcm = '';
var notifications = FlutterLocalNotificationsPlugin();
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ValueNotifier _totalNotifications = ValueNotifier(0);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  late AppBloc appBloc;
  late HomeBloc homeBloc;
  final FcmServices fcmService = FcmServices();

  String empName = '';
  String serverMode = '';
  List<AnnouncementsResponse> listAnn = [];
  List<GalleryResponse> listGallery = [];
  double remainAnnualLeave = 0;
  List<int> workTime = [];
  List<Widget> page1Items = [];
  List<Widget> page2Items = [];

  List<RequestServiceResponse> listRequestService = [];
  List<InterviewApprovalResult> listInterview = [];

  Color primaryColor = MyColor.defaultColor;

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context)..add(GetWifiEvent());
    homeBloc = BlocProvider.of<HomeBloc>(context)
      ..add(HomeViewLoaded(appBloc: appBloc));
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    initFcmLocalNotifications();
  }

  initFcmLocalNotifications() {
    fcmService.iosPermission();
    fcmService.firebaseCloudMessagingListeners(_totalNotifications);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String yearAfterJoin = "0";
  String monthAfterJoin = "0";
  final _navigationService = getIt<NavigationService>();
  int page = 0;
  bool enabled = false;
  final ValueNotifier<int> _indexPage = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    String defaultLang = EasyLocalization.of(context)!.currentLocale.toString();
    primaryColor = Theme.of(context).primaryColor;
    List<Widget> allItems = [
      _itemWithPageView(
          iconUrl: MyAssets.oldCheckInOut,
          text: "clock",
          onPress: () {
            _navigationService.pushNamed(MyRoute.clockInOutRoute);
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.oldHistoryCheckInOut,
          text: "historyinout",
          onPress: () {
            _navigationService.pushNamed(MyRoute.historyInOutRoute);
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.oldTimeSheet,
          text: "timesheets",
          onPress: () {
            _navigationService.pushNamed(MyRoute.timesheetsRoute);
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.employee,
          text: "employee",
          onPress: () {
            _navigationService.pushNamed(MyRoute.employeeRoute);
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.oldBooking,
          text: "facilitybooking",
          onPress: () {
            voidCallBack(context, path: "GN005");
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.icLeave,
          text: "leave",
          onPress: () {
            voidCallBack(context, path: "GN0002");
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.icServiceRequest,
          text: "servicerequest",
          onPress: () {
            voidCallBack(context, path: "SS0004");
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.oldItServices,
          text: "itservice",
          onPress: () {
            voidCallBack(context, path: "ITSR0002");
          },
          enabled: enabled),

      // *Review xong mở lại
      _itemWithPageView(
          iconUrl: MyAssets.icServiceApproval,
          text: "gn003",
          onPress: () {
            voidCallBack(context, path: "GN003");
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.icLeaveApproval,
          text: "leaveapproval",
          onPress: () {
            voidCallBack(context, path: "PAP003");
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.icLeaveApproval,
          text: "timesheetapproval",
          onPress: () {
            voidCallBack(context, path: "PAP004");
          },
          enabled: enabled),
      _itemWithPageView(
          iconUrl: MyAssets.icInterview,
          text: "approvalinterview",
          onPress: () {
            _onNavigateInterviewApproval(context);
          },
          enabled: enabled),
    ];
    double numberOfPages = allItems.length / 8;
    int pageCount = numberOfPages.ceil();

    page = pageCount;

    page1Items = allItems.sublist(0, 8);
    page2Items = allItems.sublist(8); //
    return PopScope(
      canPop: false,
      child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (state is HomeLoading) {
              MyDialog.showLoading(context: context);
            } else {
              MyDialog.hideLoading(context: context);
            }
            if (state is UserDefaultPassState) {
              _navigationService.pushNamed(MyRoute.changePasswordRoute,
                  args: {KeyParams.isBackLogin: true});
            }
            if (state is HomeFailure) {
              MyDialog.showError(
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);

                  _navigationService.pushNamed(MyRoute.loginViewRoute,
                      args: {KeyParams.isLogout: true});
                },
              );
            }
            if (state is HomeSuccess) {
              _firebaseMessaging.getToken().then((token) {
                if (token != "") {
                  appBloc.add(LoginToHub(token: token ?? ''));
                }
              });
              _totalNotifications.value = globalApp.countNotification;
              await context.setLocale(Locale(defaultLang == LanguageHelper.vi
                  ? LanguageHelper.en
                  : LanguageHelper.vi));

              // ignore: use_build_context_synchronously
              await context.setLocale(Locale(defaultLang));
              if (Platform.isAndroid) {
                await PermissionHelper.requestLocation();
                await PermissionHelper.requestCamera();
                await PermissionHelper.requestStore();
                await PermissionHelper.requestNotification();
              }

              if (Platform.isIOS) {
                await PermissionHelper.requestLocation();
                await PermissionHelper.requestCamera();
                await PermissionHelper.requestPhoto();
                await PermissionHelper.requestNotification();
              }
              setState(() {
                serverMode = state.serverMode;
                listRequestService = state.listRequestService ?? [];
                listInterview = state.listInterview ?? [];
                remainAnnualLeave = state.remainAnnualLeave;
                listAnn = state.listAnn;
                listGallery = state.listGallery;
                empName = appBloc.userInfo?.employeeName ?? '';
                state.serverMode == ServerMode.dev.toString()
                    ? empName = "$empName-DEV"
                    : state.serverMode == ServerMode.qa.toString()
                        ? empName = "$empName-QA"
                        : empName = empName;
                enabled = true;
              });

              var workStartTime = state.checkIn;

              workTime = workStartTime != null
                  ? _calculatorWorkTime(workStartTime: workStartTime)
                  : [00, 00];
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,

            //tạm khóa
            // drawer: MenuView(
            //   empName: empName,
            //   listMenu:
            //       globalServer.isLeftMenu ?? false ? state.menuList : [],
            //   linkAvt: globalUser.getLinkAvt.toString(),
            //   serverMode: state.serverMode,
            // ),
            body: DecoratedBox(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(MyAssets.bg),
                fit: BoxFit.fill,
              )),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w,
                        MediaQuery.paddingOf(context).top + 20.h, 12.w, 20.h),
                    child: _buildHeader(),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 8.h),
                      children: [
                        Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(top: 65),
                            padding: EdgeInsets.fromLTRB(12.w, 70, 12.w, 6.h),
                            decoration: BoxDecoration(
                                color: MyColor.bgDrawerColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.r),
                                  topRight: Radius.circular(30.r),
                                )),
                            child: pageViewFavorite(
                              page1Items: page1Items,
                              page2Items: page2Items,
                              page: page,
                            ),
                          ),
                          _buildRow(workTime: workTime),
                        ]),
                        const SizedBox(height: 10),
                        ValueListenableBuilder(
                          valueListenable: _indexPage,
                          builder: (context, value, child) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(page, (index2) {
                              return page == 1
                                  ? const SizedBox()
                                  : Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      width: 8.h,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index2 == _indexPage.value
                                            ? primaryColor
                                            : MyColor.bgDrawerColor,
                                      ),
                                    );
                            }),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
                          alignment: Alignment.center,
                          child: Text(
                            "announcements".tr().toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          height: 100.h,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: MyColor.bgDrawerColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.r)),
                          ),
                          child: listAnn.isEmpty
                              ? Center(
                                  child: Text(
                                    "nodata".tr().toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : _buildListAnn(),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 48),
                            child: (listGallery.isNotEmpty && listGallery != [])
                                ? _buildCarouse()
                                : const SizedBox())
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget pageViewFavorite({
    required List<Widget> page1Items,
    required List<Widget> page2Items,
    required int page,
  }) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.sizeOf(context).width / 2.07,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: page,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      children: page1Items,
                    ),
                  );
                } else {
                  return SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      children: page2Items,
                    ),
                  );
                }
              },
              onPageChanged: (index) {
                _indexPage.value = index;
              },
            )),
      ],
    );
  }

  InkWell _itemWithPageView({
    required String iconUrl,
    required String text,
    VoidCallback? onPress,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onPress : null,
      child: Card(
        elevation: 2,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: IconCustom(
                  iConURL: iconUrl,
                  size: 30,
                ),
              ),
              Expanded(
                child: Text(
                  text.tr(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow({List<int>? workTime}) {
    return Container(
      height: 130,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: .5,
              spreadRadius: .5,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _widgetRow1(title: "afterjoin".tr(), type: 1),
          _dividerRow1(),
          _widgetRow1(title: "leave".tr(), type: 2),
          _dividerRow1(),
          _widgetRow1(title: "workingtime".tr(), type: 3, workTime: workTime),
          _dividerRow1(),
          _widgetRow1(title: "approval".tr(), type: 4),
          _dividerRow1(),
          _widgetRow1(title: "interview".tr(), type: 5),
        ],
      ),
    );
  }

  VerticalDivider _dividerRow1() {
    return const VerticalDivider(
      color: MyColor.pastelGray,
      width: 3,
      endIndent: 10,
      indent: 10,
    );
  }

  Expanded _widgetRow1(
      {required String title, required int type, List<int>? workTime}) {
    var workMonth = _workingmonth();

    String midLeft = "";
    String midRight = "";

    switch (type) {
      case 1:
        if (workMonth.isNotEmpty && workMonth[0] != 0) {
          midLeft = "${workMonth[0].toString()}Y ";
          midRight = " ${workMonth[1].toString()}M";
        } else {
          midLeft = "";
          midRight = workMonth[1].toString();
        }
        break;
      case 2:
        midRight = "$remainAnnualLeave";
        break;
      case 3:
        if (workTime != null && workTime.isNotEmpty) {
          workTime[0].toString().length == 2
              ? midLeft = "${workTime[0]}"
              : midLeft = "0${workTime[0]}";
          workTime[1].toString().length == 2
              ? midRight = "${workTime[1]}"
              : midRight = "0${workTime[1]}";
        }
        break;
      case 4:
        int countRequest = 0;

        // How much request for listRequestService with cnt?
        for (var element in listRequestService) {
          countRequest += element.cnt!;
        }

        midRight = "$countRequest";
        break;

      case 5:
        midRight = "${listInterview.length}";

        break;
      default:
    }

    return Expanded(
      flex: (type == 1 || type == 2 || type == 5 || type == 4) ? 2 : 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
              flex: 2,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              )),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(midLeft, style: _styleMid()),
                type == 3 ? Text(" : ", style: _styleMid()) : const SizedBox(),
                Text(midRight, style: _styleMid()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _styleMid() {
    return const TextStyle(
      color: MyColor.textBlack,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
  }

  CarouselSlider _buildCarouse() {
    return CarouselSlider.builder(
      itemCount: listGallery.length,
      itemBuilder: (context, index, realIndex) {
        String urlImg =
            listGallery.isNotEmpty ? listGallery[index].big ?? '' : '';
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FutureBuilder(
                  future: isImage(
                      url: (listGallery.isNotEmpty && listGallery != [])
                          ? urlImg
                          : '',
                      sv: ""),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !(snapshot.data ?? false)) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.asset(
                            MyAssets.imgPictureFails,
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            fit: BoxFit.cover,
                          ));
                    } else {
                      return InkWell(
                        onTap: () {
                          MyDialog.showPopupImage(context,
                              path: urlImg, type: 1);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) => Image.asset(
                              MyAssets.imgPictureFails,
                              width: MediaQuery.sizeOf(context).width * 0.7,
                              fit: BoxFit.cover,
                            ),
                            imageUrl: urlImg,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  }),
              _buildTextWithGallery(index)
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 200.h,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Positioned _buildTextWithGallery(int index) {
    return Positioned(
      left: 5.w,
      top: 5.h,
      right: 5.w,
      child: Text(
        listGallery.isNotEmpty ? listGallery[index].description.toString() : "",
        style: const TextStyle(
          backgroundColor: Color.fromARGB(163, 80, 80, 80),
          color: MyColor.textWhite,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildListAnn() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
      itemCount: listAnn.length,
      itemBuilder: (context, index) {
        final item = listAnn[index];

        return InkWell(
          onTap: () {
            _navigationService.pushNamed(MyRoute.announcementRoute, args: {
              KeyParams.announcements: item,
            });
          },
          child: CardCustom(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: IconCustom(iConURL: MyAssets.gifNew, size: 25),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.subject ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: MyColor.textDarkBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _navigationService.pushNamed(MyRoute.proFileRoute,
                args: {KeyParams.uploadImg: 1});
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 45,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: MyColor.bgDrawerColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 15, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          empName,
                          style: MyStyle.styleDefaultText,
                        ),
                        Text(
                          '${appBloc.subsidiaryInfo?.divisionDesc ?? ''} - ${appBloc.userInfo?.employeeCode ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: Row(
                  children: [
                    AvtCustom(
                      linkAvt: appBloc.linkAvt ?? '',
                      fullName: empName,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Stack(children: [
              IconButton(
                icon: Image.asset(
                  MyAssets.icBell,
                  width: 40,
                ),
                onPressed: () async {
                  final result = await _navigationService
                      .navigateAndDisplaySelection(MyRoute.inboxRoute,
                          args: {KeyParams.totalNoti: _totalNotifications});
                  if (result != null) {
                    homeBloc.add(HomeViewLoaded(appBloc: appBloc));
                  }
                },
              ),
              ValueListenableBuilder(
                  valueListenable: _totalNotifications,
                  builder: (context, value, child) => value == null || value < 1
                      ? const SizedBox()
                      : Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  globalApp.countNotification != null
                                      ? globalApp.countNotification! > 10
                                          ? 32
                                          : 4
                                      : 0),
                              color: MyColor.textRed,
                            ),
                            child: Text(
                              (value < 100) ? value.toString() : "99+",
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: MyColor.textWhite),
                            ),
                          )))
            ]),
            IconButton(
              onPressed: () {
                PlatformDialog.showConfirmDialog(context, onOk: () {
                  _navigationService.pushNamedAndRemoveUntil(
                    MyRoute.loginViewRoute,
                    args: {
                      KeyParams.loginServer: serverMode.toString(),
                      KeyParams.isLogout: true
                    },
                  );
                  appBloc.add(LogOut());
                }, text: 'wanttologout', btnOkText: 'logout');
              },
              icon: const Icon(
                Icons.logout,
                color: MyColor.outerSpace,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<int> _workingmonth() {
    int startTimeInMilliseconds = globalUser.dateofJoin ?? 0;
    if (startTimeInMilliseconds == 0) {
      return [0, 0];
    } else {
      DateTime startTime =
          DateTime.fromMillisecondsSinceEpoch(startTimeInMilliseconds);

      DateTime now = DateTime.now();
      int months =
          (now.year - startTime.year) * 12 + (now.month - startTime.month);
      int years = months ~/ 12;
      int remainingMonths = months % 12;

      String y = years.toString().padLeft(2, '0');
      String m = remainingMonths.toString().padLeft(2, '0');
      List<int> result = [int.parse(y), int.parse(m)];

      return result;
    }
  }

  voidCallBack(context, {required String path}) {
    switch (path) {
      case MyConstants.caseCheckInOut:
        return _onNavigateCheckInOut(context);
      case MyConstants.caseTimeSheets:
        return _onNavigateTimesheets(context);
      case MyConstants.caseLeave:
        return _onNavigateLeave(context);
      case MyConstants.caseBookingRoom:
        return _onNavigateBookingMeeting(context);
      case MyConstants.caseServiceRequest:
        return _onNavigateServiceRequest(context);
      case MyConstants.caseITService:
        return _onNavigateITService(context);
      case MyConstants.caseServiceApproval:
        return _onNavigateServiceApproval(context);
      case MyConstants.caseLeaveApproval:
        return _onNavigateLeaveApproval(context);
      case MyConstants.caseTimesheetApproval:
        return _onNavigateTimesheetApproval(context);

      default:
    }
  }

  void _onNavigateCheckInOut(BuildContext context) {
    _navigationService.pushNamed(MyRoute.clockInOutRoute);
  }

  void _onNavigateTimesheets(BuildContext context) {
    _navigationService.pushNamed(MyRoute.timesheetsRoute);
  }

  void _onNavigateLeave(BuildContext context) {
    _navigationService
        .pushNamed(MyRoute.leaveRoute, args: {KeyParams.isAddLeave: false});
  }

  void _onNavigateBookingMeeting(BuildContext context) {
    _navigationService.pushNamed(MyRoute.bookingMeetingRoute);
  }

  void _onNavigateServiceRequest(BuildContext context) {
    _navigationService.pushNamed(MyRoute.serviceRequestRoute);
  }

  void _onNavigateITService(BuildContext context) {
    _navigationService.pushNamed(MyRoute.itServiceRoute);
  }

  void _onNavigateServiceApproval(BuildContext context) {
    _navigationService.pushNamed(MyRoute.serviceApprovalRoute);
  }

  Future<void> _onNavigateLeaveApproval(BuildContext context) async {
    final result = await _navigationService.navigateAndDisplaySelection(
      MyRoute.leaveApprovalRoute,
    );
    if (result != null) {
      homeBloc.add(HomeViewLoaded(appBloc: appBloc));
    }
  }

  void _onNavigateTimesheetApproval(BuildContext context) {
    _navigationService.pushNamed(MyRoute.timesheetApprovalRoute);
  }

  void _onNavigateInterviewApproval(BuildContext context) {
    _navigationService.pushNamed(MyRoute.interviewApprovalRoute);
  }

  List<int> _calculatorWorkTime({
    required DateTime workStartTime,
  }) {
    DateTime startTime;
    DateTime currentTime;
    startTime = workStartTime;
    currentTime = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime = DateTime.now();
    });
    Duration duration = currentTime.difference(startTime);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    List<int> result = [hours, minutes];
    return result;
  }
}
