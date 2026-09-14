
class StaffStatusChoiceModel {
  final String value;
  final String label;

  StaffStatusChoiceModel({required this.value, required this.label});

  factory StaffStatusChoiceModel.fromJson(Map<String, dynamic> json) {
    return StaffStatusChoiceModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}