part of 'leave_bloc.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object?> get props => [];
}

class LeaveLoaded extends LeaveEvent {
  final DateTime date;
  const LeaveLoaded({required this.date});
  @override
  List<Object?> get props => [date];
}

class LeaveChangeMonth extends LeaveEvent {
  final int typeMonth;

  const LeaveChangeMonth({required this.typeMonth});
  @override
  List<Object> get props => [typeMonth];
}

class LeavePickMonth extends LeaveEvent {
  final DateTime date;
  const LeavePickMonth({required this.date});
  @override
  List<Object> get props => [date];
}

class LeavePaging extends LeaveEvent {
  final DateTime date;
  const LeavePaging({required this.date});
  @override
  List<Object?> get props => [date];
}
