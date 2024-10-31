import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/businesses_logics/config/server_config.dart';
import 'package:mpi_new/data/global/global_app.dart';
import 'package:mpi_new/data/models/common/api_response.dart';
import 'package:mpi_new/data/models/configuration/system_response.dart';
import 'package:mpi_new/data/models/configuration/generate_response.dart';
import 'package:mpi_new/data/models/server/server_info.dart';
import 'package:mpi_new/data/repository/login/login_repository.dart';
import 'package:mpi_new/data/services/injection/injection_mpi.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:mpi_new/data/shared/preference/share_pref_service.dart';

part 'configuration_event.dart';
part 'configuration_state.dart';

class ConfigurationBloc extends Bloc<ConfigurationEvent, ConfigurationState> {
  final _repoLogin = getIt<LoginRepository>();
  ConfigurationBloc() : super(ConfigurationInitial()) {
    on<ConfigurationLoaded>(_mapLoadedToState);
  }
  Future<void> _mapLoadedToState(ConfigurationLoaded event, emit) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo = await ServerConfig.getAddressServerInfo(
          sharedPref.serverMode ?? 'DEV');
      ThemeItem currentTheme = ThemeItem();
      final results = await Future.wait([
        _repoLogin.getGenerateConfiguration(
            subsidiaryId: sharedPref.subsidiaryId ?? 'S1',
            baseUrl: serverInfo.sso ?? ''),
        _repoLogin.getSystemConfiguration(
            subsidiaryId: sharedPref.subsidiaryId ?? 'S1',
            baseUrl: serverInfo.sso ?? ''),
      ]);
      ApiResult apiGenerateRes = results[0];

      if (apiGenerateRes.isSuccess) {
        ApiResponse apiRes = apiGenerateRes.data;

        ConfigGenerateResponse themeRes = apiRes.payload;
        ColorThemeResponse colorTheme =
            ColorThemeResponse.fromJson(jsonDecode(themeRes.colortheme!));
        final themeList = colorTheme.themes ?? [];
        for (var element in themeList) {
          if (element.id == colorTheme.currentTheme) {
            currentTheme = element;
          }
        }
        currentTheme = themeList
            .where((element) => element.id == colorTheme.currentTheme)
            .first;
        globalApp.iconLogin = themeRes.ownerlogo;
        globalApp.logoLogin = themeRes.loginlogo;
      }
      ApiResult apiSystemRes = results[1];

      if (apiSystemRes.isSuccess) {
        ApiResponse apiRes = apiSystemRes.data;
        ConfigSystemResponse systemRes = apiRes.payload;
        globalApp.setSystemName = systemRes.systemname;
      }
      emit(ConfigurationSuccess(currentTheme: currentTheme));
    } catch (e) {
      log(e.toString());
    }
  }
}
