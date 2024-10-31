import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:r_get_ip/r_get_ip.dart';
// import 'package:vpn_connection_detector/vpn_connection_detector.dart';

import '../../application_bloc/app_bloc.dart';
part 'clock_in_out_event.dart';
part 'clock_in_out_state.dart';

class ClockInOutBloc extends Bloc<ClockInOutEvent, ClockInOutState> {
  final _clockInOutRepo = getIt<ClockInOutRepository>();
  final _timesheetsRepo = getIt<TimesheetsRepository>();

  ClockInOutBloc() : super(ClockInOutInitial()) {
    on<ClockInOutViewLoaded>(_mapViewLoadedToState);
    on<ClockInOutUpdate>(_mapUpdateToState);
    on<ClockInOutGetTimesheetToday>(_mapGetTimesheetTodayToState);
  }

  void _mapViewLoadedToState(ClockInOutViewLoaded event, emit) async {
    emit(ClockInOutLoading());
    try {
      List<WifiResponse> workLocs = [];
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        final workLocation = event.appBloc.userInfo?.workingLocation;
        if (workLocation != '' && workLocation != null) {
          List<String> workLocationList = workLocation.split(',');
          for (var element in workLocationList) {
            for (var elm in event.appBloc.wifi) {
              if (int.parse(element) == elm.id) {
                workLocs.add(elm);
              }
            }
          }
        }
      }
      List<String> workLocsName =
          workLocs.map((e) => e.locationName ?? '').toList();
      emit(ClockInOutSuccess(workingLocation: workLocsName.join(', ')));
    } catch (e) {
      emit(ClockInOutFailure(message: e.toString()));
    }
  }

  Future<bool> initPlatformState() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final a = position.isMocked;
    log(a.toString());
    return a;
  }

  Future<void> _mapUpdateToState(ClockInOutUpdate event, emit) async {
    try {
      final currentState = state;
      if (currentState is ClockInOutSuccess) {
        emit(ClockInOutLoading());

        // bool jailbroken = await FlutterJailbreakDetection.jailbroken;
        bool developerMode = await FlutterJailbreakDetection.developerMode;
        // bool isVpnConnected = await VpnConnectionDetector.isVpnActive();
        if (developerMode) {
          emit(const ClockInOutFailure(
              message:
                  'Không thể chấm công khi thiết bị đang bật chế độ nhà phát triển'));
          return;
        }
        // if (isVpnConnected) {
        //   emit(const ClockInOutFailure(
        //       message: 'Không thể chấm công khi thiết bị đang kết nối VPN'));
        //   return;
        // }
        // if (jailbroken) {
        //   emit(const ClockInOutFailure(
        //       message: 'Không thể chấm công khi thiết bị có Jailbreake'));
        //   return;
        // }
        String lat = '0';
        String lon = '0';

        String deviceId = globalServer.deviceId ?? '';
        //  get IP
        final externalIP = await RGetIp.externalIP;
        log('IP: ${externalIP.toString()}');

        String method = 'LOCATION';
        String macAddressWifi = '';

        //check wifi/4G
        final connectivityResult = await (Connectivity().checkConnectivity());
        var location = await LocationHelper.getLatitudeAndLongitude();
        lat = location[0].toString();
        lon = location[1].toString();
        //user Hải Phòng office
        if (event.appBloc.tokenResponse?.asIgnoreCheckLocation != "False") {
          //hardcode //False
          if (await initPlatformState()) {
            emit(const ClockInOutFailure(message: 'Vị trí không chính xác'));
            return;
          }

          List<WifiResponse> workLocs = [];

          final workLocation = event.appBloc.userInfo?.workingLocation;
          if (workLocation != '' && workLocation != null) {
            List<String> workLocationList = workLocation.split(',');
            for (var element in workLocationList) {
              for (var elm in event.appBloc.wifi) {
                if (int.parse(element) == elm.id) {
                  workLocs.add(elm);
                }
              }
            }
          }
          List<String> workLocsName =
              workLocs.map((e) => e.locationName ?? '').toList();
          final content = ClockInOutRequest(
            employeeId: globalUser.getEmployeeId ?? 0,
            lat: lat,
            lon: lon,
            wifiSSID: '',
            actionDate: DateFormat(MyConstants.yyyyMMddHHmmssSlash)
                .format(DateTime.now()),
            actionType: event.type == 0 ? 'I' : 'O',
            macAddressWifi: macAddressWifi,
            method: method,
            deviceId: deviceId,
          );

          ApiResult apiResultCheckInOut =
              await _clockInOutRepo.postCheckInOut(content: content);
          if (apiResultCheckInOut.isFailure) {
            Error error = apiResultCheckInOut.getErrorResponse();
            emit(ClockInOutFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
          ApiResponse apiResponse = apiResultCheckInOut.data;
          if (apiResponse.success == false) {
            emit(ClockInOutFailure(
              message: apiResponse.error.errorMessage,
            ));
            return;
          } else if (apiResponse.error.errorCode == '1') {
            emit(ClockInOutSuccessfully(lat: lat, lon: lon));

            emit(currentState.copyWith(
                workingLocation: workLocsName.join(', ')));
          } else {
            String messErr = apiResponse.error.errorMessage;
            emit(ClockInOutFailure(
                message: messErr, errorCode: MyError.errCodeDevice));
            emit(currentState.copyWith(
                workingLocation: workLocsName.join(', ')));
          }
        } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
          List<WifiResponse> wifi = event.appBloc.wifi;

          for (var element in wifi) {
            if (element.macAddressWifi != '' &&
                element.macAddressWifi != null) {
              final wifiItem = element.macAddressWifi!.split(';');
              for (var i in wifiItem) {
                if (i == externalIP) {
                  method = 'IP';
                  macAddressWifi = externalIP.toString();
                  break;
                }
              }
            }
          }
          //validate
          if (method == 'IP') {
            final content = ClockInOutRequest(
                employeeId: globalUser.getEmployeeId ?? 0,
                lat: lat,
                lon: lon,
                wifiSSID: '',
                actionDate: DateFormat(MyConstants.yyyyMMddHHmmssSlash)
                    .format(DateTime.now()),
                actionType: event.type == 0 ? 'I' : 'O',
                macAddressWifi: macAddressWifi,
                method: method,
                deviceId: deviceId);

            ApiResult apiResultCheckInOut =
                await _clockInOutRepo.postCheckInOut(content: content);
            if (apiResultCheckInOut.isFailure) {
              Error? error = apiResultCheckInOut.getErrorResponse();
              emit(ClockInOutFailure(
                  message: error.errorMessage, errorCode: error.errorCode));
              return;
            }
            ApiResponse apiResponse = apiResultCheckInOut.data;
            if (apiResponse.error.errorCode == '1') {
              emit(ClockInOutSuccessfully(lat: lat, lon: lon));
              emit(currentState.copyWith(workingLocation: ''));
            } else {
              emit(ClockInOutFailure(message: apiResponse.error.errorMessage));
            }
          } else {
            emit(const ClockInOutFailure(
                message: 'Vui lòng sử dụng Wifi Minh Phương để chấm công!'));
            return;
          }
        } else {
          //4G
          //get Location
          if (await initPlatformState()) {
            emit(const ClockInOutFailure(message: 'Location không chính xác'));
            return;
          }

          List<WifiResponse> workLocs = [];
          final connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult.contains(ConnectivityResult.mobile)) {
            final workLocation = event.appBloc.userInfo?.workingLocation;
            if (workLocation != '' && workLocation != null) {
              List<String> workLocationList = workLocation.split(',');
              for (var element in workLocationList) {
                for (var elm in event.appBloc.wifi) {
                  if (int.parse(element) == elm.id) {
                    workLocs.add(elm);
                  }
                }
              }
            }
          }
          List<String> workLocsName =
              workLocs.map((e) => e.locationName ?? '').toList();
          final content = ClockInOutRequest(
              employeeId: globalUser.getEmployeeId ?? 0,
              lat: lat,
              lon: lon,
              wifiSSID: '',
              actionDate: DateFormat(MyConstants.yyyyMMddHHmmssSlash)
                  .format(DateTime.now()),
              actionType: event.type == 0 ? 'I' : 'O',
              macAddressWifi: macAddressWifi,
              method: method,
              deviceId: deviceId);

          ApiResult apiResultCheckInOut =
              await _clockInOutRepo.postCheckInOut(content: content);
          if (apiResultCheckInOut.isFailure) {
            Error error = apiResultCheckInOut.getErrorResponse();
            emit(ClockInOutFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
          ApiResponse apiResponse = apiResultCheckInOut.data;
          if (apiResponse.success == false) {
            emit(ClockInOutFailure(message: apiResponse.error.errorMessage));
            return;
          } else if (apiResponse.error.errorCode == '1') {
            emit(ClockInOutSuccessfully(lat: lat, lon: lon));

            emit(currentState.copyWith(
                workingLocation: workLocsName.join(', ')));
          } else {
            String messErr = apiResponse.error.errorMessage;
            emit(ClockInOutFailure(
                message: messErr, errorCode: MyError.errCodeDevice));
            emit(currentState.copyWith(
                workingLocation: workLocsName.join(', ')));
          }
        }
      } else {
        emit(const ClockInOutFailure(message: "updatefailure"));
      }
    } catch (e) {
      emit(ClockInOutFailure(message: e.toString()));
    }
  }

  Future<void> _mapGetTimesheetTodayToState(
      ClockInOutGetTimesheetToday event, emit) async {
    try {
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
      final apiTimesheets =
          await _timesheetsRepo.getTimesheets(content: contentTimesheets);
      if (apiTimesheets.isFailure) {
        Error error = apiTimesheets.getErrorResponse();
        emit(ClockInOutFailure(
          message: error.errorMessage,
        ));

        return;
      }
      ApiResponse apiTimesheetRes = apiTimesheets.data!;
      TimesheetResponse tsRes = apiTimesheetRes.payload;
      List<TimesheetResult> timesheetList = tsRes.result ?? [];
      /*
      DateTime? checkIn;
      
       DateTime? checkIn = timesheetList != [] && timesheetList.isNotEmpty
          ? FormatDateConstants.convertUTCtoDateTime(
              timesheetList.first.startTime!)
          : null; */
      TimesheetResult? timesheetToday;
      if (timesheetList != [] && timesheetList.isNotEmpty) {
        // checkIn = FormatDateConstants.convertUTCtoDateTime(
        //     timesheetList.first.startTime!);
        timesheetToday = timesheetList.first;
      }
      event.appBloc.timesheetToday = timesheetToday;
    } catch (e) {
      emit(ClockInOutFailure(message: e.toString()));
    }
  }
}
