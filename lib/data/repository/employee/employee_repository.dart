import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractEmployeeRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getEmployee(
      {required EmployeeSearchRequest content});
}

class EmployeeRepository implements AbstractEmployeeRepository {
  AbstractDioHttpClient client;
  EmployeeRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getEmployee(
      {required EmployeeSearchRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.getEmployee, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getEmployee));
       } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
