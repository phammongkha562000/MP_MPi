part of 'timesheet_approval_bloc.dart';

abstract class TimesheetApprovalState extends Equatable {
  const TimesheetApprovalState();

  @override
  List<Object?> get props => [];
}

class TimesheetApprovalInitial extends TimesheetApprovalState {}

class TimesheetApprovalLoading extends TimesheetApprovalState {}

class TimesheetApprovalPagingLoading extends TimesheetApprovalState {}

class TimesheetApprovalSuccess extends TimesheetApprovalState {
  final DateTime fromDate;
  final DateTime toDate;
  final List<TimesheetApprovalResult> timesheetApprovalList;
  final bool isSelectAll;
  final List<StdCode> statusList;
  final StdCode status;
  final int quantity;

  const TimesheetApprovalSuccess(
      {required this.fromDate,
      required this.toDate,
      required this.timesheetApprovalList,
      required this.isSelectAll,
      required this.statusList,
      required this.status,
      required this.quantity});
  @override
  List<Object?> get props => [
        fromDate,
        toDate,
        timesheetApprovalList,
        isSelectAll,
        statusList,
        status,
        quantity
      ];

  TimesheetApprovalSuccess copyWith(
      {DateTime? fromDate,
      DateTime? toDate,
      List<TimesheetApprovalResult>? timesheetApprovalList,
      List<StdCode>? statusList,
      bool? isSelectAll,
      StdCode? status,
      int? quantity}) {
    return TimesheetApprovalSuccess(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      timesheetApprovalList:
          timesheetApprovalList ?? this.timesheetApprovalList,
      isSelectAll: isSelectAll ?? this.isSelectAll,
      statusList: statusList ?? this.statusList,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
    );
  }
}

class TimesheetApprovalFailure extends TimesheetApprovalState {
  final String message;
  final int? errorCode;
  const TimesheetApprovalFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class TimesheetApprovalSaveSuccessful extends TimesheetApprovalState {}

class GetTimesheetApprovalSuccess extends TimesheetApprovalState {
  final DateTime fromDate;
  final DateTime toDate;
  final List<TimesheetApprovalResult> timesheetApprovalList;
  final bool isSelectAll;
  final int quantity;

  const GetTimesheetApprovalSuccess({
    required this.fromDate,
    required this.toDate,
    required this.timesheetApprovalList,
    required this.isSelectAll,
    required this.quantity,
  });
  @override
  List<Object?> get props =>
      [fromDate, toDate, timesheetApprovalList, isSelectAll, quantity];
}

class ChangeStatusTimesheetApprovalSuccess extends TimesheetApprovalState {
  final List<TimesheetApprovalResult> timesheetApprovalList;
  final StdCode status;
  final int quantity;

  const ChangeStatusTimesheetApprovalSuccess({
    required this.timesheetApprovalList,
    required this.status,
    required this.quantity,
  });
  @override
  List<Object?> get props => [timesheetApprovalList, status, quantity];
}

class SelectTimesheetApprovalSuccess extends TimesheetApprovalState {
  final List<TimesheetApprovalResult> timesheetApprList;
  final bool isSelectAll;

  const SelectTimesheetApprovalSuccess(
      {required this.timesheetApprList, required this.isSelectAll});
  @override
  List<Object?> get props => [timesheetApprList, isSelectAll];
}
