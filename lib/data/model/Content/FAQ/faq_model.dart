class FaqModel {
  int? id;
  String? question;
  String? answer;
  bool? isVisible;
  DateTime? createDate;
  DateTime? createdAt;
  DateTime? updateDate;

  FaqModel({
    this.id,
    this.question,
    this.answer,
    this.isVisible,
    this.createDate,
    this.createdAt,
    this.updateDate,
  });

  FaqModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    isVisible = json['is_visible'];

    createDate = json['create_date'] != null
        ? DateTime.tryParse(json['create_date'])
        : null;

    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;

    updateDate = json['update_date'] != null
        ? DateTime.tryParse(json['update_date'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['is_visible'] = this.isVisible;
    data['create_date'] = this.createDate?.toIso8601String();
    data['created_at'] = this.createdAt?.toIso8601String();
    data['update_date'] = this.updateDate?.toIso8601String();
    return data;
  }
}