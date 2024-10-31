// import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data.dart';

abstract class AbstractHttpRequest {
  final String path;

  final Map<String, dynamic>? parameters;
  final dynamic body;
  final Map<String, dynamic>? header;
  final String? baseUrl;
  const AbstractHttpRequest(
    this.path, {
    this.parameters,
    this.header,
    this.body,
    this.baseUrl,
  });
}

abstract class AbstractHttpClient {
  Future<dynamic> getNew<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback onReceiveProgress,
  });
  Future<dynamic> postNew<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
  Future<dynamic> putNew<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback onReceiveProgress,
  });
  // * =================================================
  Future<dynamic> get<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback onReceiveProgress,
  });
  Future<dynamic> post<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
  Future<dynamic> put<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
  Future<dynamic> patch<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  });
  Future<dynamic> head<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
  });
  Future<dynamic> delete<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
  });
}

@module
abstract class RegisterModule {
  @injectable
  Dio get dio => Dio();
}

abstract class AbstractDioHttpClient extends AbstractHttpClient {
  final Dio client;
  AbstractDioHttpClient({required this.client});
  void addOptions(BaseOptions options);
  void addInterceptor(Interceptor interceptor);
}

@LazySingleton(as: AbstractDioHttpClient)
class ApiClient extends AbstractDioHttpClient {
  ApiClient({required Dio client}) : super(client: client);

  @override
  void addInterceptor(Interceptor interceptor) =>
      client.interceptors.add(interceptor);

  @override
  void addOptions(BaseOptions options) {
    client.options = options;
  }

  @override
  Future<dynamic> getNew<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await client.get(
        request.path,
        queryParameters: request.parameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: request.header,
        ),
      );
      return factory != null ? factory(response.data) : response.data;
    } catch (e) {
      return e;
    }
  }

  @override
  Future<dynamic> get<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await client.get(
        request.path,
        queryParameters: request.parameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: request.header,
        ),
      );
      return factory != null ? factory(response.data) : response.data;
    } on DioException catch (e) {
      throw NetworkExceptions.exceptionToError(e);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> postNew<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await client.post(
        request.path,
        queryParameters: request.parameters,
        data: request.body,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: request.header,
        ),
      );
      return factory == null ? response : factory(response.data);
    } catch (e) {
      return e;
    }
  }

  @override
  Future<dynamic> post<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await client.post(
        request.path,
        queryParameters: request.parameters,
        data: request.body,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: request.header,
        ),
      );
      return factory == null ? response : factory(response.data);
    } on DioException catch (e) {
      throw NetworkExceptions.exceptionToError(e);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (e) {
      throw FormatException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> put<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await client.put(
        request.path,
        queryParameters: request.parameters,
        data: request.body,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: request.header),
      );
      return factory == null ? response : factory(response.data);
    } on DioException catch (e) {
      throw NetworkExceptions.exceptionToError(e);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> putNew<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await client.put(
        request.path,
        queryParameters: request.parameters,
        data: request.body,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: request.header),
      );
      return factory == null ? response : factory(response.data);
    } catch (e) {
      return e;
    }
  }

  @override
  Future<dynamic> delete<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await client.delete(
        request.path,
        queryParameters: request.parameters,
        data: request.body,
        cancelToken: cancelToken,
        options: Options(headers: request.header),
      );
      return factory == null ? response : factory(response.data);
    } on DioException catch (e) {
      throw NetworkExceptions.exceptionToError(e);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> head<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await client.head(
        request.path,
        queryParameters: request.parameters,
        data: request.body,
        options: Options(headers: request.header),
      );
      return factory == null ? response : factory(response.data);
    } on DioException catch (e) {
      throw NetworkExceptions.exceptionToError(e);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> patch<T>(
    AbstractHttpRequest request,
    T Function(dynamic data)? factory, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await client.patch(
        request.path,
        queryParameters: request.parameters,
        data: request.body,
        options: Options(headers: request.header),
      );
      return factory == null ? response : factory(response.data);
    } on DioException catch (e) {
      throw NetworkExceptions.exceptionToError(e);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
