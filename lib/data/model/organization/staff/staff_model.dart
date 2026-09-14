import '../../../../res/api_url/app_url.dart';

class StaffModel {
  int? id;
  String? name;
  String? role;
  int? department;
  int? departmentId;
  String? email;
  String? phone;
  DateTime? joiningDate;
  String? bio;
  int? profilePic;
  ProfilePicData? profilePicData;
  String? status;
  int? order;
  DateTime? createDate;
  DateTime? updateDate;

  StaffModel(
      {this.id,
        this.name,
        this.role,
        this.department,
        this.departmentId,
        this.email,
        this.phone,
        this.joiningDate,
        this.bio,
        this.profilePic,
        this.profilePicData,
        this.status,
        this.order,
        this.createDate,
        this.updateDate});

  StaffModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    department = json['department'];
    departmentId = json['department_id'];
    email = json['email'];
    phone = json['phone'];
    joiningDate = json['joining_date']!=null
        ? DateTime.parse(json['joining_date'])
        : null;
    bio = json['bio'];
    profilePic = json['profile_pic'];
    profilePicData = json['profile_pic_data'] != null
        ? new ProfilePicData.fromJson(json['profile_pic_data'])
        : null;
    status = json['status'];
    order = json['order'];
    createDate = json['create_date']!=null
        ? DateTime.parse(json['create_date'])
        : null;
    updateDate = json['update_date']!=null
        ? DateTime.parse(json['update_date'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['department'] = this.department;
    data['department_id'] = this.departmentId;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['joining_date'] = this.joiningDate?.toIso8601String();
    data['bio'] = this.bio;
    data['profile_pic'] = this.profilePic;
    if (this.profilePicData != null) {
      data['profile_pic_data'] = this.profilePicData!.toJson();
    }
    data['status'] = this.status;
    data['order'] = this.order;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}

class ProfilePicData {
  int? id;
  String? fileUrl;
  String? altText;
  String? fileType;

  ProfilePicData({this.id, this.fileUrl, this.altText, this.fileType});

  ProfilePicData.fromJson(Map<String, dynamic> json) {
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
class DepartmentModel {
  int? id;
  String? name;
  String? description;
  int? staffCount;
  DateTime? createDate;
  DateTime? updateDate;

  DepartmentModel({
    this.id,
    this.name,
    this.description,
    this.staffCount,
    this.createDate,
    this.updateDate,
  });

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    staffCount = json['staff_count'];

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
    data['description'] = this.description;
    data['staff_count'] = this.staffCount;
    data['create_date'] = this.createDate?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}