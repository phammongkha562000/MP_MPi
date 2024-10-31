import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<SettingLoaded>(_mapViewToState);
    on<SwitchBiometrics>(_mapSwitchBiometricsToState);
  }
  void _mapViewToState(SettingLoaded event, emit) async {
    try {
      emit(SettingLoading());
      final sharedPref = await SharedPreferencesService.instance;
      String biometrics = await LocalAuthHelper.checkBiometrics();
      if (biometrics == BiometricsHelper.notBiometrics) {
        sharedPref.setIsBiometrics(false);
        sharedPref.setIsAllowBiometrics(false);
      } else {
        sharedPref.setIsBiometrics(true);
      }
      emit(SettingLoadSuccess(
        isBiometrics: sharedPref.isBiometrics ?? false,
        isAllowBiometrics: sharedPref.isAllowBiometrics ?? false,
      ));
    } catch (e) {
      emit(SettingLoadFailure(message: e.toString()));
    }
  }

  Future<void> _mapSwitchBiometricsToState(SwitchBiometrics event, emit) async {
    try {
      final currentState = state;
      if (currentState is SettingLoadSuccess) {
        emit(SettingLoading());

        final sharedPref = await SharedPreferencesService.instance;

        sharedPref.setIsAllowBiometrics(event.isAllowBiometrics);
        emit(currentState.copyWith(
            isAllowBiometrics: sharedPref.isAllowBiometrics));
      }
    } catch (e) {
      emit(SettingLoadFailure(message: e.toString()));
    }
  }
}
