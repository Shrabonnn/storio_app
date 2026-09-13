import 'package:storio_app/core/network/network_api_services.dart';
import 'package:storio_app/data/model/Content/event/event_model.dart';
import 'package:storio_app/res/api_url/app_url.dart';

class EventRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // EVENT LIST
  // ============================================================

  // ============================================================
// EVENT LIST
// ============================================================

  Future<List<EventModel>> getEventList(
      String? status,
      String? search,
      int? category,
      ) async {
    final Map<String, dynamic> queryParams = {};

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    if (category != null) {
      queryParams['category'] = category.toString();
    }

    final response = await _apiServices.getApi(
      AppUrl.getEvent,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    final List results = response is Map<String, dynamic>
        ? (response['results'] as List? ?? [])
        : (response as List);

    return results
        .map((e) => EventModel.fromJson(e))
        .toList();
  }

  // ============================================================
  // EVENT DETAIL
  // ============================================================

  Future<EventModel> getEventDetails(int id) async {
    final response = await _apiServices.getApi(
      AppUrl.eventDatils(id),
    );

    return EventModel.fromJson(response);
  }

  // ============================================================
  // CREATE EVENT
  // ============================================================

  Future<EventModel> createEvent(
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.getEvent,
      data,
    );

    return EventModel.fromJson(response);
  }

  // ============================================================
  // UPDATE EVENT
  // ============================================================

  Future<EventModel> updateEvent(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.eventDatils(id),
      data,
    );

    return EventModel.fromJson(response);
  }

  // ============================================================
  // DELETE EVENT
  // ============================================================

  Future<Map<String, dynamic>> deleteEvent(int id) async {
    final response = await _apiServices.deleteApi(
      AppUrl.eventDatils(id),
    );

    return response;
  }

  // ============================================================
  // CATEGORY MANAGEMENT
  // ============================================================

  // ============================================================
// CATEGORY MANAGEMENT
// ============================================================

  Future<List<CategoriesDetail>> getCategoryList({
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiServices.getApi(
      AppUrl.getEventCategories,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    final List results = response is Map<String, dynamic>
        ? (response['results'] as List? ?? [])
        : (response as List);

    return results
        .map((e) => CategoriesDetail.fromJson(e))
        .toList();
  }

  // ============================================================
  // CREATE CATEGORY
  // ============================================================

  Future<CategoriesDetail> createCategory(
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.getEventCategories,
      data,
    );

    return CategoriesDetail.fromJson(response);
  }

  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  Future<CategoriesDetail> updateCategory(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.eventCategoriesDetails(id),
      data,
    );

    return CategoriesDetail.fromJson(response);
  }

  // ============================================================
  // DELETE CATEGORY
  // ============================================================

  Future<Map<String, dynamic>> deleteCategory(int id) async {
    return await _apiServices.deleteApi(
      AppUrl.eventCategoriesDetails(id),
    );
  }
}