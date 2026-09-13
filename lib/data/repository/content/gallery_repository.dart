import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';

import '../../model/Content/gallery/gallery_model.dart';

class GalleryRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // GALLERY IMAGE LIST (Management)
  // ============================================================
  Future<List<GalleryModel>> getGalleryList({
    String? search,
    String? album, // album ID or "uncategorized"
    bool? visible,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (album != null && album.isNotEmpty) queryParams['album'] = album;
    if (visible != null) queryParams['visible'] = visible.toString();

    final response = await _apiServices.getApi(
      AppUrl.getManagementGallery,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List).map((e) => GalleryModel.fromJson(e)).toList();
  }

  // ============================================================
  // GET SINGLE GALLERY IMAGE
  // ============================================================
  Future<GalleryModel> getGalleryDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.galleryImageDetail(id));
    return GalleryModel.fromJson(response);
  }

  // ============================================================
  // CREATE GALLERY IMAGE
  // ============================================================
  Future<GalleryModel> createGalleryImage(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createGalleryImage, data);
    return GalleryModel.fromJson(response['gallery']);
  }

  // ============================================================
  // UPDATE GALLERY IMAGE (PATCH)
  // ============================================================
  Future<GalleryModel> updateGalleryImage(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.galleryImageDetail(id), data);
    return GalleryModel.fromJson(response['gallery']);
  }

  // ============================================================
  // DELETE GALLERY IMAGE
  // ============================================================
  Future<Map<String, dynamic>> deleteGalleryImage(int id) async {
    return await _apiServices.deleteApi(AppUrl.galleryImageDetail(id));
  }

  // ============================================================
  // BULK OPERATIONS (delete, show, hide, move)
  // ============================================================
  Future<Map<String, dynamic>> bulkOperation({
    required String action,
    required List<int> imageIds,
    int? albumId,
  }) async {
    final body = <String, dynamic>{
      "action": action,
      "image_ids": imageIds,
    };

    if (action == "move" && albumId != null) {
      body["album_id"] = albumId;
    }

    return await _apiServices.postApi(AppUrl.galleryBulkOperations, body);
  }

  // ============================================================
  // ALBUM LIST (Management)
  // ============================================================
  Future<List<AlbumModel>> getAlbumList({String? search}) async {
    final Map<String, dynamic> queryParams = {};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _apiServices.getApi(
      AppUrl.getManagementAlbums,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List).map((e) => AlbumModel.fromJson(e)).toList();
  }

  Future<AlbumModel> getAlbumDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.albumDetail(id));
    return AlbumModel.fromJson(response);
  }

  Future<AlbumModel> createAlbum(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createAlbum, data);
    return AlbumModel.fromJson(response['album']);
  }

  Future<AlbumModel> updateAlbum(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.albumDetail(id), data);
    return AlbumModel.fromJson(response['album']);
  }

  Future<Map<String, dynamic>> deleteAlbum(int id) async {
    return await _apiServices.deleteApi(AppUrl.albumDetail(id));
  }
}