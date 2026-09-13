import '../../../../res/api_url/app_url.dart';

class GalleryModel {
  int? id;
  int? media;
  MediaData? mediaData;
  String? imageTitle;
  int? album;
  String? albumName;
  List<String>? tags;
  bool? isVisible;
  DateTime? createDate;
  DateTime? updateDate;

  GalleryModel({
    this.id,
    this.media,
    this.mediaData,
    this.imageTitle,
    this.album,
    this.albumName,
    this.tags,
    this.isVisible,
    this.createDate,
    this.updateDate,
  });

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    media = json['media'];
    mediaData = json['media_data'] != null ? MediaData.fromJson(json['media_data']) : null;
    imageTitle = json['image_title'];
    album = json['album'];
    albumName = json['album_name'];

    if (json['tags'] != null) {
      tags = List<String>.from(json['tags']);
    }

    isVisible = json['is_visible'];

    createDate = json['create_date'] != null ? DateTime.tryParse(json['create_date']) : null;
    updateDate = json['update_date'] != null ? DateTime.tryParse(json['update_date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['media'] = this.media;
    data['media_data'] = this.mediaData?.toJson();
    data['image_title'] = this.imageTitle;
    data['album'] = this.album;
    data['album_name'] = this.albumName;
    data['tags'] = this.tags;
    data['is_visible'] = this.isVisible;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}

class MediaData {
  int? id;
  String? file;
  String? fileType;
  String? fileName;
  int? fileSize;
  String? title;
  String? description;
  String? altText;
  String? caption;
  String? uploadedBy;
  DateTime? createDate;
  DateTime? updateDate;

  MediaData({
    this.id,
    this.file,
    this.fileType,
    this.fileName,
    this.fileSize,
    this.title,
    this.description,
    this.altText,
    this.caption,
    this.uploadedBy,
    this.createDate,
    this.updateDate,
  });

  MediaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    final rawFile = json['file'] as String?;
    file = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;
    fileType = json['file_type'];
    fileName = json['file_name'];
    fileSize = json['file_size'];
    title = json['title'];
    description = json['description'];
    altText = json['alt_text'];
    caption = json['caption'];
    uploadedBy = json['uploaded_by'];
    createDate = json['create_date'] != null ? DateTime.tryParse(json['create_date']) : null;
    updateDate = json['update_date'] != null ? DateTime.tryParse(json['update_date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['file'] = this.file;
    data['file_type'] = this.fileType;
    data['file_name'] = this.fileName;
    data['file_size'] = this.fileSize;
    data['title'] = this.title;
    data['description'] = this.description;
    data['alt_text'] = this.altText;
    data['caption'] = this.caption;
    data['uploaded_by'] = this.uploadedBy;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}

class AlbumModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? parent;
  String? parentName;
  int? totalImages;
  DateTime? createDate;
  DateTime? updateDate;

  AlbumModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.parent,
    this.parentName,
    this.totalImages,
    this.createDate,
    this.updateDate,
  });

  AlbumModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    parent = json['parent'];
    parentName = json['parent_name'];
    totalImages = json['total_images'];
    createDate = json['create_date'] != null ? DateTime.tryParse(json['create_date']) : null;
    updateDate = json['update_date'] != null ? DateTime.tryParse(json['update_date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['parent'] = this.parent;
    data['parent_name'] = this.parentName;
    data['total_images'] = this.totalImages;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}