// data/model/Content/status_choice_model.dart
class StatusChoiceModel {
  final String value;
  final String label;

  StatusChoiceModel({required this.value, required this.label});

  factory StatusChoiceModel.fromJson(Map<String, dynamic> json) {
    return StatusChoiceModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}