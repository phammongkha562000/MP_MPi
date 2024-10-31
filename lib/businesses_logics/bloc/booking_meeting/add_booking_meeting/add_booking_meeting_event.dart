part of 'add_booking_meeting_bloc.dart';

abstract class AddBookingMeetingEvent extends Equatable {
  const AddBookingMeetingEvent();

  @override
  List<Object> get props => [];
}

class AddBookingMeetingViewLoaded extends AddBookingMeetingEvent {}

class AddBookingMeetingPressed extends AddBookingMeetingEvent {
  final DateTime date;
  final TimeOfDay startDate;
  final TimeOfDay endDate;
  final FacilitiesResponse facilities;
  final String subject;
  final String memo;
  const AddBookingMeetingPressed({
    required this.date,
    required this.startDate,
    required this.endDate,
    required this.facilities,
    required this.subject,
    required this.memo,
  });
  @override
  List<Object> get props =>
      [date, startDate, endDate, facilities, subject, memo];
}
