import 'dart:io';
import 'package:flutter/material.dart';


import '../../data/model/media/media_model.dart';

import '../../data/repository/media_repository.dart';

class MediaViewModel extends ChangeNotifier {
  final MediaRepository _repository = MediaRepository();

  // ============================================================
  // Upload Configuration
  // ============================================================

  bool configLoading = false;
  String? configError;
  Map<String, dynamic>? sizeLimits;
  Map<String, dynamic>? allowedExtensions;

  Future<void> getUploadConfig() async {
    configLoading = true;
    configError = null;
    notifyListeners();

    try {
      final response = await _repository.getUploadConfigApi();

      sizeLimits = response['size_limits'];
      allowedExtensions = response['allowed_extensions'];

      debugPrint("UPLOAD CONFIG: $response");
    } catch (e) {
      configError = e.toString();
      debugPrint("UPLOAD CONFIG ERROR: $e");
    } finally {
      configLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // File Type Choices (filter dropdown)
  // ============================================================

  bool fileTypesLoading = false;
  String? fileTypesError;
  List<Map<String, String>> fileTypeChoices = [];

  Future<void> getFileTypeChoices() async {
    fileTypesLoading = true;
    fileTypesError = null;
    notifyListeners();

    try {
      final List response = await _repository.getFileTypesApi();

      fileTypeChoices = response
          .map<Map<String, String>>((item) => {
        "value": item['value'].toString(),
        "label": item['label'].toString(),
      })
          .toList();

      debugPrint("FILE TYPE CHOICES: $fileTypeChoices");
    } catch (e) {
      fileTypesError = e.toString();
      debugPrint("FILE TYPE CHOICES ERROR: $e");
    } finally {
      fileTypesLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Media Library List
  // ============================================================

  bool libraryLoading = false;
  String? libraryError;
  List<MediaFileModel> libraryItems = [];

  Future<void> getMediaList({
    String? search,
    String? fileType,
    bool? uploadedByMe,
  }) async {
    libraryLoading = true;
    libraryError = null;
    notifyListeners();

    try {
      final response = await _repository.getMediaListApi(
        search: search,
        fileType: fileType,
        uploadedByMe: uploadedByMe,
      );

      final List items =
      response is List ? response : (response['results'] ?? []);

      libraryItems = items
          .map((item) => MediaFileModel.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint("MEDIA LIBRARY LENGTH: ${libraryItems.length}");
    } catch (e) {
      libraryError = e.toString();
      debugPrint("MEDIA LIBRARY ERROR: $e");
    } finally {
      libraryLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Upload
  // ============================================================

  bool isUploading = false;
  String? uploadError;

  Future<MediaFileModel?> uploadMedia({
    required File file,
    String? title,
    String? description,
    String? altText,
    String? caption,
  }) async {
    isUploading = true;
    uploadError = null;
    notifyListeners();

    try {
      final result = await _repository.uploadMediaApi(
        file: file,
        title: title,
        description: description,
        altText: altText,
        caption: caption,
      );

      debugPrint("UPLOAD SUCCESS: id=${result.id}, file=${result.file}");

      // নতুন uploaded file টা library list এর শুরুতে যোগ করে দিচ্ছি
      libraryItems.insert(0, result);

      return result;
    } catch (e) {
      uploadError = e.toString();
      debugPrint("UPLOAD ERROR: $e");
      return null;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Update Metadata
  // ============================================================

  bool isUpdating = false;
  String? updateError;

  Future<bool> updateMedia({
    required int id,
    String? title,
    String? description,
    String? altText,
    String? caption,
  }) async {
    isUpdating = true;
    updateError = null;
    notifyListeners();

    try {
      final response = await _repository.updateMediaApi(
        id: id,
        title: title,
        description: description,
        altText: altText,
        caption: caption,
      );

      final updated = MediaFileModel.fromJson(response);

      final index = libraryItems.indexWhere((e) => e.id == id);
      if (index != -1) {
        libraryItems[index] = updated;
      }

      debugPrint("UPDATE MEDIA SUCCESS: id=$id");
      return true;
    } catch (e) {
      updateError = e.toString();
      debugPrint("UPDATE MEDIA ERROR: $e");
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Delete
  // ============================================================

  bool isDeleting = false;
  String? deleteError;

  Future<bool> deleteMedia(int id) async {
    isDeleting = true;
    deleteError = null;
    notifyListeners();

    try {
      await _repository.deleteMediaApi(id);

      libraryItems.removeWhere((e) => e.id == id);

      debugPrint("DELETE MEDIA SUCCESS: id=$id");
      return true;
    } catch (e) {
      deleteError = e.toString();
      debugPrint("DELETE MEDIA ERROR: $e");
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Screen-level Selection State (Upload tab vs Library tab)
  // ============================================================

  MediaFileModel? selectedLibraryMedia;
  File? selectedLocalFile;

  void selectFromLibrary(MediaFileModel media) {
    selectedLibraryMedia = media;
    selectedLocalFile = null;
    notifyListeners();
  }

  void pickLocalFile(File file) {
    selectedLocalFile = file;
    selectedLibraryMedia = null;
    notifyListeners();
  }

  void clearSelection() {
    selectedLibraryMedia = null;
    selectedLocalFile = null;
    notifyListeners();
  }
}