part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class GetWifiEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class LogOut extends AppEvent {
  @override
  List<Object> get props => [];
}

class LoginToHub extends AppEvent {
  final String token;
  const LoginToHub({required this.token});
  @override
  List<Object?> get props => [];
}
