import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mpi_new/data/models/inbox/notification_delete_request.dart';
import 'package:mpi_new/data/models/inbox/notification_response.dart';
import 'package:mpi_new/data/models/inbox/notification_update_request.dart';
import 'package:mpi_new/data/services/result/api_result.dart';
import 'package:sprintf/sprintf.dart';

import '../../../businesses_logics/api/endpoints.dart';
import '../../data.dart';

abstract class AbstractInboxRepository implements AbstractRepository {
  Future<ApiResult> getInbox({
    required String userId,
    required String sourceType,
    required String messageType,
    required String numberOfPage,
    required String numberOfRow,
    required String baseUrl,
    required String serverHub,
  });
  Future<ApiResult> updateInbox({
    required NotificationUpdateRequest content,
    required String baseUrl,
    required String serverHub,
  });

  Future<ApiResult> getTotalNotifications({
    required String userId,
    required String sourceType,
    required String baseUrl,
    required String serverHub,
  });

  Future<ApiResult> deleteNotification({
    required NotificationDeleteRequest content,
    required String baseUrl,
    required String serverHub,
  });
}

class InboxRepository implements AbstractInboxRepository {
  AbstractDioHttpClient client;
  InboxRepository({required this.client});

  @override
  Future<ApiResult> getInbox({
    required String userId,
    required String sourceType,
    required String messageType,
    required String numberOfPage,
    required String numberOfRow,
    required String baseUrl,
    required String serverHub,
  }) async {
    try {
      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: serverHub));

      final request = ModelRequest(sprintf(Endpoint.getNotification,
          [userId, sourceType, messageType, numberOfPage, numberOfRow]));
      final api1 = await client.getNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      final api = jsonDecode(api1);
      if (api is! DioException) {
        return ApiResult.success(data: NotificationResponse.fromJson(api));
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }

  @override
  Future<ApiResult> updateInbox({
    required NotificationUpdateRequest content,
    required String baseUrl,
    required String serverHub,
  }) async {
    try {
      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: serverHub));

      final request = ModelRequest(Endpoint.updateStatusNotification,
          body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(data: api);
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }

  @override
  Future<ApiResult> getTotalNotifications(
      {required String userId,
      required String sourceType,
      required String baseUrl,
      required String serverHub}) async {
    try {
      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: serverHub));

      final request = ModelRequest(sprintf(
        Endpoint.getTotalNotifications,
        [userId, sourceType],
      ));
      final api = await client.getNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(data: api);
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(
          error: Error.fromJson(Error(errorMessage: e).toJson()));
    }
  }

  @override
  Future<ApiResult> deleteNotification(
      {required NotificationDeleteRequest content,
      required String baseUrl,
      required String serverHub}) async {
    try {
      getIt<AbstractDioHttpClient>()
          .addOptions(BaseOptions(baseUrl: serverHub));

      final request =
          ModelRequest(Endpoint.deleteNotifications, body: content.toJson());
      final api = await client.postNew(request, (data) => data);
      getIt<AbstractDioHttpClient>().addOptions(BaseOptions(baseUrl: baseUrl));
      if (api is! DioException) {
        return ApiResult.success(data: api);
      } else {
        return ApiResult.fail(error: api);
      }
    } catch (e) {
      return ApiResult.fail(error: e);
    }
  }
}
