part of 'clock_in_out_bloc.dart';

abstract class ClockInOutState extends Equatable {
  const ClockInOutState();

  @override
  List<Object?> get props => [];
}

class ClockInOutInitial extends ClockInOutState {}

class ClockInOutLoading extends ClockInOutState {}

class ClockInOutSuccess extends ClockInOutState {
  final String workingLocation;
  const ClockInOutSuccess({required this.workingLocation});
  @override
  List<Object?> get props => [workingLocation];

  ClockInOutSuccess copyWith({String? workingLocation}) {
    return ClockInOutSuccess(
        workingLocation: workingLocation ?? this.workingLocation);
  }
}

class ClockInOutSuccessfully extends ClockInOutState {
  final String lat;
  final String lon;
  const ClockInOutSuccessfully({required this.lat, required this.lon});
  @override
  List<Object?> get props => [lat, lon];
}

class ClockInOutFailure extends ClockInOutState {
  final String message;
  final int? errorCode;
  const ClockInOutFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
