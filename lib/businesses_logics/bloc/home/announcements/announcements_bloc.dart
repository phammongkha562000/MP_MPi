import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  AnnouncementsBloc() : super(AnnouncementsInitial()) {
    on<AnnouncementsLoaded>(_mapViewToState);
  }
  Future<void> _mapViewToState(AnnouncementsLoaded event, emit) async {
    emit(AnnouncementsLoading());
    try {
      emit(AnnouncementsSuccess(
          announcementsPayload: event.announcementsPayload));
    } catch (e) {
      emit(AnnouncementsFailure(message: e.toString()));
    }
  }
}
