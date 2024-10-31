import 'package:dio/dio.dart';
import 'package:mpi_new/data/data.dart';

abstract class NetworkExceptions implements Exception {
  factory NetworkExceptions.requestCancelled() => RequestCancelled();
  factory NetworkExceptions.unauthorisedRequest() => UnauthorisedRequest();
  factory NetworkExceptions.badRequest() => BadRequest();
  factory NetworkExceptions.notFound(reason) => NotFound(reason);
  factory NetworkExceptions.methodNotAllowed() => MethodNotAllowed();
  factory NetworkExceptions.notAcceptable() => NotAcceptable();
  factory NetworkExceptions.requestTimeout() => RequestTimeout();
  factory NetworkExceptions.sendTimeout() => SendTimeout();
  factory NetworkExceptions.conflict() => Conflict();
  factory NetworkExceptions.internalServerError() => InternalServerError();
  factory NetworkExceptions.notImplemented() => NotImplemented();
  factory NetworkExceptions.serviceUnavailable() => ServiceUnavailable();
  factory NetworkExceptions.defaultError(String error) => DefaultError(error);
  factory NetworkExceptions.unexpectedError() => UnexpectedError();

  static NetworkExceptions exceptionToError(DioException e) {
    NetworkExceptions networkExceptions;
    switch (e.type) {
      case DioExceptionType.cancel:
        networkExceptions = NetworkExceptions.requestCancelled();
        break;
      case DioExceptionType.connectionTimeout:
        networkExceptions = NetworkExceptions.requestTimeout();
        break;
      case DioExceptionType.unknown:
        networkExceptions = NetworkExceptions.unexpectedError();
        break;
      case DioExceptionType.receiveTimeout:
        networkExceptions = NetworkExceptions.sendTimeout();
        break;
      case DioExceptionType.sendTimeout:
        networkExceptions = NetworkExceptions.sendTimeout();
        break;
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            networkExceptions = NetworkExceptions.badRequest();
            break;
          case 401:
            networkExceptions = NetworkExceptions.unauthorisedRequest();
            globalServer.setTokenExpires = true;
            break;
          case 403:
            networkExceptions = NetworkExceptions.unauthorisedRequest();
            globalServer.setTokenExpires = true;
            break;
          case 404:
            networkExceptions = NetworkExceptions.notFound("Not found");
            break;
          case 409:
            networkExceptions = NetworkExceptions.conflict();
            break;
          case 408:
            networkExceptions = NetworkExceptions.requestTimeout();
            break;
          case 500:
            networkExceptions = NetworkExceptions.internalServerError();
            break;
          case 503:
            networkExceptions = NetworkExceptions.serviceUnavailable();
            break;
          default:
            networkExceptions = NetworkExceptions.defaultError(
              "Received invalid status code: ${e.response?.statusCode}",
            );
        }

        break;
      default:
        networkExceptions = NetworkExceptions.defaultError(
          "Received invalid status code: ${e.response?.statusCode}",
        );
    }

    return networkExceptions;
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "An error occurred";
    if (networkExceptions is NotImplemented) {
      errorMessage = "Not implemented";
    } else if (networkExceptions is RequestCancelled) {
      errorMessage = "Request cancelled";
    } else if (networkExceptions is InternalServerError) {
      errorMessage = "Internal server error";
    } else if (networkExceptions is NotFound) {
      errorMessage = networkExceptions.toString();
    } else if (networkExceptions is ServiceUnavailable) {
      errorMessage = "Service unavailable";
    } else if (networkExceptions is MethodNotAllowed) {
      errorMessage = "Method allowed";
    } else if (networkExceptions is BadRequest) {
      errorMessage = "Bad request";
    } else if (networkExceptions is UnauthorisedRequest) {
      errorMessage = "Unauthorized request";
    } else if (networkExceptions is UnexpectedError) {
      errorMessage = "Unexpected error occurred";
    } else if (networkExceptions is RequestTimeout) {
      errorMessage = "Connection request timeout";
    } else if (networkExceptions is Conflict) {
      errorMessage = "Error due to a conflict";
    } else if (networkExceptions is SendTimeout) {
      errorMessage = "Send timeout in connection with API server";
    } else if (networkExceptions is DefaultError) {
      errorMessage = networkExceptions.toString();
    } else if (networkExceptions is FormatException) {
      errorMessage = "Unexpected error occurred";
    } else if (networkExceptions is NotAcceptable) {
      errorMessage = "Not acceptable";
    }
    return errorMessage;
  }
}

class RequestCancelled implements NetworkExceptions {}

class UnauthorisedRequest implements NetworkExceptions {}

class BadRequest implements NetworkExceptions {}

class MethodNotAllowed implements NetworkExceptions {}

class NotAcceptable implements NetworkExceptions {}

class RequestTimeout implements NetworkExceptions {}

class SendTimeout implements NetworkExceptions {}

class Conflict implements NetworkExceptions {}

class InternalServerError implements NetworkExceptions {}

class NotImplemented implements NetworkExceptions {}

class ServiceUnavailable implements NetworkExceptions {}

class UnexpectedError implements NetworkExceptions {}

class DefaultError implements NetworkExceptions {
  final String error;

  const DefaultError(this.error);

  @override
  String toString() => error;
}

class NotFound implements NetworkExceptions {
  final String reason;

  const NotFound(this.reason);

  @override
  String toString() => reason;
}
