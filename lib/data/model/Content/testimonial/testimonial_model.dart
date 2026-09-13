import '../../../../res/api_url/app_url.dart';

class TestimonialModel {
  int? id;
  String? name;
  String? designation;
  String? organization;
  String? message;
  int? rating;
  int? photo;
  PhotoData? photoData;
  String? status;
  int? order;
  DateTime? createDate;
  DateTime? updateDate;

  TestimonialModel(
      {this.id,
        this.name,
        this.designation,
        this.organization,
        this.message,
        this.rating,
        this.photo,
        this.photoData,
        this.status,
        this.order,
        this.createDate,
        this.updateDate});

  TestimonialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    designation = json['designation'];
    organization = json['organization'];
    message = json['message'];
    rating = json['rating'];
    photo = json['photo'];
    photoData = json['photo_data'] != null
        ? new PhotoData.fromJson(json['photo_data'])
        : null;
    status = json['status'];
    order = json['order'];
    createDate = json['create_date'] !=null
        ? DateTime.parse(json['create_date'])
        :null;
    updateDate = json['update_date']!=null
        ? DateTime.parse(json['update_date'])
        :null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['designation'] = this.designation;
    data['organization'] = this.organization;
    data['message'] = this.message;
    data['rating'] = this.rating;
    data['photo'] = this.photo;
    if (this.photoData != null) {
      data['photo_data'] = this.photoData!.toJson();
    }
    data['status'] = this.status;
    data['order'] = this.order;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}

class PhotoData {
  int? id;
  String? fileUrl;
  String? altText;
  String? fileType;

  PhotoData({this.id, this.fileUrl, this.altText, this.fileType});

  PhotoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    final rawFile = json['file_url'] as String?;
    fileUrl = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;
    altText = json['alt_text'];
    fileType = json['file_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_url'] = this.fileUrl;
    data['alt_text'] = this.altText;
    data['file_type'] = this.fileType;
    return data;
  }
}
