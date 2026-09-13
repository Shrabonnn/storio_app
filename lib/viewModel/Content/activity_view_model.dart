import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/activity/activity_model.dart';
import '../../data/model/Content/activity/activity_status_choice_model.dart';
import '../../data/repository/content/activity_repository.dart';

class ActivityViewModel extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();

  // ------------------------------------------------------------
  // Activity list state
  // ------------------------------------------------------------
  List<ActivityModel> activityList = [];
  bool loading = false;
  String? errorMessage; // list-load errors ONLY (getActivityApi)

  // ------------------------------------------------------------
  // Action state — kept separate from errorMessage so a failed
  // create/update/delete/bulk action doesn't blank out the list
  // screen (which only checks errorMessage).
  // ------------------------------------------------------------
  String? actionError;

  // ------------------------------------------------------------
  // Status choices state
  // ------------------------------------------------------------
  List<ActivityStatusChoiceModel> statusChoices = [];
  bool statusLoading = false;

  // ------------------------------------------------------------
  // Category state
  // ------------------------------------------------------------
  List<ActivityCategoryModel> categoryList = [];
  bool categoryLoading = false;
  String? categoryErrorMessage;

  // ============================================================
  // GET ACTIVITY LIST
  // ============================================================
  Future<void> getActivityApi({String? status, String? search, int? category}) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      activityList = await _repository.getActivityList(status: status, search: search, category: category);
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
  // GET STATUS CHOICES
  // ============================================================
  Future<void> getStatusChoices() async {
    statusLoading = true;
    notifyListeners();

    try {
      statusChoices = await _repository.getStatusChoices();
    } on ApiException catch (e) {
      actionError = e.message;
    } catch (e) {
      actionError = "Failed to load status choices.";
    } finally {
      statusLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREATE ACTIVITY
  // ============================================================
  Future<ActivityModel?> createActivity(Map<String, dynamic> data) async {
    try {
      return await _repository.createActivity(data);
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      actionError = "Failed to create activity post.";
      notifyListeners();
      return null;
    }
  }

  // ============================================================
  // UPDATE ACTIVITY
  // ============================================================
  Future<ActivityModel?> updateActivity(int id, Map<String, dynamic> data) async {
    try {
      return await _repository.updateActivity(id, data);
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      actionError = "Failed to update activity post.";
      notifyListeners();
      return null;
    }
  }

  // ============================================================
  // SCHEDULE ACTIVITY
  // ============================================================
  Future<bool> scheduleActivity(int id, DateTime publishDate) async {
    try {
      await _repository.scheduleActivity(id, publishDate);
      return true;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      actionError = "Failed to schedule activity post.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // DELETE ACTIVITY (permanent)
  // ============================================================
  Future<bool> deleteActivity(int id) async {
    try {
      await _repository.deleteActivity(id);
      return true;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      actionError = "Failed to delete activity post.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // MOVE TO BIN
  // ============================================================
  Future<bool> binActivity(int id) async {
    try {
      await _repository.binActivity(id);
      return true;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      actionError = "Failed to move activity post to bin.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // RESTORE FROM BIN
  // ============================================================
  Future<bool> restoreActivity(int id) async {
    try {
      await _repository.restoreActivity(id);
      return true;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      actionError = "Failed to restore activity post.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // BULK ACTION
  // ============================================================
  Future<bool> bulkAction({required String action, required List<int> postIds}) async {
    try {
      await _repository.bulkOperation(action: action, postIds: postIds);
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
  // CATEGORY: GET LIST
  // ============================================================
  Future<void> getCategoryApi({String? search}) async {
    categoryLoading = true;
    categoryErrorMessage = null;
    notifyListeners();

    try {
      categoryList = await _repository.getCategoryList(search: search);
    } on ApiException catch (e) {
      categoryErrorMessage = e.message;
    } catch (e) {
      categoryErrorMessage = "Failed to load categories.";
    } finally {
      categoryLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CATEGORY: CREATE
  // ============================================================
  Future<bool> createCategory(Map<String, dynamic> data) async {
    try {
      await _repository.createCategory(data);
      return true;
    } on ApiException catch (e) {
      categoryErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      categoryErrorMessage = "Failed to create category.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // CATEGORY: UPDATE
  // ============================================================
  Future<bool> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateCategory(id, data);
      return true;
    } on ApiException catch (e) {
      categoryErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      categoryErrorMessage = "Failed to update category.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // CATEGORY: DELETE
  // ============================================================
  Future<bool> deleteCategory(int id) async {
    try {
      await _repository.deleteCategory(id);
      return true;
    } on ApiException catch (e) {
      categoryErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      categoryErrorMessage = "Failed to delete category.";
      notifyListeners();
      return false;
    }
  }
}