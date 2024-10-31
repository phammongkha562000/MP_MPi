import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

part 'add_booking_meeting_event.dart';
part 'add_booking_meeting_state.dart';

class AddBookingMeetingBloc
    extends Bloc<AddBookingMeetingEvent, AddBookingMeetingState> {
  final _bookingMeetingRepo = getIt<BookingMeetingRepository>();

  AddBookingMeetingBloc() : super(AddBookingMeetingInitial()) {
    on<AddBookingMeetingViewLoaded>(_mapViewLoadedToState);
    on<AddBookingMeetingPressed>(_mapPressedToState);
  }
  Future<void> _mapViewLoadedToState(
      AddBookingMeetingViewLoaded event, emit) async {
    emit(AddBookingMeetingLoading());
    try {
      ApiResult apiResult = await _bookingMeetingRepo.getFacilities();
      if (apiResult.isFailure) {
        Error error = apiResult.getErrorResponse();

        emit(AddBookingMeetingFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      ApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(AddBookingMeetingFailure(message: apiResponse.error.errorMessage));
        return;
      }
      List<FacilitiesResponse> payLoadList = apiResponse.payload;
      List<FacilitiesResponse> facilitiesList = payLoadList
          .where((e) => e.facilityGroup == MyConstants.facilityGroup)
          .toList();
      emit(AddBookingMeetingSuccess(facilitiesList: facilitiesList));
    } catch (e) {
      emit(AddBookingMeetingFailure(message: e.toString()));
    }
  }

  Future<void> _mapPressedToState(AddBookingMeetingPressed event, emit) async {
    try {
      final currentState = state;
      if (currentState is AddBookingMeetingSuccess) {
        emit(AddBookingMeetingLoading());

        final date1 = DateFormat(MyConstants.yyyyMMddHHmmss).parse(
            '${event.date.toString().split(' ').first} ${event.startDate.hour}:${event.startDate.minute}:00');

        final startBook =
            DateFormat(MyConstants.yyyyMMddHHmmssSlash).format(date1);

        final date2 = DateFormat(MyConstants.yyyyMMddHHmmss).parse(
            '${event.date.toString().split(' ').first} ${event.endDate.hour}:${event.endDate.minute}:00');

        final endBook =
            DateFormat(MyConstants.yyyyMMddHHmmssSlash).format(date2);

        final contentValidate = NewBookingMeetingRequest(
            bookDateStart: startBook,
            bookDateTo: endBook,
            bookMemo: event.memo,
            bookSubject: event.subject,
            createUser: globalUser.employeeId ?? 0,
            facilityCode: event.facilities.facilityCode ?? '',
            id: '0');
        ApiResult apiResultValidate = await _bookingMeetingRepo
            .postBookingValidate(content: contentValidate);
        if (apiResultValidate.isFailure) {
          Error? error = apiResultValidate.getErrorResponse();
          emit(AddBookingMeetingFailure(
              message: error.errorMessage, errorCode: error.errorCode));
          return;
        }
        ApiResponse apiResponseValidate = apiResultValidate.data;
        if (apiResponseValidate.success == false) {
          emit(AddBookingMeetingFailure(
              message: apiResponseValidate.error.errorMessage));
          return;
        }

        List<ValidateBookMeetingResponse> validateList =
            apiResponseValidate.payload ?? [];

        ///check false
        if (validateList != [] && validateList.isNotEmpty) {
          emit(AddBookingMeetingFailure(message: 'meetingroombooked'.tr()));
          emit(currentState.copyWith(saveSuccess: null));
          return;
        } else {
          ApiResult apiResultSave = await _bookingMeetingRepo.postSaveBooking(
              content: contentValidate);
          if (apiResultSave.isFailure) {
            Error error = apiResultSave.getErrorResponse();
            emit(AddBookingMeetingFailure(
                message: error.errorMessage, errorCode: error.errorCode));
            return;
          }
          ApiResponse apiSave = apiResultSave.data;
          if (apiSave.success == false) {
            emit(AddBookingMeetingFailure(message: apiSave.error.errorMessage));
            return;
          }
          if (apiSave.payload != null) {
            emit(AddBookingMeetingFailure(
                message: apiSave.error.errorMessage ?? ''));
            emit(currentState.copyWith(saveSuccess: null));

            return;
          }
          emit(currentState.copyWith(saveSuccess: true));
        }
      }
    } catch (e) {
      emit(AddBookingMeetingFailure(message: e.toString()));
    }
  }
}
