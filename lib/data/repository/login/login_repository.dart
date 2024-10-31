import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mpi_new/businesses_logics/application_bloc/app_bloc.dart';
import 'package:mpi_new/businesses_logics/config/server_config.dart';
import 'package:mpi_new/data/models/login/refresh_token_request.dart';
import 'package:mpi_new/data/models/server/model_request_no_token.dart';
import 'package:sprintf/sprintf.dart';

import 'package:mpi_new/data/data.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../models/login/refresh_token_reponse.dart';
import '../../services/result/api_result.dart';

abstract class AbstractLoginRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getStatussummary(
      {required LeaveListRemainRequest content});
  Future<ApiResult<ApiResponse>> getVersion({required String baseUrl});
  Future<dynamic> getUserProfile(
      {required int id, String? token, String? baseUrl});
  Future<ApiResult<RefreshTokenResponse>> refreshToken(AppBloc apploc);
  Future<ApiResult<ApiResponse>> getSubsidiary({required String subsidiaryId});
  Future<ApiResult<ApiResponse>> getGenerateConfiguration(
      {required String subsidiaryId, required String baseUrl});

  Future<ApiResult<ApiResponse>> getSystemConfiguration(
      {required String subsidiaryId, required String baseUrl});
}

@injectable
class LoginRepository implements AbstractLoginRepository {
  AbstractDioHttpClient client;
  JsonDecoder decoder = const JsonDecoder();

  Dio dio = Dio();

  BaseOptions? baseOptions;
  LoginRepository({required this.client, this.baseOptions});

  @override
  Future<dynamic> getUserProfile(
      {required int id, String? token, String? baseUrl}) async {
    String url = "$baseUrl${sprintf(Endpoint.getUserProfile, [id])}";

    log("URL: $url");
    final request = ModelRequest(sprintf(Endpoint.getUserProfile, [id]));
    final api = await client.getNew(request, (data) => data);
    if (api is! DioException) {
      return ApiResult.success(
          data: ApiResponse.fromJson(api, endpoint: Endpoint.getUserProfile));
    } else {
      return ApiResult.fail(error: api);
    }
  }

  void throwIfNoSuccess(Response response) {
    if (response.statusCode! < 200 || response.statusCode! > 299) {
      log("Network Util ERROR : ${response.realUri}");
      throw HttpException(response.statusMessage ?? "");
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getStatussummary(
      {required LeaveListRemainRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.getStatussummary, body: content.toMap());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data:
                ApiResponse.fromJson(api, endpoint: Endpoint.getStatussummary));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getVersion({required String baseUrl}) async {
    try {
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      final request = ModelRequestNoToken(Endpoint.getVersion);

      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getVersion));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }

  @override
  Future<ApiResult<RefreshTokenResponse>> refreshToken(AppBloc appBloc) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverMode);

      BaseOptions options = BaseOptions(
          baseUrl: "${serverInfo.sso}${Endpoint.apitoken}",
          method: "POST",
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});

      Dio dio = Dio(options);
      RefreshTokenRequest request = RefreshTokenRequest(
          grantType: 'refresh_token',
          refreshToken: globalServer.getRefreshToken,
          clienId: MyConstants.systemIDMB);
      String path = "${serverInfo.sso}${Endpoint.apitoken}";
      var refreshToken = await dio.post(path, data: request.toJson());
      if (refreshToken.statusCode == 200) {
        RefreshTokenResponse refreshTokenRes =
            RefreshTokenResponse.fromJson(refreshToken.data);

        return ApiResult.success(data: refreshTokenRes);
      } else {
        return ApiResult.fail(error: refreshToken.statusMessage);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getSubsidiary(
      {required String subsidiaryId}) async {
    try {
      final request =
          ModelRequest(sprintf(Endpoint.getSubsidiary, [subsidiaryId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getSubsidiary));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getGenerateConfiguration(
      {required String subsidiaryId, required String baseUrl}) async {
    getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
    final request =
        ModelRequest(sprintf(Endpoint.getGenerateConfig, [subsidiaryId]));
    final api = await client.getNew(request, (data) => data);
    if (api is! DioException) {
      return ApiResult.success(
          data:
              ApiResponse.fromJson(api, endpoint: Endpoint.getGenerateConfig));
    } else {
      return ApiResult.fail(error: api);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getSystemConfiguration(
      {required String subsidiaryId, required String baseUrl}) async {
    getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
    final request =
        ModelRequest(sprintf(Endpoint.getSystemConfig, [subsidiaryId]));
    final api = await client.getNew(request, (data) => data);
    if (api is! DioException) {
      return ApiResult.success(
          data: ApiResponse.fromJson(api, endpoint: Endpoint.getSystemConfig));
    } else {
      return ApiResult.fail(error: api);
    }
  }
}
