
class ActivityStatusChoiceModel {
  final String value;
  final String label;

  ActivityStatusChoiceModel({required this.value, required this.label});

  factory ActivityStatusChoiceModel.fromJson(Map<String, dynamic> json) {
    return ActivityStatusChoiceModel(
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