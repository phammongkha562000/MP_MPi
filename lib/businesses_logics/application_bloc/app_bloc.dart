import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data.dart';
import '../../data/models/notifications/notifications_model.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  TokenResponse? tokenResponse;
  UserInfo? userInfo;
  String? linkAvt;
  SubsidiaryInfo? subsidiaryInfo;
  List<WifiResponse> wifi = [];
  List<GalleryResponse> listGallery = [];
  List<ApplicationResponse> listApplication = [];
  List<InterviewApprovalResult> listInterviewApproval = [];
  List<ITAdminResponse> listITAdmin = [];
  List<WorkFlowResponse> listWorkFlow = [];
  List<StdCode> listStdCodeHr = [];
  List<StdCode> listSrStatus = [];
  List<StdCode> listTSPostType = [];
  List<StdCode> listItService = [];
  List<StdCode> listSVC = [];
  List<StdCode> listPriority = [];
  List<StdCode> listStdStatus = [];
  List<StdCode> listStdCostCenter = [];
  bool isGetTokenFcm = false;
  String? token;

  TimesheetResult? timesheetToday;

  AppBloc() : super(AppInitial()) {
    on<GetWifiEvent>(_getWifi);
    on<LogOut>(_logout);
    on<LoginToHub>(_loginToHub);
  }
  final _serviceRequestRepo = getIt<ServiceRequestRepository>();
  final _commonRepo = getIt<CommonRepository>();

  Future<void> _getWifi(GetWifiEvent event, emit) async {
    final getWifi = await DataBoxHelper.getWifi();
    if (getWifi is ApiResult) {
      if (getWifi.isFailure) {
        if (getWifi.isFailure) {
          Error error = getWifi.getErrorResponse();
          emit(GetWifiCompanyFail(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
      }
    }
    wifi = getWifi;
  }

  Future<dynamic> getApplication() async {
    if (listApplication.isEmpty) {
      final apiResult = await _serviceRequestRepo.getApplication();
      if (apiResult.isFailure) {
        return apiResult;
      }
      ApiResponse apiResponse = apiResult.data!;
      if (apiResponse.payload != null && apiResponse.payload != []) {
        List<ApplicationResponse> listApp = apiResponse.payload;
        listApplication =
            listApp.where((element) => element.appGroup == 'SVR').toList();
      }
      return listApplication;
    }
    return listApplication;
  }

  Future<dynamic> getWorkFlow(WorkFlowRequest content) async {
    if (listWorkFlow.isEmpty) {
      final apiResult = await _commonRepo.getWorkFlow(content: content);
      if (apiResult.isFailure) {
        return apiResult;
      }
      ApiResponse apiResponse = apiResult.data!;
      if (apiResponse.payload != null && apiResponse.payload != []) {
        listWorkFlow = apiResponse.payload;
      }
      return listWorkFlow;
    }
    return listWorkFlow;
  }

  Future<dynamic> getStdCodeWithType({
    required String type,
  }) async {
    final apiResult = await _commonRepo.getStdCodeWithType(typeStdCode: type);
    if (apiResult.isFailure) {
      return apiResult;
    } else {
      ApiResponse apiResponse = apiResult.data!;
      if (apiResponse.payload != null && apiResponse.payload != []) {
        return apiResponse.payload;
      }
    }
  }

  Future<void> _loginToHub(LoginToHub event, emit) async {
    try {
      if (isGetTokenFcm == false) {
        final model = NotificationsModel(
            userId: userInfo?.employeeId.toString() ?? '',
            userName: userInfo?.employeeName ?? '',
            platform: MyConstants.systemIDMB,
            token: event.token,
            status: 1,
            userVersion: globalApp.getVersion ?? '');
        token = event.token;
        final loginHubResult =
            await _serviceRequestRepo.loginToHub(model: model);
        if (loginHubResult.isFailure) {
          return;
        }
        isGetTokenFcm = true;
        return;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _logout(LogOut event, emit) async {
    try {
      if (token != null) {
        final model = NotificationsModel(
            userId: userInfo?.employeeId.toString() ?? '',
            userName: userInfo?.employeeName ?? '',
            platform: MyConstants.systemIDMB,
            token: token!,
            status: 1);

        final logoutFromHubResult =
            await _serviceRequestRepo.logoutFromHub(model: model);
        if (logoutFromHubResult.isSuccess) {
          isGetTokenFcm = false;
          log('Logged Out');
        }
      }
      final sharedPref = await SharedPreferencesService.instance;
      for (var element in SharedPrefKeys.listKey) {
        sharedPref.remove(element);
      }
      listGallery.clear();
      tokenResponse = null;
      userInfo = null;
      subsidiaryInfo = null;
      wifi.clear();
      listApplication.clear();
      listInterviewApproval.clear();
      listITAdmin.clear();
      listWorkFlow.clear();
      listStdCodeHr.clear();
      listSrStatus.clear();
      listTSPostType.clear();
      listItService.clear();
      listSVC.clear();
      listPriority.clear();
      listStdStatus.clear();
      listStdCostCenter.clear();
      linkAvt = null;
      getIt<AbstractDioHttpClient>().client.interceptors.clear();
    } catch (e) {
      log(e.toString());
    }
  }
}
