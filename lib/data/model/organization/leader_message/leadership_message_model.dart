import '../../../../res/api_url/app_url.dart';

class LeadershipMessageModel {
  int? id;
  String? sectionTitle;
  String? name;
  String? role;
  String? company;
  String? message;
  int? image;
  LeadershipMediaData? imageData;
  int? signature;
  LeadershipMediaData? signatureData;
  String? status;
  int? displayOrder;
  DateTime? createDate;
  DateTime? updateDate;

  LeadershipMessageModel({
    this.id,
    this.sectionTitle,
    this.name,
    this.role,
    this.company,
    this.message,
    this.image,
    this.imageData,
    this.signature,
    this.signatureData,
    this.status,
    this.displayOrder,
    this.createDate,
    this.updateDate,
  });

  LeadershipMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sectionTitle = json['section_title'];
    name = json['name'];
    role = json['role'];
    company = json['company'];
    message = json['message'];
    image = json['image'];

    imageData = json['image_data'] != null
        ? LeadershipMediaData.fromJson(json['image_data'])
        : null;

    signature = json['signature'];

    signatureData = json['signature_data'] != null
        ? LeadershipMediaData.fromJson(json['signature_data'])
        : null;

    status = json['status'];
    displayOrder = json['display_order'];

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
    data['section_title'] = this.sectionTitle;
    data['name'] = this.name;
    data['role'] = this.role;
    data['company'] = this.company;
    data['message'] = this.message;
    data['image'] = this.image;
    if (this.imageData != null) {
      data['image_data'] = this.imageData!.toJson();
    }
    data['signature'] = this.signature;
    if (this.signatureData != null) {
      data['signature_data'] = this.signatureData!.toJson();
    }
    data['status'] = this.status;
    data['display_order'] = this.displayOrder;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}


class LeadershipMediaData {
  int? id;
  String? fileUrl;
  String? altText;
  String? fileType;

  LeadershipMediaData({
    this.id,
    this.fileUrl,
    this.altText,
    this.fileType,
  });

  LeadershipMediaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    final rawFile = json['file_url'] as String?;
    fileUrl = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;

    altText = json['alt_text'];
    fileType = json['file_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['file_url'] = this.fileUrl;
    data['alt_text'] = this.altText;
    data['file_type'] = this.fileType;
    return data;
  }
}