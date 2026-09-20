import 'dart:io';

import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/Content/video_reel/reel_model.dart';

class ReelRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // PUBLIC REEL LIST
  // ============================================================
  Future<ReelListResponse> getPublicReelList({
    String? search,
    String? type,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (type != null && type.isNotEmpty) {
      queryParams['type'] = type;
    }

    final response = await _apiServices.getApi(
      AppUrl.getPublicReels,
      queryParams: queryParams.isEmpty ? null : queryParams,
      requiresAuth: false,
    );

    return ReelListResponse.fromJson(response);
  }

  // ============================================================
  // REEL LIST (Management)
  // ============================================================
  Future<ReelListResponse> getReelList({
    String? status,
    String? type,
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (type != null && type.isNotEmpty) {
      queryParams['type'] = type;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiServices.getApi(
      AppUrl.getManagementReels,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return ReelListResponse.fromJson(response);
  }

  // ============================================================
  // REEL DETAIL (Management)
  // ============================================================
  Future<ReelModel> getReelDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.reelDetail(id));
    return ReelModel.fromJson(response);
  }

  // ============================================================
  // CREATE REEL
  // ============================================================
  Future<ReelModel> createReel(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createReel, data);
    return ReelModel.fromJson(response);
  }

  // ============================================================
  // UPDATE REEL (PATCH)
  // ============================================================
  Future<ReelModel> updateReel(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.reelDetail(id), data);
    return ReelModel.fromJson(response);
  }

  // ============================================================
  // DELETE REEL (permanent, 204 No Content)
  // ============================================================
  Future<void> deleteReel(int id) async {
    await _apiServices.deleteApi(AppUrl.reelDetail(id));
  }

  // ============================================================
  // UPDATE STATUS (active / draft)
  // ============================================================
  Future<Map<String, dynamic>> updateReelStatus(
      int id,
      String status,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.reelStatus(id),
      {"status": status},
    );
    return response;
  }

  // ============================================================
  // UPDATE METRICS (views / likes)
  // ============================================================
  Future<Map<String, dynamic>> updateReelMetrics(
      int id, {
        int? views,
        int? likes,
      }) async {
    final Map<String, dynamic> data = {};
    if (views != null) data['views'] = views;
    if (likes != null) data['likes'] = likes;

    final response = await _apiServices.patchApi(
      AppUrl.reelMetrics(id),
      data,
    );
    return response;
  }

  // ============================================================
  // UPLOAD THUMBNAIL
  // ============================================================
  Future<Map<String, dynamic>> uploadReelThumbnail(File file) async {
    final response = await _apiServices.multipartApi(
      AppUrl.uploadReelThumbnail,
      {},
      {"file": file},
    );
    return response;
  }
}