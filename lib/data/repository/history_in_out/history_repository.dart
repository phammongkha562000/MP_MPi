import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractHistoryInOutRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getHistoryInOut({
    required HistoryInOutRequest content,
  });
}

class HistoryInOutRepository implements AbstractHistoryInOutRepository {
  AbstractDioHttpClient client;
  HistoryInOutRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getHistoryInOut(
      {required HistoryInOutRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.getHistoryInOut, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data:
                ApiResponse.fromJson(api, endpoint: Endpoint.getHistoryInOut));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
