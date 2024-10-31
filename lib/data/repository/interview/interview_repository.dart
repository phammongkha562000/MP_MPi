import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:sprintf/sprintf.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractInterviewRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getInterviewAppr(
      {required InterviewApprovalRequest content});
  Future<ApiResult<ApiResponse>> getSchedulersHecviveeId(
      {required String hecviveeId});
  Future<ApiResult<ApiResponse>> updateInterviewComment(
      {required UpdateInterviewRequest content});
  Future<ApiResult<ApiResponse>> getRecruitInterviewForm(
      {required String hecId});

  Future<ApiResult<ApiResponse>> getDocumentInterview({required String hecvId});
}

class InterviewRepository implements AbstractInterviewRepository {
  AbstractDioHttpClient client;
  InterviewRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getSchedulersHecviveeId(
      {required String hecviveeId}) async {
    try {
      final request =
          ModelRequest(sprintf(Endpoint.getRecruitInterview, [hecviveeId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getRecruitInterview));
      } else {
        return ApiResult.fail(
            error: Error.fromJson(Error(
                    errorCode:
                        api.response == null ? 0 : api.response!.statusCode,
                    errorMessage: api.response!.data)
                .toJson()));
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getRecruitInterviewForm(
      {required String hecId}) async {
    try {
      final request =
          ModelRequest(sprintf(Endpoint.getRecruitInterviewForm, [hecId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getRecruitInterviewForm));
      } else {
        return ApiResult.fail(
            error: Error.fromJson(Error(
                    errorCode:
                        api.response == null ? 0 : api.response!.statusCode,
                    errorMessage: api.response!.data)
                .toJson()));
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }

  @override
  Future<ApiResult<ApiResponse>> updateInterviewComment(
      {required UpdateInterviewRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.recruitCVInterviewee, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.recruitCVInterviewee));
      } else {
        return ApiResult.fail(
            error: Error.fromJson(Error(
                    errorCode:
                        api.response == null ? 0 : api.response!.statusCode,
                    errorMessage: api.response!.data)
                .toJson()));
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getDocumentInterview({
    required String hecvId,
  }) async {
    try {
      final request =
          ModelRequest(sprintf(Endpoint.getDocumentByInterview, [hecvId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getDocumentByInterview));
      } else {
        return ApiResult.fail(
            error: Error.fromJson(Error(
                    errorCode:
                        api.response == null ? 0 : api.response!.statusCode,
                    errorMessage: api.response!.data)
                .toJson()));
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getInterviewAppr(
      {required InterviewApprovalRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.getInterviewApproval, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getInterviewApproval));
      } else {
        return ApiResult.fail(
            error: Error.fromJson(Error(
                    errorCode:
                        api.response == null ? 0 : api.response!.statusCode,
                    errorMessage: api.response!.data)
                .toJson()));
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }
}
