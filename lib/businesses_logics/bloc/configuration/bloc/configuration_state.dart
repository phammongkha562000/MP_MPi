part of 'configuration_bloc.dart';

sealed class ConfigurationState extends Equatable {
  const ConfigurationState();

  @override
  List<Object> get props => [];
}

final class ConfigurationInitial extends ConfigurationState {}

final class ConfigurationSuccess extends ConfigurationState {
  final ThemeItem currentTheme;

  const ConfigurationSuccess({required this.currentTheme});
  @override
  List<Object> get props => [currentTheme];
}
