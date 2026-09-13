import '../../../../res/api_url/app_url.dart';

class EventModel {
  int? id;
  String? title;
  String? slug;
  String? content;
  String? excerpt;
  String? location;
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  bool? isFeatured;
  int? viewCount;
  String? seoTitle;
  String? seoDescription;
  int? featuredImage;
  FeaturedImageDetail? featuredImageDetail;
  List<int>? categories;
  List<CategoriesDetail>? categoriesDetail;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;

  EventModel(
      {this.id,
        this.title,
        this.slug,
        this.content,
        this.excerpt,
        this.location,
        this.startDate,
        this.endDate,
        this.status,
        this.isFeatured,
        this.viewCount,
        this.seoTitle,
        this.seoDescription,
        this.featuredImage,
        this.featuredImageDetail,
        this.categories,
        this.categoriesDetail,
        this.createdAt,
        this.updatedAt,
        this.createdBy});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    content = json['content'];
    excerpt = json['excerpt'];
    location = json['location'];
    startDate = json['start_date'] !=null
        ?DateTime.parse(json['start_date'])
        :null ;
    endDate = json['end_date'] !=null
        ?DateTime.parse(json['end_date'])
        :null;
    status = json['status'];
    isFeatured = json['is_featured'];
    viewCount = json['view_count'];
    seoTitle = json['seo_title'];
    seoDescription = json['seo_description'];
    featuredImage = json['featured_image'];
    featuredImageDetail = json['featured_image_detail'] != null
        ? new FeaturedImageDetail.fromJson(json['featured_image_detail'])
        : null;
    categories =  json['categories'] != null
        ? List<int>.from(json['categories'])
        : null;
    if (json['categories_detail'] != null) {
      categoriesDetail = <CategoriesDetail>[];
      json['categories_detail'].forEach((v) {
        categoriesDetail!.add(new CategoriesDetail.fromJson(v));
      });
    }
    createdAt = json['created_at'] !=null
        ?DateTime.parse(json['created_at'])
        :null;
    updatedAt = json['updated_at'] !=null
        ?DateTime.parse(json['updated_at'])
        :null;
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['content'] = this.content;
    data['excerpt'] = this.excerpt;
    data['location'] = this.location;
    data['start_date'] = this.startDate?.toIso8601String();
    data['end_date'] = this.endDate?.toIso8601String();
    data['status'] = this.status;
    data['is_featured'] = this.isFeatured;
    data['view_count'] = this.viewCount;
    data['seo_title'] = this.seoTitle;
    data['seo_description'] = this.seoDescription;
    data['featured_image'] = this.featuredImage;
    if (this.featuredImageDetail != null) {
      data['featured_image_detail'] = this.featuredImageDetail!.toJson();
    }
    data['categories'] = this.categories;
    if (this.categoriesDetail != null) {
      data['categories_detail'] =
          this.categoriesDetail!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt?.toIso8601String();
    data['updated_at'] = this.updatedAt?.toIso8601String();
    data['created_by'] = this.createdBy;
    return data;
  }
}

class FeaturedImageDetail {
  int? id;
  String? file;
  String? fileName;

  FeaturedImageDetail({this.id, this.file, this.fileName});

  FeaturedImageDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    final rawFile = json['file'] as String?;
    file = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file'] = this.file;
    data['fileName'] = this.fileName;
    return data;
  }
}

class CategoriesDetail {
  int? id;
  String? name;
  String? slug;
  int? eventsCount;

  CategoriesDetail({this.id, this.name, this.slug, this.eventsCount});

  CategoriesDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    eventsCount = json['events_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['events_count'] = this.eventsCount;
    return data;
  }
}
