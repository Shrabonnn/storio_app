import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/gallery/gallery_model.dart';
import '../../data/repository/content/gallery_repository.dart';

class GalleryViewModel extends ChangeNotifier {
  final GalleryRepository _repository = GalleryRepository();


  List<GalleryModel> galleryList = [];
  bool loading = false;
  String? errorMessage;


  String? actionError;


  List<AlbumModel> albumList = [];
  bool albumLoading = false;
  String? albumErrorMessage;

  // ============================================================
  // GET GALLERY LIST
  // ============================================================
  Future<void> getGalleryApi({String? search, String? album, bool? visible}) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      galleryList = await _repository.getGalleryList(search: search, album: album, visible: visible);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREATE GALLERY IMAGE
  // ============================================================
  Future<GalleryModel?> createGalleryImage(Map<String, dynamic> data) async {
    try {
      return await _repository.createGalleryImage(data);
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      actionError = "Failed to add image to gallery.";
      notifyListeners();
      return null;
    }
  }

  // ============================================================
  // UPDATE GALLERY IMAGE
  // ============================================================
  Future<GalleryModel?> updateGalleryImage(int id, Map<String, dynamic> data) async {
    try {
      return await _repository.updateGalleryImage(id, data);
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      actionError = "Failed to update image.";
      notifyListeners();
      return null;
    }
  }

  // ============================================================
  // DELETE GALLERY IMAGE
  // ============================================================
  Future<bool> deleteGalleryImage(int id) async {
    try {
      await _repository.deleteGalleryImage(id);
      return true;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      actionError = "Failed to delete image.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // BULK ACTION (delete / show / hide / move)
  // ============================================================
  Future<bool> bulkAction({
    required String action,
    required List<int> imageIds,
    int? albumId,
  }) async {
    try {
      await _repository.bulkOperation(action: action, imageIds: imageIds, albumId: albumId);
      return true;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      actionError = "Bulk action failed.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // ALBUM: GET LIST
  // ============================================================
  Future<void> getAlbumApi({String? search}) async {
    albumLoading = true;
    albumErrorMessage = null;
    notifyListeners();

    try {
      albumList = await _repository.getAlbumList(search: search);
    } on ApiException catch (e) {
      albumErrorMessage = e.message;
    } catch (e) {
      albumErrorMessage = "Failed to load albums.";
    } finally {
      albumLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // ALBUM: CREATE
  // ============================================================
  Future<AlbumModel?> createAlbum(Map<String, dynamic> data) async {
    try {
      return await _repository.createAlbum(data);
    } on ApiException catch (e) {
      albumErrorMessage = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      albumErrorMessage = "Failed to create album.";
      notifyListeners();
      return null;
    }
  }

  // ============================================================
  // ALBUM: UPDATE
  // ============================================================
  Future<AlbumModel?> updateAlbum(int id, Map<String, dynamic> data) async {
    try {
      return await _repository.updateAlbum(id, data);
    } on ApiException catch (e) {
      albumErrorMessage = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      albumErrorMessage = "Failed to update album.";
      notifyListeners();
      return null;
    }
  }

  // ============================================================
  // ALBUM: DELETE
  // ============================================================
  Future<bool> deleteAlbum(int id) async {
    try {
      await _repository.deleteAlbum(id);
      return true;
    } on ApiException catch (e) {
      albumErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      albumErrorMessage = "Failed to delete album.";
      notifyListeners();
      return false;
    }
  }
}