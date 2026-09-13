import 'package:storio_app/core/network/network_api_services.dart';
import 'package:storio_app/data/model/Content/testimonial/testimonial_model.dart';
import 'package:storio_app/res/api_url/app_url.dart';

class TestimonialRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // GET PUBLIC TESTIMONIALS
  // ============================================================

  Future<List<TestimonialModel>> getPublicTestimonials() async {
    final response = await _apiServices.getApi(
      AppUrl.testimonialsApi,
      requiresAuth: false,
    );

    return (response as List)
        .map((json) => TestimonialModel.fromJson(json))
        .toList();
  }

  // ============================================================
  // GET ALL TESTIMONIALS - MANAGEMENT
  // ============================================================

  Future<List<TestimonialModel>> getManagementTestimonials({
    String? search,
    String? status,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await _apiServices.getApi(
      AppUrl.managementTestimonialsApi,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      requiresAuth: true,
    );

    return (response as List)
        .map((json) => TestimonialModel.fromJson(json))
        .toList();
  }

  // ============================================================
  // CREATE TESTIMONIAL
  // ============================================================

  Future<TestimonialModel> createTestimonial({
    required String name,
    String? designation,
    String? organization,
    required String message,
    required int rating,
    int? photo,
    required String status,
  }) async {
    final data = {
      'name': name,
      'designation': designation,
      'organization': organization,
      'message': message,
      'rating': rating,
      'photo': photo,
      'status': status,
    };

    final response = await _apiServices.postApi(
      AppUrl.createTestimonialApi,
      data,
      requiresAuth: true,
    );

    return TestimonialModel.fromJson(
      response['testimonial'],
    );
  }

  // ============================================================
  // GET SINGLE TESTIMONIAL
  // ============================================================

  Future<TestimonialModel> getTestimonialById(int id) async {
    final response = await _apiServices.getApi(
      '${AppUrl.managementTestimonialsApi}$id/',
      requiresAuth: true,
    );

    return TestimonialModel.fromJson(response);
  }

  // ============================================================
  // UPDATE TESTIMONIAL
  // ============================================================

  Future<TestimonialModel> updateTestimonial(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      '${AppUrl.managementTestimonialsApi}$id/',
      data,
      requiresAuth: true,
    );

    return TestimonialModel.fromJson(
      response['testimonial'],
    );
  }

  // ============================================================
  // DELETE TESTIMONIAL
  // ============================================================

  Future<String> deleteTestimonial(int id) async {
    final response = await _apiServices.deleteApi(
      '${AppUrl.managementTestimonialsApi}$id/',
      requiresAuth: true,
    );

    return response['message'];
  }

  // ============================================================
  // BULK OPERATIONS
  // ============================================================

  Future<String> bulkOperation({
    required List<int> ids,
    required String action,
  }) async {
    final data = {
      'ids': ids,
      'action': action,
    };

    final response = await _apiServices.postApi(
      AppUrl.bulkTestimonialOperationsApi,
      data,
      requiresAuth: true,
    );

    return response['message'];
  }

  // ============================================================
  // REORDER TESTIMONIALS
  // ============================================================

  Future<String> reorderTestimonials(
      List<int> orderedIds,
      ) async {
    final data = {
      'ordered_ids': orderedIds,
    };

    final response = await _apiServices.postApi(
      AppUrl.reorderTestimonialsApi,
      data,
      requiresAuth: true,
    );

    return response['message'];
  }
}