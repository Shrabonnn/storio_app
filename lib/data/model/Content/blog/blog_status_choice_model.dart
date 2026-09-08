// data/model/Content/status_choice_model.dart
class BlogStatusChoiceModel {
  final String value;
  final String label;

  BlogStatusChoiceModel({required this.value, required this.label});

  factory BlogStatusChoiceModel.fromJson(Map<String, dynamic> json) {
    return BlogStatusChoiceModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}