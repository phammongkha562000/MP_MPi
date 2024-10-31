part of 'configuration_bloc.dart';

sealed class ConfigurationEvent extends Equatable {
  const ConfigurationEvent();

  @override
  List<Object> get props => [];
}

class ConfigurationLoaded extends ConfigurationEvent {}
