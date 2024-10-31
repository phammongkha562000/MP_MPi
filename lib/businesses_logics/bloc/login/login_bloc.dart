import 'dart:async';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/businesses_logics/config/server_config.dart';
import 'package:r_get_ip/r_get_ip.dart';
import '../../../data/data.dart';
import '../../application_bloc/app_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginViewLoaded>(_mapViewToState);
    on<LoginOnPressed>(_mapOnPressToState);
    on<LoginRemember>(_mapRememberToState);
    on<LoginChooseServer>(_mapChooseServerToState);
    on<ValidateLogin>(_mapValidateToState);
    on<LoginChangeLang>(_mapChangeLangToState);
    on<LoginWithBiometrics>(_mapLoginBiometricsToState);
  }

  Future<void> _mapViewToState(LoginViewLoaded event, emit) async {
    try {
      emit(LoginLoading());
      final sharedPref = await SharedPreferencesService.instance;

      if (event.isLogOut == true) {
        for (var element in SharedPrefKeys.listKey) {
          sharedPref.remove(element);
        }
      }
      String biometrics = await LocalAuthHelper.checkBiometrics();

      if (biometrics == BiometricsHelper.notBiometrics) {
        sharedPref.setIsBiometrics(false);
        sharedPref.setIsAllowBiometrics(false);
      } else {
        sharedPref.setIsBiometrics(true);
      }

      final remember = sharedPref.remember ?? false;
      final username = remember ? sharedPref.username ?? '' : '';
      final password = remember ? sharedPref.password ?? '' : '';
      final serverMode = remember
          ? sharedPref.serverMode ?? ServerMode.prod.toString()
          : ServerMode.prod.toString();

      emit(LoginLoadedSuccess(
        showPassword: true,
        isRemember: remember,
        serverMode: serverMode,
        userName: username,
        password: password,
        versionClient: globalApp.getVersion,
        biometrics: biometrics,
        isAllowBiometrics: sharedPref.isAllowBiometrics ?? false,
      ));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }

  Future<void> _mapOnPressToState(LoginOnPressed event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadedSuccess) {
        emit(LoginLoading());
        var defaultAccount =
            DefaultAccount(username: "ADMIN", password: "123456");
        final sharedPref = await SharedPreferencesService.instance;

        final username = event.username.trim();
        final password = event.password.trim();

        ServerInfo serverInfo;
        if (username == defaultAccount.username) {
          serverInfo = await ServerConfig.getAddressServerInfo(
              ServerMode.dev.toString());
          sharedPref.setServerMode(ServerMode.dev.toString());
        } else {
          serverInfo =
              await ServerConfig.getAddressServerInfo(event.serverMode);
          sharedPref.setServerMode(event.serverMode.toString());
        }

        final externalIP = await RGetIp.externalIP;

        final apiResultLogin = await DataBoxHelper.getToken(
          svSSO: serverInfo.sso.toString(),
          username: username,
          password: password,
          externalIP: externalIP ?? '',
          serverMode: event.serverMode,
        );

        if (apiResultLogin.isFailure) {
          Error error = apiResultLogin.getErrorLogin();
          emit(LoginFailure(
              message: error.errorMessage ?? '', errorCode: error.errorCode));
          emit(currentState.copyWith(
              userName: event.username,
              password: event.password,
              isRemember: event.remember,
              serverMode: event.serverMode));
          return;
        }
        TokenResponse tokenResponse = apiResultLogin.data;
        event.appBloc.tokenResponse = tokenResponse;
        if (tokenResponse.asVersion != globalApp.getVersion) {
          emit(LoginFailure(
            message: MyError.errVersionOld,
            errorCode: MyError.errCodeOldVersion,
            serverMode: event.serverMode,
          ));
          return;
        }
        sharedPref.setServerSSO(serverInfo.sso.toString());
        sharedPref.setServerHub(serverInfo.serverHub.toString());
        sharedPref.setRemember(event.remember);
        sharedPref.setUsername(event.username);
        sharedPref.setPassword(event.password);
        globalApp.setIsLogin = true;

        emit(LoginSuccessfully(
            lastVersion: event.appBloc.tokenResponse?.asVersion,
            serverMode: event.serverMode,
            isUseDefaultPass: event.appBloc.tokenResponse?.asUseDefaultPass));
        var location = await LocationHelper.getLatitudeAndLongitude();
        final lat = location[0].toString();
        final lon = location[1].toString();
        sharedPref.setLatLocation(lat);
        sharedPref.setLonLocation(lon);
        //tạm thời
        sharedPref.setIsCheckVersion(false);
      }
    } on DioException catch (e) {
      if (e.error == DioExceptionType.connectionTimeout) {
        emit(const LoginFailure(message: 'Connect timeout'));
        return;
      }
      emit(LoginFailure(message: e.toString()));
    }
  }

  Future<void> _mapChooseServerToState(LoginChooseServer event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadedSuccess) {
        emit(LoginLoading());
        final sharedPref = await SharedPreferencesService.instance;
        sharedPref.setServerMode(event.serverMode);
        emit(currentState.copyWith(
          isRemember: event.remember,
          userName: event.username,
          password: event.password,
          serverMode: event.serverMode,
        ));
      }
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }

  Future<void> _mapRememberToState(LoginRemember event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadedSuccess) {
        emit(currentState.copyWith(
          isRemember: event.remember,
          userName: event.username,
          serverMode: event.serverMode,
          password: event.password,
          showPassword: event.showPassword,
        ));
      }
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }

  Future<void> _mapValidateToState(ValidateLogin event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadedSuccess) {
        emit(LoginLoading());
        if (event.userName == true || event.passWord == true) {
          emit(currentState.copyWith(
            isRemember: false,
          ));
        } else {
          emit(currentState);
        }
      }
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }

  Future<void> _mapChangeLangToState(LoginChangeLang event, emit) async {
    try {
      final currentState = state;
      if (currentState is LoginLoadedSuccess) {
        emit(LoginLoading());
        String lang = "";
        if (event.langChange == LanguageHelper.en) {
          lang = LanguageHelper.vi;
        } else {
          lang = LanguageHelper.en;
        }
        emit(currentState.copyWith(
          userName: event.username,
          password: event.password,
          serverMode: event.serverMode,
          isRemember: event.remember,
          langChange: lang,
        ));
      }
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }

  Future<void> _mapLoginBiometricsToState(
      LoginWithBiometrics event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;

      final currentState = state;
      if (currentState is LoginLoadedSuccess) {
        if (sharedPref.isAllowBiometrics == true) {
          if (sharedPref.username == null ||
              sharedPref.password == null ||
              sharedPref.username == "" ||
              sharedPref.password == "") {
            emit(LoginFailure(
              message: MyError.errInitLogin,
              errorCode: MyError.errCodeInitLogin,
            ));
          } else {
            if (event.userName != sharedPref.username &&
                event.userName.isNotEmpty) {
              sharedPref.setRemember(false);
              sharedPref.setIsAllowBiometrics(false);
              emit(const LoginFailure(
                message: MyError.errFirstAccLoginWithBiometrics,
              ));
              return;
            }

            int check = await LocalAuthHelper.isAuthenticated();

            if (check == BiometricsHelper.authenticateSuccess) {
              add(LoginOnPressed(
                appBloc: event.appBloc,
                remember: sharedPref.remember ?? false,
                username: sharedPref.username!,
                password: sharedPref.password!,
                serverMode: sharedPref.serverMode ?? ServerMode.prod.toString(),
                showPassword: false,
              ));
            } else if (check == BiometricsHelper.cancelAuthenticate) {
              emit(currentState);
            } else {
              sharedPref.setRemember(false);
              sharedPref.setIsAllowBiometrics(false);

              emit(const LoginFailure(
                message: MyError.errBiometrics,
                errorCode: MyError.errCodeBiometrics,
              ));
            }
          }
        } else {
          emit(LoginFailure(
            message: MyError.errInitLogin,
            errorCode: MyError.errCodeInitLogin,
          ));
        }
      }
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}

class ErrorLogin {
  ErrorLogin({
    this.error,
    this.errorDescription,
  });

  String? error;
  String? errorDescription;

  factory ErrorLogin.fromMap(Map<String, dynamic> json) => ErrorLogin(
        error: json["error"],
        errorDescription: json["error_description"],
      );
}

class DefaultAccount {
  final String username;
  final String password;
  DefaultAccount({
    required this.username,
    required this.password,
  });
}
