import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:storio_app/core/network/api_exception.dart';
import 'package:storio_app/data/model/Content/promotion/promotion_model.dart';
import 'package:storio_app/data/repository/content/promotion_repository.dart';

class PromotionViewModel extends ChangeNotifier{

  final PromotionRepository _repository = PromotionRepository();

  List<PromotionModel> promotionList  =[];

  bool loading = false;
  String? errorMessage;

  // Get Promotion

  Future<void> getManagementPromotion({
    String? search,
    String? status,
    String? type,
  }) async {
    loading= true;
    errorMessage = null;
    notifyListeners();

    try {
      promotionList = await _repository.getManagementPromotions(
        search: search,
        status: status,
        type: type
      );
    } on ApiException catch (e){
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading =false;
      notifyListeners();
    }

  }


  // Create Promotion
  Future<PromotionModel?> createPromotionApi(
      Map<String, dynamic> data,
      ) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final promotion = await _repository.createPromotion(data);

      promotionList.insert(0, promotion);

      return promotion;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Publish Promotion

  Future<PromotionModel?> publishPromotionApi(int id) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final promotion = await _repository.publishPromotion(id);

      _updatePromotionInList(promotion);

      return promotion;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Archive Promotion


  Future<PromotionModel?> archivePromotionApi(int id) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final promotion = await _repository.archivePromotion(id);

      _updatePromotionInList(promotion);

      return promotion;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Draft Promotion


  Future<PromotionModel?> draftPromotionApi(int id) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final promotion = await _repository.draftPromotion(id);

      _updatePromotionInList(promotion);

      return promotion;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Bulk Operations


  Future<bool> bulkPromotionApi({
    required List<int> ids,
    required String action,
  }) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.bulkPromotion(
        ids: ids,
        action: action,
      );

      return true;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Restore
  Future<PromotionModel?> restorePromotionApi(int id) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final promotion = await _repository.restorePromotion(id);

      _updatePromotionInList(promotion);

      return promotion;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Update ============================================================

  Future<PromotionModel?> updatePromotionApi(
      int id,
      Map<String, dynamic> data,
      ) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final promotion = await _repository.updatePromotion(
        id,
        data,
      );

      _updatePromotionInList(promotion);

      return promotion;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  // Permanenlty delete
  Future<bool> permanentlyDeletePromotionApi(int id) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.permanentlyDeletePromotion(id);

      promotionList.removeWhere(
            (promotion) => promotion.id == id,
      );

      return true;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  // Bin
  List<PromotionModel> binPromotionList = [];

  Future<void> getBinPromotions() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      binPromotionList = await _repository.getBinPromotions();
    } on ApiException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  // helper
  void _updatePromotionInList(PromotionModel promotion) {
    if (promotion.id == null) return;

    final index = promotionList.indexWhere(
          (item) => item.id == promotion.id,
    );

    if (index != -1) {
      promotionList[index] = promotion;
    }
  }


  // ============================================================
  // Clear Errors
  // ============================================================

  void clearErrors() {
    errorMessage = null;


    notifyListeners();
  }
}