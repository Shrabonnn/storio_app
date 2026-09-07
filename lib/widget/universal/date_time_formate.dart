import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return '';

  return DateFormat('dd MMM yyyy').format(date);
}

String formatTime(DateTime? date) {
  if (date == null) return '';

  return DateFormat('hh:mm a').format(date);
}