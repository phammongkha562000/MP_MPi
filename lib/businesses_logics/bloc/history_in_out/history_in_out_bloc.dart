import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

part 'history_in_out_event.dart';
part 'history_in_out_state.dart';

class HistoryInOutBloc extends Bloc<HistoryInOutEvent, HistoryInOutState> {
  final _historyInOutRepo = getIt<HistoryInOutRepository>();

  HistoryInOutBloc() : super(HistoryInOutInitial()) {
    on<HistoryInOutViewLoaded>(_mapViewLoadedToState);
    on<HistoryInOutChangeDate>(_mapChangeDateToState);
    on<HistoryInOutPickDate>(_mapPickDateToState);
  }
  Future<void> _mapViewLoadedToState(HistoryInOutViewLoaded event, emit) async {
    emit(HistoryInOutLoading());
    try {
      final submitDateF = DateTime.now();
      ApiResult apiResult = await _getHistory(submitDateF: submitDateF);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(HistoryInOutFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }

      ApiResponse apiHistory = apiResult.data;
      if (apiHistory.success == false || apiHistory.error.errorCode != null) {
        emit(HistoryInOutFailure(message: apiHistory.error.errorMessage));
        return;
      }
      List<HistoryInOutResponse> inOutList =
          _getInOutList(historyList: apiHistory.payload);
      emit(HistoryInOutSuccess(
          historyList: inOutList, date: submitDateF, isLoading: false));
    } catch (e) {
      emit(const HistoryInOutFailure(message: MyError.messError));
    }
  }

  Future<void> _mapChangeDateToState(HistoryInOutChangeDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is HistoryInOutSuccess) {
        emit(currentState.copyWith(isLoading: true));
        final submitDateF = event.typeDate == 0
            ? currentState.date.subtract(const Duration(days: 1))
            : currentState.date.add(const Duration(days: 1));

        ApiResult apiGetHistory = await _getHistory(submitDateF: submitDateF);
        if (apiGetHistory.isFailure) {
          Error? error = apiGetHistory.getErrorResponse();
          emit(HistoryInOutFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiHistory = apiGetHistory.data;
        if (apiHistory.success == false || apiHistory.error.errorCode != null) {
          emit(HistoryInOutFailure(message: apiHistory.error.errorMessage));
          return;
        }
        List<HistoryInOutResponse> inOutList =
            _getInOutList(historyList: apiHistory.payload);

        emit(currentState.copyWith(
            historyList: inOutList, date: submitDateF, isLoading: false));
      }
    } catch (e) {
      emit(const HistoryInOutFailure(message: MyError.messError));
    }
  }

  Future<void> _mapPickDateToState(HistoryInOutPickDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is HistoryInOutSuccess) {
        emit(currentState.copyWith(isLoading: true));

        final submitDateF = event.date;

        ApiResult apiGetHistory = await _getHistory(submitDateF: submitDateF);
        if (apiGetHistory.isFailure) {
          Error? error = apiGetHistory.getErrorResponse();
          emit(HistoryInOutFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiHistory = apiGetHistory.data;
        if (apiHistory.success == false) {
          emit(HistoryInOutFailure(message: apiHistory.error.errorMessage));
          return;
        }

        List<HistoryInOutResponse> inOutList =
            _getInOutList(historyList: apiHistory.payload);

        emit(currentState.copyWith(
            historyList: inOutList, date: submitDateF, isLoading: false));
      }
    } catch (e) {
      emit(const HistoryInOutFailure(message: MyError.messError));
    }
  }

  Future<ApiResult<ApiResponse>> _getHistory({
    required DateTime submitDateF,
  }) async {
    final content = HistoryInOutRequest(
        employeeId: globalUser.getEmployeeId,
        submitDateF:
            submitDateF.toString().split(' ').first.replaceAll('-', '/'));
    return await _historyInOutRepo.getHistoryInOut(content: content);
  }

  List<HistoryInOutResponse> _getInOutList(
      {required List<HistoryInOutResponse> historyList}) {
    final inOutList = historyList.where((e) => e.type != ' ').toList();
    return inOutList;
  }
}
