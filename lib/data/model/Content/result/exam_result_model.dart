import '../../../../res/api_url/app_url.dart';

class ExamResultModel {
  int? id;
  String? examType;
  String? examName;
  String? className;
  String? year;
  int? totalExaminees;
  int? passed;
  int? failed;
  int? aplusCount;
  int? agradeCount;
  String? file;
  String? passRate;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExamResultModel({
    this.id,
    this.examType,
    this.examName,
    this.className,
    this.year,
    this.totalExaminees,
    this.passed,
    this.failed,
    this.aplusCount,
    this.agradeCount,
    this.file,
    this.passRate,
    this.createdAt,
    this.updatedAt,
  });

  // V2 public template endpoint sends "file_url" instead of "file",
  // so both keys are checked here
  ExamResultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    examType = json['exam_type'];
    examName = json['exam_name'];
    className = json['class_name'];
    year = json['year']?.toString();
    totalExaminees = json['total_examinees'];
    passed = json['passed'];
    failed = json['failed'];
    aplusCount = json['aplus_count'];
    agradeCount = json['agrade_count'];
    final rawFile = json['file'] as String?;
    file = (rawFile != null && rawFile.isNotEmpty)
        ? (rawFile.startsWith('http') ? rawFile : '${AppUrl.baseUrl}$rawFile')
        : null;
    //file = json['file'] ?? json['file_url'];
    passRate = json['pass_rate'];

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
    data['exam_type'] = this.examType;
    data['exam_name'] = this.examName;
    data['class_name'] = this.className;
    data['year'] = this.year;
    data['total_examinees'] = this.totalExaminees;
    data['passed'] = this.passed;
    data['failed'] = this.failed;
    data['aplus_count'] = this.aplusCount;
    data['agrade_count'] = this.agradeCount;
    data['file'] = this.file;
    data['pass_rate'] = this.passRate;
    data['created_at'] = this.createdAt?.toIso8601String();
    data['updated_at'] = this.updatedAt?.toIso8601String();
    return data;
  }
}