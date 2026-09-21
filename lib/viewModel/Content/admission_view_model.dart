import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/admission/admission_model.dart';
import '../../data/repository/content/admission_repository.dart';

class AdmissionViewModel extends ChangeNotifier {
  final AdmissionRepository _repository = AdmissionRepository();

  // ============================================================
  // STATE
  // ============================================================

  bool formConfigLoading = false;
  bool isSavingFormConfig = false;
  AdmissionFormConfigModel? formConfig;

  bool applicationsLoading = false;
  List<AdmissionApplicationModel> applicationList = [];

  bool isUpdatingStatus = false;
  bool isExporting = false;

  String? errorMessage;

  // ============================================================
  // GET FORM CONFIG (Shimmer-friendly)
  // ============================================================
  Future<void> getFormConfig({bool forceRefresh = false}) async {
    errorMessage = null;

    // 1. Force refresh করা হলে বা মেমোরিতে ফর্ম কনফিগ না থাকলে shimmer দেখাবে
    if (forceRefresh || formConfig == null) {
      if (forceRefresh) {
        formConfig = null; // পুরানো ডাটা ক্লিয়ার করে shimmer নিশ্চিত করা হলো
      }
      formConfigLoading = true;
      notifyListeners();
    }

    try {
      formConfig = await _repository.getFormConfig();
      errorMessage = null;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      formConfigLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // SAVE / UPDATE FORM CONFIG
  // ============================================================
  Future<bool> saveFormConfig(AdmissionFormConfigModel configToSave) async {
    isSavingFormConfig = true;
    notifyListeners();

    try {
      formConfig = await _repository.saveFormConfig(configToSave);
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Failed to save configuration. Please try again.";
      return false;
    } finally {
      isSavingFormConfig = false;
      notifyListeners();
    }
  }

  // ============================================================
  // LIST APPLICATIONS (Shimmer-friendly)
  // ============================================================
  Future<void> getApplications({
    bool isFilterOrSearch = false,
  }) async {
    errorMessage = null;

    // 1. Filter/Search করা হলে বা মেমোরিতে কোনো ডাটা না থাকলে shimmer animation দেখাবে
    if (isFilterOrSearch || applicationList.isEmpty) {
      if (isFilterOrSearch) {
        applicationList.clear(); // পুরানো ডাটা ক্লিয়ার করে shimmer নিশ্চিত করা হলো
      }
      applicationsLoading = true;
      notifyListeners();
    }

    try {
      applicationList = await _repository.getApplications();
      errorMessage = null;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      applicationsLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE APPLICATION STATUS (Management — approve/reject)
  // ============================================================
  Future<bool> updateApplicationStatus(
      int id, {
        required String status,
        String? notes,
      }) async {
    isUpdatingStatus = true;
    notifyListeners();

    try {
      await _repository.updateApplicationStatus(
        id,
        status: status,
        notes: notes,
      );
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      isUpdatingStatus = false;
      notifyListeners();
    }
  }

  // ============================================================
  // EXPORT APPLICATIONS TO CSV (Management)
  // ============================================================
  Future<List<int>?> exportApplicationsCsv() async {
    isExporting = true;
    notifyListeners();

    try {
      final bytes = await _repository.exportApplicationsCsv();
      errorMessage = null;
      return bytes;
    } catch (e) {
      errorMessage = "Failed to export applications.";
      return null;
    } finally {
      isExporting = false;
      notifyListeners();
    }
  }
}