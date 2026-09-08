// data/model/Content/status_choice_model.dart
class CareerStatusChoiceModel {
  final String value;
  final String label;

  CareerStatusChoiceModel({required this.value, required this.label});

  factory CareerStatusChoiceModel.fromJson(Map<String, dynamic> json) {
    return CareerStatusChoiceModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}