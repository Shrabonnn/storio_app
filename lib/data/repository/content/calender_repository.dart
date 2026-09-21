import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/Content/calender/calender_model.dart';

class CalendarRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // LIST EVENTS (Public)
  // ============================================================
  Future<List<CalendarEventModel>> getEventList({
    String? search,
    String? category,
    String? level,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (level != null && level.isNotEmpty) {
      queryParams['level'] = level;
    }

    final response = await _apiServices.getApi(
      AppUrl.calendarEvents,
      queryParams: queryParams.isEmpty ? null : queryParams,
      requiresAuth: false,
    );

    // 🔹 Map Response (Django Rest Framework Paginated Results) Handle
    if (response is Map<String, dynamic> && response.containsKey('results')) {
      final List results = response['results'] ?? [];
      return results.map((e) => CalendarEventModel.fromJson(e)).toList();
    }
    // 🔹 Direct List Response Handle (Backup)
    else if (response is List) {
      return response.map((e) => CalendarEventModel.fromJson(e)).toList();
    }

    return [];
  }

  // ============================================================
  // EVENT DETAIL (Public)
  // ============================================================
  Future<CalendarEventModel> getEventDetail(int id) async {
    final response = await _apiServices.getApi(
      AppUrl.calendarEventDetail(id),
      requiresAuth: false,
    );
    return CalendarEventModel.fromJson(response);
  }

  // ============================================================
  // CREATE EVENT (Management)
  // ============================================================
  Future<CalendarEventModel> createEvent(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.calendarEvents, data);
    return CalendarEventModel.fromJson(response);
  }

  // ============================================================
  // UPDATE EVENT (Management, PATCH)
  // ============================================================
  Future<CalendarEventModel> updateEvent(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.calendarEventDetail(id),
      data,
    );
    return CalendarEventModel.fromJson(response);
  }

  // ============================================================
  // DELETE EVENT (Management, 204 No Content)
  // ============================================================
  Future<void> deleteEvent(int id) async {
    await _apiServices.deleteApi(AppUrl.calendarEventDetail(id));
  }

  // ============================================================
  // GET SETTINGS (Public)
  // ============================================================
  Future<CalendarSettingsModel> getSettings() async {
    final response = await _apiServices.getApi(
      AppUrl.calendarSettings,
      requiresAuth: false,
    );
    return CalendarSettingsModel.fromJson(response);
  }

  // ============================================================
  // UPDATE SETTINGS (Management)
  // ============================================================
  Future<CalendarSettingsModel> updateSettings(String weekendDays) async {
    final response = await _apiServices.postApi(
      AppUrl.calendarSettingsUpdate,
      {"weekend_days": weekendDays},
    );
    return CalendarSettingsModel.fromJson(response);
  }
}