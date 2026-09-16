class SocialLinkModel {
  int? id;
  String? platform;
  String? url;
  String? iconClass;
  DateTime? createDate;
  DateTime? updateDate;

  SocialLinkModel({
    this.id,
    this.platform,
    this.url,
    this.iconClass,
    this.createDate,
    this.updateDate,
  });

  SocialLinkModel.fromJson(Map<String, dynamic> json) {
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

class SocialLinkPlatformChoiceModel {
  final String value;
  final String label;

  SocialLinkPlatformChoiceModel({
    required this.value,
    required this.label,
  });

  factory SocialLinkPlatformChoiceModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkPlatformChoiceModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}