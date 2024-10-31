import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:sprintf/sprintf.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractITServiceRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getITService(
      {required ItServiceSearchRequest content});
  Future<ApiResult<ApiResponse>> getITServiceDetail({required String irsNo});
  Future<ApiResult<ApiResponse>> getITAdmin({required String value});
  Future<ApiResult<ApiResponse>> replyITServiceDetail(
      {required ItServiceReplyRequest content});
  Future<ApiResult<ApiResponse>> createNewITService(
      {required CreateNewITServiceRequest content});
  Future<ApiResult> getITServiceDocument({required int docNo});
}

class ITServiceRepository implements AbstractITServiceRepository {
  AbstractDioHttpClient client;
  ITServiceRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getITService(
      {required ItServiceSearchRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.getITServiceSearch, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getITServiceSearch));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getITServiceDetail(
      {required String irsNo}) async {
    try {
      final request =
          ModelRequest(sprintf(Endpoint.getITServiceDetail, [irsNo]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getITServiceDetail));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getITAdmin({
    required String value,
  }) async {
    try {
      final request = ModelRequest(sprintf(Endpoint.getITAdmin, [value]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getITAdmin));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> replyITServiceDetail(
      {required ItServiceReplyRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.replyITServiceDetail, body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.replyITServiceDetail));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> createNewITService(
      {required CreateNewITServiceRequest content}) async {
    try {
      final request = ModelRequest(Endpoint.createITServiceRequests,
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.createITServiceRequests));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult> getITServiceDocument({required int docNo}) async {
    try {
      final request =
          ModelRequest(sprintf(Endpoint.getDocumentService, [docNo]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getDocumentService));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
