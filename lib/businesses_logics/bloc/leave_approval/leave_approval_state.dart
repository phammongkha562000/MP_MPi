part of 'leave_approval_bloc.dart';

abstract class LeaveApprovalState extends Equatable {
  const LeaveApprovalState();

  @override
  List<Object?> get props => [];
}

class LeaveApprovalInitial extends LeaveApprovalState {}

class LeaveApprovalLoading extends LeaveApprovalState {}

class LeaveApprovalSuccess extends LeaveApprovalState {
  final List<LeaveApprovalResult> leaveApprovalList;
  final List<LeaveApprovalResult> leaveApprovalListPending;
  final List<StdCode> leaveTypeList;
  final List<StdCode> leaveStatusList;
  final DateTime fromDate;
  final DateTime toDate;
  final StdCode? typeLeave;
  final StdCode? statusLeave;
  final bool isPending;
  const LeaveApprovalSuccess({
    required this.leaveApprovalList,
    required this.leaveApprovalListPending,
    required this.leaveTypeList,
    required this.leaveStatusList,
    required this.fromDate,
    required this.toDate,
    this.typeLeave,
    this.statusLeave,
    required this.isPending,
  });
  @override
  List<Object?> get props => [
        leaveApprovalList,
        leaveApprovalListPending,
        fromDate,
        toDate,
        leaveTypeList,
        leaveStatusList,
        statusLeave,
        typeLeave,
        isPending,
      ];

  LeaveApprovalSuccess copyWith({
    List<LeaveApprovalResult>? leaveApprovalList,
    List<LeaveApprovalResult>? leaveApprovalListPending,
    List<StdCode>? leaveTypeList,
    List<StdCode>? leaveStatusList,
    DateTime? fromDate,
    DateTime? toDate,
    StdCode? typeLeave,
    StdCode? statusLeave,
    bool? isPending,
  }) {
    return LeaveApprovalSuccess(
      leaveApprovalList: leaveApprovalList ?? this.leaveApprovalList,
      leaveApprovalListPending:
          leaveApprovalListPending ?? this.leaveApprovalListPending,
      leaveTypeList: leaveTypeList ?? this.leaveTypeList,
      leaveStatusList: leaveStatusList ?? this.leaveStatusList,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      typeLeave: typeLeave ?? this.typeLeave,
      statusLeave: statusLeave ?? this.statusLeave,
      isPending: isPending ?? this.isPending,
    );
  }
}

class LeaveApprovalFailure extends LeaveApprovalState {
  final String message;
  final int? errorCode;
  const LeaveApprovalFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}

class LeaveApprovalSaveSuccessful extends LeaveApprovalState {}

class GetLeaveApprovalSuccessful extends LeaveApprovalState {
  final List<LeaveApprovalResult> leaveApprovalListPending;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isSelectAll;

  const GetLeaveApprovalSuccessful(
      {required this.leaveApprovalListPending,
      required this.fromDate,
      required this.toDate,
      required this.isSelectAll});
  @override
  List<Object?> get props =>
      [leaveApprovalListPending, fromDate, toDate, isSelectAll];
}

class SelectLeaveApprovalSuccess extends LeaveApprovalState {
  final List<LeaveApprovalResult> leaveApprovalListPending;
  final bool isSelectAll;

  const SelectLeaveApprovalSuccess(
      {required this.leaveApprovalListPending, required this.isSelectAll});
  @override
  List<Object?> get props => [leaveApprovalListPending, isSelectAll];
}

class LeaveApprovalSelectedSuccess extends LeaveApprovalState {
  final List<LeaveApprovalResult> leaveApprovalList;
  final List<LeaveApprovalResult> leaveApprovalListPending;

  const LeaveApprovalSelectedSuccess(
      {required this.leaveApprovalList,
      required this.leaveApprovalListPending});

  @override
  List<Object?> get props => [leaveApprovalListPending, leaveApprovalList];
}

class LeaveApprovalPagingLoading extends LeaveApprovalState {}

class LeaveApprovalPagingSuccess extends LeaveApprovalState {
  final List<LeaveApprovalResult> leaveApprovalListPending;

  const LeaveApprovalPagingSuccess({required this.leaveApprovalListPending});
  @override
  List<Object?> get props => [leaveApprovalListPending];
}
