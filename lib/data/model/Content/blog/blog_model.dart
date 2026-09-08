import '../../../../res/api_url/app_url.dart';

class BlogModel {
  int? id;
  String? title;
  String? slug;
  String? content;
  String? excerpt;
  String? author;
  String? status;
  String? statusDisplay;
  List<String>? tags;
  DateTime? publishDate;
  DateTime? deletedAt;
  int? createdBy;
  int? featuredImage;
  FeaturedImageData? featuredImageData;
  String? seoTitle;
  String? seoDescription;
  int? viewCount;
  bool? isFeatured;
  List<int>? categories;
  List<CategoriesData>? categoriesData;
  DateTime? createDate;
  DateTime? updateDate;

  BlogModel(
      {this.id,
        this.title,
        this.slug,
        this.content,
        this.excerpt,
        this.author,
        this.status,
        this.statusDisplay,
        this.tags,
        this.publishDate,
        this.deletedAt,
        this.createdBy,
        this.featuredImage,
        this.featuredImageData,
        this.seoTitle,
        this.seoDescription,
        this.viewCount,
        this.isFeatured,
        this.categories,
        this.categoriesData,
        this.createDate,
        this.updateDate});

  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    content = json['content'];
    excerpt = json['excerpt'];
    author = json['author'];
    status = json['status'];
    statusDisplay = json['status_display'];

    if (json['tags'] != null) {
      tags = List<String>.from(json['tags']);
    }

    publishDate = json['publish_date'] != null
        ? DateTime.tryParse(json['publish_date'])
        : null;

    deletedAt = json['deleted_at'] != null
        ? DateTime.tryParse(json['deleted_at'])
        : null;

    createdBy = json['created_by'];
    featuredImage = json['featured_image'];

    featuredImageData = json['featured_image_data'] != null
        ? FeaturedImageData.fromJson(json['featured_image_data'])
        : null;

    seoTitle = json['seo_title'];
    seoDescription = json['seo_description'];
    viewCount = json['view_count'];
    isFeatured = json['is_featured'];

    if (json['categories'] != null) {
      categories = List<int>.from(json['categories']);
    }

    if (json['categories_data'] != null) {
      categoriesData = <CategoriesData>[];
      json['categories_data'].forEach((v) {
        categoriesData!.add(CategoriesData.fromJson(v));
      });
    }

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
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['content'] = this.content;
    data['excerpt'] = this.excerpt;
    data['author'] = this.author;
    data['status'] = this.status;
    data['status_display'] = this.statusDisplay;
    data['tags'] = this.tags;
    data['publish_date'] = this.publishDate?.toIso8601String();
    data['deleted_at'] = this.deletedAt?.toIso8601String();
    data['created_by'] = this.createdBy;
    data['featured_image'] = this.featuredImage;
    data['featured_image_data'] = this.featuredImageData?.toJson();
    data['seo_title'] = this.seoTitle;
    data['seo_description'] = this.seoDescription;
    data['view_count'] = this.viewCount;
    data['is_featured'] = this.isFeatured;
    data['categories'] = this.categories;
    if (this.categoriesData != null) {
      data['categories_data'] =
          this.categoriesData!.map((v) => v.toJson()).toList();
    }
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}

class FeaturedImageData {
  int? id;
  String? uploadedBy;
  String? fileSizeDisplay;
  String? file;
  DateTime? createDate;
  DateTime? updateDate;
  String? fileType;
  String? fileName;
  int? fileSize;
  String? title;
  String? altText;
  String? caption;
  String? description;

  FeaturedImageData(
      {this.id,
        this.uploadedBy,
        this.fileSizeDisplay,
        this.file,
        this.createDate,
        this.updateDate,
        this.fileType,
        this.fileName,
        this.fileSize,
        this.title,
        this.altText,
        this.caption,
        this.description});

  FeaturedImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uploadedBy = json['uploaded_by'];
    fileSizeDisplay = json['file_size_display'];

    final rawFile = json['file'] as String?;
    file = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;

    createDate = json['create_date'] != null
        ? DateTime.tryParse(json['create_date'])
        : null;

    updateDate = json['update_date'] != null
        ? DateTime.tryParse(json['update_date'])
        : null;

    fileType = json['file_type'];
    fileName = json['file_name'];
    fileSize = json['file_size'];
    title = json['title'];
    altText = json['alt_text'];
    caption = json['caption'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['uploaded_by'] = this.uploadedBy;
    data['file_size_display'] = this.fileSizeDisplay;
    data['file'] = this.file;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    data['file_type'] = this.fileType;
    data['file_name'] = this.fileName;
    data['file_size'] = this.fileSize;
    data['title'] = this.title;
    data['alt_text'] = this.altText;
    data['caption'] = this.caption;
    data['description'] = this.description;
    return data;
  }
}

class CategoriesData {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? parent;
  String? parentName;
  int? postsCount;
  DateTime? createDate;
  DateTime? updateDate;

  CategoriesData(
      {this.id,
        this.name,
        this.slug,
        this.description,
        this.parent,
        this.parentName,
        this.postsCount,
        this.createDate,
        this.updateDate});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    parent = json['parent'];
    parentName = json['parent_name'];
    postsCount = json['posts_count'];

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
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['parent'] = this.parent;
    data['parent_name'] = this.parentName;
    data['posts_count'] = this.postsCount;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}