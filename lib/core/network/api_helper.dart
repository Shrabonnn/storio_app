import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiHelper {

  static dynamic handleResponse(http.Response response) {
    debugPrint("RAW RESPONSE BODY: ${response.body}");

    final decodedBody = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;

    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return decodedBody;

      case 400:
        throw ApiException(
          _extractMessage(decodedBody, "Bad Request"),
          statusCode: 400,
        );

      case 401:
        throw ApiException(
          _extractMessage(decodedBody, "Unauthorized. Please login again."),
          statusCode: 401,
        );

      case 403:
        throw ApiException(
          _extractMessage(decodedBody, "Access forbidden."),
          statusCode: 403,
        );

      case 404:
        throw ApiException(
          _extractMessage(decodedBody, "Requested resource not found."),
          statusCode: 404,
        );

      case 422:
        throw ApiException(
          _extractMessage(decodedBody, "Validation error."),
          statusCode: 422,
        );

      case 500:
        throw ApiException(
          _extractMessage(decodedBody, "Internal server error."),
          statusCode: 500,
        );

      default:
        throw ApiException(
          _extractMessage(decodedBody, "Something went wrong (${response.statusCode})"),
          statusCode: response.statusCode,
        );
    }
  }

  static String _extractMessage(dynamic decodedBody, String fallback) {
    if (decodedBody == null) return fallback;

    if (decodedBody is Map) {
      // DRF style: {"detail": "..."}
      if (decodedBody['detail'] != null) {
        return decodedBody['detail'].toString();
      }

      // Common custom formats
      final direct = decodedBody['message'] ?? decodedBody['error'] ?? decodedBody['msg'];
      if (direct != null) {
        return direct.toString();
      }

      // DRF field-level errors: {"file": ["..."], "title": ["..."]}
      final messages = <String>[];
      decodedBody.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          messages.add("$key: ${value.first}");
        } else if (value is String) {
          messages.add("$key: $value");
        }
      });

      if (messages.isNotEmpty) {
        return messages.join("\n");
      }
    }

    return fallback;
  }

}