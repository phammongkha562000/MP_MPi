import 'package:dio/dio.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:sprintf/sprintf.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractBookingMeetingRepository implements AbstractRepository {
  Future<ApiResult<ApiResponse>> getFacilities();

  Future<ApiResult<ApiResponse>> getBooking(
      {required BookingMeetingRequest content});
  Future<ApiResult<ApiResponse>> postBookingValidate(
      {required NewBookingMeetingRequest content});
  Future<ApiResult<ApiResponse>> postSaveBooking(
      {required NewBookingMeetingRequest content});

  Future<ApiResult<ApiResponse>> deleteBooking(
      {required int fbId, required int userId});
}

class BookingMeetingRepository implements AbstractBookingMeetingRepository {
  AbstractDioHttpClient client;
  BookingMeetingRepository({required this.client});

  @override
  Future<ApiResult<ApiResponse>> getBooking(
      {required BookingMeetingRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.getFacilitybookings, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.getFacilitybookings));
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
  Future<ApiResult<ApiResponse>> postBookingValidate(
      {required NewBookingMeetingRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.postFacilityValidate, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postFacilityValidate));
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
  Future<ApiResult<ApiResponse>> getFacilities() async {
    try {
      final request = ModelRequest(Endpoint.getFacilities);
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api, endpoint: Endpoint.getFacilities));
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
  Future<ApiResult<ApiResponse>> postSaveBooking(
      {required NewBookingMeetingRequest content}) async {
    try {
      final request =
          ModelRequest(Endpoint.postSavefacilityBooking, body: content.toMap());
      final api = await client.postNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.postSavefacilityBooking));
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
  Future<ApiResult<ApiResponse>> deleteBooking(
      {required int fbId, required int userId}) async {
    try {
      final request = ModelRequest(
        sprintf(Endpoint.deleteFacilityBooking, [fbId, userId]),
      );
      final api = await client.getNew(request, (data) => data);
      if (api is! DioException) {
        return ApiResult.success(
            data: ApiResponse.fromJson(api,
                endpoint: Endpoint.deleteFacilityBooking));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
