import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

part 'leave_event.dart';
part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final _leaveRepo = getIt<LeaveRepository>();

  List<LeaveResult> leaveLst = [];
  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;

  LeaveBloc() : super(LeaveInitial()) {
    on<LeaveLoaded>(_mapViewToState);
    on<LeavePaging>(_mapPagingToState);
  }

  Future<void> _mapViewToState(LeaveLoaded event, emit) async {
    try {
      emit(LeaveLoading());
      pageNumber = 1;
      endPage = false;
      leaveLst.clear();
      final today = event.date;
      ApiResult apiResult = await getLeave(date: today);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(LeaveFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(LeaveFailure(message: apiResponse.error.errorMessage));
        return;
      }
      LeavePayload leaveRes = apiResponse.payload;
      List<LeaveResult> listLeave = leaveRes.result ?? [];
      leaveLst.addAll(listLeave);
      quantity = leaveRes.totalRecord ?? 0;
      emit(LeaveLoadSuccess(
          leavePayload: listLeave, date: today, quantity: quantity));
    } catch (e) {
      emit(LeaveFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(LeavePaging event, emit) async {
    try {
      if (quantity == leaveLst.length) {
        endPage = true;
        return;
      }
      if (endPage == false) {
        emit(LeavePagingLoading());
        pageNumber++;
        final apiLeave = await getLeave(date: event.date);
        if (apiLeave.isFailure) {
          Error error = apiLeave.getErrorResponse();
          emit(LeaveFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiRes = apiLeave.data;
        if (apiRes.success == false) {
          emit(LeaveFailure(message: apiRes.error.errorMessage));
          return;
        }
        LeavePayload leaveRes = apiRes.payload;
        List<LeaveResult> listLeave = leaveRes.result ?? [];

        if (listLeave.isNotEmpty && listLeave != []) {
          leaveLst.addAll(listLeave);
        } else {
          endPage = true;
        }
        emit(LeaveLoadSuccess(
            leavePayload: leaveLst, date: event.date, quantity: quantity));
      }
    } catch (e) {
      emit(LeaveFailure(message: e.toString()));
    }
  }

  Future<ApiResult> getLeave({
    required DateTime date,
  }) async {
    final firstDateOfMonthYyyymmdd =
        FindDate.firstDateOfMonth_yyyyMMdd(today: date);
    final lastDateOfMonthYyyymmdd =
        FindDate.lastDateOfMonth_yyyyMMdd(today: date);

    final content = LeaveRequest(
        status: "",
        leaveType: "",
        submitDateF: firstDateOfMonthYyyymmdd,
        submitDateT: lastDateOfMonthYyyymmdd,
        userId: int.parse(globalUser.employeeId.toString()),
        pageNumber: pageNumber,
        rowNumber: MyConstants.pagingSize);
    return await _leaveRepo.getLeave(content: content);
  }
}
