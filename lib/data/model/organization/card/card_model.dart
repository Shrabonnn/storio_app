import '../../../../res/api_url/app_url.dart';

class CardModel {
  int? id;
  int? institutionProfile;
  String? title;
  String? description;
  String? icon;
  int? image;
  String? imageUrl;
  int? order;
  DateTime? createdAt;
  DateTime? updatedAt;

  CardModel({
    this.id,
    this.institutionProfile,
    this.title,
    this.description,
    this.icon,
    this.image,
    this.imageUrl,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionProfile = json['institution_profile'];
    title = json['title'];
    description = json['description'];
    icon = json['icon'];
    image = json['image'];

    final rawImageUrl = json['image_url'] as String?;
    imageUrl = (rawImageUrl != null && rawImageUrl.isNotEmpty)
        ? (rawImageUrl.startsWith('http')
        ? rawImageUrl
        : '${AppUrl.baseUrl}$rawImageUrl')
        : null;

    order = json['order'];

    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;

    updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['institution_profile'] = this.institutionProfile;
    data['title'] = this.title;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    data['order'] = this.order;
    data['created_at'] = this.createdAt?.toIso8601String();
    data['updated_at'] = this.updatedAt?.toIso8601String();

    return data;
  }
}