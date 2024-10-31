part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class SettingLoaded extends SettingEvent {}

class SwitchBiometrics extends SettingEvent {
  final bool isAllowBiometrics;
  const SwitchBiometrics({
    required this.isAllowBiometrics,
  });
  @override
  List<Object> get props => [isAllowBiometrics];
}
