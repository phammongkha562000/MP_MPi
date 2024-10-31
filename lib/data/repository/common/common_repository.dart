import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:sprintf/sprintf.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractCommonRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getStdCodeWithType(
      {required String typeStdCode});

  Future<ApiResult<ApiResponse>> getWorkFlow(
      {required WorkFlowRequest content});
}

class CommonRepository implements AbstractCommonRepository {
  AbstractDioHttpClient client;
  CommonRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getStdCodeWithType(
      {required String typeStdCode}) async {
    try {
      final request = ModelRequest(sprintf(Endpoint.getStdcode, [typeStdCode]));
      final api = await client.getNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getStdcode));
      } else {
        return ApiResult.fail(
          error: api,
        );
        
      }
    } catch (e) {
      return ApiResult.fail(
        error: Error.fromJson(Error(errorMessage: e).toJson()),
      );
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getWorkFlow({
    required WorkFlowRequest content,
  }) async {
    try {
      final request = ModelRequest(
        Endpoint.getWorkFlow,
        body: content.toJson(),
      );
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getWorkFlow));
      } else {
        return ApiResult.fail(
          error: api,
        );
        
      }
    } catch (e) {
      return ApiResult.fail(
        error: Error.fromJson(Error(errorMessage: e).toJson()),
      );
    }
  }
}
