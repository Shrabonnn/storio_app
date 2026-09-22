import 'package:flutter/foundation.dart';
import '../../core/network/api_exception.dart';
import '../../data/model/institute_profile/institute_profile_model.dart';
import '../../data/repository/institute_profile_repository.dart';

class InstitutionProfileViewModel with ChangeNotifier {
  final _repository = InstitutionProfileRepository();

  bool _loading = false;
  bool get loading => _loading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  InstitutionProfileModel? _profile;
  InstitutionProfileModel? get profile => _profile;

  // GET API Call with Shimmer Support Logic
  Future<void> getInstitutionProfile({
    bool isRefresh = false,
  }) async {
    _errorMessage = null;

    // 1. Show shimmer loading on initial load or forced pull-to-refresh
    if (isRefresh || _profile == null) {
      if (isRefresh) {
        _profile = null; // Clear cached data so UI triggers full shimmer effect
      }
      _loading = true;
      notifyListeners();
    }

    // 2. Fetch fresh data (updates silently in background if profile already cached)
    try {
      _profile = await _repository.getInstitutionProfile();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // PUT / PATCH API Call for Admin Updates
  Future<bool> updateInstitutionProfile(
      Map<String, dynamic> data, {
        bool isPatch = false,
      }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedProfile = await _repository.updateInstitutionProfile(
        data,
        isPatch: isPatch,
      );
      _profile = updatedProfile;
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = "Failed to update profile. Please try again.";
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}