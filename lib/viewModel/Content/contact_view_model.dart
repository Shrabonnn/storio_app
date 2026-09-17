import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/contact/contact_model.dart';
import '../../data/repository/content/contact_repository.dart';

class ContactViewModel extends ChangeNotifier {
  final ContactRepository _repository = ContactRepository();

  List<ContactMessageModel> messageList = [];
  bool loading = false;
  String? errorMessage;

  ContactMessageModel? messageDetail;
  bool messageDetailLoading = false;

  bool submitting = false;
  String? submitErrorMessage;

  // ============================================================
  // Submit (Public contact form)
  // ============================================================

  Future<bool> submitContactMessage({
    required String name,
    required String email,
    String? mobile,
    required String subject,
    required String message,
    String? recaptchaToken,
  }) async {
    submitting = true;
    submitErrorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.submitContactMessage(
        name: name,
        email: email,
        mobile: mobile,
        subject: subject,
        message: message,
        recaptchaToken: recaptchaToken,
      );
      return success;
    } on ApiException catch (e) {
      submitErrorMessage = e.message;
      return false;
    } catch (e) {
      submitErrorMessage = "Failed to send your message. Please try again.";
      return false;
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  // ============================================================
  // GET LIST
  // ============================================================

  // ============================================================
  // GET LIST (With Caching Support)
  // ============================================================

  Future<void> getContactMessageApi({
    String? status,
    String? search,
    bool isFilterOrSearch = false,
  }) async {
     if (isFilterOrSearch || messageList.isEmpty) {
      loading = true;
      errorMessage = null;
      notifyListeners();
    }

    try {
      messageList = await _repository.getContactMessages(
        status: status,
        search: search,
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
  // GET DETAIL
  // ============================================================

  Future<void> getContactMessageDetail(int id) async {
    messageDetailLoading = true;
    notifyListeners();

    try {
      messageDetail = await _repository.getContactMessageDetail(id);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load message details.";
    } finally {
      messageDetailLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // STATUS ACTIONS
  // ============================================================

  Future<bool> markAsRead(int id) async {
    try {
      final success = await _repository.markAsRead(id);
      if (success) _updateLocalStatus(id, "read", readAt: DateTime.now());
      return success;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to mark message as read.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAsReplied(int id) async {
    try {
      final success = await _repository.markAsReplied(id);
      if (success) _updateLocalStatus(id, "replied");
      return success;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to mark message as replied.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAsArchived(int id) async {
    try {
      final success = await _repository.markAsArchived(id);
      if (success) _updateLocalStatus(id, "archived");
      return success;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to archive message.";
      notifyListeners();
      return false;
    }
  }

  void _updateLocalStatus(int id, String status, {DateTime? readAt}) {
    final index = messageList.indexWhere((item) => item.id == id);
    if (index != -1) {
      messageList[index].status = status;
      if (readAt != null) {
        messageList[index].readAt = readAt;
      }
    }

    if (messageDetail?.id == id) {
      messageDetail!.status = status;
      if (readAt != null) {
        messageDetail!.readAt = readAt;
      }
    }

    notifyListeners();

  }



  // ============================================================
  // DELETE
  // ============================================================

  Future<bool> deleteContactMessage(int id) async {
    try {
      await _repository.deleteContactMessage(id);
      messageList.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete message.";
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // CLEAR DATA (For Logout)
  // ============================================================

  void clearData() {
    messageList.clear();
    messageDetail = null;
    errorMessage = null;
    notifyListeners();
  }
}