import '../../../../res/api_url/app_url.dart';

class InstitutionProfileModel {
  int? id;
  int? institutionImage;
  String? institutionImageUrl;
  String? schoolDetails;
  List<AdditionalInfo>? additionalInfo;
  int? totalStudents;
  int? totalTeachers;
  String? mission;
  String? vision;
  List<ImportantLink>? importantLinks;
  int? eiin;
  String? schoolCode;
  String? schoolShift;
  String? schoolType;
  DateTime? createdAt;
  DateTime? updatedAt;

  // V2 Specific Fields
  String? division;
  String? district;
  String? upazila;
  String? wardNo;
  List<dynamic>? keyMetrics;
  String? metricsTitle;
  String? totalStudentsLabel;
  String? totalTeachersLabel;

  InstitutionProfileModel({
    this.id,
    this.institutionImage,
    this.institutionImageUrl,
    this.schoolDetails,
    this.additionalInfo,
    this.totalStudents,
    this.totalTeachers,
    this.mission,
    this.vision,
    this.importantLinks,
    this.eiin,
    this.schoolCode,
    this.schoolShift,
    this.schoolType,
    this.createdAt,
    this.updatedAt,
    this.division,
    this.district,
    this.upazila,
    this.wardNo,
    this.keyMetrics,
    this.metricsTitle,
    this.totalStudentsLabel,
    this.totalTeachersLabel,
  });

  InstitutionProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionImage = json['institution_image'];

    final rawUrl = json['institution_image_url'] as String?;
    institutionImageUrl = (rawUrl != null && rawUrl.isNotEmpty)
        ? (rawUrl.startsWith('http') ? rawUrl : '${AppUrl.baseUrl}$rawUrl')
        : null;

    schoolDetails = json['school_details'];

    if (json['additional_info'] != null) {
      additionalInfo = <AdditionalInfo>[];
      json['additional_info'].forEach((v) {
        additionalInfo!.add(AdditionalInfo.fromJson(v));
      });
    }

    totalStudents = json['total_students'];
    totalTeachers = json['total_teachers'];
    mission = json['mission'];
    vision = json['vision'];

    if (json['important_links'] != null) {
      importantLinks = <ImportantLink>[];
      json['important_links'].forEach((v) {
        importantLinks!.add(ImportantLink.fromJson(v));
      });
    }

    eiin = json['eiin'];
    schoolCode = json['school_code'];
    schoolShift = json['school_shift'];
    schoolType = json['school_type'];

    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'])
        : null;

    // V2 Fields
    division = json['division'];
    district = json['district'];
    upazila = json['upazila'];
    wardNo = json['ward_no'];
    keyMetrics = json['key_metrics'];
    metricsTitle = json['metrics_title'];
    totalStudentsLabel = json['total_students_label'];
    totalTeachersLabel = json['total_teachers_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['institution_image'] = institutionImage;
    data['institution_image_url'] = institutionImageUrl;
    data['school_details'] = schoolDetails;
    if (additionalInfo != null) {
      data['additional_info'] = additionalInfo!.map((v) => v.toJson()).toList();
    }
    data['total_students'] = totalStudents;
    data['total_teachers'] = totalTeachers;
    data['mission'] = mission;
    data['vision'] = vision;
    if (importantLinks != null) {
      data['important_links'] = importantLinks!.map((v) => v.toJson()).toList();
    }
    data['eiin'] = eiin;
    data['school_code'] = schoolCode;
    data['school_shift'] = schoolShift;
    data['school_type'] = schoolType;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();

    // V2 Fields
    data['division'] = division;
    data['district'] = district;
    data['upazila'] = upazila;
    data['ward_no'] = wardNo;
    data['key_metrics'] = keyMetrics;
    data['metrics_title'] = metricsTitle;
    data['total_students_label'] = totalStudentsLabel;
    data['total_teachers_label'] = totalTeachersLabel;

    return data;
  }
}

class AdditionalInfo {
  String? label;
  String? value;

  AdditionalInfo({this.label, this.value});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class ImportantLink {
  int? id;
  String? title;
  String? url;
  int? order;
  DateTime? createdAt;
  DateTime? updatedAt;

  ImportantLink({
    this.id,
    this.title,
    this.url,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  ImportantLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // Handles both Legacy ('title') and V2 ('label') representations
    title = json['title'] ?? json['label'];

    final rawFile = json['url'] as String?;
    url = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    data['order'] = order;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}