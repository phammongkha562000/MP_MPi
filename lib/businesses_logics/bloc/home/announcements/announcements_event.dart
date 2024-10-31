part of 'announcements_bloc.dart';

abstract class AnnouncementsEvent extends Equatable {
  const AnnouncementsEvent();

  @override
  List<Object?> get props => [];
}

class AnnouncementsLoaded extends AnnouncementsEvent {
  final AnnouncementsResponse announcementsPayload;
  const AnnouncementsLoaded({required this.announcementsPayload});
  @override
  List<Object?> get props => [announcementsPayload];
}
