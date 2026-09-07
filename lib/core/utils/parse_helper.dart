// core/utils/parse_helper.dart
List<dynamic> parseApiList(dynamic responseData) {
  if (responseData is List) {
    return responseData;
  } else if (responseData is Map && responseData.containsKey('results')) {
    return responseData['results'] as List<dynamic>? ?? [];
  }
  return [];
}