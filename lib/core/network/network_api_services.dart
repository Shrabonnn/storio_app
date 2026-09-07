import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:storio_app/core/network/api_exception.dart';
import 'package:storio_app/core/network/api_helper.dart';

import '../storage/storage_service.dart';
import '../../res/api_url/app_url.dart';

class NetworkApiServices {

  // ============================================================
  // POST
  // ============================================================

  Future<dynamic> postApi(String url, dynamic data, {bool requiresAuth = true,}) async {
    try {
      String? token;

      if (requiresAuth) {
        token = await TokenStorage.getToken();
      }

      final headers = <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Tenant-Host": AppUrl.tenantHost,
      };

      if (requiresAuth && token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      debugPrint("POST URL: $url");
      debugPrint("POST STATUS: ${response.statusCode}");

      return ApiHelper.handleResponse(response);

    } on SocketException {
      throw ApiException("No internet connection.");

    } on FormatException {
      throw ApiException("Invalid response format from server.");

    } catch (e) {
      debugPrint("POST ERROR: $e");

      if (e is ApiException) {
        rethrow;
      }

      throw ApiException("Unexpected error occurred.");
    }
  }


  // ============================================================
  // GET
  // ============================================================

  Future<dynamic> getApi(String url, {Map<String, dynamic>? queryParams, bool requiresAuth = true,}) async {
    try {
      String? token;

      if (requiresAuth) {
        token = await TokenStorage.getToken();
      }

      final headers = <String, String>{
        "Accept": "application/json",
        "X-Tenant-Host": AppUrl.tenantHost,
      };

      if (requiresAuth && token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final uri = Uri.parse(url).replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: headers,
      );

      debugPrint("GET URL: $uri");
      debugPrint("GET STATUS: ${response.statusCode}");

      return ApiHelper.handleResponse(response);

    } on SocketException {
      throw ApiException("No internet connection.");

    } on FormatException {
      throw ApiException("Invalid response format from server.");

    } catch (e) {
      debugPrint("GET ERROR: $e");

      if (e is ApiException) {
        rethrow;
      }

      throw ApiException("Unexpected error occurred.");
    }
  }


  // ============================================================
  // PUT
  // ============================================================

  Future<dynamic> putApi(String url, dynamic data, {bool requiresAuth = true,}) async {
    try {
      String? token;

      if (requiresAuth) {
        token = await TokenStorage.getToken();
      }

      final headers = <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Tenant-Host": AppUrl.tenantHost,
      };

      if (requiresAuth && token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      debugPrint("PUT URL: $url");
      debugPrint("PUT STATUS: ${response.statusCode}");

      return ApiHelper.handleResponse(response);

    } on SocketException {
      throw ApiException("No internet connection.");

    } on FormatException {
      throw ApiException("Invalid response format from server.");

    } catch (e) {
      debugPrint("PUT ERROR: $e");

      if (e is ApiException) {
        rethrow;
      }

      throw ApiException("Unexpected error occurred.");
    }
  }


  // ============================================================
  // PATCH
  // ============================================================

  Future<dynamic> patchApi(String url, dynamic data, {bool requiresAuth = true,}) async {
    try {
      String? token;

      if (requiresAuth) {
        token = await TokenStorage.getToken();
      }

      final headers = <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Tenant-Host": AppUrl.tenantHost,
      };

      if (requiresAuth && token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      debugPrint("PATCH URL: $url");
      debugPrint("PATCH STATUS: ${response.statusCode}");

      return ApiHelper.handleResponse(response);

    } on SocketException {
      throw ApiException("No internet connection.");

    } on FormatException {
      throw ApiException("Invalid response format from server.");

    } catch (e) {
      debugPrint("PATCH ERROR: $e");

      if (e is ApiException) {
        rethrow;
      }

      throw ApiException("Unexpected error occurred.");
    }
  }


  // ============================================================
  // DELETE
  // ============================================================

  Future<dynamic> deleteApi(String url, {bool requiresAuth = true,}) async {
    try {
      String? token;

      if (requiresAuth) {
        token = await TokenStorage.getToken();
      }

      final headers = <String, String>{
        "Accept": "application/json",
        "X-Tenant-Host": AppUrl.tenantHost,
      };

      if (requiresAuth && token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      debugPrint("DELETE URL: $url");
      debugPrint("DELETE STATUS: ${response.statusCode}");

      return ApiHelper.handleResponse(response);

    } on SocketException {
      throw ApiException("No internet connection.");

    } on FormatException {
      throw ApiException("Invalid response format from server.");

    } catch (e) {
      debugPrint("DELETE ERROR: $e");

      if (e is ApiException) {
        rethrow;
      }

      throw ApiException("Unexpected error occurred.");
    }
  }


  // ============================================================
  // MULTIPART POST
  // ============================================================

  Future<dynamic> multipartApi(String url, Map<String, String> fields, Map<String, File> files, {bool requiresAuth = true,}) async {
    try {
      String? token;

      if (requiresAuth) {
        token = await TokenStorage.getToken();
      }

      final request = http.MultipartRequest(
        "POST",
        Uri.parse(url),
      );

      request.headers.addAll({
        "Accept": "application/json",
        "X-Tenant-Host": AppUrl.tenantHost,
      });

      if (requiresAuth && token != null && token.isNotEmpty) {
        request.headers["Authorization"] = "Bearer $token";
      }

      // Add normal fields
      request.fields.addAll(fields);


      // Add files
      // Add files
      for (final entry in files.entries) {
        final f = entry.value;
        final bytes = await f.readAsBytes();

        final ext = f.path.split('.').last.toLowerCase();
        final mimeSubtype = switch (ext) {
          'jpg' || 'jpeg' => 'jpeg',
          'png' => 'png',
          'webp' => 'webp',
          'gif' => 'gif',
          'bmp' => 'bmp',
          _ => 'jpeg',
        };

        debugPrint("FILE PATH: ${f.path}");
        debugPrint("FILE SIZE: ${bytes.length} bytes");
        debugPrint("CONTENT TYPE: image/$mimeSubtype");

        request.files.add(
          http.MultipartFile.fromBytes(
            entry.key,
            bytes,
            filename: f.path.split('/').last,
            contentType: http.MediaType('image', mimeSubtype),
          ),
        );
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      debugPrint("MULTIPART URL: $url");
      debugPrint(
        "MULTIPART STATUS: ${response.statusCode}",
      );

      return ApiHelper.handleResponse(response);

    } on SocketException {
      throw ApiException("No internet connection.");

    } on FormatException {
      throw ApiException("Invalid response format from server.");

    } catch (e) {
      debugPrint("MULTIPART ERROR: $e");

      if (e is ApiException) {
        rethrow;
      }

      throw ApiException("Unexpected error occurred.");
    }
  }
}