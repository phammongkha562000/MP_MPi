part of 'add_booking_meeting_bloc.dart';

abstract class AddBookingMeetingState extends Equatable {
  const AddBookingMeetingState();

  @override
  List<Object?> get props => [];
}

class AddBookingMeetingInitial extends AddBookingMeetingState {}

class AddBookingMeetingLoading extends AddBookingMeetingState {}

class AddBookingMeetingSuccess extends AddBookingMeetingState {
  final List<FacilitiesResponse> facilitiesList;
  final bool? saveSuccess;
  const AddBookingMeetingSuccess(
      {required this.facilitiesList, this.saveSuccess});
  @override
  List<Object?> get props => [facilitiesList, saveSuccess];

  AddBookingMeetingSuccess copyWith(
      {List<FacilitiesResponse>? facilitiesList, bool? saveSuccess}) {
    return AddBookingMeetingSuccess(
        facilitiesList: facilitiesList ?? this.facilitiesList,
        saveSuccess: saveSuccess ?? this.saveSuccess);
  }
}

class AddBookingMeetingFailure extends AddBookingMeetingState {
  final int? errorCode;
  final String message;
  const AddBookingMeetingFailure({
    this.errorCode,
    required this.message,
  });
  @override
  List<Object?> get props => [errorCode, message];
}
