part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoadedSuccess extends LoginState {
  final String? serverMode;
  final String? userName;
  final String? password;
  // * SHOW PASS: TRUE= 0 SHOW; FALSE = show
  final bool? showPassword;
  final bool? isRemember;
  final String? versionClient;
  final String? versionRelease;
  final String? langChange;
  final bool? isAllowBiometrics;

  final String? biometrics;

  const LoginLoadedSuccess({
    this.serverMode,
    this.userName,
    this.password,
    this.showPassword,
    this.isRemember,
    this.versionClient,
    this.versionRelease,
    this.langChange,
    this.isAllowBiometrics,
    this.biometrics,
  });

  LoginLoadedSuccess copyWith({
    String? serverMode,
    String? userName,
    String? password,
    bool? showPassword,
    bool? isRemember,
    String? versionClient,
    String? versionRelease,
    String? langChange,
    bool? isAllowBiometrics,
    String? biometrics,
  }) {
    return LoginLoadedSuccess(
      serverMode: serverMode ?? this.serverMode,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      isRemember: isRemember ?? this.isRemember,
      versionClient: versionClient ?? this.versionClient,
      versionRelease: versionRelease ?? this.versionRelease,
      langChange: langChange ?? this.langChange,
      isAllowBiometrics: isAllowBiometrics ?? this.isAllowBiometrics,
      biometrics: biometrics ?? this.biometrics,
    );
  }

  @override
  List<Object?> get props => [
        serverMode,
        userName,
        password,
        showPassword,
        isRemember,
        versionRelease,
        versionClient,
        langChange,
      ];
}

class LoginSuccessfully extends LoginState {
  final String? lastVersion;
  final String? serverMode;
  final String? isUseDefaultPass;
  const LoginSuccessfully({
    this.lastVersion,
    this.serverMode,
    this.isUseDefaultPass,
  });

  @override
  List<Object?> get props => [lastVersion, serverMode, isUseDefaultPass];
}

class LoginFailure extends LoginState {
  final String message;
  final int? errorCode;
  final String? serverMode;
  const LoginFailure({
    required this.message,
    this.errorCode,
    this.serverMode,
  });
  @override
  List<Object?> get props => [message, errorCode, serverMode];
}

class LoginRememberState extends LoginState {
  final bool isRemember;

  const LoginRememberState({
    required this.isRemember,
  });
  @override
  List<Object?> get props => [isRemember];
}
