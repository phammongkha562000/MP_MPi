part of 'timesheet_approval_bloc.dart';

abstract class TimesheetApprovalEvent extends Equatable {
  const TimesheetApprovalEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetApprovalViewLoaded extends TimesheetApprovalEvent {
  final DateTime? fromDate;
  final DateTime? toDate;
  final AppBloc appBloc;
  const TimesheetApprovalViewLoaded(
      {this.fromDate, this.toDate, required this.appBloc});
  @override
  List<Object?> get props => [fromDate, toDate, appBloc];
}

class TimesheetApprovalChangeDate extends TimesheetApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final String statusCode;

  @override
  List<Object?> get props => [statusCode, fromDate, toDate];

  const TimesheetApprovalChangeDate(
      {required this.fromDate, required this.toDate, required this.statusCode});
}

class TimesheetSelected extends TimesheetApprovalEvent {
  final int tsId;
  final bool selected;
  final List<TimesheetApprovalResult> timesheetApprList;
  const TimesheetSelected(
      {required this.tsId,
      required this.selected,
      required this.timesheetApprList});
  @override
  List<Object?> get props => [tsId, selected, timesheetApprList];

  TimesheetSelected copyWith(
      {int? tsId,
      bool? selected,
      List<TimesheetApprovalResult>? timesheetApprList}) {
    return TimesheetSelected(
        tsId: tsId ?? this.tsId,
        selected: selected ?? this.selected,
        timesheetApprList: timesheetApprList ?? this.timesheetApprList);
  }
}

class TimesheetSelectedAll extends TimesheetApprovalEvent {
  final bool isSelectAll;
  final List<TimesheetApprovalResult> timesheetApprList;
  const TimesheetSelectedAll(
      {required this.isSelectAll, required this.timesheetApprList});
  @override
  List<Object?> get props => [isSelectAll, timesheetApprList];
}

class TimesheetApproveSelected extends TimesheetApprovalEvent {
  final String comment;
  final List<TimesheetApprovalResult> timesheetApprList;
  final DateTime fromDate;
  final DateTime toDate;
  final String statusCode;
  const TimesheetApproveSelected(
      {required this.comment,
      required this.timesheetApprList,
      required this.fromDate,
      required this.toDate,
      required this.statusCode});
  @override
  List<Object?> get props =>
      [comment, timesheetApprList, statusCode, fromDate, toDate];
}

class TimesheetChangeStatus extends TimesheetApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final String statusCode;
  final List<StdCode> statusList;

  @override
  List<Object?> get props => [statusCode, fromDate, toDate, statusList];

  const TimesheetChangeStatus(
      {required this.fromDate,
      required this.toDate,
      required this.statusCode,
      required this.statusList});
}

class TimesheetApprovalSlidable extends TimesheetApprovalEvent {
  final int tsId;
  final String approvalType;
  final String comment;
  const TimesheetApprovalSlidable(
      {required this.tsId, required this.approvalType, required this.comment});
  @override
  List<Object?> get props => [tsId, approvalType, comment];
}

class TimesheetApprovalPaging extends TimesheetApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final String statusCode;

  @override
  List<Object?> get props => [statusCode, fromDate, toDate];

  const TimesheetApprovalPaging(
      {required this.fromDate, required this.toDate, required this.statusCode});
}
