part of 'timesheets_bloc.dart';

abstract class TimesheetsState extends Equatable {
  const TimesheetsState();

  @override
  List<Object?> get props => [];
}

class TimesheetsInitial extends TimesheetsState {}

class TimesheetsLoading extends TimesheetsState {}

class TimesheetsPagingLoading extends TimesheetsState {}

class TimesheetsSuccess extends TimesheetsState {
  final List<TimesheetResult> timesheetsList;
  final DateTime fromDate;
  final DateTime toDate;
  final int quantity;
  final bool isLoading;
  final bool isPagingLoading;
  const TimesheetsSuccess(
      {required this.timesheetsList,
      required this.fromDate,
      required this.toDate,
      required this.quantity,
      required this.isLoading,
      required this.isPagingLoading});
  @override
  List<Object?> get props =>
      [timesheetsList, fromDate, toDate, quantity, isLoading, isPagingLoading];

  TimesheetsSuccess copyWith(
      {List<TimesheetResult>? timesheetsList,
      DateTime? fromDate,
      DateTime? toDate,
      int? quantity,
      bool? isLoading,
      bool? isPagingLoading}) {
    return TimesheetsSuccess(
        timesheetsList: timesheetsList ?? this.timesheetsList,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        quantity: quantity ?? this.quantity,
        isPagingLoading: isPagingLoading ?? this.isPagingLoading,
        isLoading: isLoading ?? this.isLoading);
  }
}

class TimesheetsFailure extends TimesheetsState {
  final String message;
  final int? errorCode;
  const TimesheetsFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
