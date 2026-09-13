import '../../../../res/api_url/app_url.dart';

class PromotionModel {
  int? id;
  String? createdBy;
  ImageDetail? imageDetail;
  bool? isLive;
  String? title;
  String? subtitle;
  String? description;
  String? badgeText;
  int? image;
  String? promotionType;
  String? targetAudience;
  String? ctaLabel;
  String? ctaUrl;
  bool? ctaIsExternal;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  int? priority;
  int? viewCount;
  int? clickCount;
  DateTime? createDate;
  DateTime? updateDate;

  PromotionModel(
      {this.id,
        this.createdBy,
        this.imageDetail,
        this.isLive,
        this.title,
        this.subtitle,
        this.description,
        this.badgeText,
        this.image,
        this.promotionType,
        this.targetAudience,
        this.ctaLabel,
        this.ctaUrl,
        this.ctaIsExternal,
        this.status,
        this.startDate,
        this.endDate,
        this.priority,
        this.viewCount,
        this.clickCount,
        this.createDate,
        this.updateDate});

  PromotionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    imageDetail = json['image_detail'] != null
        ? new ImageDetail.fromJson(json['image_detail'])
        : null;
    isLive = json['is_live'];
    title = json['title'];
    subtitle = json['subtitle'];
    description = json['description'];
    badgeText = json['badge_text'];
    image = json['image'];
    promotionType = json['promotion_type'];
    targetAudience = json['target_audience'];
    ctaLabel = json['cta_label'];
    ctaUrl = json['cta_url'];
    ctaIsExternal = json['cta_is_external'];
    status = json['status'];
    startDate = json['start_date']!= null 
        ?  DateTime.parse(json['start_date'])
        :null;
    endDate = json['end_date']!= null
        ?  DateTime.parse(json['end_date'])
        :null;
    priority = json['priority'];
    viewCount = json['view_count'];
    clickCount = json['click_count'];
    createDate = json['create_date']!= null
        ?  DateTime.parse(json['create_date'])
        :null;
    updateDate = json['update_date']!= null
        ?  DateTime.parse(json['update_date'])
        :null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    if (this.imageDetail != null) {
      data['image_detail'] = this.imageDetail!.toJson();
    }
    data['is_live'] = this.isLive;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['description'] = this.description;
    data['badge_text'] = this.badgeText;
    data['image'] = this.image;
    data['promotion_type'] = this.promotionType;
    data['target_audience'] = this.targetAudience;
    data['cta_label'] = this.ctaLabel;
    data['cta_url'] = this.ctaUrl;
    data['cta_is_external'] = this.ctaIsExternal;
    data['status'] = this.status;
    data['start_date'] = this.startDate?.toIso8601String();
    data['end_date'] = this.endDate?.toIso8601String();
    data['priority'] = this.priority;
    data['view_count'] = this.viewCount;
    data['click_count'] = this.clickCount;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = {};

    data['title'] = title;
    data['subtitle'] = subtitle;
    data['description'] = description;
    data['badge_text'] = badgeText;
    data['cta_label'] = ctaLabel;
    data['cta_url'] = ctaUrl;
    data['cta_is_external'] = ctaIsExternal;
    data['status'] = status;
    data['priority'] = priority;

    if (image != null) {
      data['image'] = image;
    }

    if (startDate != null) {
      data['start_date'] =
          startDate!.toIso8601String().split('T').first;
    }

    if (endDate != null) {
      data['end_date'] =
          endDate!.toIso8601String().split('T').first;
    }

    return data;
  }
}

class ImageDetail {
  int? id;
  String? file;
  String? fileName;
  String? fileType;
  String? title;
  String? altText;

  ImageDetail(
      {this.id,
        this.file,
        this.fileName,
        this.fileType,
        this.title,
        this.altText});

  ImageDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    final rawFile = json['file'] as String?;
    file = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;
    fileName = json['file_name'];
    fileType = json['file_type'];
    title = json['title'];
    altText = json['alt_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file'] = this.file;
    data['file_name'] = this.fileName;
    data['file_type'] = this.fileType;
    data['title'] = this.title;
    data['alt_text'] = this.altText;
    return data;
  }


}
