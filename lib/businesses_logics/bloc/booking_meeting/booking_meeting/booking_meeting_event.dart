part of 'booking_meeting_bloc.dart';

abstract class BookingMeetingEvent extends Equatable {
  const BookingMeetingEvent();

  @override
  List<Object> get props => [];
}

class BookingMeetingViewLoaded extends BookingMeetingEvent {
  final DateTime date;
  const BookingMeetingViewLoaded({required this.date});
  @override
  List<Object> get props => [date];
}

class BookingMeetingChangeDate extends BookingMeetingEvent {
  final DateTime date;
  const BookingMeetingChangeDate({required this.date});
  @override
  List<Object> get props => [date];
}

class BookingMeetingDelete extends BookingMeetingEvent {
  final int fbId;
  const BookingMeetingDelete({required this.fbId});
  @override
  List<Object> get props => [fbId];
}
