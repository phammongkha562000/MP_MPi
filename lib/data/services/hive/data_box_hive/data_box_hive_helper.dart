import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import '../../../../businesses_logics/api/endpoints.dart';
import '../../../data.dart';

class DataBoxHelper {
  static final _clockInOutRepo = getIt<ClockInOutRepository>();

  static Future<ApiResult> getToken({
    required String svSSO,
    required String username,
    required String password,
    required String externalIP,
    required String serverMode,
  }) async {
    try {
      TokenResponse tokenResponse;
      BaseOptions options = BaseOptions(
          baseUrl: "$svSSO${Endpoint.apitoken}",
          receiveTimeout: const Duration(seconds: 2000),
          method: "POST",
          headers: {
            "Accept": "application/json",
          },
          contentType: "application/x-www-form-urlencoded");

      Dio dio = Dio(options);

      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: svSSO.toString()));
      String path = "$svSSO${Endpoint.apitoken}";
      Response login = await dio.post(
        path,
        data: {
          "username": username,
          "password": password,
          "grant_type": "password",
          "client_id": "MB_MPI",
          "ip": externalIP
        },
      );

      if (login.statusCode == 200) {
        tokenResponse = TokenResponse.fromJson(login.data);
        globalServer.setToken = tokenResponse.accessToken.toString();
        globalServer.setRefreshToken = tokenResponse.refreshToken.toString();
        globalServer.setTokenExpires = false;

        return ApiResult.success(data: tokenResponse);
      } else {
        return ApiResult.success(data: TokenResponse(accessToken: null));
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  static Future<dynamic> getWifi() async {
    final apiResult = await _clockInOutRepo.getcoworklocs();
    if (apiResult.isFailure) {
      return apiResult;
    } else {
      ApiResponse apiResponse = apiResult.data!;
      if (apiResponse.payload != null && apiResponse.payload != []) {
        return apiResponse.payload;
      }
    }
  }
}
