import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/businesses_logics/application_bloc/app_bloc.dart';
import 'package:mpi_new/data/models/change_password/change_password_req.dart';
import 'package:r_get_ip/r_get_ip.dart';

import '../../../data/data.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final _homeRepo = getIt<HomeRepository>();

  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordLoaded>(_mapViewToState);
    on<ChangePasswordSubmit>(_mapChangePassToState);
  }
  void _mapViewToState(ChangePasswordLoaded event, emit) async {
    try {
      emit(ChangePasswordLoading());
      final sharedPref = await SharedPreferencesService.instance;
      emit(ChangePasswordLoadSuccess(oldPass: sharedPref.password ?? ""));
    } catch (e) {
      emit(ChangePasswordFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangePassToState(ChangePasswordSubmit event, emit) async {
    try {
      final currentState = state;
      if (currentState is ChangePasswordLoadSuccess) {
        emit(ChangePasswordLoading());

        final sharedPref = await SharedPreferencesService.instance;
        UserInfo info = event.appBloc.userInfo ?? UserInfo();
        final externalIP = await RGetIp.externalIP;

        try {
          final content = ChangePasswordReq(
              password: event.newPass,
              updateUser: info.employeeId.toString(),
              ipAddress: externalIP ?? '',
              systemId: MyConstants.systemIDMB,
              employeeId: info.employeeId.toString(),
              confirmPassword: event.newPass,
              currentPassword: event.oladPass);
          final changePassResult =
              await _homeRepo.changePassword(changePasswordReq: content);
          if (changePassResult.isSuccess) {
            emit(currentState);
            emit(ChangePasswordSuccessful(
                severMode: sharedPref.serverMode.toString(),
                newPass: event.newPass));
          } else {
            emit(const ChangePasswordFailure(message: "Change pass fail"));
          }
        } catch (e) {
          emit(ChangePasswordFailure(message: e.toString()));
        }
      }
    } catch (e) {
      emit(ChangePasswordFailure(message: e.toString()));
    }
  }
}
