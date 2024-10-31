import 'package:dio/dio.dart';
import 'package:mpi_new/data/models/change_password/change_password_req.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractHomeRepository implements AbstractRepository {
  Future<ApiResult> getMenu({
    required MenuRequest content,
  });

  Future<ApiResult<ApiResponse>> getGallery();

  Future<ApiResult<ApiResponse>> getAnn(
      {required AnnouncementsRequest content});

  Future<ApiResult> changePassword(
      {required ChangePasswordReq changePasswordReq});
}

class HomeRepository implements AbstractHomeRepository {
  AbstractDioHttpClient client;
  HomeRepository({required this.client});

  @override
  Future<ApiResult> getMenu({
    required MenuRequest content,
  }) async {
    try {
      final request = ModelRequest(
        Endpoint.getMenu,
        body: content.toJson(),
      );
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getMenu));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getAnn({
    required AnnouncementsRequest content,
  }) async {
    try {
      final request = ModelRequest(
        Endpoint.getAnnouncements,
        body: content.toJson(),
      );

      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data:
                ApiResponse.fromJson(api, endpoint: Endpoint.getAnnouncements));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getGallery() async {
    try {
      final request = ModelRequest(
        Endpoint.getGallery,
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getGallery));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult> changePassword({
    required ChangePasswordReq changePasswordReq,
  }) async {
    try {
      final request = ModelRequest(Endpoint.changePassword,
          body: changePasswordReq.toJson());
      final driverChangePass = await client.postNew(request, (data) => data);

      if (driverChangePass is! DioException) {
        return ApiResult.success(data: driverChangePass);
      } else {
        return ApiResult.fail(error: driverChangePass);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
