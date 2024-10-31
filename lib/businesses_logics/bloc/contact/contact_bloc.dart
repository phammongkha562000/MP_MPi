import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/models/login/subsidiary_response.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final _loginRepo = getIt<LoginRepository>();
  ContactBloc() : super(ContactInitial()) {
    on<ContactViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(ContactViewLoaded event, emit) async {
    emit(ContactLoading());
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final apiSubsidiary = await _loginRepo.getSubsidiary(
          subsidiaryId: sharedPref.subsidiaryId ?? '');
      log(apiSubsidiary.toString());
      if (apiSubsidiary.isFailure) {
        Error? error = apiSubsidiary.getErrorResponse();
        emit(ContactFailure(
            message: error.errorMessage, errorCode: error.errorCode));
        return;
      }
      if (apiSubsidiary.data?.success != true) {
        emit(ContactFailure(
            message: apiSubsidiary.data?.error.errorMessage,
            errorCode: apiSubsidiary.data?.error.errorCode));
        return;
      }

      emit(ContactSuccess(subsidiaryRes: apiSubsidiary.data?.payload[0]));
    } catch (e) {
      emit(ContactFailure(message: e.toString()));
    }
  }
}
