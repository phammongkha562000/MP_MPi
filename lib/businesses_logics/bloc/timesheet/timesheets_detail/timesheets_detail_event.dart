part of 'timesheets_detail_bloc.dart';

abstract class TimesheetsDetailEvent extends Equatable {
  const TimesheetsDetailEvent();

  @override
  List<Object> get props => [];
}

class TimesheetsDetailViewLoaded extends TimesheetsDetailEvent {
  final TimesheetResult timesheetsItem;
  final AppBloc appBloc;
  const TimesheetsDetailViewLoaded(
      {required this.timesheetsItem, required this.appBloc});
  @override
  List<Object> get props => [timesheetsItem, appBloc];
}

class TimesheetsDetailUpdate extends TimesheetsDetailEvent {
  final TimesheetsUpdateRequest timesheets;
  final AppBloc appBloc;

  const TimesheetsDetailUpdate(
      {required this.timesheets, required this.appBloc});
  @override
  List<Object> get props => [timesheets, appBloc];
}
