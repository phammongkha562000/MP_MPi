part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginViewLoaded extends LoginEvent {
  final bool? isLogOut;
  final bool? checkAnotherDevice;
  final String? defaultServerMode;
  final String? errRefresh;
  const LoginViewLoaded(
      {this.checkAnotherDevice,
      this.defaultServerMode,
      this.errRefresh,
      this.isLogOut});

  @override
  List<Object?> get props =>
      [checkAnotherDevice, defaultServerMode, errRefresh, isLogOut];
}

class ValidateLogin extends LoginEvent {
  final bool? userName;
  final bool? passWord;
  const ValidateLogin({this.userName, this.passWord});
  @override
  List<Object?> get props => [userName, passWord];
}

class LoginOnPressed extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final bool showPassword;
  final AppBloc appBloc;
  const LoginOnPressed(
      {required this.remember,
      required this.username,
      required this.password,
      required this.serverMode,
      required this.showPassword,
      required this.appBloc});
  @override
  List<Object> get props =>
      [username, password, serverMode, remember, showPassword, appBloc];
}

class LoginRemember extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final bool showPassword;

  const LoginRemember(
      {required this.remember,
      required this.username,
      required this.password,
      required this.serverMode,
      required this.showPassword});
  @override
  List<Object> get props =>
      [remember, username, password, serverMode, showPassword];
}

class LoginChooseServer extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  const LoginChooseServer(
      {required this.remember,
      required this.username,
      required this.password,
      required this.serverMode});

  @override
  List<Object> get props => [remember, username, password, serverMode];
}

class LoginChangeLang extends LoginEvent {
  final bool remember;
  final String username;
  final String password;
  final String serverMode;
  final String langChange;
  const LoginChangeLang({
    required this.remember,
    required this.username,
    required this.password,
    required this.serverMode,
    required this.langChange,
  });
  @override
  List<Object> get props =>
      [remember, username, password, serverMode, langChange];
}

class LoginWithBiometrics extends LoginEvent {
  final String userName;
  final String password;
  final AppBloc appBloc;
  const LoginWithBiometrics(
      {required this.userName, required this.password, required this.appBloc});
  @override
  List<Object?> get props => [userName, password, appBloc];
}
