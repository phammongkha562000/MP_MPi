part of 'timesheets_bloc.dart';

abstract class TimesheetsEvent extends Equatable {
  const TimesheetsEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetsViewLoaded extends TimesheetsEvent {
  final DateTime? fromDate;
  final DateTime? toDate;
  const TimesheetsViewLoaded({
    this.fromDate,
    this.toDate,
  });
  @override
  List<Object?> get props => [fromDate, toDate];
}

class TimesheetsChangeDate extends TimesheetsEvent {
  final DateTime? fromDate;
  final DateTime? toDate;
  const TimesheetsChangeDate({
    this.fromDate,
    this.toDate,
  });
  @override
  List<Object?> get props => [fromDate, toDate];
}

class TimesheetsPaging extends TimesheetsEvent {}
