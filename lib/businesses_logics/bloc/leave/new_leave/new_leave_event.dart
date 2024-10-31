part of 'new_leave_bloc.dart';

abstract class NewLeaveEvent extends Equatable {
  const NewLeaveEvent();

  @override
  List<Object?> get props => [];
}

class NewLeaveLoaded extends NewLeaveEvent {
  final AppBloc appBloc;

  const NewLeaveLoaded({
    required this.appBloc,
  });
  @override
  List<Object?> get props => [appBloc];
}

class NewLeaveChangeFromDate extends NewLeaveEvent {
  final String divisionCode;

  final DateTime fromDate;

  const NewLeaveChangeFromDate({
    required this.divisionCode,
    required this.fromDate,
  });
  @override
  List<Object?> get props => [fromDate, divisionCode];
}

class NewLeaveChangeToDate extends NewLeaveEvent {
  final String divisionCode;
  final DateTime toDate;

  const NewLeaveChangeToDate({
    required this.divisionCode,
    required this.toDate,
  });
  @override
  List<Object?> get props => [toDate, divisionCode];
}

class NewLeaveChangeTypeLeave extends NewLeaveEvent {
  final StdCode typeLeave;
  final String phoneNumber;
  const NewLeaveChangeTypeLeave(
      {required this.typeLeave, required this.phoneNumber});
  @override
  List<Object?> get props => [typeLeave, phoneNumber];
}

class NewLeaveChangeSesionType extends NewLeaveEvent {
  final SessionType sessionType;
  final String divisionCode;
  const NewLeaveChangeSesionType({
    required this.sessionType,
    required this.divisionCode,
  });
  @override
  List<Object?> get props => [sessionType, divisionCode];
}

class NewLeaveUploadImage extends NewLeaveEvent {
  final String pathImg;
  const NewLeaveUploadImage({
    required this.pathImg,
  });
  @override
  List<Object?> get props => [pathImg];
}

class NewLeaveSubmit extends NewLeaveEvent {
  final String remark;

  const NewLeaveSubmit({required this.remark});
  @override
  List<Object?> get props => [remark];
}
