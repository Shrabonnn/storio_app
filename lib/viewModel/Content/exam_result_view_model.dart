import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/result/exam_result_model.dart';
import '../../data/repository/content/exam_result_repository.dart';

class ExamResultViewModel extends ChangeNotifier {
  final ExamResultRepository _repository = ExamResultRepository();

  List<ExamResultModel> examResultList = [];
  bool loading = false;
  String? errorMessage;

  ExamResultModel? examResultDetail;
  bool examResultDetailLoading = false;

  Future<void> getExamResultApi({
    String? examType,
    String? search,
    String? ordering,
  }) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      examResultList = await _repository.getExamResults(
        examType: examType,
        search: search,
        ordering: ordering,
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

  Future<void> getExamResultDetail(int id) async {
    examResultDetailLoading = true;
    notifyListeners();

    try {
      examResultDetail = await _repository.getExamResultDetail(id);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load exam result details.";
    } finally {
      examResultDetailLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createExamResult(Map<String, dynamic> data, {File? file}) async {
    try {
      final result = await _repository.createExamResult(data, file: file);
      examResultList.insert(0, result);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to create exam result.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExamResult(int id, Map<String, dynamic> data) async {
    try {
      final result = await _repository.updateExamResult(id, data);

      final index = examResultList.indexWhere((item) => item.id == id);
      if (index != -1) {
        examResultList[index] = result;
        notifyListeners();
      }

      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to update exam result.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExamResult(int id) async {
    try {
      await _repository.deleteExamResult(id);
      examResultList.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete exam result.";
      notifyListeners();
      return false;
    }
  }
}