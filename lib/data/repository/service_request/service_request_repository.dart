import 'package:dio/dio.dart';
import 'package:mpi_new/businesses_logics/api/endpoints.dart';
import 'package:mpi_new/data/data.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:sprintf/sprintf.dart';

import '../../../businesses_logics/config/server_config.dart';
import '../../models/notifications/notifications_model.dart';

abstract class AbstractServiceRequestRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> postServiceRequest(
      {required ServiceRequestRequest content});

  Future<ApiResult<ApiResponse>> getApplication();
  Future<ApiResult<ApiResponse>> getDivisions();
  Future<ApiResult<ApiResponse>> postCreateServiceRequests(
      AddServiceRequestRequest content);

  Future<ApiResult<ApiResponse>> getServiceRequestDetail(
      {required String svrNo, required int employeeId});
  Future<ApiResult<ApiResponse>> getServiceRequestDocument(
      {required String svrNo, required String type});
  Future<ApiResult> postServiceRequestUpFile({required FileSend content});
  Future<ApiResult> getServiceDocument({required int docNo});

  Future<ApiResult<ApiResponse>> postServicePending(
      {required ServiceApprovalRequest content});
  Future<ApiResult<ApiResponse>> postSaveServiceApproval(
      {required SaveServiceApprovalRequest content});
  Future<ApiResult> loginToHub({required NotificationsModel model});
  Future<ApiResult> logoutFromHub({required NotificationsModel model});
}

class ServiceRequestRepository implements AbstractServiceRequestRepository {
  AbstractDioHttpClient client;
  ServiceRequestRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getApplication() async {
    try {
      final request = ModelRequest(Endpoint.getApplications);
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data:
                ApiResponse.fromJson(api, endpoint: Endpoint.getApplications));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getDivisions() async {
    try {
      final request = ModelRequest(Endpoint.getDivisions);
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getDivisions));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> postCreateServiceRequests(
      AddServiceRequestRequest content) async {
    try {
      final request = ModelRequest(Endpoint.postCreateServiceRequests,
          body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postCreateServiceRequests));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> postServiceRequest(
      {required ServiceRequestRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.postServiceRequests, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postServiceRequests));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getServiceRequestDetail(
      {required String svrNo, required int employeeId}) async {
    try {
      final request = ModelRequest(
          sprintf(Endpoint.getServiceRequestDetail, [svrNo, employeeId]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getServiceRequestDetail));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getServiceRequestDocument(
      {required String svrNo, required String type}) async {
    try {
      final request = ModelRequest(
          sprintf(Endpoint.getDocumentServiceRequest, [type, svrNo]));
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getDocumentServiceRequest));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult> postServiceRequestUpFile(
      {required FileSend content}) async {
    try {
      final request =
          ModelRequest(Endpoint.postDocumentService, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postDocumentService));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult> getServiceDocument({required int docNo}) async {
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

  @override
  Future<ApiResult<ApiResponse>> postServicePending(
      {required ServiceApprovalRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.postServiceApprovals, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postServiceApprovals));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> postSaveServiceApproval(
      {required SaveServiceApprovalRequest content}) async {
    try {
      final request = ModelRequest(Endpoint.postSaveServiceApproval,
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postSaveServiceApproval));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult> loginToHub({required NotificationsModel model}) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverMode);
      String startUrl = serverInfo.serverHub.toString();
      BaseOptions options =
          BaseOptions(baseUrl: "$startUrl${Endpoint.loginHub}", method: "POST");
      Dio dio = Dio(options);
      String path = "$startUrl${Endpoint.loginHub}";
      final loginToHub = await dio.post(path,
          data: model, options: Options(contentType: Headers.jsonContentType));

      if (loginToHub.statusCode == 200) {
        return ApiResult.success(data: "");
      } else {
        return ApiResult.fail(error: loginToHub);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult> logoutFromHub({required NotificationsModel model}) async {
    try {
      final sharedPref = await SharedPreferencesService.instance;
      ServerInfo serverInfo =
          await ServerConfig.getAddressServerInfo(sharedPref.serverMode);
      String startUrl = serverInfo.serverHub.toString();
      BaseOptions options = BaseOptions(
          baseUrl: "$startUrl${Endpoint.logoutHub}", method: "POST");
      Dio dio = Dio(options);
      String path = "$startUrl${Endpoint.logoutHub}";
      final loginToHub = await dio.post(path,
          data: model, options: Options(contentType: Headers.jsonContentType));

      if (loginToHub.statusCode == 200) {
        return ApiResult.success(data: "");
      } else {
        return ApiResult.fail(error: loginToHub);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
