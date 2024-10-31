import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

part 'booking_meeting_event.dart';
part 'booking_meeting_state.dart';

class BookingMeetingBloc
    extends Bloc<BookingMeetingEvent, BookingMeetingState> {
  final _bookingMeetingRepo = getIt<BookingMeetingRepository>();
  BookingMeetingBloc() : super(BookingMeetingInitial()) {
    on<BookingMeetingViewLoaded>(_mapViewLoadedToState);
    on<BookingMeetingChangeDate>(_mapChangeDateToState);
    on<BookingMeetingDelete>(_mapDeleteToState);
  }
  Future<void> _mapViewLoadedToState(
      BookingMeetingViewLoaded event, emit) async {
    emit(BookingMeetingLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final date = DateFormat(MyConstants.yyyyMMdd).format(event.date);
      final content = BookingMeetingRequest(
          userId: globalUser.employeeId ?? 0,
          bookDateF: date,
          bookDateT: date,
          facilityCode: '',
          facilityGroup: MyConstants.facilityGroup,
          subsidiaryId: sharedPref.subsidiaryId ?? '');
      ApiResult apiResult =
          await _bookingMeetingRepo.getBooking(content: content);
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();
        emit(BookingMeetingFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(BookingMeetingFailure(message: apiResponse.error.errorMessage));
        return;
      }
      emit(BookingMeetingSuccess(
          bookList: apiResponse.payload, date: event.date, isLoading: false));
    } catch (e) {
      emit(BookingMeetingFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeDateToState(
      BookingMeetingChangeDate event, emit) async {
    try {
      final currentState = state;
      if (currentState is BookingMeetingSuccess) {
        emit(currentState.copyWith(isLoading: true));
        final sharedPref = await SharedPreferencesService.instance;

        final date = DateFormat(MyConstants.yyyyMMdd).format(event.date);
        final content = BookingMeetingRequest(
            userId: globalUser.employeeId ?? 0,
            bookDateF: date,
            bookDateT: date,
            facilityCode: '',
            facilityGroup: MyConstants.facilityGroup,
            subsidiaryId: sharedPref.subsidiaryId ?? '');
        ApiResult apiResult =
            await _bookingMeetingRepo.getBooking(content: content);
        if (apiResult.isFailure) {
          Error error = apiResult.getErrorResponse();
          emit(BookingMeetingFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(BookingMeetingFailure(message: apiResponse.error.errorMessage));
          return;
        }
        final List<BookingMeetingResponse> bookList = apiResponse.payload;
        emit(currentState.copyWith(bookList: bookList, isLoading: false));
      }
    } catch (e) {
      emit(BookingMeetingFailure(message: e.toString()));
    }
  }

  Future<void> _mapDeleteToState(BookingMeetingDelete event, emit) async {
    try {
      final apiDelete = await _bookingMeetingRepo.deleteBooking(
          fbId: event.fbId, userId: globalUser.employeeId!);
      if (apiDelete.isFailure) {
        Error error = apiDelete.getErrorResponse();
        emit(BookingMeetingFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      if (apiDelete.data!.payload != true) {
        emit(
            BookingMeetingFailure(message: apiDelete.data?.error.errorMessage));
        return;
      }
      emit(BookingMeetingDeleteSuccess());
    } catch (e) {
      emit(BookingMeetingFailure(message: e.toString()));
    }
  }
}
