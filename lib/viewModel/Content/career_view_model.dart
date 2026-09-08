import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/Content/career/career_model.dart';
import '../../data/model/Content/career/career_status_choice_model.dart';
import '../../data/repository/content/career_repository.dart';

class CareerViewModel extends ChangeNotifier {
  final CareerRepository _repository = CareerRepository();

   List<CareerModel> jobList = [];
  bool loading = false;
  String? errorMessage;

 List<CareerStatusChoiceModel> statusChoices = [];
  bool statusLoading = false;

  List<CareerStatusChoiceModel> typeChoices = [];
  bool typeLoading = false;

  Future<void> getJobApi({String? status, String? search, String? jobType}) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      jobList = await _repository.getJobList(status: status, search: search, jobType: jobType);
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

  Future<void> getTypeChoices() async {
    typeLoading = true;
    notifyListeners();

    try {
      typeChoices = await _repository.getTypeChoices();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load job type choices.";
    } finally {
      typeLoading = false;
      notifyListeners();
    }
  }

  Future<CareerModel?> createJob(Map<String, dynamic> data) async {
    try {
      return await _repository.createJob(data);
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      errorMessage = "Failed to create job circular.";
      notifyListeners();
      return null;
    }
  }

  Future<CareerModel?> updateJob(int id, Map<String, dynamic> data) async {
    try {
      return await _repository.updateJob(id, data);
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      errorMessage = "Failed to update job circular.";
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteJob(int id) async {
    try {
      await _repository.deleteJob(id);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete job circular.";
      notifyListeners();
      return false;
    }
  }

  Future<bool> bulkAction({required String action, required List<int> ids}) async {
    try {
      await _repository.bulkOperation(action: action, ids: ids);
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
}