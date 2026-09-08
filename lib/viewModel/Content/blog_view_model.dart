import 'package:flutter/material.dart';
import 'package:storio_app/data/model/Content/blog/blog_status_choice_model.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/blog/blog_model.dart';
import '../../data/repository/content/blog_repository.dart';

class BlogViewModel extends ChangeNotifier {
  final BlogRepository _repository = BlogRepository();

  List<BlogModel> blogList = [];
  bool loading = false;
  String? errorMessage;

  List<BlogStatusChoiceModel> statusChoices = [];
  bool statusLoading = false;

  List<CategoriesData> categoryList = [];
  bool categoryLoading = false;
  String? categoryErrorMessage;

   Future<void> getBlogApi({String? status, String? search, int? category}) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      blogList = await _repository.getBlogList(
        status: status,
        search: search,
        category: category,
      );
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> getStatusChoices() async {
    statusLoading = true;
    notifyListeners();

    try {
      statusChoices = await _repository.getStatusChoices();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load status choices.";
    } finally {
      statusLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBlog(Map<String, dynamic> data) async {
    try {
      await _repository.createBlog(data);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to create blog post.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBlog(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateBlog(id, data);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to update blog post.";
      notifyListeners();
      return false;
    }
  }
Future<bool> scheduleBlog(int id, DateTime publishDate) async {
    try {
      await _repository.scheduleBlog(id, publishDate);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to schedule blog post.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBlog(int id) async {
    try {
      await _repository.deleteBlog(id);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete blog post.";
      notifyListeners();
      return false;
    }
  }

   Future<bool> binBlog(int id) async {
    try {
      await _repository.binBlog(id);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to move blog post to bin.";
      notifyListeners();
      return false;
    }
  }

   Future<bool> restoreBlog(int id) async {
    try {
      await _repository.restoreBlog(id);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to restore blog post.";
      notifyListeners();
      return false;
    }
  }
Future<bool> bulkAction({required String action, required List<int> postIds}) async {
    try {
      await _repository.bulkOperation(action: action, postIds: postIds);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Bulk action failed.";
      notifyListeners();
      return false;
    }
  }

   Future<List<int>> fetchBinnedBlogIds() async {
    try {
      final binned = await _repository.getBlogList(status: "binned");
      return binned.map((e) => e.id).whereType<int>().toList();
    } catch (e) {
      return [];
    }
  }

   Future<void> getCategoryApi({String? search}) async {
    categoryLoading = true;
    categoryErrorMessage = null;
    notifyListeners();

    try {
      categoryList = await _repository.getCategoryList(search: search);
    } on ApiException catch (e) {
      categoryErrorMessage = e.message;
    } catch (e) {
      categoryErrorMessage = "Failed to load categories.";
    } finally {
      categoryLoading = false;
      notifyListeners();
    }
  }

   Future<bool> createCategory(Map<String, dynamic> data) async {
    try {
      await _repository.createCategory(data);
      await getCategoryApi();
      return true;
    } on ApiException catch (e) {
      categoryErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      categoryErrorMessage = "Failed to create category.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateCategory(id, data);
      await getCategoryApi();
      return true;
    } on ApiException catch (e) {
      categoryErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      categoryErrorMessage = "Failed to update category.";
      notifyListeners();
      return false;
    }
  }

   Future<bool> deleteCategory(int id) async {
    try {
      await _repository.deleteCategory(id);
      await getCategoryApi();
      return true;
    } on ApiException catch (e) {
      categoryErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      categoryErrorMessage = "Failed to delete category.";
      notifyListeners();
      return false;
    }
  }


  BlogModel? blogDetail;
  //bool blogDetailLoading = false;

  Future<void> getBlogDetail(int id) async {
    loading = true;
    notifyListeners();

    try {
      blogDetail = await _repository.getBlogDetail(id);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load blog details.";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

}