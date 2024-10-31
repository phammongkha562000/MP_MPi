import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../application_bloc/app_bloc.dart';

part 'leave_approval_state.dart';
part 'leave_approval_event.dart';

class LeaveApprovalBloc extends Bloc<LeaveApprovalEvent, LeaveApprovalState> {
  final _leaveRepo = getIt<LeaveRepository>();
  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<LeaveApprovalResult> leaveApprLst = [];
  LeaveApprovalBloc() : super(LeaveApprovalInitial()) {
    on<LeaveApprovalViewLoaded>(_mapViewLoadedToState);
    on<LeaveApprovalChangeDate>(_mapChangeDateToState);
    on<LeaveApprovalChangeType>(_mapChangeTypeToState);
    on<LeaveApproveSelected>(_mapApproveSelectedToState);
    on<LeaveSelected>(_mapSelectedToState);
    on<LeaveSelectedAll>(_mapSelectedAllToState);
    on<LeaveApprovalPaging>(_mapPagingToState);
  }
  Future<void> _mapViewLoadedToState(
      LeaveApprovalViewLoaded event, emit) async {
    emit(LeaveApprovalLoading());
    try {
      leaveApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;
      final StdCode stdFirst = StdCode(codeDesc: 'all'.tr(), codeId: '');

      //loaded init lấy từ ngày hôm nay về 1 tháng trước
      final fromDate = event.fromDate ??
          DateTime(DateTime.now().year, DateTime.now().month - 1,
              DateTime.now().day);
      final toDate = event.toDate ?? DateTime.now();
      final submitDateF = event.fromDate == null
          ? DateFormat(MyConstants.yyyyMMdd).format(DateTime(
              DateTime.now().year,
              DateTime.now().month - 1,
              DateTime.now().day))
          : DateFormat(MyConstants.yyyyMMdd).format(event.fromDate ??
              DateTime(DateTime.now().year, DateTime.now().month - 1,
                  DateTime.now().day));
      final submitDateT = event.toDate == null
          ? DateFormat(MyConstants.yyyyMMdd).format(DateTime.now())
          : DateFormat(MyConstants.yyyyMMdd)
              .format(event.toDate ?? DateTime.now());
      final content = LeaveApprovalRequest(
          leaveType: '',
          submitDateF: submitDateF,
          submitDateT: submitDateT,
          status: '',
          userId: globalUser.employeeId ?? 0,
          pageNumber: 1,
          rowNumber: MyConstants.pagingSize);
      //std type
      List<StdCode> stdCodeHrList = [stdFirst];
      if (event.appBloc.listStdCodeHr.isEmpty) {
        final getSrStatus = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeHr,
        );
        if (getSrStatus is ApiResult) {
          if (getSrStatus.isFailure) {
            Error? error = getSrStatus.getErrorResponse();
            emit(LeaveApprovalFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listStdCodeHr = getSrStatus;
        stdCodeHrList.addAll(getSrStatus);
      } else {
        stdCodeHrList.addAll(event.appBloc.listStdCodeHr);
      }

      //std status
      List<StdCode> stdStatusList = [stdFirst];

      if (event.appBloc.listStdStatus.isEmpty) {
        final getStatusList = await event.appBloc.getStdCodeWithType(
          type: TypeStdCode.typeDOCGENSTATUSTSPOSTTYPE,
        );
        if (getStatusList is ApiResult) {
          if (getStatusList.isFailure) {
            Error? error = getStatusList.getErrorResponse();
            emit(LeaveApprovalFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
        }
        event.appBloc.listStdStatus = getStatusList;
        stdStatusList.addAll(getStatusList);
      } else {
        stdStatusList.addAll(event.appBloc.listStdStatus);
      }

      //get approval api
      ApiResult apiResult =
          await _leaveRepo.postLeaveApproval(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(LeaveApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiLeaveApproval = apiResult.data;
      if (apiLeaveApproval.success == false ||
          apiLeaveApproval.error.errorCode != null) {
        emit(
            LeaveApprovalFailure(message: apiLeaveApproval.error.errorMessage));
        return;
      }

      LeaveApprovalResponse leaveApprRes = apiLeaveApproval.payload;
      List<LeaveApprovalResult> leaveApprovalList = leaveApprRes.result ?? [];
      //filter pending -- load init isPending true
      List<LeaveApprovalResult> leaveApprovalListPending =
          _getLeaveApprovalPending(list: leaveApprovalList, isPending: true);
      leaveApprLst.addAll(leaveApprovalListPending);
      quantity = leaveApprovalListPending.length;
      emit(LeaveApprovalSuccess(
          leaveApprovalList: leaveApprovalList,
          leaveApprovalListPending: leaveApprovalListPending,
          leaveStatusList: stdStatusList,
          leaveTypeList: stdCodeHrList,
          fromDate: fromDate,
          toDate: toDate,
          isPending: true));
    } catch (e) {
      //
    }
  }

  Future<void> _mapChangeDateToState(
      LeaveApprovalChangeDate event, emit) async {
    try {
      emit(LeaveApprovalLoading());
      leaveApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;

      final fromDate = event.fromDate;
      final toDate = event.toDate;

      //nếu event không truyền fromDate, toDate thì dùng currentState
      final firstDay = FindDate.convertDateyyyyMMdd(today: event.fromDate);
      final lastDay = FindDate.convertDateyyyyMMdd(today: event.toDate);

      final content = LeaveApprovalRequest(
          leaveType: event.stdType != null ? event.stdType!.codeId : '',
          status: event.stdStatus != null ? event.stdStatus!.codeId : '',
          submitDateF: firstDay,
          submitDateT: lastDay,
          userId: globalUser.employeeId ?? 0,
          pageNumber: pageNumber,
          rowNumber: MyConstants.pagingSize);
      ApiResult apiResult =
          await _leaveRepo.postLeaveApproval(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(LeaveApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiLeaveApproval = apiResult.data;
      if (apiLeaveApproval.success == false ||
          apiLeaveApproval.error.errorCode != null) {
        emit(
            LeaveApprovalFailure(message: apiLeaveApproval.error.errorMessage));
        return;
      }

      LeaveApprovalResponse leaveApprRes = apiLeaveApproval.payload;
      List<LeaveApprovalResult> leaveApprovalList = leaveApprRes.result ?? [];
      List<LeaveApprovalResult> leaveApprovalListPending =
          _getLeaveApprovalPending(
              list: leaveApprovalList, isPending: event.isPending);
      leaveApprLst.addAll(leaveApprovalListPending);
      quantity = leaveApprovalListPending.length;
      emit(GetLeaveApprovalSuccessful(
          fromDate: fromDate,
          leaveApprovalListPending: leaveApprovalListPending,
          toDate: toDate,
          isSelectAll: false));

      // }
    } catch (e) {
      emit(const LeaveApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapChangeTypeToState(
      LeaveApprovalChangeType event, emit) async {
    try {
      emit(LeaveApprovalLoading());
      leaveApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;

      final firstDay = FindDate.convertDateyyyyMMdd(today: event.fromDate);
      final lastDay = FindDate.convertDateyyyyMMdd(today: event.toDate);

      //lấy từ: event!= null ? event : currentState!= null? currentState : ''
      final leaveTypeId =
          event.stdType != null ? (event.stdType!.codeId ?? '') : '';
      final leaveStatusId =
          event.stdStatus != null ? (event.stdStatus!.codeId ?? '') : '';

      final content = LeaveApprovalRequest(
          leaveType: leaveTypeId,
          status: leaveStatusId,
          submitDateF: firstDay,
          submitDateT: lastDay,
          userId: globalUser.employeeId ?? 0,
          pageNumber: pageNumber,
          rowNumber: MyConstants.pagingSize);
      ApiResult apiResult =
          await _leaveRepo.postLeaveApproval(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(LeaveApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiLeaveApproval = apiResult.data;
      if (apiLeaveApproval.success == false ||
          apiLeaveApproval.error.errorCode != null) {
        emit(
            LeaveApprovalFailure(message: apiLeaveApproval.error.errorMessage));
        return;
      }

      LeaveApprovalResponse leaveApprRes = apiLeaveApproval.payload;
      List<LeaveApprovalResult> leaveApprovalList = leaveApprRes.result ?? [];
      List<LeaveApprovalResult> leaveApprovalListPending =
          _getLeaveApprovalPending(
              list: leaveApprovalList, isPending: event.isPending);
      leaveApprLst.addAll(leaveApprovalListPending);
      quantity = leaveApprovalListPending.length;
      emit(GetLeaveApprovalSuccessful(
          fromDate: event.fromDate,
          leaveApprovalListPending: leaveApprovalListPending,
          toDate: event.toDate,
          isSelectAll: false));
    } catch (e) {
      emit(const LeaveApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapApproveSelectedToState(
      LeaveApproveSelected event, emit) async {
    try {
      emit(LeaveApprovalLoading());
      leaveApprLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;

      final listSelected = event.leaveApprovalListPending
          .where((element) => element.selected == true)
          .toList();
      for (var element in listSelected) {
        final content = SaveLeaveApprovalRequest(
            comment: event.comment,
            approvalType: 'Approved',
            existedUserId: '1',
            userId: globalUser.getEmployeeId,
            hLvNo: element.lvNo ?? '');
        ApiResult apiResult =
            await _leaveRepo.postSaveLeaveApproval(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(LeaveApprovalFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiUpdate = apiResult.data;
        if (apiUpdate.success == false || apiUpdate.error.errorCode != null) {
          emit(LeaveApprovalFailure(message: apiUpdate.error.errorMessage));
          return;
        }
      }
      final firstDay = DateFormat(MyConstants.yyyyMMdd).format(event.fromDate);

      final lastDay = DateFormat(MyConstants.yyyyMMdd).format(event.toDate);
      final content = LeaveApprovalRequest(
          leaveType: '',
          submitDateF: firstDay,
          submitDateT: lastDay,
          status: '',
          userId: globalUser.employeeId ?? 0,
          pageNumber: pageNumber,
          rowNumber: MyConstants.pagingSize);
      //get approval api
      ApiResult apiResult =
          await _leaveRepo.postLeaveApproval(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(LeaveApprovalFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiLeaveApproval = apiResult.data;
      if (apiLeaveApproval.success == false ||
          apiLeaveApproval.error.errorCode != null) {
        emit(
            LeaveApprovalFailure(message: apiLeaveApproval.error.errorMessage));
        return;
      }
      LeaveApprovalResponse leaveApprRes = apiLeaveApproval.payload;
      List<LeaveApprovalResult> leaveApprovalList = leaveApprRes.result ?? [];
      //filter pending -- load init isPending true
      List<LeaveApprovalResult> leaveApprovalListPending =
          _getLeaveApprovalPending(list: leaveApprovalList, isPending: true);

      emit(LeaveApprovalSaveSuccessful());
      emit(LeaveApprovalSelectedSuccess(
          leaveApprovalList: leaveApprovalList,
          leaveApprovalListPending: leaveApprovalListPending));
    } catch (e) {
      emit(const LeaveApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapSelectedToState(LeaveSelected event, emit) async {
    try {
      emit(LeaveApprovalLoading());

      final listSelected = event.leaveApprovalListPending
          .map((e) =>
              e.lvNo == event.lvNo ? e.copyWith(selected: event.selected) : e)
          .toList();
      final isSelectedAll =
          listSelected.where((element) => element.selected == false).isNotEmpty
              ? false
              : true;

      emit(SelectLeaveApprovalSuccess(
          leaveApprovalListPending: listSelected, isSelectAll: isSelectedAll));
      /*  } */
    } catch (e) {
      emit(const LeaveApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapSelectedAllToState(LeaveSelectedAll event, emit) async {
    try {
      emit(LeaveApprovalLoading());

      final listSelected = event.leaveApprovalListPending
          .map((e) => event.isSelectAll
              ? e.copyWith(selected: true)
              : e.copyWith(selected: false))
          .toList();
      emit(SelectLeaveApprovalSuccess(
          leaveApprovalListPending: listSelected,
          isSelectAll: event.isSelectAll));
      /*  } */
      // }
    } catch (e) {
      emit(const LeaveApprovalFailure(message: MyError.messError));
    }
  }

  Future<void> _mapPagingToState(LeaveApprovalPaging event, emit) async {
    try {
      if (endPage == false) {
        emit(LeaveApprovalPagingLoading());
        pageNumber++;
        final firstDay = FindDate.convertDateyyyyMMdd(today: event.fromDate);
        final lastDay = FindDate.convertDateyyyyMMdd(today: event.toDate);

        //lấy từ: event!= null ? event : currentState!= null? currentState : ''
        final leaveTypeId =
            event.stdType != null ? (event.stdType!.codeId ?? '') : '';
        final leaveStatusId =
            event.stdStatus != null ? (event.stdStatus!.codeId ?? '') : '';

        final content = LeaveApprovalRequest(
            leaveType: leaveTypeId,
            status: leaveStatusId,
            submitDateF: firstDay,
            submitDateT: lastDay,
            userId: globalUser.employeeId ?? 0,
            pageNumber: pageNumber,
            rowNumber: MyConstants.pagingSize);
        ApiResult apiResult =
            await _leaveRepo.postLeaveApproval(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(LeaveApprovalFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiLeaveApproval = apiResult.data;
        if (apiLeaveApproval.success == false ||
            apiLeaveApproval.error.errorCode != null) {
          emit(LeaveApprovalFailure(
              message: apiLeaveApproval.error.errorMessage));
          return;
        }

        LeaveApprovalResponse leaveApprRes = apiLeaveApproval.payload;
        List<LeaveApprovalResult> leaveApprovalList = leaveApprRes.result ?? [];
        List<LeaveApprovalResult> leaveApprovalListPending =
            _getLeaveApprovalPending(
                list: leaveApprovalList, isPending: event.isPending);
        if (leaveApprovalListPending.isNotEmpty &&
            leaveApprovalListPending != []) {
          leaveApprLst.addAll(leaveApprovalListPending);
          quantity = leaveApprLst.length;
        } else {
          endPage = true;
        }
        emit(LeaveApprovalPagingSuccess(
          leaveApprovalListPending: leaveApprLst,
        ));
      }
    } catch (e) {
      emit(LeaveApprovalFailure(message: e.toString()));
    }
  }

  List<LeaveApprovalResult> _getLeaveApprovalPending(
      {required List<LeaveApprovalResult> list, required bool isPending}) {
    return isPending
        ? list
            .where((element) =>
                element.leaveStatusDetail == null &&
                (element.leaveStatus != 'DROP' &&
                    element.leaveStatus != 'CLOS'))
            .toList()
        : list;
  }
}
