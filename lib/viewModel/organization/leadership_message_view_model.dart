import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/organization/leader_message/leadership_message_model.dart';
import '../../data/model/organization/leader_message/leadership_message_status_choice_model.dart';
import '../../data/repository/organization/leadership_message_repository.dart';

class LeadershipMessageViewModel extends ChangeNotifier {
  final LeadershipMessageRepository _repository = LeadershipMessageRepository();


  // Message list state

  List<LeadershipMessageModel> messageList = [];
  bool loading = false;
  String? errorMessage;

  // Message detail state

  LeadershipMessageModel? messageDetail;
  bool messageDetailLoading = false;


  // Status choices state

  List<LeadershipMessageStatusChoiceModel> statusChoices = [];
  bool statusLoading = false;

  // ============================================================
  // GET MESSAGE LIST
  // ============================================================
  Future<void> getMessageApi({String? search, String? status}) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      messageList = await _repository.getMessageList(
        search: search,
        status: status,
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

  // GET MESSAGE DETAIL

  Future<void> getMessageDetail(int id) async {
    messageDetailLoading = true;
    notifyListeners();

    try {
      messageDetail = await _repository.getMessageDetail(id);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load message details.";
    } finally {
      messageDetailLoading = false;
      notifyListeners();
    }
  }


  // GET STATUS CHOICES

  Future<void> getStatusChoices() async {
    statusLoading = true;
    notifyListeners();

    try {
      statusChoices = await _repository.getStatusChoices();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load status choices.";
    } finally {
      statusLoading = false;
      notifyListeners();
    }
  }


  // CREATE MESSAGE

  Future<bool> createMessage(Map<String, dynamic> data) async {
    try {
      await _repository.createMessage(data);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to create leadership message.";
      notifyListeners();
      return false;
    }
  }


  // UPDATE MESSAGE

  Future<bool> updateMessage(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateMessage(id, data);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to update leadership message.";
      notifyListeners();
      return false;
    }
  }


  // DELETE MESSAGE

  Future<bool> deleteMessage(int id) async {
    try {
      await _repository.deleteMessage(id);
      messageList.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete leadership message.";
      notifyListeners();
      return false;
    }
  }


  // BULK OPERATIONS (publish / draft / delete)

  Future<bool> bulkAction({
    required String action,
    required List<int> ids,
  }) async {
    try {
      await _repository.bulkOperation(action: action, ids: ids);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Bulk action failed.";
      notifyListeners();
      return false;
    }
  }


  // REORDER MESSAGES (drag-and-drop)

  Future<bool> reorderMessages(List<int> orderedIds) async {
    try {
      await _repository.reorderMessages(orderedIds);

      final reordered = <LeadershipMessageModel>[];
      for (final id in orderedIds) {
        final match = messageList.where((item) => item.id == id);
        if (match.isNotEmpty) reordered.add(match.first);
      }
      if (reordered.length == messageList.length) {
        messageList = reordered;
        notifyListeners();
      }

      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to reorder messages.";
      notifyListeners();
      return false;
    }
  }
}