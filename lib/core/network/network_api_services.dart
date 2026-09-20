import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:storio_app/core/network/api_exception.dart';
import 'package:storio_app/core/network/api_helper.dart';

import '../storage/storage_service.dart';
import '../../res/api_url/app_url.dart';

class NetworkApiServices {
  // ============================================================
  // POST
  // ============================================================

  // Content-type == what i send  (post e)
  // Accept == Which type of response i want (get)

  Future<dynamic> postApi(
      String url,
      dynamic data, {
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
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

      if (response.statusCode == 401 && requiresAuth && !isRetry) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          return postApi(
            url,
            data,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        }
      }

      return ApiHelper.handleResponse(
          response); // based on response success or error message shows apihelper
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

  Future<dynamic> getApi(
      String url, {
        Map<String, dynamic>? queryParams,
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
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

      if (response.statusCode == 401 && requiresAuth && !isRetry) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          return getApi(
            url,
            queryParams: queryParams,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        }
      }

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

  Future<dynamic> putApi(
      String url,
      dynamic data, {
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
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

      if (response.statusCode == 401 && requiresAuth && !isRetry) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          return putApi(
            url,
            data,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        }
      }

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

  Future<dynamic> patchApi(
      String url,
      dynamic data, {
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
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

      if (response.statusCode == 401 && requiresAuth && !isRetry) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          return patchApi(
            url,
            data,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        }
      }

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

  Future<dynamic> deleteApi(
      String url, {
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
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

      if (response.statusCode == 401 && requiresAuth && !isRetry) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          return deleteApi(
            url,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        }
      }

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

  /*Future<dynamic> multipartApi(
      String url,
      Map<String, String> fields,
      Map<String, File> files, {
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
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

      if (response.statusCode == 401 && requiresAuth && !isRetry) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          return multipartApi(
            url,
            fields,
            files,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        }
      }

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
  }*/

  Future<dynamic> multipartApi(
      String url,
      Map<String, String> fields,
      Map<String, File> files, {
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
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

      // Add files dynamically
      for (final entry in files.entries) {
        final f = entry.value;

       final mimeTypeString = lookupMimeType(f.path) ?? 'application/octet-stream';
        final mediaType = MediaType.parse(mimeTypeString);

        debugPrint("FILE PATH: ${f.path}");
        debugPrint("CONTENT TYPE: $mimeTypeString");

        request.files.add(
          await http.MultipartFile.fromPath(
            entry.key,
            f.path,
            filename: f.path.split('/').last,
            contentType: mediaType,
          ),
        );
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      debugPrint("MULTIPART URL: $url");
      debugPrint("MULTIPART STATUS: ${response.statusCode}");

      if (response.statusCode == 401 && requiresAuth && !isRetry) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          return multipartApi(
            url,
            fields,
            files,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        }
      }

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

  // ============================================================
  // REFRESH ACCESS TOKEN
  // ============================================================


  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await http.post(
        Uri.parse(AppUrl.refreshTokenApi),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-Tenant-Host": AppUrl.tenantHost,
        },
        body: jsonEncode({"refresh": refreshToken}),
      );

      debugPrint("REFRESH TOKEN STATUS: ${response.statusCode}");

      if (response.statusCode != 200) {
        // refresh token ও মেয়াদোত্তীর্ণ / invalid — force logout দরকার
        await TokenStorage.clearTokens();
        return false;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final newAccess = data['access'] as String?;

      if (newAccess == null || newAccess.isEmpty) {
        await TokenStorage.clearTokens();
        return false;
      }

      await TokenStorage.saveToken(newAccess);

      // SimpleJWT এ ROTATE_REFRESH_TOKENS enabled থাকলে নতুন refresh
      // token ও দিতে পারে — থাকলে সেভ করে নেই
      final newRefresh = data['refresh'] as String?;
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await TokenStorage.saveRefreshToken(newRefresh);
      }

      return true;
    } catch (e) {
      debugPrint("REFRESH TOKEN ERROR: $e");
      return false;
    }
  }
}