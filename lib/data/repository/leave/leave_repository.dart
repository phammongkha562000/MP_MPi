import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:sprintf/sprintf.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractLeaveRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getLeave({required LeaveRequest content});
  Future<ApiResult<ApiResponse>> getLeaveDetail({required String lvNo});

  Future<ApiResult<ApiResponse>> checkLeaveWithType(
      {required CheckLeaveRequest content});

  Future<ApiResult<ApiResponse>> createNewLeave(
      {required NewLeaveRequest content});

  Future<ApiResult<ApiResponse>> postLeaveApproval(
      {required LeaveApprovalRequest content});
  Future<ApiResult<ApiResponse>> postSaveLeaveApproval(
      {required SaveLeaveApprovalRequest content});
}

class LeaveRepository implements AbstractLeaveRepository {
  AbstractDioHttpClient client;
  LeaveRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getLeave(
      {required LeaveRequest content}) async {
    try {
      final request = ModelRequest(Endpoint.getLeave, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getLeave));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getLeaveDetail({
    required String lvNo,
  }) async {
    try {
      final request = ModelRequest(sprintf(Endpoint.getLeaveDetail, [lvNo]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getLeaveDetail));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> checkLeaveWithType(
      {required CheckLeaveRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.checkLeaveWithType, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.checkLeaveWithType));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> createNewLeave(
      {required NewLeaveRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.createNewLeave, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.createNewLeave));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> postLeaveApproval(
      {required LeaveApprovalRequest content}) async {
    try {
      final request = ModelRequest(
        Endpoint.postLeaveApprovals,
        body: content.toJson(),
      );
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postLeaveApprovals));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> postSaveLeaveApproval(
      {required SaveLeaveApprovalRequest content}) async {
    try {
      final request = ModelRequest(Endpoint.postUpdateLeaveApproval,
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postUpdateLeaveApproval));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
