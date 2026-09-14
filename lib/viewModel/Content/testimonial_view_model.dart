import 'package:flutter/material.dart';

import 'package:storio_app/core/network/api_exception.dart';
import 'package:storio_app/data/model/Content/testimonial/testimonial_model.dart';
import 'package:storio_app/data/repository/content/testimonial_repository.dart';

class TestimonialViewModel extends ChangeNotifier {
  final TestimonialRepository _repository = TestimonialRepository();

  // ============================================================
  // STATE
  // ============================================================

  List<TestimonialModel> testimonialList = [];

  TestimonialModel? selectedTestimonial;

  bool isLoading = false;
  bool isCreating = false;
  bool isUpdating = false;
  bool isDeleting = false;
  bool isBulkOperating = false;
  bool isReordering = false;

  String? errorMessage;
  String? successMessage;

  // ============================================================
  // PUBLIC TESTIMONIALS
  // ============================================================

  Future<void> getPublicTestimonials() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      testimonialList = await _repository.getPublicTestimonials();
    } on ApiException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = 'Something went wrong.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // MANAGEMENT TESTIMONIALS
  // ============================================================

  Future<void> getManagementTestimonials({
    String? search,
    String? status,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      testimonialList =
      await _repository.getManagementTestimonials(
        search: search,
        status: status,
      );
    } on ApiException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = 'Something went wrong.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // GET SINGLE TESTIMONIAL
  // ============================================================

  Future<void> getTestimonialById(int id) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      selectedTestimonial = await _repository.getTestimonialById(id);
    } on ApiException catch (e) {
      errorMessage = e.toString();
    } catch (e) {
      errorMessage = 'Something went wrong.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREATE
  // ============================================================

  Future<bool> createTestimonial({
    required String name,
    String? designation,
    String? organization,
    required String message,
    required int rating,
    int? photo,
    required String status,
  }) async {
    try {
      isCreating = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      final testimonial =
      await _repository.createTestimonial(
        name: name,
        designation: designation,
        organization: organization,
        message: message,
        rating: rating,
        photo: photo,
        status: status,
      );

      testimonialList.add(testimonial);

      successMessage = 'Testimonial created successfully!';

      return true;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      return false;
    } finally {
      isCreating = false;
      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  Future<bool> updateTestimonial(
      int id,
      Map<String, dynamic> data,
      ) async {
    try {
      isUpdating = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      final updatedTestimonial =
      await _repository.updateTestimonial(
        id,
        data,
      );

      final index = testimonialList.indexWhere(
            (item) => item.id == id,
      );

      if (index != -1) {
        testimonialList[index] = updatedTestimonial;
      }

      if (selectedTestimonial?.id == id) {
        selectedTestimonial = updatedTestimonial;
      }

      successMessage = 'Testimonial updated successfully!';

      return true;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<bool> deleteTestimonial(int id) async {
    try {
      isDeleting = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      final message =
      await _repository.deleteTestimonial(id);

      testimonialList.removeWhere(
            (item) => item.id == id,
      );

      if (selectedTestimonial?.id == id) {
        selectedTestimonial = null;
      }

      successMessage = message;

      return true;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }

  // ============================================================
  // BULK OPERATION
  // ============================================================

  Future<bool> bulkOperation({
    required List<int> ids,
    required String action,
  }) async {
    try {
      isBulkOperating = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      final message =
      await _repository.bulkOperation(
        ids: ids,
        action: action,
      );

      if (action == 'delete') {
        testimonialList.removeWhere(
              (item) => ids.contains(item.id),
        );
      } else if (action == 'activate') {
        for (final item in testimonialList) {
          if (ids.contains(item.id)) {
            item.status = 'active';
          }
        }
      } else if (action == 'deactivate') {
        for (final item in testimonialList) {
          if (ids.contains(item.id)) {
            item.status = 'inactive';
          }
        }
      }

      successMessage = message;

      return true;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      return false;
    } finally {
      isBulkOperating = false;
      notifyListeners();
    }
  }

  // ============================================================
  // REORDER
  // ============================================================

  Future<bool> reorderTestimonials(
      List<int> orderedIds,
      ) async {
    try {
      isReordering = true;
      errorMessage = null;
      successMessage = null;
      notifyListeners();

      final message =
      await _repository.reorderTestimonials(
        orderedIds,
      );

      successMessage = message;

      return true;
    } on ApiException catch (e) {
      errorMessage = e.toString();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      return false;
    } finally {
      isReordering = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CLEAR MESSAGE
  // ============================================================

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}