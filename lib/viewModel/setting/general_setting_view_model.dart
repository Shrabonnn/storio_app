import 'package:flutter/foundation.dart';

import '../../data/model/settings/general_settings_model.dart';
import '../../data/repository/settings/gerenal_setting_repository.dart';

class GeneralSettingViewModel extends ChangeNotifier {
  final GeneralSettingRepository _repository = GeneralSettingRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  GeneralSettingModel? _generalSetting;
  GeneralSettingModel? get generalSetting => _generalSetting;

  List<SocialLinkData> _socialLinks = [];
  List<SocialLinkData> get socialLinks => _socialLinks;

  List<PlatformChoiceData> _platformChoices = [];
  List<PlatformChoiceData> get platformChoices => _platformChoices;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  Future<void> fetchPublicSettings() async {
    _setLoading(true);
    clearMessages();
    try {
      _generalSetting = await _repository.getPublicSettings();
      _socialLinks = _generalSetting?.socialLinks ?? [];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchManagementSettings() async {
    _setLoading(true);
    clearMessages();
    try {
      _generalSetting = await _repository.getManagementSettings();
      _socialLinks = _generalSetting?.socialLinks ?? [];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateGeneralSettings({
    String? siteTitle,
    String? siteTagline,
    int? logo,
    int? favicon,
    int? dashboardLogo,
    int? ogImage,
    bool? useSameLogoForDashboard,
    String? logoBackgroundColor,
    bool? showSiteTitle,
    bool? showSiteTagline,
    String? contactEmail,
    String? phoneNumber,
    String? mailingAddress,
    // ===== নতুন =====
    String? seoTitle,
    String? seoDescription,
    String? seoKeywords,
    bool? allowIndexing,
    String? defaultLanguage,
    bool isPatch = true,
  }) async {
    _setLoading(true);
    clearMessages();
    try {
      final currentSocialLinkIds =
      _socialLinks.where((e) => e.id != null).map((e) => e.id!).toList();

      final Map<String, dynamic> body = {
        if (siteTitle != null) 'site_title': siteTitle,
        if (siteTagline != null) 'site_tagline': siteTagline,
        if (logo != null) 'logo': logo,
        if (favicon != null) 'favicon': favicon,
        if (dashboardLogo != null) 'dashboard_logo': dashboardLogo,
        if (ogImage != null) 'og_image': ogImage,
        if (useSameLogoForDashboard != null) 'use_same_logo_for_dashboard': useSameLogoForDashboard,
        if (logoBackgroundColor != null) 'logo_background_color': logoBackgroundColor,
        if (showSiteTitle != null) 'show_site_title': showSiteTitle,
        if (showSiteTagline != null) 'show_site_tagline': showSiteTagline,
        if (contactEmail != null) 'contact_email': contactEmail,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (mailingAddress != null) 'mailing_address': mailingAddress,
        if (seoTitle != null) 'seo_title': seoTitle,
        if (seoDescription != null) 'seo_description': seoDescription,
        if (seoKeywords != null) 'seo_keywords': seoKeywords,
        if (allowIndexing != null) 'allow_indexing': allowIndexing,
        if (defaultLanguage != null) 'default_language': defaultLanguage,
        'social_link_ids': currentSocialLinkIds,
      };

      _generalSetting = await _repository.updateSettings(body, isPatch: isPatch);
      _socialLinks = _generalSetting?.socialLinks ?? _socialLinks;
      _successMessage = "Settings updated successfully!";
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============ SOCIAL LINKS ============

  Future<void> fetchSocialLinks({String? searchQuery}) async {
    _setLoading(true);
    clearMessages();
    try {
      _socialLinks = await _repository.getSocialLinks(searchQuery: searchQuery);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addSocialLink({required String platform, required String url}) async {
    _setLoading(true);
    clearMessages();
    try {
      final newLink = await _repository.createSocialLink(platform: platform, url: url);
      _socialLinks.add(newLink);
      _successMessage = "Social link created successfully!";
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> editSocialLink({required int id, required String platform, required String url}) async {
    _setLoading(true);
    clearMessages();
    try {
      final updatedLink = await _repository.updateSocialLink(id: id, platform: platform, url: url);
      final index = _socialLinks.indexWhere((element) => element.id == id);
      if (index != -1) _socialLinks[index] = updatedLink;
      _successMessage = "Social link updated successfully!";
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteSocialLink(int id) async {
    _setLoading(true);
    clearMessages();
    try {
      await _repository.deleteSocialLink(id);
      _socialLinks.removeWhere((e) => e.id == id);
      _successMessage = "Social link removed successfully!";
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPlatformChoices() async {
    try {
      _platformChoices = await _repository.getPlatformChoices();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}