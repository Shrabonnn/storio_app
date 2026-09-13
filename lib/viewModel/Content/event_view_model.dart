import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/event/event_model.dart';
import '../../data/repository/content/event_repository.dart';

class EventViewModel extends ChangeNotifier {
  final EventRepository _repository = EventRepository();

  // ------------------------------------------------------------
  // Event list state
  // ------------------------------------------------------------
  List<EventModel> eventList = [];
  bool loading = false;
  String? errorMessage; // list-load errors ONLY

  // ------------------------------------------------------------
  // Event detail state
  // ------------------------------------------------------------
  EventModel? selectedEvent;
  bool detailLoading = false;
  String? detailErrorMessage;

  // ------------------------------------------------------------
  // Action state
  // ------------------------------------------------------------
  // Create / Update / Delete errors
  String? actionError;

  // ------------------------------------------------------------
  // Category state
  // ------------------------------------------------------------
  List<CategoriesDetail> categoryList = [];
  bool categoryLoading = false;
  String? categoryErrorMessage;

  // ============================================================
  // GET EVENT LIST
  // ============================================================

  Future<void> getEventApi({
    String? status,
    String? search,
    int? category,
  }) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      eventList = await _repository.getEventList(
        status,
        search,
        category,
      );
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
  // GET EVENT DETAILS
  // ============================================================

  Future<EventModel?> getEventDetailsApi(int id) async {
    detailLoading = true;
    detailErrorMessage = null;
    notifyListeners();

    try {
      selectedEvent = await _repository.getEventDetails(id);

      return selectedEvent;
    } on ApiException catch (e) {
      detailErrorMessage = e.message;
      return null;
    } catch (e) {
      detailErrorMessage = "Failed to load event details.";
      return null;
    } finally {
      detailLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREATE EVENT
  // ============================================================

  Future<EventModel?> createEvent(
      Map<String, dynamic> data,
      ) async {
    actionError = null;

    try {
      final event = await _repository.createEvent(data);

      return event;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      actionError = "Failed to create event.";
      notifyListeners();
      return null;
    }
  }

  // ============================================================
  // UPDATE EVENT
  // ============================================================

  Future<EventModel?> updateEvent(
      int id,
      Map<String, dynamic> data,
      ) async {
    actionError = null;

    try {
      final event = await _repository.updateEvent(
        id,
        data,
      );

      return event;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      actionError = "Failed to update event.";
      notifyListeners();
      return null;
    }
  }

  // ============================================================
  // DELETE EVENT
  // ============================================================

  Future<bool> deleteEvent(int id) async {
    actionError = null;

    try {
      await _repository.deleteEvent(id);

      return true;
    } on ApiException catch (e) {
      actionError = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      actionError = "Failed to delete event.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // CATEGORY: GET LIST
  // ============================================================

  Future<void> getCategoryApi({String? search,}) async {
    categoryLoading = true;
    categoryErrorMessage = null;
    notifyListeners();

    try {
      categoryList = await _repository.getCategoryList(
        search: search,
      );
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

  Future<bool> createCategory(
      Map<String, dynamic> data,
      ) async {
    categoryErrorMessage = null;

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

  Future<bool> updateCategory(
      int id,
      Map<String, dynamic> data,
      ) async {
    categoryErrorMessage = null;

    try {
      await _repository.updateCategory(
        id,
        data,
      );

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
    categoryErrorMessage = null;

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

  // ============================================================
  // CLEAR SELECTED EVENT
  // ============================================================

  void clearSelectedEvent() {
    selectedEvent = null;
    detailErrorMessage = null;
    notifyListeners();
  }

  // ============================================================
  // CLEAR ERRORS
  // ============================================================

  void clearErrors() {
    errorMessage = null;
    detailErrorMessage = null;
    actionError = null;
    categoryErrorMessage = null;
    notifyListeners();
  }
}