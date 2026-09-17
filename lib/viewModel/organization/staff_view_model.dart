import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/organization/staff/staff_model.dart';
import '../../data/model/organization/staff/staff_status_choice_model.dart';
import '../../data/repository/organization/staff_repository.dart';

class StaffViewModel extends ChangeNotifier {
  final StaffRepository _repository = StaffRepository();


  // Staff list state

  List<StaffModel> staffList = [];
  bool loading = false;
  String? errorMessage;


  // Staff detail state

  StaffModel? staffDetail;
  bool staffDetailLoading = false;


  // Status choices state

  List<StaffStatusChoiceModel> statusChoices = [];
  bool statusLoading = false;


  // Department state

  List<DepartmentModel> departmentList = [];
  bool departmentLoading = false;
  String? departmentErrorMessage;



  // GET STAFF LIST

  Future<void> getStaffApi({
    String? search,
    int? department,
    String? status,
  bool isFilterOrSearch = false,
  }) async {

    //loading = true;
    errorMessage = null;

    if(isFilterOrSearch || staffList.isEmpty){
      if(isFilterOrSearch){
        staffList.clear();  // old data clear kore shimmer make sure kore
      }
      loading = true;
      notifyListeners();
    }

    try {
      staffList = await _repository.getStaffList(
        search: search,
        department: department,
        status: status,
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


  // GET STAFF DETAIL

  Future<void> getStaffDetail(int id) async {
    staffDetailLoading = true;
    notifyListeners();

    try {
      staffDetail = await _repository.getStaffDetail(id);
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Failed to load staff details.";
    } finally {
      staffDetailLoading = false;
      notifyListeners();
    }
  }


  // GET STATUS CHOICES

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


  // CREATE STAFF

  Future<bool> createStaff(Map<String, dynamic> data) async {
    try {
      await _repository.createStaff(data);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to create staff member.";
      notifyListeners();
      return false;
    }
  }


  // UPDATE STAFF

  Future<bool> updateStaff(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateStaff(id, data);
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to update staff member.";
      notifyListeners();
      return false;
    }
  }


  // DELETE STAFF

  Future<bool> deleteStaff(int id) async {
    try {
      await _repository.deleteStaff(id);
      staffList.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to delete staff member.";
      notifyListeners();
      return false;
    }
  }


  // BULK OPERATIONS (activate / deactivate / on_leave / retire / delete)

  Future<bool> bulkAction({
    required String action,
    required List<int> staffIds,
  }) async {
    try {
      await _repository.bulkOperation(action: action, staffIds: staffIds);
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


  // REORDER STAFF (drag-and-drop)

  Future<bool> reorderStaff(List<int> orderedIds) async {
    try {
      await _repository.reorderStaff(orderedIds);


      final reordered = <StaffModel>[];
      for (final id in orderedIds) {
        final match = staffList.where((item) => item.id == id);
        if (match.isNotEmpty) reordered.add(match.first);
      }
      if (reordered.length == staffList.length) {
        staffList = reordered;
        notifyListeners();
      }

      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "Failed to reorder staff.";
      notifyListeners();
      return false;
    }
  }


  // DEPARTMENT: GET LIST

  Future<void> getDepartmentApi({String? search}) async {
    departmentLoading = true;
    departmentErrorMessage = null;
    notifyListeners();

    try {
      departmentList = await _repository.getDepartmentList(search: search);
    } on ApiException catch (e) {
      departmentErrorMessage = e.message;
    } catch (e) {
      departmentErrorMessage = "Failed to load departments.";
    } finally {
      departmentLoading = false;
      notifyListeners();
    }
  }


  // DEPARTMENT: CREATE

  Future<bool> createDepartment(Map<String, dynamic> data) async {
    try {
      await _repository.createDepartment(data);
      return true;
    } on ApiException catch (e) {
      departmentErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      departmentErrorMessage = "Failed to create department.";
      notifyListeners();
      return false;
    }
  }


  // DEPARTMENT: UPDATE

  Future<bool> updateDepartment(int id, Map<String, dynamic> data) async {
    try {
      await _repository.updateDepartment(id, data);
      return true;
    } on ApiException catch (e) {
      departmentErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      departmentErrorMessage = "Failed to update department.";
      notifyListeners();
      return false;
    }
  }


  // DEPARTMENT: DELETE

  Future<bool> deleteDepartment(int id) async {
    try {
      await _repository.deleteDepartment(id);
      departmentList.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      departmentErrorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      departmentErrorMessage = "Failed to delete department.";
      notifyListeners();
      return false;
    }
  }
}