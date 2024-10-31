part of 'leave_detail_bloc.dart';

abstract class LeaveDetailState extends Equatable {
  const LeaveDetailState();

  @override
  List<Object?> get props => [];
}

class LeaveDetailInitial extends LeaveDetailState {}

class LeaveDetailLoading extends LeaveDetailState {}

class LeaveApprovalSuccessful extends LeaveDetailState {}

class LeaveDetailLoadSuccess extends LeaveDetailState {
  final LeaveDetailPayload leaveDetail;
  const LeaveDetailLoadSuccess({required this.leaveDetail});
  @override
  List<Object?> get props => [leaveDetail];
}

class LeaveDetailFailure extends LeaveDetailState {
  final String message;
  final int? errorCode;
  const LeaveDetailFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
