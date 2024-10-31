part of 'leave_detail_bloc.dart';

abstract class LeaveDetailEvent extends Equatable {
  const LeaveDetailEvent();

  @override
  List<Object?> get props => [];
}

class LeaveDetailLoaded extends LeaveDetailEvent {
  final String lvNo;
  const LeaveDetailLoaded({
    required this.lvNo,
  });
  @override
  List<Object> get props => [lvNo];
}

class SaveLeaveApproval extends LeaveDetailEvent {
  final String comment;
  final String approvalType;

  final String hLvNo;
  const SaveLeaveApproval({
    required this.comment,
    required this.approvalType,
    required this.hLvNo,
  });
  @override
  List<Object?> get props => [comment, approvalType, hLvNo];
}
