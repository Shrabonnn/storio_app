import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/hero/hero_slide_model.dart';
import '../../data/repository/content/hero_repository.dart';

class HeroSlideViewModel extends ChangeNotifier {
  final HeroSlideRepository _repository = HeroSlideRepository();

  // ------------------------------------------------------------
  // Public (site-facing) hero slides
  // ------------------------------------------------------------
  List<HeroSlideModel> heroSlideList = [];
  bool loading = false;
  String? errorMessage;

  Future<void> getHeroSlideApi() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      heroSlideList = await _repository.getHeroSlideList();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // Management (admin) hero slides
  // ------------------------------------------------------------
  List<HeroSlideModel> managementHeroSlideList = [];
  bool managementLoading = false;
  String? managementErrorMessage;

  Future<void> getManagementHeroSlideApi({
    String? search,
    bool isFilterOrSearch = false,
  }) async {
    managementErrorMessage = null;

    if (isFilterOrSearch || managementHeroSlideList.isEmpty) {
      if (isFilterOrSearch) {
        managementHeroSlideList.clear();
      }
      managementLoading = true;
      notifyListeners();
    }

    try {
      managementHeroSlideList =
      await _repository.getManagementHeroSlideList(search: search);
    } on ApiException catch (e) {
      managementErrorMessage = e.message;
    } catch (e) {
      managementErrorMessage = "Failed to load hero slides.";
    } finally {
      managementLoading = false;
      notifyListeners();
    }
  }

  HeroSlideModel? heroSlideDetail;

  Future<void> getHeroSlideDetail(int id) async {
    loading = true;
    notifyListeners();

    try {
      heroSlideDetail = await _repository.getHeroSlideDetail(id);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load hero slide details.";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> createHeroSlide(Map<String, dynamic> data) async {
    try {
      await _repository.createHeroSlide(data);
      return true;
    } on ApiException catch (e) {
      managementErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      managementErrorMessage = "Failed to create hero slide.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateHeroSlide(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateHeroSlide(id, data);
      return true;
    } on ApiException catch (e) {
      managementErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      managementErrorMessage = "Failed to update hero slide.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteHeroSlide(int id) async {
    try {
      await _repository.deleteHeroSlide(id);
      return true;
    } on ApiException catch (e) {
      managementErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      managementErrorMessage = "Failed to delete hero slide.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> reorderHeroSlide(List<int> orderedIds) async {
    final previous = List<HeroSlideModel>.from(managementHeroSlideList);

    // Optimistically reorder the local list first (drag-and-drop feel).
    managementHeroSlideList = orderedIds
        .map((id) => previous.firstWhere((slide) => slide.id == id))
        .toList();
    notifyListeners();

    try {
      await _repository.reorderHeroSlide(orderedIds);
      return true;
    } on ApiException catch (e) {
      managementHeroSlideList = previous;
      managementErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      managementHeroSlideList = previous;
      managementErrorMessage = "Failed to reorder hero slides.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> bulkAction(List<int> sectionIds) async {
    try {
      await _repository.bulkOperation(sectionIds);
      managementHeroSlideList = managementHeroSlideList
          .where((slide) => !sectionIds.contains(slide.id))
          .toList();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      managementErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      managementErrorMessage = "Bulk action failed.";
      notifyListeners();
      return false;
    }
  }

  void clearData() {
    heroSlideList.clear();
    managementHeroSlideList.clear();
    errorMessage = null;
    managementErrorMessage = null;
    notifyListeners();
  }
}

