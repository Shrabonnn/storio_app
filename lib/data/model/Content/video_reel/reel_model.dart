import '../../../../res/api_url/app_url.dart';

class ReelModel {
  int? id;
  String? title;
  String? type; // reel / video
  String? platform; // youtube / instagram / tiktok / vimeo / custom
  String? url;
  String? thumbnail;
  String? status; // active / draft
  String? description;
  int? views;
  int? likes;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReelModel({
    this.id,
    this.title,
    this.type,
    this.platform,
    this.url,
    this.thumbnail,
    this.status,
    this.description,
    this.views,
    this.likes,
    this.createdAt,
    this.updatedAt,
  });

  ReelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    platform = json['platform'];
    final rawFile = json['url'] as String?;
    url = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;
    //url = json['url'];
    final rawThumbnail = json['thumbnail'] as String?;
    thumbnail = (rawThumbnail != null && rawThumbnail.isNotEmpty)
        ? (rawThumbnail.startsWith('http')
        ? rawThumbnail
        : '${AppUrl.baseUrl}$rawThumbnail')
        : null;
    status = json['status'];
    description = json['description'];
    views = json['views'];
    likes = json['likes'];

    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;

    updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['platform'] = this.platform;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    data['status'] = this.status;
    data['description'] = this.description;
    data['views'] = this.views;
    data['likes'] = this.likes;
    data['created_at'] = this.createdAt?.toIso8601String();
    data['updated_at'] = this.updatedAt?.toIso8601String();
    return data;
  }
}

// ============================================================
// Wrapper for list responses -> { "count": 1, "data": [...] }
// ============================================================
class ReelListResponse {
  int? count;
  List<ReelModel>? data;

  ReelListResponse({this.count, this.data});

  ReelListResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <ReelModel>[];
      json['data'].forEach((v) {
        data!.add(ReelModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}