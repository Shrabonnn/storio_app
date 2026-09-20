import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/video_reel/reel_model.dart';
import '../../data/repository/Content/reel_repository.dart';

class ReelViewModel extends ChangeNotifier {
  final ReelRepository _repository = ReelRepository();

  // ============================================================
  // STATE
  // ============================================================

  bool loading = false;
  bool detailLoading = false;
  bool isSubmitting = false;

  String? errorMessage;

  List<ReelModel> reelList = [];
  int? reelCount;

  ReelModel? reelDetail;

  // ============================================================
  // PUBLIC REEL LIST
  // ============================================================
  Future<void> getPublicReelApi({
    String? type,
    String? search,
    bool isFilterOrSearch = false,
  }) async {
    if (!isFilterOrSearch) {
      loading = true;
      notifyListeners();
    }

    try {
      final response = await _repository.getPublicReelList(
        type: type,
        search: search,
      );

      reelList = response.data ?? [];
      reelCount = response.count;
      errorMessage = null;
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
  // REEL LIST (Management)
  // ============================================================
  Future<void> getReelApi({
    String? status,
    String? type,
    String? search,
    bool isFilterOrSearch = false,
  }) async {
    if (!isFilterOrSearch) {
      loading = true;
      notifyListeners();
    }

    try {
      final response = await _repository.getReelList(
        status: status,
        type: type,
        search: search,
      );

      reelList = response.data ?? [];
      reelCount = response.count;
      errorMessage = null;
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
  // REEL DETAIL
  // ============================================================
  Future<void> getReelDetail(int id) async {
    detailLoading = true;
    notifyListeners();

    try {
      reelDetail = await _repository.getReelDetail(id);
      errorMessage = null;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      detailLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREATE REEL
  // ============================================================
  Future<bool> createReel(Map<String, dynamic> data) async {
    isSubmitting = true;
    notifyListeners();

    try {
      await _repository.createReel(data);
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE REEL
  // ============================================================
  Future<bool> updateReel(int id, Map<String, dynamic> data) async {
    isSubmitting = true;
    notifyListeners();

    try {
      await _repository.updateReel(id, data);
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ============================================================
  // DELETE REEL
  // ============================================================
  Future<bool> deleteReel(int id) async {
    try {
      await _repository.deleteReel(id);
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE STATUS (active / draft toggle)
  // ============================================================
  Future<bool> updateReelStatus(int id, String status) async {
    try {
      await _repository.updateReelStatus(id, status);
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE METRICS (views / likes)
  // ============================================================
  Future<bool> updateReelMetrics(int id, {int? views, int? likes}) async {
    try {
      await _repository.updateReelMetrics(id, views: views, likes: likes);
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      notifyListeners();
    }
  }

  // ============================================================
  // UPLOAD THUMBNAIL
  // ============================================================
  Future<Map<String, dynamic>?> uploadReelThumbnail(File file) async {
    try {
      final response = await _repository.uploadReelThumbnail(file);
      errorMessage = null;
      return response;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return null;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return null;
    } finally {
      notifyListeners();
    }
  }
}