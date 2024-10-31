part of 'history_in_out_bloc.dart';

abstract class HistoryInOutEvent extends Equatable {
  const HistoryInOutEvent();

  @override
  List<Object> get props => [];
}

class HistoryInOutViewLoaded extends HistoryInOutEvent {}

class HistoryInOutChangeDate extends HistoryInOutEvent {
  final int typeDate; //0 là lùi, 1 là tiến
  const HistoryInOutChangeDate({required this.typeDate});
  @override
  List<Object> get props => [typeDate];
}

class HistoryInOutPickDate extends HistoryInOutEvent {
  final DateTime date;
  const HistoryInOutPickDate({required this.date});
  @override
  List<Object> get props => [date];
}
