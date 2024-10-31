import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/services/navigator/import_generate.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordViewLoaded>(_mapViewLoadedToState);
  }
  Future<void> _mapViewLoadedToState(
      ForgotPasswordViewLoaded event, emit) async {
    emit(ForgotPasswordLoading());
    try {
      String url = '';
      final sharedPref = await SharedPreferencesService.instance;
      final serverMode = sharedPref.serverMode;
      final username = event.username;
      url = serverMode == MyConstants.dev
          ? 'https://dev.mpi.mplogistics.vn:9099/login/forgotpassword?username=$username'
          : serverMode == MyConstants.prod
              ? 'https://mpi.mplogistics.vn/login/forgotpassword?username=$username'
              : 'https://qa.mpi.mplogistics.vn:8088/login/forgotpassword?username=$username';
      emit(ForgotPasswordSuccess(url: url));
    } catch (e) {
      emit(ForgotPasswordFailure(message: e.toString()));
    }
  }
}
