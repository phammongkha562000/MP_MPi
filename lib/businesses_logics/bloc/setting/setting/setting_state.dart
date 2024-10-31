part of 'setting_bloc.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoadSuccess extends SettingState {
  final bool isBiometrics;
  final bool isAllowBiometrics;
  const SettingLoadSuccess({
    required this.isBiometrics,
    required this.isAllowBiometrics,
  });
  @override
  List<Object?> get props => [isAllowBiometrics, isBiometrics];

  SettingLoadSuccess copyWith({
    bool? isBiometrics,
    bool? isAllowBiometrics,
  }) {
    return SettingLoadSuccess(
      isBiometrics: isBiometrics ?? this.isBiometrics,
      isAllowBiometrics: isAllowBiometrics ?? this.isAllowBiometrics,
    );
  }
}

class SettingLoadFailure extends SettingState {
  final String message;
  final int? errorCode;
  const SettingLoadFailure({
    required this.message,
    this.errorCode,
  });
  @override
  List<Object?> get props => [message, errorCode];
}
