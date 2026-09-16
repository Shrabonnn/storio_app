import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';

import '../../data/model/organization/links/education_link_model.dart';
import '../../data/model/organization/links/important_link_model.dart';

import '../../data/repository/organization/important_link_repository.dart';

class ImportantLinkViewModel extends ChangeNotifier {
  final ImportantLinkRepository _repository =
  ImportantLinkRepository();

  // ==================================================
  // Important Links
  // ==================================================

  List<ImportantLinkModel> linkList = [];

  bool loading = false;
  String? errorMessage;

  Future<void> getImportantLinkApi() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      linkList = await _repository.getImportantLinks();

      linkList.sort(
            (a, b) => (a.order ?? 0).compareTo(
          b.order ?? 0,
        ),
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

  Future<bool> createImportantLink(
      Map<String, dynamic> data,
      ) async {
    try {
      final link =
      await _repository.createImportantLink(data);

      linkList.add(link);

      linkList.sort(
            (a, b) => (a.order ?? 0).compareTo(
          b.order ?? 0,
        ),
      );

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to create important link.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateImportantLink(
      int id,
      Map<String, dynamic> data,
      ) async {
    try {
      final link =
      await _repository.updateImportantLink(id, data);

      final index = linkList.indexWhere(
            (item) => item.id == id,
      );

      if (index != -1) {
        linkList[index] = link;

        linkList.sort(
              (a, b) => (a.order ?? 0).compareTo(
            b.order ?? 0,
          ),
        );

        notifyListeners();
      }

      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to update important link.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteImportantLink(int id) async {
    try {
      await _repository.deleteImportantLink(id);

      linkList.removeWhere(
            (item) => item.id == id,
      );

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete important link.";
      notifyListeners();
      return false;
    }
  }

  // ==================================================
  // Education Board Settings
  // ==================================================

  ImportantLinksBoardSettingsModel?
  boardSettings;

  bool boardSettingsLoading = false;

  Future<void> getBoardSettingsApi() async {
    boardSettingsLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      boardSettings =
      await _repository.getBoardSettings();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage =
      "Failed to load education board settings.";
    } finally {
      boardSettingsLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBoardSettings(
      Map<String, dynamic> data,
      ) async {
    try {
      boardSettings =
      await _repository.updateBoardSettings(data);

      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage =
      "Failed to update education board settings.";
      notifyListeners();
      return false;
    }
  }

  // ==================================================
  // Education Board Notices
  // ==================================================

  EducationBoardNoticesResponseModel?boardNoticesResponse;

  List<EducationBoardNoticeModel> boardNotices = [];

  bool boardNoticesLoading = false;

  Future<void> fetchBoardNoticesApi(
      String boards,
      ) async {
    boardNoticesLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      boardNoticesResponse =
      await _repository.fetchBoardNotices(boards);

      boardNotices =
          boardNoticesResponse?.notices ?? [];
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage =
      "Failed to fetch education board notices.";
    } finally {
      boardNoticesLoading = false;
      notifyListeners();
    }
  }
}