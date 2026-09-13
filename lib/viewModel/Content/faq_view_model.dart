import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/faq/faq_model.dart';
import '../../data/repository/content/faq_repository.dart';

class FaqViewModel extends ChangeNotifier {
  final FaqRepository _repository = FaqRepository();

  // ------------------------------------------------------------
  // FAQ list state (Management)
  // ------------------------------------------------------------
  List<FaqModel> faqList = [];
  bool loading = false;
  String? errorMessage;

  // ------------------------------------------------------------
  // FAQ detail state
  // ------------------------------------------------------------
  FaqModel? faqDetail;
  bool faqDetailLoading = false;

  // ============================================================
  // GET FAQ LIST (Management)
  // ============================================================
  Future<void> getFaqApi() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      faqList = await _repository.getFaqList();
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
  // GET FAQ DETAIL
  // ============================================================
  Future<void> getFaqDetail(int id) async {
    faqDetailLoading = true;
    notifyListeners();

    try {
      faqDetail = await _repository.getFaqDetail(id);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load FAQ details.";
    } finally {
      faqDetailLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREATE FAQ
  // ============================================================
  Future<bool> createFaq(Map<String, dynamic> data) async {
    try {
      await _repository.createFaq(data);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to create FAQ.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // UPDATE FAQ
  // ============================================================
  Future<bool> updateFaq(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateFaq(id, data);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to update FAQ.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // DELETE FAQ
  // ============================================================
  Future<bool> deleteFaq(int id) async {
    try {
      await _repository.deleteFaq(id);

      faqList.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete FAQ.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // TOGGLE VISIBILITY (quick patch helper)
  // ============================================================
  Future<bool> toggleVisibility(int id, bool isVisible) async {
    return updateFaq(id, {"is_visible": isVisible});
  }
}