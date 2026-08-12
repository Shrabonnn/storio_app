import 'dart:ui';

class ExamStatistic {
  final String title;
  final String value;
  final Color? valueColor;

  const ExamStatistic({
    required this.title,
    required this.value,
    this.valueColor,
  });
}