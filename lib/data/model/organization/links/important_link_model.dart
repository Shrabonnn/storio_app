class ImportantLinkModel {
  int? id;
  String? title;
  String? url;
  int? order;
  DateTime? createdAt;
  DateTime? updatedAt;

  ImportantLinkModel({
    this.id,
    this.title,
    this.url,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  ImportantLinkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    order = json['order'];

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
    data['url'] = this.url;
    data['order'] = this.order;
    data['created_at'] = this.createdAt?.toIso8601String();
    data['updated_at'] = this.updatedAt?.toIso8601String();
    return data;
  }
}