import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/calender/calender_model.dart';
import '../../data/repository/content/calender_repository.dart';

class CalendarViewModel extends ChangeNotifier {
  final CalendarRepository _repository = CalendarRepository();

  // ============================================================
  // STATE
  // ============================================================

  bool loading = false;
  bool detailLoading = false;
  bool isSubmitting = false;

  String? errorMessage;

  List<CalendarEventModel> eventList = [];
  CalendarEventModel? eventDetail;

  bool settingsLoading = false;
  CalendarSettingsModel? settings;

  // ============================================================
  // LIST EVENTS
  // ============================================================
  Future<void> getEventApi({
    String? search,
    String? category,
    String? level,
    bool isFilterOrSearch = false,
  }) async {
    if (!isFilterOrSearch) {
      loading = true;
      notifyListeners();
    }

    try {
      eventList = await _repository.getEventList(
        search: search,
        category: category,
        level: level,
      );
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
  // EVENT DETAIL
  // ============================================================
  Future<void> getEventDetail(int id) async {
    detailLoading = true;
    notifyListeners();

    try {
      eventDetail = await _repository.getEventDetail(id);
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
  // CREATE EVENT
  // ============================================================
  Future<bool> createEvent(Map<String, dynamic> data) async {
    isSubmitting = true;
    notifyListeners();

    try {
      await _repository.createEvent(data);
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
  // UPDATE EVENT
  // ============================================================
  Future<bool> updateEvent(int id, Map<String, dynamic> data) async {
    isSubmitting = true;
    notifyListeners();

    try {
      await _repository.updateEvent(id, data);
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
  // DELETE EVENT
  // ============================================================
  Future<bool> deleteEvent(int id) async {
    try {
      await _repository.deleteEvent(id);
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
  // GET SETTINGS (weekend days)
  // ============================================================
  Future<void> getSettings() async {
    settingsLoading = true;
    notifyListeners();

    try {
      settings = await _repository.getSettings();
      errorMessage = null;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      settingsLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE SETTINGS (weekend days)
  // ============================================================
  Future<bool> updateSettings(String weekendDays) async {
    isSubmitting = true;
    notifyListeners();

    try {
      settings = await _repository.updateSettings(weekendDays);
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
}