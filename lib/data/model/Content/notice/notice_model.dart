import '../../../../res/api_url/app_url.dart';

class NoticeModel {
  int? id;
  String? createdBy;
  List<int>? attachments;
  List<AttachmentsDetail>? attachmentsDetail;
  String? title;
  String? content;
  String? status;
  DateTime? publishDate;
  DateTime? createDate;
  DateTime? updateDate;
  DateTime? deletedAt;
  bool? pdfViewMode;

  NoticeModel(
      {this.id,
        this.createdBy,
        this.attachments,
        this.attachmentsDetail,
        this.title,
        this.content,
        this.status,
        this.publishDate,
        this.createDate,
        this.updateDate,
        this.deletedAt,
        this.pdfViewMode});

  NoticeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    attachments = json['attachments'] != null
        ? List<int>.from(json['attachments'])
        : [];
    if (json['attachments_detail'] != null) {
      attachmentsDetail = <AttachmentsDetail>[];
      json['attachments_detail'].forEach((v) {
        attachmentsDetail!.add(new AttachmentsDetail.fromJson(v));
      });
    }
    title = json['title'];
    content = json['content'];
    status = json['status'];
    publishDate = json['publish_date'] != null
        ? DateTime.tryParse(json['publish_date'])
        : null;
    createDate = json['create_date'] != null
        ? DateTime.tryParse(json['create_date'])
        : null;
    updateDate = json['update_date'] != null
        ? DateTime.tryParse(json['update_date'])
        : null;
    deletedAt = json['deleted_at'] != null
        ? DateTime.tryParse(json['deleted_at'])
        : null;
    pdfViewMode = json['pdf_view_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['attachments'] = this.attachments;
    if (this.attachmentsDetail != null) {
      data['attachments_detail'] =
          this.attachmentsDetail!.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['content'] = this.content;
    data['status'] = this.status;
    data['publish_date'] = this.publishDate;
    data['create_date'] = this.createDate;
    data['update_date'] = this.updateDate;
    data['deleted_at'] = this.deletedAt;
    data['pdf_view_mode'] = this.pdfViewMode;
    return data;
  }
}

class AttachmentsDetail {
  int? id;
  String? uploadedBy;
  String? fileSizeDisplay;
  String? file;
  String? createDate;
  String? updateDate;
  String? fileType;
  String? fileName;
  int? fileSize;
  String? title;
  String? altText;
  String? caption;
  String? description;

  AttachmentsDetail(
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

  AttachmentsDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uploadedBy = json['uploaded_by'];
    fileSizeDisplay = json['file_size_display'];

    final rawFile = json['file'] as String?;
    file = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;

    createDate = json['create_date'];
    updateDate = json['update_date'];
    fileType = json['file_type'];
    fileName = json['file_name'];
    fileSize = json['file_size'];
    title = json['title'];
    altText = json['alt_text'];
    caption = json['caption'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uploaded_by'] = this.uploadedBy;
    data['file_size_display'] = this.fileSizeDisplay;
    data['file'] = this.file;
    data['create_date'] = this.createDate;
    data['update_date'] = this.updateDate;
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

