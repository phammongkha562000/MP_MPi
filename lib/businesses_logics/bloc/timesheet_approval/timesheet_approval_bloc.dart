import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/models/timesheet_approval/save_timesheet_approval_request.dart';
import 'package:mpi_new/data/models/timesheet_approval/timesheet_approval_request.dart';
import 'package:mpi_new/data/models/timesheet_approval/timesheet_approval_response.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../application_bloc/app_bloc.dart';

part 'timesheet_approval_event.dart';
part 'timesheet_approval_state.dart';

class TimesheetApprovalBloc
    extends Bloc<TimesheetApprovalEvent, TimesheetApprovalState> {
  final _timesheetsRepo = getIt<TimesheetsRepository>();

  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<TimesheetApprovalResult> timesheetApprLst = [];

  TimesheetApprovalBloc() : super(TimesheetApprovalInitial()) {
    on<TimesheetApprovalViewLoaded>(_mapViewLoadedToState);
    on<TimesheetApprovalChangeDate>(_mapChangeDateToState);
    on<TimesheetSelected>(_mapSelectedToState);
    on<TimesheetSelectedAll>(_mapSelectedAllToState);
    on<TimesheetApproveSelected>(_mapApprovalSelectedToState);
    on<TimesheetChangeStatus>(_mapChangeStatusToState);
    on<TimesheetApprovalSlidable>(_mapSlidableToState);
    on<TimesheetApprovalPaging>(_mapPagingToState);
  }

  Future<void> _mapViewLoadedToState(
      TimesheetApprovalViewLoaded event, emit) async {
    emit(TimesheetApprovalLoading());
    try {
      timesheetApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;
      //init load từ ngày đầu của tháng trước đến ngày cuối tháng này - 2 tháng
      final fromDate = event.fromDate ??
          DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      final toDate = event.toDate ??
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

      final StdCode stdFirst = StdCode(codeDesc: 'all'.tr(), codeId: '');

      //std status
      List<StdCode> stdStatusList = [stdFirst];
      if (event.appBloc.listStdStatus.isEmpty) {
        final getTSPostType = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeDOCGENSTATUSTSPOSTTYPE,
        );
        if (getTSPostType is ApiResult) {
          if (getTSPostType.isFailure) {
            Error? error = getTSPostType.getErrorResponse();
            emit(TimesheetApprovalFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listStdStatus = getTSPostType;
        stdStatusList.addAll(getTSPostType);
      } else {
        stdStatusList.addAll(event.appBloc.listStdStatus);
      }

      final statusInit =
          stdStatusList.where((element) => element.codeId == 'NEW').single;
      ApiResult apiResult = await _getTimesheetApproval(
          status: statusInit.codeId ?? '',
          fromDate: event.fromDate ??
              DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
          toDate: event.toDate ??
              DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(TimesheetApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiTimesheetApproval = apiResult.data;

      if (!apiTimesheetApproval.success ||
          apiTimesheetApproval.error.errorCode != null) {
        emit(TimesheetApprovalFailure(
            message: apiTimesheetApproval.error.errorMessage));
        return;
      }
      TimesheetApprovalResponse timesheetRes = apiTimesheetApproval.payload;
      List<TimesheetApprovalResult> timesheetApprList =
          timesheetRes.result ?? [];
      timesheetApprLst.addAll(timesheetApprList);
      quantity = timesheetRes.totalRecord ?? 0;
      emit(TimesheetApprovalSuccess(
          status: statusInit,
          statusList: stdStatusList,
          isSelectAll: false,
          fromDate: fromDate,
          toDate: toDate,
          timesheetApprovalList: timesheetApprList,
          quantity: quantity));
    } catch (e) {
      emit(const TimesheetApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapChangeDateToState(
      TimesheetApprovalChangeDate event, emit) async {
    try {
      emit(TimesheetApprovalLoading());
      timesheetApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;

      final fromDate = event.fromDate;
      final toDate = event.toDate;

      //nếu event không truyền fromDate, toDate thì dùng currentState
      ApiResult apiResult = await _getTimesheetApproval(
          status: event.statusCode,
          fromDate: event.fromDate,
          toDate: event.toDate);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(TimesheetApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiTimesheetApproval = apiResult.data;

      if (!apiTimesheetApproval.success ||
          apiTimesheetApproval.error.errorCode != null) {
        emit(TimesheetApprovalFailure(
            message: apiTimesheetApproval.error.errorMessage));
        return;
      }
      TimesheetApprovalResponse timesheetRes = apiTimesheetApproval.payload;
      List<TimesheetApprovalResult> timesheetApprList =
          timesheetRes.result ?? [];
      timesheetApprLst.addAll(timesheetApprList);
      quantity = timesheetRes.totalRecord ?? 0;
      emit(GetTimesheetApprovalSuccess(
          fromDate: fromDate,
          toDate: toDate,
          isSelectAll: false,
          timesheetApprovalList: timesheetApprList,
          quantity: quantity));
    } catch (e) {
      emit(const TimesheetApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapSelectedToState(TimesheetSelected event, emit) async {
    try {
      emit(TimesheetApprovalLoading());

      final listSelected = event.timesheetApprList
          .map((e) =>
              e.tsId == event.tsId ? e.copyWith(selected: event.selected) : e)
          .toList();
      final isSelectedAll =
          listSelected.where((element) => element.selected == false).isNotEmpty
              ? false
              : true;
      emit(SelectTimesheetApprovalSuccess(
          timesheetApprList: listSelected, isSelectAll: isSelectedAll));
    } catch (e) {
      emit(const TimesheetApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapSelectedAllToState(TimesheetSelectedAll event, emit) async {
    try {
      final listSelected = event.timesheetApprList
          .map((e) => event.isSelectAll
              ? e.copyWith(selected: true)
              : e.copyWith(selected: false))
          .toList();
      emit(SelectTimesheetApprovalSuccess(
          timesheetApprList: listSelected, isSelectAll: event.isSelectAll));
    } catch (e) {
      emit(const TimesheetApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapApprovalSelectedToState(
      TimesheetApproveSelected event, emit) async {
    try {
      emit(TimesheetApprovalLoading());
      final listSelected = event.timesheetApprList
          .where((element) => element.selected == true)
          .toList();
      for (var element in listSelected) {
        final content = SaveTimesheetApprovalRequest(
            tsId: element.tsId ?? 0,
            updateUser: globalUser.employeeId.toString(),
            approveType: 'Approved',
            approveComment: event.comment);
        ApiResult apiResult =
            await _timesheetsRepo.saveTimesheetApproval(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(TimesheetApprovalFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiUpdate = apiResult.data;
        if (!apiUpdate.success || apiUpdate.error.errorCode != null) {
          emit(TimesheetApprovalFailure(message: apiUpdate.error.errorMessage));
          return;
        }
        if (apiUpdate.success && apiUpdate.error.errorMessage != null) {
          emit(TimesheetApprovalFailure(message: apiUpdate.error.errorMessage));
          return;
        }
      }

      emit(TimesheetApprovalSaveSuccessful());
    } catch (e) {
      emit(const TimesheetApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapChangeStatusToState(
      TimesheetChangeStatus event, emit) async {
    try {
      emit(TimesheetApprovalLoading());
      timesheetApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;
      ApiResult apiResult = await _getTimesheetApproval(
          fromDate: event.fromDate,
          toDate: event.toDate,
          status: event.statusCode);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(TimesheetApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiTimesheetApproval = apiResult.data;

      if (!apiTimesheetApproval.success ||
          apiTimesheetApproval.error.errorCode != null) {
        emit(TimesheetApprovalFailure(
            message: apiTimesheetApproval.error.errorMessage));
        return;
      }
      final StdCode selectStd = event.statusList
          .where((element) => element.codeId == event.statusCode)
          .single;

      TimesheetApprovalResponse timesheetRes = apiTimesheetApproval.payload;
      List<TimesheetApprovalResult> timesheetApprList =
          timesheetRes.result ?? [];
      timesheetApprLst.addAll(timesheetApprList);
      quantity = timesheetRes.totalRecord ?? 0;
      emit(ChangeStatusTimesheetApprovalSuccess(
          quantity: quantity,
          timesheetApprovalList: timesheetApprLst,
          status: selectStd));
    } catch (e) {
      emit(const TimesheetApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapSlidableToState(
      TimesheetApprovalSlidable event, emit) async {
    try {
      final content = SaveTimesheetApprovalRequest(
          tsId: event.tsId,
          updateUser: globalUser.employeeId.toString(),
          approveType: event.approvalType,
          approveComment: event.comment);
      ApiResult apiResult =
          await _timesheetsRepo.saveTimesheetApproval(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(TimesheetApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiUpdate = apiResult.data;
      if (!apiUpdate.success || apiUpdate.error.errorCode != null) {
        emit(TimesheetApprovalFailure(message: apiUpdate.error.errorMessage));
        return;
      }

      emit(TimesheetApprovalSaveSuccessful());
    } catch (e) {
      emit(const TimesheetApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapPagingToState(TimesheetApprovalPaging event, emit) async {
    try {
      if (quantity == timesheetApprLst.length) {
        endPage = true;
        return;
      }
      if (endPage == false) {
        emit(TimesheetApprovalPagingLoading());
        pageNumber++;
        final fromDate = event.fromDate;
        final toDate = event.toDate;

        ApiResult apiResult = await _getTimesheetApproval(
            fromDate: fromDate, toDate: toDate, status: event.statusCode);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(TimesheetApprovalFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiTimesheetApproval = apiResult.data;

        if (!apiTimesheetApproval.success ||
            apiTimesheetApproval.error.errorCode != null) {
          emit(TimesheetApprovalFailure(
              message: apiTimesheetApproval.error.errorMessage));
          return;
        }

        TimesheetApprovalResponse timesheetRes = apiTimesheetApproval.payload;
        List<TimesheetApprovalResult> timesheetApprList =
            timesheetRes.result ?? [];
        if (timesheetApprList.isNotEmpty && timesheetApprList != []) {
          timesheetApprLst.addAll(timesheetApprList);
        } else {
          endPage = true;
        }
        emit(GetTimesheetApprovalSuccess(
            fromDate: fromDate,
            timesheetApprovalList: timesheetApprLst,
            toDate: toDate,
            quantity: quantity,
            isSelectAll: false));
      }
    } catch (e) {
      emit(const TimesheetApprovalFailure(message: MyError.messError));
    }
  }

  Future<ApiResult<ApiResponse>> _getTimesheetApproval({
    required DateTime fromDate,
    required DateTime toDate,
    required String status,
  }) async {
    final submitDateF = DateFormat(MyConstants.yyyyMMdd).format(fromDate);
    final submitDateT = DateFormat(MyConstants.yyyyMMdd).format(toDate);

    final content = TimesheetApprovalRequest(
        skipRecord: 0,
        submitDateF: submitDateF,
        submitDateT: submitDateT,
        takeRecord: 12,
        employeeId: "0",
        status: status,
        userId: globalUser.employeeId.toString(),
        pageNumber: pageNumber,
        rowNumber: MyConstants.pagingSize);
    return await _timesheetsRepo.getTimesheetApproval(content: content);
  }
}
