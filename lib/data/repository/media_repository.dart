import 'dart:io';

import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../model/media/media_model.dart';

class MediaRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // Upload Configuration (allowed extensions, size limits)
  // ============================================================

  Future<dynamic> getUploadConfigApi() async {
    return await _apiServices.getApi(
      AppUrl.mediaFileUploadConfig,
      requiresAuth: false,
    );
  }

  // ============================================================
  // File Type Choices (filter dropdown)
  // ============================================================

  Future<dynamic> getFileTypesApi() async {
    return await _apiServices.getApi(
      AppUrl.mediaFileTypes,
      requiresAuth: true,
    );
  }

  // ============================================================
  // Media Library List (with search/filter)
  // ============================================================

  Future<dynamic> getMediaListApi({
    String? search,
    String? fileType,
    bool? uploadedByMe,
  }) async {
    return await _apiServices.getApi(
      AppUrl.mediaList,
      requiresAuth: true,
      queryParams: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (fileType != null && fileType.isNotEmpty) 'file_type': fileType,
        if (uploadedByMe != null) 'uploaded_by_me': uploadedByMe.toString(),
      },
    );
  }

  // ============================================================
  // Upload Media File — multipart/form-data
  // ============================================================

  Future<MediaFileModel> uploadMediaApi({
    required File file,
    String? title,
    String? description,
    String? altText,
    String? caption,
  }) async {
    final response = await _apiServices.multipartApi(
      AppUrl.mediaCreate,
      {
        if (title != null) "title": title,
        if (description != null) "description": description,
        if (altText != null) "alt_text": altText,
        if (caption != null) "caption": caption,
      },
      {
        "file": file,
      },
      requiresAuth: true,
    );

    print("RAW UPLOAD RESPONSE: $response");

    return MediaFileModel.fromJson(response);
  }

  // ============================================================
  // Get Media File Detail
  // ============================================================

  Future<MediaFileModel> getMediaDetailApi(int id) async {
    final response = await _apiServices.getApi(
      AppUrl.mediaDetail(id),
      requiresAuth: true,
    );

    return MediaFileModel.fromJson(response);
  }

  // ============================================================
  // Update Media File (metadata)
  // ============================================================

  Future<dynamic> updateMediaApi({
    required int id,
    String? title,
    String? description,
    String? altText,
    String? caption,
  }) async {
    return await _apiServices.patchApi(
      AppUrl.mediaDetail(id),
      {
        if (title != null) "title": title,
        if (description != null) "description": description,
        if (altText != null) "alt_text": altText,
        if (caption != null) "caption": caption,
      },
      requiresAuth: true,
    );
  }

  // ============================================================
  // Delete Media File
  // ============================================================

  Future<dynamic> deleteMediaApi(int id) async {
    return await _apiServices.deleteApi(
      AppUrl.mediaDetail(id),
      requiresAuth: true,
    );
  }
}