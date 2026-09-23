import '../../../../res/api_url/app_url.dart';

class GeneralSettingModel {
  int? id;
  String? siteTitle;
  String? siteTagline;
  int? logo;
  int? favicon;
  int? dashboardLogo;
  int? ogImage;                    // <-- নতুন: management response-এ id হিসেবে আসে
  String? logoUrl;
  String? faviconUrl;
  String? dashboardLogoUrl;
  String? ogImageUrl;
  bool? useSameLogoForDashboard;
  String? logoBackgroundColor;
  bool? showSiteTitle;
  bool? showSiteTagline;
  String? contactEmail;
  String? phoneNumber;
  String? mailingAddress;
  List<SocialLinkData>? socialLinks;

  // ===== নতুন: SEO =====
  String? seoTitle;
  String? seoDescription;
  String? seoKeywords;
  bool? allowIndexing;
  String? defaultLanguage;

  // ===== নতুন: Analytics (চাইলে UI-তে যোগ করা যাবে) =====
  String? googleAnalyticsId;
  String? googleTagManagerId;
  String? metaPixelId;

  GeneralSettingModel({
    this.id,
    this.siteTitle,
    this.siteTagline,
    this.logo,
    this.favicon,
    this.dashboardLogo,
    this.ogImage,
    this.logoUrl,
    this.faviconUrl,
    this.dashboardLogoUrl,
    this.ogImageUrl,
    this.useSameLogoForDashboard,
    this.logoBackgroundColor,
    this.showSiteTitle,
    this.showSiteTagline,
    this.contactEmail,
    this.phoneNumber,
    this.mailingAddress,
    this.socialLinks,
    this.seoTitle,
    this.seoDescription,
    this.seoKeywords,
    this.allowIndexing,
    this.defaultLanguage,
    this.googleAnalyticsId,
    this.googleTagManagerId,
    this.metaPixelId,
  });

  static String? _resolveUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return raw.startsWith('http') ? raw : '${AppUrl.baseUrl}$raw';
  }

  GeneralSettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteTitle = json['site_title'];
    siteTagline = json['site_tagline'];
    logo = json['logo'];
    favicon = json['favicon'];
    dashboardLogo = json['dashboard_logo'];
    ogImage = json['og_image'];

    logoUrl = _resolveUrl(json['logo_url'] as String?);
    faviconUrl = _resolveUrl(json['favicon_url'] as String?);
    dashboardLogoUrl = _resolveUrl(json['dashboard_logo_url'] as String?);
    ogImageUrl = _resolveUrl(json['og_image_url'] as String?);

    useSameLogoForDashboard = json['use_same_logo_for_dashboard'];
    logoBackgroundColor = json['logo_background_color'];

    showSiteTitle = json['show_site_title'];
    showSiteTagline = json['show_site_tagline'];
    contactEmail = json['contact_email'];
    phoneNumber = json['phone_number'];
    mailingAddress = json['mailing_address'];

    seoTitle = json['seo_title'];
    seoDescription = json['seo_description'];
    seoKeywords = json['seo_keywords'];
    allowIndexing = json['allow_indexing'];
    defaultLanguage = json['default_language'];

    googleAnalyticsId = json['google_analytics_id'];
    googleTagManagerId = json['google_tag_manager_id'];
    metaPixelId = json['meta_pixel_id'];

    if (json['social_links'] != null) {
      socialLinks = <SocialLinkData>[];
      json['social_links'].forEach((v) {
        socialLinks!.add(SocialLinkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['site_title'] = this.siteTitle;
    data['site_tagline'] = this.siteTagline;
    data['logo'] = this.logo;
    data['favicon'] = this.favicon;
    data['dashboard_logo'] = this.dashboardLogo;
    data['og_image'] = this.ogImage;
    data['logo_url'] = this.logoUrl;
    data['favicon_url'] = this.faviconUrl;
    data['dashboard_logo_url'] = this.dashboardLogoUrl;
    data['og_image_url'] = this.ogImageUrl;
    data['use_same_logo_for_dashboard'] = this.useSameLogoForDashboard;
    data['logo_background_color'] = this.logoBackgroundColor;
    data['show_site_title'] = this.showSiteTitle;
    data['show_site_tagline'] = this.showSiteTagline;
    data['contact_email'] = this.contactEmail;
    data['phone_number'] = this.phoneNumber;
    data['mailing_address'] = this.mailingAddress;
    data['seo_title'] = this.seoTitle;
    data['seo_description'] = this.seoDescription;
    data['seo_keywords'] = this.seoKeywords;
    data['allow_indexing'] = this.allowIndexing;
    data['default_language'] = this.defaultLanguage;
    data['google_analytics_id'] = this.googleAnalyticsId;
    data['google_tag_manager_id'] = this.googleTagManagerId;
    data['meta_pixel_id'] = this.metaPixelId;
    if (this.socialLinks != null) {
      data['social_links'] = this.socialLinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class SocialLinkData {
  int? id;
  String? platform;
  String? url;
  String? iconClass;
  DateTime? createDate;
  DateTime? updateDate;

  SocialLinkData({
    this.id,
    this.platform,
    this.url,
    this.iconClass,
    this.createDate,
    this.updateDate,
  });

  SocialLinkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    platform = json['platform'];
    url = json['url'];
    iconClass = json['icon_class'];

    createDate = json['create_date'] != null
        ? DateTime.tryParse(json['create_date'])
        : null;

    updateDate = json['update_date'] != null
        ? DateTime.tryParse(json['update_date'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['platform'] = this.platform;
    data['url'] = this.url;
    data['icon_class'] = this.iconClass;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}

class PlatformChoiceData {
  String? value;
  String? label;

  PlatformChoiceData({this.value, this.label});

  PlatformChoiceData.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = this.value;
    data['label'] = this.label;
    return data;
  }
}