class LeadershipMessageStatusChoiceModel {
  final String value;
  final String label;

  LeadershipMessageStatusChoiceModel({
    required this.value,
    required this.label,
  });

  factory LeadershipMessageStatusChoiceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return LeadershipMessageStatusChoiceModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }
}