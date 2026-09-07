import '../../../res/api_url/app_url.dart';

class MediaFileModel {
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
  String? description;
  String? altText;
  String? caption;

  MediaFileModel({
    this.id,
    this.uploadedBy,
    this.fileSizeDisplay,
    this.file,
    this.createDate,
    this.updateDate,
    this.fileType,
    this.fileName,
    this.fileSize,
    this.title,
    this.description,
    this.altText,
    this.caption,
  });

  factory MediaFileModel.fromJson(Map<String, dynamic> json) {
    final rawFile = json['file'] as String?;

    String? fullFile;
    if (rawFile != null && rawFile.isNotEmpty) {
      fullFile = rawFile.startsWith('http')
          ? rawFile
          : '${AppUrl.baseUrl}$rawFile';
    }
    return MediaFileModel(
      id: json['id'],
      uploadedBy: json['uploaded_by'],
      fileSizeDisplay: json['file_size_display'],
      file: fullFile,
      createDate: json['create_date'],
      updateDate: json['update_date'],
      fileType: json['file_type'],
      fileName: json['file_name'],
      fileSize: json['file_size'],
      title: json['title'],
      description: json['description'],
      altText: json['alt_text'],
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uploaded_by': uploadedBy,
      'file_size_display': fileSizeDisplay,
      'file': file,
      'create_date': createDate,
      'update_date': updateDate,
      'file_type': fileType,
      'file_name': fileName,
      'file_size': fileSize,
      'title': title,
      'description': description,
      'alt_text': altText,
      'caption': caption,
    };
  }
}