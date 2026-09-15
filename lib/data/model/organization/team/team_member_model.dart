import '../../../../res/api_url/app_url.dart';

class TeamMemberModel {
  int? id;
  String? fullname;
  String? designation;
  String? role;
  String? experience;
  int? section;
  String? sectionName;
  int? image;
  ImageDataModel? imageData;
  String? imageShape;
  String? imageShapeDisplay;
  bool? isVisible;
  DateTime? createDate;
  DateTime? updateDate;

  TeamMemberModel({
    this.id,
    this.fullname,
    this.designation,
    this.role,
    this.experience,
    this.section,
    this.sectionName,
    this.image,
    this.imageData,
    this.imageShape,
    this.imageShapeDisplay,
    this.isVisible,
    this.createDate,
    this.updateDate,
  });

  TeamMemberModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    designation = json['designation'];
    role = json['role'];
    experience = json['experience'];
    section = json['section'];
    sectionName = json['section_name'];
    image = json['image'];

    imageData = json['image_data'] != null
        ? ImageDataModel.fromJson(json['image_data'])
        : null;

    imageShape = json['image_shape'];
    imageShapeDisplay = json['image_shape_display'];
    isVisible = json['is_visible'];

    createDate = json['create_date'] != null
        ? DateTime.tryParse(json['create_date'])
        : null;

    updateDate = json['update_date'] != null
        ? DateTime.tryParse(json['update_date'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['fullname'] = fullname;
    data['designation'] = designation;
    data['role'] = role;
    data['experience'] = experience;
    data['section'] = section;
    data['section_name'] = sectionName;
    data['image'] = image;

    if (imageData != null) {
      data['image_data'] = imageData!.toJson();
    }

    data['image_shape'] = imageShape;
    data['image_shape_display'] = imageShapeDisplay;
    data['is_visible'] = isVisible;
    data['create_date'] = createDate?.toIso8601String();
    data['update_date'] = updateDate?.toIso8601String();

    return data;
  }
}

class ImageDataModel {
  int? id;
  String? fileUrl;
  String? altText;
  String? caption;

  ImageDataModel({
    this.id,
    this.fileUrl,
    this.altText,
    this.caption,
  });

  ImageDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    final rawFile = json['file_url'] as String?;

    fileUrl = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http')
        ? rawFile
        : '${AppUrl.baseUrl}$rawFile')
        : null;

    altText = json['alt_text'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['file_url'] = fileUrl;
    data['alt_text'] = altText;
    data['caption'] = caption;

    return data;
  }
}

class TeamSectionModel {
  int? id;
  String? name;
  String? description;
  bool? isVisible;
  int? membersCount;
  DateTime? createDate;
  DateTime? updateDate;

  TeamSectionModel({
    this.id,
    this.name,
    this.description,
    this.isVisible,
    this.membersCount,
    this.createDate,
    this.updateDate,
  });

  TeamSectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isVisible = json['is_visible'];
    membersCount = json['members_count'];

    createDate = json['create_date'] != null
        ? DateTime.tryParse(json['create_date'])
        : null;

    updateDate = json['update_date'] != null
        ? DateTime.tryParse(json['update_date'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['is_visible'] = isVisible;
    data['members_count'] = membersCount;
    data['create_date'] = createDate?.toIso8601String();
    data['update_date'] = updateDate?.toIso8601String();

    return data;
  }
}

class ImageShapeChoiceModel {
  String? value;
  String? label;

  ImageShapeChoiceModel({
    this.value,
    this.label,
  });

  ImageShapeChoiceModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['value'] = value;
    data['label'] = label;

    return data;
  }
}