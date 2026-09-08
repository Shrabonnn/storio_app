class CareerModel {
  int? id;
  String? title;
  String? slug;
  String? companyName;
  String? location;
  String? jobType;
  int? vacancy;
  DateTime? deadline;
  String? description;
  String? applicationLink;
  String? status;
  List<AttachmentsData>? attachmentsData;
  DateTime? createdAt;
  DateTime? updatedAt;

  CareerModel(
      {this.id,
        this.title,
        this.slug,
        this.companyName,
        this.location,
        this.jobType,
        this.vacancy,
        this.deadline,
        this.description,
        this.applicationLink,
        this.status,
        this.attachmentsData,
        this.createdAt,
        this.updatedAt});

  CareerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    companyName = json['company_name'];
    location = json['location'];
    jobType = json['job_type'];
    vacancy = json['vacancy'];

    // API sends "deadline" as "yyyy-MM-dd" (date only).
    deadline = json['deadline'] != null && json['deadline'].toString().isNotEmpty
        ? DateTime.tryParse(json['deadline'])
        : null;

    description = json['description'];
    applicationLink = json['application_link'];
    status = json['status'];

    if (json['attachments_data'] != null) {
      attachmentsData = <AttachmentsData>[];
      json['attachments_data'].forEach((v) {
        attachmentsData!.add(AttachmentsData.fromJson(v));
      });
    }

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
    data['slug'] = this.slug;
    data['company_name'] = this.companyName;
    data['location'] = this.location;
    data['job_type'] = this.jobType;
    data['vacancy'] = this.vacancy;

    // API expects "yyyy-MM-dd" for deadline.
    data['deadline'] = this.deadline ;
    data['description'] = this.description;
    data['application_link'] = this.applicationLink;
    data['status'] = this.status;

    if (this.attachmentsData != null) {
      data['attachments_data'] =
          this.attachmentsData!.map((v) => v.toJson()).toList();
    }

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AttachmentsData {
  int? id;
  String? type;
  String? fileName;
  String? url;
  String? altText;

  AttachmentsData({this.id, this.type, this.fileName, this.url, this.altText});

  AttachmentsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    fileName = json['file_name'];
    url = json['url'];
    altText = json['alt_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['type'] = this.type;
    data['file_name'] = this.fileName;
    data['url'] = this.url;
    data['alt_text'] = this.altText;
    return data;
  }
}