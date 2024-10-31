part of 'leave_approval_bloc.dart';

abstract class LeaveApprovalEvent extends Equatable {
  const LeaveApprovalEvent();

  @override
  List<Object?> get props => [];
}

class LeaveApprovalViewLoaded extends LeaveApprovalEvent {
  final DateTime? fromDate;
  final DateTime? toDate;
  final AppBloc appBloc;
  const LeaveApprovalViewLoaded(
      {this.fromDate, this.toDate, required this.appBloc});
  @override
  List<Object?> get props => [fromDate, toDate, appBloc];
}

class LeaveApprovalChangeDate extends LeaveApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final StdCode? stdType;
  final StdCode? stdStatus;
  final bool isPending;

  const LeaveApprovalChangeDate(
      {required this.fromDate,
      required this.toDate,
      this.stdType,
      this.stdStatus,
      required this.isPending});
  @override
  List<Object?> get props => [fromDate, toDate, stdType, stdStatus, isPending];
}

class LeaveApprovalChangeType extends LeaveApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final StdCode? stdType;
  final StdCode? stdStatus;
  final bool isPending;
  const LeaveApprovalChangeType(
      {required this.fromDate,
      required this.toDate,
      this.stdType,
      this.stdStatus,
      required this.isPending});

  @override
  List<Object?> get props => [stdType, stdStatus, isPending, fromDate, toDate];
}

class LeaveApproveSelected extends LeaveApprovalEvent {
  final String comment;
  final DateTime fromDate;
  final DateTime toDate;
  final List<LeaveApprovalResult> leaveApprovalListPending;

  const LeaveApproveSelected(
      {required this.comment,
      required this.fromDate,
      required this.toDate,
      required this.leaveApprovalListPending});
  @override
  List<Object?> get props =>
      [comment, fromDate, toDate, leaveApprovalListPending];
}

class LeaveSelected extends LeaveApprovalEvent {
  final String lvNo;
  final bool selected;
  final List<LeaveApprovalResult> leaveApprovalListPending;
  const LeaveSelected(
      {required this.lvNo,
      required this.selected,
      required this.leaveApprovalListPending});
  @override
  List<Object?> get props => [lvNo, selected, leaveApprovalListPending];
}

class LeaveSelectedAll extends LeaveApprovalEvent {
  final bool isSelectAll;
  final List<LeaveApprovalResult> leaveApprovalListPending;

  const LeaveSelectedAll({
    required this.isSelectAll,
    required this.leaveApprovalListPending,
  });
  @override
  List<Object?> get props => [isSelectAll, leaveApprovalListPending];
}

class LeaveApprovalPaging extends LeaveApprovalEvent {
  final DateTime fromDate;
  final DateTime toDate;
  final StdCode? stdType;
  final StdCode? stdStatus;
  final bool isPending;

  const LeaveApprovalPaging(
      {required this.fromDate,
      required this.toDate,
      this.stdType,
      this.stdStatus,
      required this.isPending});
  @override
  List<Object?> get props => [stdType, stdStatus, isPending, fromDate, toDate];
}
