part of 'announcements_bloc.dart';

abstract class AnnouncementsState extends Equatable {
  const AnnouncementsState();

  @override
  List<Object?> get props => [];
}

class AnnouncementsInitial extends AnnouncementsState {}

class AnnouncementsLoading extends AnnouncementsState {}

class AnnouncementsSuccess extends AnnouncementsState {
  final AnnouncementsResponse announcementsPayload;
  const AnnouncementsSuccess({
    required this.announcementsPayload,
  });
  @override
  List<Object?> get props => [announcementsPayload];
}

class AnnouncementsFailure extends AnnouncementsState {
  final String message;
  final int? errorCode;
  const AnnouncementsFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
