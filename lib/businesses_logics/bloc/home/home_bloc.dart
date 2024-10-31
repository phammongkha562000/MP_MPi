import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import 'package:path_provider/path_provider.dart';

import '../../../data/data.dart';
import '../../../data/repository/inbox/inbox_repository.dart';
import '../../application_bloc/app_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _loginRepo = getIt<LoginRepository>();
  final _homeRepo = getIt<HomeRepository>();
  final _timesheetsRepo = getIt<TimesheetsRepository>();
  final _inboxRepo = getIt<InboxRepository>();
  HomeBloc() : super(HomeInitial()) {
    on<HomeViewLoaded>(_mapViewLoaded);
  }
  Future<void> _mapViewLoaded(HomeViewLoaded event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;

      TokenResponse tokenResponse =
          event.appBloc.tokenResponse ?? TokenResponse();

      ApiResult apiUserProfileeResult = await _loginRepo.getUserProfile(
          baseUrl: sharedPref.serverSSO,
          id: int.parse(
            tokenResponse.asEmployeeId ?? '0',
          ));
      if (apiUserProfileeResult.isFailure) {
        Error? error = apiUserProfileeResult.getErrorResponse();
        emit(HomeFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse a = apiUserProfileeResult.data;
      UserProfile userProfile = a.payload;
      UserInfo userInfo = userProfile.userInfo;

      event.appBloc.userInfo = userInfo;
      event.appBloc.subsidiaryInfo = userProfile.subsidiaryInfo;

      if (event.appBloc.tokenResponse?.asUseDefaultPass != "False") {
        emit(UserDefaultPassState());
        return;
      }
      //set globaluser
      globalUser.setEmployeeId = userInfo.employeeId;
      globalUser.setEmployeeCode = userInfo.employeeCode;
      globalUser.setUsername = userInfo.loginName;

      globalUser.setDateofJoin = userInfo.dateofJoin;
      sharedPref.setSubsidiaryId(userProfile.subsidiaryInfo.subsidiaryId ?? '');

      var firstDayMonth = FindDate.firstDateOfMonth_yyyyMMdd(
          today: DateTime(DateTime.now().year, DateTime.now().month - 3,
              DateTime.now().day));
      var lastDayMonth =
          FindDate.lastDateOfMonth_yyyyMMdd(today: DateTime.now());

      //* Check avt
      event.appBloc.linkAvt = userInfo.avartarThumbnail ?? '';
      // event.appBloc.linkAvt = await ImageHelper.setAvatar(
      //   linkAvt: userInfo.avartarThumbnail ?? '',
      //   sv: sharedPref.serverMode.toString(),
      // );

      final countNotification = await _inboxRepo.getTotalNotifications(
          userId: globalUser.employeeId.toString(),
          sourceType: MyConstants.systemIDMB,
          baseUrl: sharedPref.serverSSO.toString(),
          serverHub: sharedPref.serverHub.toString());

      if (countNotification.isSuccess) {
        globalApp.setCountNotification = int.parse(countNotification.data);
        log('Total noti: ${globalApp.getCountNotification}');
      }
      final contentAnnouncements = AnnouncementsRequest(
        type: "",
        subject: "",
        dateFrom: firstDayMonth,
        dateTo: lastDayMonth,
        employeeId: globalUser.employeeId.toString(),
      );
      final contentStatussummary = LeaveListRemainRequest(
          subsidiaryId: sharedPref.subsidiaryId ?? '',
          employeeId: globalUser.employeeId.toString());
      //==============================ANNOUNCEMENTS=============================
      List<AnnouncementsResponse> listAnn = [];
      //working today
      final dateValue =
          DateFormat(MyConstants.yyyyMMdd).format(DateTime.now()); //hardcode
      final contentTimesheets = TimesheetsRequest(
          status: '',
          userId: globalUser.employeeId.toString(),
          employeeId: globalUser.employeeId ?? 0,
          submitDateF: dateValue,
          submitDateT: dateValue,
          isCheckTime: '0',
          skipRecord: 0,
          takeRecord: 10,
          pageNumber: 1,
          rowNumber: 1);
      final results = await Future.wait([
        _homeRepo.getAnn(content: contentAnnouncements),
        _loginRepo.getStatussummary(content: contentStatussummary),
        _timesheetsRepo.getTimesheets(content: contentTimesheets)
      ]);
      ApiResult apiResult = results[0];

      if (apiResult.isFailure) {
        listAnn = [];
        Error error = apiResult.getErrorResponse();
        emit(HomeFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }

      ApiResponse apiResponseAnn = apiResult.data;
      if (apiResponseAnn.success == false ||
          apiResponseAnn.error.errorCode != null) {
        emit(HomeFailure(message: apiResponseAnn.error.errorMessage));
        return;
      }
      listAnn = apiResponseAnn.payload;

      //remainAnnualLeave
      //==============================STATUSSUMARY=============================
      LeaveListRemainResponse statusSummary;
      List<InterviewApprovalResult> listInterView = [];

      ApiResult<ApiResponse> summaryApi = results[1];
      if (summaryApi.isFailure) {
        // listMenu = [];
        Error? error = summaryApi.getErrorResponse();
        emit(HomeFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      statusSummary = summaryApi.data?.payload;
      List<RequestServiceResponse> listRequestService =
          statusSummary.svrPendingList;
      listInterView = statusSummary.interviewSchedule;
      event.appBloc.listInterviewApproval = listInterView;

      final apiTimesheets = results[2];

      if (apiTimesheets.isFailure) {
        Error error = apiTimesheets.getErrorResponse();
        emit(HomeFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiTimesheetRes = apiTimesheets.data!;
      TimesheetResponse tsRes = apiTimesheetRes.payload;
      List<TimesheetResult> timesheetList = tsRes.result ?? [];
      DateTime? checkIn;
      /* DateTime? checkIn = timesheetList != [] && timesheetList.isNotEmpty
          ? FormatDateConstants.convertUTCtoDateTime(
              timesheetList.first.startTime!)
          : null; */
      TimesheetResult? timesheetToday;
      if (timesheetList != [] && timesheetList.isNotEmpty) {
        checkIn = FormatDateConstants.convertUTCtoDateTime(
            timesheetList.first.startTime!);
        timesheetToday = timesheetList.first;
      }
      event.appBloc.timesheetToday = timesheetToday;

      //===========================================================
      //get Gallery

      if (event.appBloc.listGallery.isEmpty) {
        final galleryApi = await _homeRepo.getGallery();
        if (galleryApi.isFailure) {
          Error error = galleryApi.getErrorResponse();

          emit(HomeFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        event.appBloc.listGallery = galleryApi.data?.payload;
      }

      double remainAnnualLeave = 0;
      final List<LeaveList> leaveList = statusSummary.leaveList;
      for (var element in leaveList) {
        element.leaveTypeDesc == 'Annual Leave' ||
                element.leaveTypeDesc == 'Annual Leave (Prev. Yr)'
            ? remainAnnualLeave +=
                ((element.remains! > 0) ? element.remains ?? 0 : 0)
            : null;
      }

      emit(HomeSuccess(
        serverMode: sharedPref.serverMode.toString(),
        // menuList: listMenu,
        listAnn: listAnn,
        listGallery: event.appBloc.listGallery,
        remainAnnualLeave: remainAnnualLeave,
        checkIn: checkIn,
        listRequestService: listRequestService,
        listInterview: listInterView,
      ));

      Directory? externalDir = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory();

      if (externalDir != null) {
        // init folder
        String bigDirPath = '${externalDir.path}/galleryBig';
        Directory bigDir = Directory(bigDirPath);
        if (await bigDir.exists()) {
          bigDir.deleteSync(recursive: true);
        }
      }

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        globalServer.setDeviceId =
            '${androidInfo.id}${globalUser.employeeCode}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        globalServer.setDeviceId =
            '${iosInfo.identifierForVendor}${globalUser.employeeCode}';
      }
    } catch (e) {
      log("Error: $e");
      emit(HomeFailure(message: e.toString()));
    }
  }
}
