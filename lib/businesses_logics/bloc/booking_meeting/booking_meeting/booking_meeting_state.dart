part of 'booking_meeting_bloc.dart';

abstract class BookingMeetingState extends Equatable {
  const BookingMeetingState();

  @override
  List<Object?> get props => [];
}

class BookingMeetingInitial extends BookingMeetingState {}

class BookingMeetingLoading extends BookingMeetingState {}

class BookingMeetingSuccess extends BookingMeetingState {
  final DateTime date;
  final List<BookingMeetingResponse> bookList;
  final bool isLoading;
  const BookingMeetingSuccess(
      {required this.bookList, required this.date, required this.isLoading});
  @override
  List<Object> get props => [bookList, date, isLoading];

  BookingMeetingSuccess copyWith(
      {DateTime? date,
      List<BookingMeetingResponse>? bookList,
      bool? isLoading}) {
    return BookingMeetingSuccess(
        date: date ?? this.date,
        bookList: bookList ?? this.bookList,
        isLoading: isLoading ?? this.isLoading);
  }
}

class BookingMeetingFailure extends BookingMeetingState {
  final int? errorCode;
  final String message;
  const BookingMeetingFailure({this.errorCode, required this.message});
  @override
  List<Object?> get props => [errorCode, message];
}

class BookingMeetingDeleteSuccess extends BookingMeetingState {}
