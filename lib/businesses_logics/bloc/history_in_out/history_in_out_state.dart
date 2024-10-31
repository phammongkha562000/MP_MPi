part of 'history_in_out_bloc.dart';

abstract class HistoryInOutState extends Equatable {
  const HistoryInOutState();

  @override
  List<Object?> get props => [];
}

class HistoryInOutInitial extends HistoryInOutState {}

class HistoryInOutLoading extends HistoryInOutState {}

class HistoryInOutSuccess extends HistoryInOutState {
  final DateTime date;
  final List<HistoryInOutResponse> historyList;
  final bool isLoading;
  const HistoryInOutSuccess(
      {required this.historyList, required this.date, required this.isLoading});
  @override
  List<Object> get props => [historyList, date, isLoading];

  HistoryInOutSuccess copyWith(
      {List<HistoryInOutResponse>? historyList,
      DateTime? date,
      bool? isLoading}) {
    return HistoryInOutSuccess(
      historyList: historyList ?? this.historyList,
      date: date ?? this.date,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HistoryInOutFailure extends HistoryInOutState {
  final String message;
  final int? errorCode;
  const HistoryInOutFailure({required this.message, this.errorCode});
  @override
  List<Object?> get props => [message, errorCode];
}
