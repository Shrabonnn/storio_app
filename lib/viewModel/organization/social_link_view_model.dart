import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/organization/links/social_links_model.dart';
import '../../data/repository/organization/social_link_repository.dart';

class SocialLinkViewModel extends ChangeNotifier {
  final SocialLinkRepository _repository = SocialLinkRepository();

  List<SocialLinkModel> socialLinkList = [];
  bool loading = false;
  String? errorMessage;

  List<SocialLinkPlatformChoiceModel> platformChoices = [];
  bool platformLoading = false;

  Future<void> getSocialLinkApi({String? search}) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      socialLinkList = await _repository.getSocialLinks(search: search);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> getPlatformChoices() async {
    platformLoading = true;
    notifyListeners();

    try {
      platformChoices = await _repository.getPlatformChoices();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load platform choices.";
    } finally {
      platformLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createSocialLink(Map<String, dynamic> data) async {
    try {
      final link = await _repository.createSocialLink(data);
      socialLinkList.insert(0, link);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to create social link.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSocialLink(int id, Map<String, dynamic> data) async {
    try {
      final link = await _repository.updateSocialLink(id, data);

      final index = socialLinkList.indexWhere((item) => item.id == id);
      if (index != -1) {
        socialLinkList[index] = link;
        notifyListeners();
      }

      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to update social link.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSocialLink(int id) async {
    try {
      await _repository.deleteSocialLink(id);
      socialLinkList.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete social link.";
      notifyListeners();
      return false;
    }
  }
}