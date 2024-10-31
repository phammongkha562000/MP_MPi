import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractClockInOutRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getcoworklocs();
  Future<ApiResult<ApiResponse>> validationLocation({
    required ValidationLocationRequest content,
  });
  Future<ApiResult<ApiResponse>> postCheckInOut(
      {required ClockInOutRequest content});
}

class ClockInOutRepository implements AbstractClockInOutRepository {
  AbstractDioHttpClient client;
  ClockInOutRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getcoworklocs() async {
    try {
      final request = ModelRequest(Endpoint.getcoworklocs);
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getcoworklocs));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> validationLocation({
    required ValidationLocationRequest content,
  }) async {
    try {
      final request =
          ModelRequest(Endpoint.validationLocation, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.validationLocation));
      } else {
        return ApiResult.fail(
          error: api,
        );
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> postCheckInOut(
      {required ClockInOutRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.postCheckInOut, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.postCheckInOut));
      } else {
        return ApiResult.fail(
          error: Error.fromJson(Error(
                  errorCode:
                      api.response == null ? 0 : api.response!.statusCode,
                  errorMessage: api.response!.data)
              .toJson()),
        );
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
