import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/businesses_logics/application_bloc/app_bloc.dart';
import 'package:mpi_new/data/data.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AddInterceptor>(_addInterceptor);
  }

  Future<void> _addInterceptor(AddInterceptor event, emit) async {
    getIt<AbstractDioHttpClient>().addInterceptor(InterceptorsWrapper(
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (e, handler) async {
        if (e.response!.statusCode == 400) {
          return dialogToLogin(text: MyError.errMess400.tr());
        }
        if (e.response != null &&
                e.response!.data.toString().contains("ERR002") ||
            e.response!.data.toString().contains("ERR001")) {
          final repoLogin = getIt<LoginRepository>();
          RequestOptions requestOptions = e.requestOptions;
          try {
            var refreshRes = await repoLogin.refreshToken(event.appBloc);
            if (refreshRes.success == true) {
              log('Refresh Token success');
              event.appBloc.tokenResponse?.accessToken =
                  refreshRes.data?.accessToken ?? '';
              event.appBloc.tokenResponse?.refreshToken =
                  refreshRes.data?.refreshToken ?? '';
              globalServer.setToken = refreshRes.data?.accessToken ?? '';
              globalServer.setRefreshToken =
                  refreshRes.data?.refreshToken ?? '';
              final opts = Options(
                method: requestOptions.method,
                headers: {
                  'Authorization': "Bearer ${globalServer.token}",
                  "Content-Type": "application/json"
                },
              );
              var response = await Dio().request(
                  options: opts,
                  "${requestOptions.baseUrl}${requestOptions.path}",
                  data: requestOptions.data,
                  cancelToken: requestOptions.cancelToken,
                  onReceiveProgress: requestOptions.onReceiveProgress,
                  queryParameters: requestOptions.queryParameters);
              if (response.statusCode == 200) {
                handler.resolve(response);
              } else {
                handler.next(e);
              }
              return;
            }
            return dialogToLogin();
          } catch (e) {
            log(e.toString());
          }
        }
        return handler.next(e);
      },
    ));
  }

  dialogToLogin({String? text}) {
    final navigationService = getIt<NavigationService>();

    return MyDialog.showError(
      context: navigationService.navigatorKey.currentContext!,
      messageError: text ?? "token_expired".tr(),
      pressTryAgain: () {
        Navigator.pop(
          navigationService.navigatorKey.currentContext!,
        );
        BlocProvider.of<AppBloc>(navigationService.navigatorKey.currentContext!)
            .add(LogOut());
        navigationService.pushNamed(MyRoute.loginViewRoute,
            args: {KeyParams.isLogout: true});
      },
    );
  }
}
