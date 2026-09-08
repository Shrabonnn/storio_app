import 'package:storio_app/data/model/Content/blog/blog_status_choice_model.dart';

import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/Content/blog/blog_model.dart';


class BlogRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // BLOG LIST (Management)
  // ============================================================
  Future<List<BlogModel>> getBlogList({
    String? status,
    String? search,
    int? category,
  }) async {
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
      AppUrl.getManagementBlogs,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List)
        .map((e) => BlogModel.fromJson(e))
        .toList();
  }

  // ============================================================
  // BLOG DETAIL (Management)
  // ============================================================
  Future<BlogModel> getBlogDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.blogDetail(id));
    return BlogModel.fromJson(response);
  }

  // ============================================================
  // CREATE BLOG
  // ============================================================
  Future<BlogModel> createBlog(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createBlog, data);
    return BlogModel.fromJson(response['blog_post']);
  }

  // ============================================================
  // UPDATE BLOG (PATCH)
  // ============================================================
  Future<BlogModel> updateBlog(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.blogDetail(id), data);
    return BlogModel.fromJson(response['blog_post']);
  }

  // ============================================================
  // SCHEDULE BLOG
  // ============================================================
  Future<Map<String, dynamic>> scheduleBlog(int id, DateTime publishDate) async {
    final response = await _apiServices.postApi(
      AppUrl.blogSchedule(id),
      {"publish_date": publishDate.toUtc().toIso8601String()},
    );
    return response;
  }

  // ============================================================
  // DELETE BLOG (permanent)
  // ============================================================
  Future<Map<String, dynamic>> deleteBlog(int id) async {
    final response = await _apiServices.deleteApi(AppUrl.blogDetail(id));
    return response;
  }

  // ============================================================
  // MOVE TO BIN
  // ============================================================
  Future<Map<String, dynamic>> binBlog(int id) async {
    final response = await _apiServices.postApi(AppUrl.blogBin(id), {});
    return response;
  }

  // ============================================================
  // RESTORE FROM BIN
  // ============================================================
  Future<Map<String, dynamic>> restoreBlog(int id) async {
    final response = await _apiServices.postApi(AppUrl.blogRestore(id), {});
    return response;
  }

  // ============================================================
  // BULK OPERATIONS
  // ============================================================
  Future<Map<String, dynamic>> bulkOperation({
    required String action,
    required List<int> postIds,
  }) async {
    final response = await _apiServices.postApi(
      AppUrl.blogBulkOperations,
      {
        "action": action,
        "post_ids": postIds,
      },
    );
    return response;
  }

  // ============================================================
  // STATUS CHOICES
  // ============================================================
  Future<List<BlogStatusChoiceModel>> getStatusChoices() async {
    final response = await _apiServices.getApi(AppUrl.getBlogStatusChoices);
    final choices = response['choices'] as List;
    return choices.map((e) => BlogStatusChoiceModel.fromJson(e)).toList();
  }

  // ============================================================
  // CATEGORY MANAGEMENT
  // ============================================================
  Future<List<CategoriesData>> getCategoryList({String? search}) async {
    final Map<String, dynamic> queryParams = {};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiServices.getApi(
      AppUrl.getManagementBlogCategories,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List)
        .map((e) => CategoriesData.fromJson(e))
        .toList();
  }

  Future<CategoriesData> createCategory(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createBlogCategory, data);
    return CategoriesData.fromJson(response['category']);
  }

  Future<CategoriesData> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.blogCategoryDetail(id), data);
    return CategoriesData.fromJson(response['category']);
  }

  Future<Map<String, dynamic>> deleteCategory(int id) async {
    final response = await _apiServices.deleteApi(AppUrl.blogCategoryDetail(id));
    return response;
  }
}