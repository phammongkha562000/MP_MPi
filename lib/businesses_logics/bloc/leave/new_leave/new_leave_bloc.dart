import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../../data/data.dart';
import '../../../application_bloc/app_bloc.dart';

part 'new_leave_event.dart';
part 'new_leave_state.dart';

class NewLeaveBloc extends Bloc<NewLeaveEvent, NewLeaveState> {
  final _leaveRepo = getIt<LeaveRepository>();

  NewLeaveBloc() : super(NewLeaveInitial()) {
    on<NewLeaveLoaded>(_mapViewToState);
    on<NewLeaveChangeFromDate>(_mapChangeFromDate);
    on<NewLeaveChangeToDate>(_mapChangeToDate);
    on<NewLeaveChangeTypeLeave>(_mapChangeTypeLeave);
    on<NewLeaveUploadImage>(_mapChooseImage);
    on<NewLeaveSubmit>(_mapNewLeaveToState);
    on<NewLeaveChangeSesionType>(_mapChangeSessionToState);
  }
  Future<void> _mapViewToState(NewLeaveLoaded event, emit) async {
    try {
      emit(NewLeaveLoading());

      List<StdCode> listStdCodeHr = event.appBloc.listStdCodeHr;
      if (listStdCodeHr.isEmpty) {
        final getStdCodeHr =
            await event.appBloc.getStdCodeWithType(type: TypeStdCode.typeHr);
        if (getStdCodeHr is ApiResult) {
          if (getStdCodeHr.isFailure) {
            Error? error = getStdCodeHr.getErrorResponse();
            emit(NewLeaveFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        listStdCodeHr = getStdCodeHr;
        event.appBloc.listStdCodeHr = getStdCodeHr;
      }

      final sharedPref = await SharedPreferencesService.instance;

      final requestWorkflow = WorkFlowRequest(
          applicationCode: "HLV",
          deptCode: event.appBloc.subsidiaryInfo?.deptCode ?? '',
          divisionCode: event.appBloc.subsidiaryInfo?.divisionCode ?? '',
          empId: globalUser.employeeId.toString(),
          localAmount: 0,
          subsidiryId: sharedPref.subsidiaryId ?? '');

      List<WorkFlowResponse> workFlow = [];
      final getResultWorkflow =
          await event.appBloc.getWorkFlow(requestWorkflow);
      if (getResultWorkflow is ApiResult) {
        if (getResultWorkflow.isFailure) {
          Error? error = getResultWorkflow.getErrorResponse();
          emit(NewLeaveFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
      }
      workFlow = getResultWorkflow;
      List<SessionType> sessionTypes = [
        SessionType(session: "full".tr(), sessionCode: 1, sessionId: "FULL"),
        SessionType(session: "morning".tr(), sessionCode: 2, sessionId: 'AM'),
        SessionType(session: "afternoon".tr(), sessionCode: 3, sessionId: 'PM')
      ];
      emit(NewLeaveLoadSuccess(
          sessionTypes: sessionTypes,
          sessionType: sessionTypes[1],
          calDate: 0.5,
          fromDate: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          toDate: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          listStdCodeHr: listStdCodeHr,
          workFlow: workFlow,
          leaveResponse: null,
          pathImg: "",
          phoneNumber: event.appBloc.userInfo?.mobile ?? ''));
    } catch (e) {
      emit(NewLeaveFailure(message: e.toString()));
    }
  }

  void _mapChangeSessionToState(NewLeaveChangeSesionType event, emit) {
    try {
      final currentState = state;
      if (currentState is NewLeaveLoadSuccess) {
        final division = event.divisionCode;
        emit(NewLeaveLoading());
        final from =
            DateFormat(MyConstants.ddMMyyyySlash).format(currentState.fromDate);
        final to =
            DateFormat(MyConstants.ddMMyyyySlash).format(currentState.toDate);
        if (from == to) {
          for (int i = 0;
              i <= currentState.toDate.difference(currentState.fromDate).inDays;
              i++) {
            var weekday = currentState.fromDate.add(Duration(days: i)).weekday;
            if (weekday == 6) {
              SessionType sessionType = currentState.sessionTypes
                  .where((element) => element.sessionCode == 2)
                  .single;
              double calDate = calculatorDate(
                  division: division,
                  fromDate: currentState.fromDate,
                  toDate: currentState.toDate,
                  type: sessionType.sessionCode);
              emit(currentState.copyWith(
                  sessionType: sessionType, calDate: calDate));
              return;
            } else {
              SessionType sessionType = event.sessionType;
              double calDate = calculatorDate(
                  division: division,
                  fromDate: currentState.fromDate,
                  toDate: currentState.toDate,
                  type: sessionType.sessionCode);
              emit(currentState.copyWith(
                  sessionType: sessionType, calDate: calDate));
            }
          }
        } else {
          SessionType sessionType = event.sessionType;
          double calDate = calculatorDate(
              division: division,
              fromDate: currentState.fromDate,
              toDate: currentState.toDate,
              type: sessionType.sessionCode);
          emit(currentState.copyWith(
              sessionType: sessionType, calDate: calDate));
        }
      }
    } catch (e) {
      emit(NewLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeFromDate(NewLeaveChangeFromDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is NewLeaveLoadSuccess) {
        emit(NewLeaveLoading());
        final division = event.divisionCode;

        double calDate = calculatorDate(
            division: division,
            fromDate: event.fromDate,
            toDate: event.fromDate,
            type: currentState.sessionType.sessionCode);
        emit(currentState.copyWith(
            fromDate: event.fromDate,
            toDate: event.fromDate,
            calDate: calDate));
      }
    } catch (e) {
      emit(NewLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeToDate(NewLeaveChangeToDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is NewLeaveLoadSuccess) {
        emit(NewLeaveLoading());
        final from =
            DateFormat(MyConstants.ddMMyyyySlash).format(currentState.fromDate);
        final to = DateFormat(MyConstants.ddMMyyyySlash).format(event.toDate);
        SessionType sessionType = currentState.sessionType;
        if (from == to) {
          for (int i = 0;
              i <= event.toDate.difference(currentState.fromDate).inDays;
              i++) {
            var weekday = currentState.fromDate.add(Duration(days: i)).weekday;
            if (weekday == 6) {
              sessionType = currentState.sessionTypes[1];
            }
          }
        } else {
          sessionType = currentState.sessionTypes
              .where((element) => element.sessionCode == 1)
              .single;
        }
        double calDate = calculatorDate(
            fromDate: currentState.fromDate,
            toDate: event.toDate,
            type: currentState.sessionType.sessionCode,
            division: event.divisionCode);
        emit(currentState.copyWith(
            sessionType: sessionType,
            toDate: event.toDate,
            leaveResponse: currentState.leaveResponse,
            calDate: calDate));
      }
    } catch (e) {
      emit(NewLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeTypeLeave(NewLeaveChangeTypeLeave event, emit) async {
    try {
      final currentState = state;
      if (currentState is NewLeaveLoadSuccess) {
        emit(NewLeaveLoading());

        final dataRequest = CheckLeaveRequest(
          employeeId: globalUser.employeeId,
          leavetype: event.typeLeave.codeId,
          lyear: DateTime.now().year.toString(),
        );

        ApiResult apiResult =
            await _leaveRepo.checkLeaveWithType(content: dataRequest);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(NewLeaveFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse checkLeave = apiResult.data;
        CheckLeaveResponse leaveResponse;
        if (checkLeave.success == true) {
          if (checkLeave.payload != null) {
            leaveResponse = checkLeave.payload;
          } else {
            leaveResponse = CheckLeaveResponse(balance: 0);
          }

          emit(currentState.copyWith(
              typeLeave: event.typeLeave,
              leaveResponse: leaveResponse,
              phoneNumber: event.phoneNumber));
        } else {
          emit(NewLeaveFailure(message: checkLeave.error.errorMessage));
        }
      }
    } catch (e) {
      emit(NewLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapChooseImage(NewLeaveUploadImage event, emit) async {
    try {
      final currentState = state;
      if (currentState is NewLeaveLoadSuccess) {
        if (event.pathImg.isNotEmpty) {
          emit(NewLeaveLoading());

          emit(currentState.copyWith(pathImg: event.pathImg));
        } else {
          emit(NewLeaveFailure(message: "no_data".tr()));
        }
      }
    } catch (e) {
      emit(NewLeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapNewLeaveToState(NewLeaveSubmit event, emit) async {
    try {
      final currentState = state;
      if (currentState is NewLeaveLoadSuccess) {
        emit(NewLeaveLoading());

        final request = NewLeaveRequest(
          employeeId: int.parse(globalUser.employeeId.toString()),
          fromDate: DateFormat("yyyy/MM/dd").format(currentState.fromDate),
          toDate: DateFormat("yyyy/MM/dd").format(currentState.toDate),
          leaveDays: currentState.calDate,
          leaveStatus: "NEW",
          leaveType: currentState.typeLeave!.codeId.toString(),
          userId: int.parse(globalUser.employeeId.toString()),
          marker: isSarturday(
                  fromDate: currentState.fromDate, toDate: currentState.toDate)
              ? 'AM'
              : currentState.sessionType.sessionId,
          remark: event.remark,
        );
        ApiResult apiResult = await _leaveRepo.createNewLeave(content: request);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(NewLeaveFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse createNewLeave = apiResult.data;
        if (createNewLeave.success == true && createNewLeave.payload != null) {
          log("$createNewLeave");
          if (createNewLeave.payload == "") {
            emit(NewLeaveFailure(
              message: "leaveexist".tr(),
              errorCode: MyError.errCodeNewLeave,
            ));
          } else {
            emit(NewLeaveSuccessfully());
          }
        } else {
          emit(NewLeaveFailure(message: createNewLeave.error.errorMessage));
        }
      }
    } catch (e) {
      emit(NewLeaveFailure(message: e.toString()));
    }
  }

  bool isSarturday({required DateTime fromDate, required DateTime toDate}) {
    final from = DateFormat(MyConstants.ddMMyyyySlash).format(fromDate);
    final to = DateFormat(MyConstants.ddMMyyyySlash).format(toDate);
    if (from == to) {
      for (int i = 0; i <= toDate.difference(fromDate).inDays;) {
        var weekday = fromDate.add(Duration(days: i)).weekday;
        if (weekday == 6) {
          return true;
        }
        return false;
      }
    }
    return false;
  }

  double calculatorDate(
      {required DateTime fromDate,
      required DateTime toDate,
      required int type,
      required String division}) {
    double countDay = 0;
    final from = DateFormat(MyConstants.ddMMyyyySlash).format(fromDate);
    final to = DateFormat(MyConstants.ddMMyyyySlash).format(toDate);
    if (from == to) {
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        var weekday = fromDate.add(Duration(days: i)).weekday;
        if (weekday == 7) {
          countDay = countDay;
        } else if (type == 1) {
          if (weekday == 6) {
            countDay = 0.5;
          } else {
            countDay = 1;
          }
        } else if (type == 2 || type == 3) {
          countDay = 0.5;
        }
      }
    } else {
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        var weekday = fromDate.add(Duration(days: i)).weekday;
        if (weekday == 7) {
          countDay = countDay;
        } else if (weekday == 6) {
          if (division == 'DNA') {
            countDay = countDay + 1;
          } else {
            countDay = countDay + 0.5;
          }
        } else {
          countDay++;
        }
      }
    }
    return countDay;
  }
}
