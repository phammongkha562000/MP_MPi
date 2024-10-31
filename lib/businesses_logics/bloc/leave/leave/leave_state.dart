part of 'leave_bloc.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();

  @override
  List<Object?> get props => [];
}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeavePagingLoading extends LeaveState {}

class LeaveLoadSuccess extends LeaveState {
  final DateTime date;
  final List<LeaveResult>? leavePayload;
  final int quantity;
  const LeaveLoadSuccess(
      {required this.date, this.leavePayload, required this.quantity});
  @override
  List<Object?> get props => [leavePayload, date, quantity];
}

class LeaveFailure extends LeaveState {
  final String message;
  final int? errorCode;
  const LeaveFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
