import 'package:dio/dio.dart';
import 'package:mpi_new/data/models/timesheet_approval/save_timesheet_approval_request.dart';
import 'package:mpi_new/data/models/timesheet_approval/timesheet_approval_request.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractTimesheetsRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getTimesheets(
      {required TimesheetsRequest content});

  Future<ApiResult<ApiResponse>> updateTimesheets(
      {required TimesheetsUpdateRequest content});

//approval
  Future<ApiResult<ApiResponse>> getTimesheetApproval(
      {required TimesheetApprovalRequest content});

  Future<ApiResult<ApiResponse>> saveTimesheetApproval(
      {required SaveTimesheetApprovalRequest content});
}

class TimesheetsRepository implements AbstractTimesheetsRepository {
  AbstractDioHttpClient client;
  TimesheetsRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getTimesheets(
      {required TimesheetsRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.getTimeSheetService, body: content.toJson());
      final api = await client.postNew(request, (data) => data);

      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getTimeSheetService));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> updateTimesheets(
      {required TimesheetsUpdateRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.putTimeSheetService, body: content.toJson());
      final api = await client.putNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.putTimeSheetService));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> getTimesheetApproval(
      {required TimesheetApprovalRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.getTimesheetApproval, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getTimesheetApproval));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }

  @override
  Future<ApiResult<ApiResponse>> saveTimesheetApproval(
      {required SaveTimesheetApprovalRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.saveTimesheetApproval, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.saveTimesheetApproval));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
