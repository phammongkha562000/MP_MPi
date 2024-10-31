part of 'timesheets_detail_bloc.dart';

abstract class TimesheetsDetailState extends Equatable {
  const TimesheetsDetailState();

  @override
  List<Object?> get props => [];
}

class TimesheetsDetailInitial extends TimesheetsDetailState {}

class TimesheetsDetailLoading extends TimesheetsDetailState {}

class TimesheetsDetailSuccess extends TimesheetsDetailState {
  final String name;
  final int employeeId;
  final List<StdCode> stdCodeList;
  final bool updateSuccess;
  final TimesheetResult timesheetsItem;
  const TimesheetsDetailSuccess(
      {required this.name,
      required this.stdCodeList,
      required this.employeeId,
      required this.updateSuccess,
      required this.timesheetsItem});

  @override
  List<Object?> get props =>
      [name, stdCodeList, employeeId, updateSuccess, timesheetsItem];

  TimesheetsDetailSuccess copyWith(
      {String? name,
      List<StdCode>? stdCodeList,
      bool? updateSuccess,
      int? employeeId,
      TimesheetResult? timesheetsItem}) {
    return TimesheetsDetailSuccess(
      name: name ?? this.name,
      stdCodeList: stdCodeList ?? this.stdCodeList,
      employeeId: employeeId ?? this.employeeId,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      timesheetsItem: timesheetsItem ?? this.timesheetsItem,
    );
  }
}

class TimesheetsDetailFailure extends TimesheetsDetailState {
  final String message;
  final int? errorCode;
  const TimesheetsDetailFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
