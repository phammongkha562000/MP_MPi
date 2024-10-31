import 'package:dio/dio.dart';

import '../../data.dart';

class ApiResult<T> {
  final bool success;
  final T? data;
  final dynamic error;

  ApiResult.success({required this.data})
      : success = true,
        error = null;

  ApiResult.fail({required this.error})
      : success = false,
        data = null;

  bool get isSuccess => success;
  bool get isFailure => !success;

  T getResult() {
    if (success) {
      if (data != null) {
        return data!;
      } else {
        throw Exception("No data available.");
      }
    } else {
      throw Exception("API request failed.");
    }
  }

  Error getErrorResponse() {
    if (error is DioException) {
      DioException e = error;
      if (e.type == DioExceptionType.badResponse) {
        return Error(
            errorCode: e.response?.statusCode,
            errorMessage: e.response?.statusMessage);
      } else if (e.type == DioExceptionType.connectionTimeout) {
        return Error(
            errorMessage: e.message, errorCode: e.response?.statusCode);
      } else if (e.type == DioExceptionType.connectionError) {
        return Error(
            errorMessage: MyError.internetDisconnect,
            errorCode: e.response?.statusCode);
      }
      return Error(errorMessage: e.message, errorCode: e.response?.statusCode);
    }
    if (error is Error) {
      return error;
    }
    return Error(errorMessage: error.toString());
  }

  Error getErrorLogin() {
    if (error is DioException) {
      DioException e = error;
      if (e.type == DioExceptionType.badResponse) {
        return Error(
            errorCode: e.response?.statusCode,
            errorMessage: e.response?.statusMessage);
        // ErrorLogin.fromMap(e.response?.data).errorDescription);
      } else if (e.type == DioExceptionType.unknown) {
        return Error(
            errorCode: MyError.errCodeNoInternet,
            errorMessage: MyError.internetDisconnect);
      } else if (e.type == DioExceptionType.connectionTimeout) {
        return Error(errorMessage: e.message);
      } else if (e.type == DioExceptionType.connectionError) {
        return Error(
            errorMessage: MyError.internetDisconnect,
            errorCode: e.response?.statusCode);
      }
      return Error(errorMessage: error.toString());
    }
    return Error(errorMessage: error.toString());
  }

  String getErrorMessage() {
    if (isFailure && error != null) {
      String errString = MyError.messError;

      return errString;
    } else {
      return "No error message available.";
    }
  }
}
