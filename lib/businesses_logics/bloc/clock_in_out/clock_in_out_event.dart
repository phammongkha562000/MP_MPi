part of 'clock_in_out_bloc.dart';

abstract class ClockInOutEvent extends Equatable {
  const ClockInOutEvent();

  @override
  List<Object> get props => [];
}

class ClockInOutViewLoaded extends ClockInOutEvent {
  final AppBloc appBloc;
  const ClockInOutViewLoaded({required this.appBloc});
  @override
  List<Object> get props => [appBloc];
}

class ClockInOutUpdate extends ClockInOutEvent {
  final AppBloc appBloc;

  final int type;
  const ClockInOutUpdate({required this.type, required this.appBloc});
  @override
  List<Object> get props => [type, appBloc];
}

class ClockInOutGetTimesheetToday extends ClockInOutEvent {
  final AppBloc appBloc;
  const ClockInOutGetTimesheetToday({required this.appBloc});
  @override
  List<Object> get props => [appBloc];
}
