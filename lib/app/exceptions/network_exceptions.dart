/*
 * File name: network_exceptions.dart
 * Updated for Dart 3 + Dio v5
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as _get;

import '../routes/app_routes.dart';

abstract class NetworkExceptions {
  static String handleResponse(Response response) {
    final int statusCode = response.statusCode ?? 0;
    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        _get.Get.offAllNamed(Routes.LOGIN);
        return "Unauthorized Request";
      case 404:
        return "Not found";
      case 409:
        return "Error due to a conflict";
      case 408:
        return "Connection request timeout";
      case 500:
        return "Internal Server Error";
      case 503:
        return "Service unavailable";
      default:
        return "Received invalid status code";
    }
  }

  static String getDioException(dynamic error) {
    if (error is Exception) {
      try {
        String errorMessage = "";

        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorMessage = "Request Cancelled";
              break;

            case DioExceptionType.connectionTimeout:
              errorMessage = "Connection request timeout";
              break;

            case DioExceptionType.receiveTimeout:
              errorMessage = "Receive timeout in connection with API server";
              break;

            case DioExceptionType.sendTimeout:
              errorMessage = "Send timeout in connection with API server";
              break;

            case DioExceptionType.badResponse:
              errorMessage = error.response != null
                  ? NetworkExceptions.handleResponse(error.response!)
                  : "Bad server response";
              break;

            case DioExceptionType.connectionError:
              errorMessage = "No internet connection";
              break;

            case DioExceptionType.unknown:
              errorMessage = "Unexpected error occurred";
              break;
            case DioExceptionType.badCertificate:
              // TODO: Handle this case.
              throw UnimplementedError();
          }
        } else if (error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          errorMessage = "Unexpected error occurred";
        }

        return errorMessage;
      } on FormatException {
        return "Unexpected error occurred";
      } catch (_) {
        return "Unexpected error occurred";
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return "Unable to process the data";
      } else {
        return "Unexpected error occurred";
      }
    }
  }
}
