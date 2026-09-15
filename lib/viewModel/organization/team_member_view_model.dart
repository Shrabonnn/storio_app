import 'package:flutter/foundation.dart';
import '../../data/model/organization/team/team_member_model.dart';
import '../../data/repository/organization/team_repository.dart';


class TeamViewModel extends ChangeNotifier {
  final TeamRepository _repository = TeamRepository();

  // Loading States
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Data Lists (Strongly Typed)
  List<TeamSectionModel> _publicSections = [];
  List<TeamSectionModel> get publicSections => _publicSections;

  List<TeamMemberModel> _publicMembers = [];
  List<TeamMemberModel> get publicMembers => _publicMembers;

  List<TeamSectionModel> _managementSections = [];
  List<TeamSectionModel> get managementSections => _managementSections;

  List<TeamMemberModel> _managementMembers = [];
  List<TeamMemberModel> get managementMembers => _managementMembers;

  List<ImageShapeChoiceModel> _imageShapeChoices = [];
  List<ImageShapeChoiceModel> get imageShapeChoices => _imageShapeChoices;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // Public Section & Member Calls
  // ---------------------------------------------------------

  Future<void> fetchPublicSections() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _repository.getPublicSections();
      if (response is List) {
        _publicSections = response
            .map((e) => TeamSectionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPublicMembers({int? sectionId}) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _repository.getPublicMembers(sectionId: sectionId);
      if (response is List) {
        _publicMembers = response
            .map((e) => TeamMemberModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------
  // Team Section Management
  // ---------------------------------------------------------

  Future<void> fetchManagementSections({String? search}) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _repository.getManagementSections(search: search);
      if (response is List) {
        _managementSections = response
            .map((e) => TeamSectionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createTeamSection(TeamSectionModel section) async {
    _setSaving(true);
    _errorMessage = null;
    try {
      await _repository.createTeamSection(section.toJson());
      await fetchManagementSections();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setSaving(false);
    }
  }

  Future<bool> updateTeamSection(
      int id,
      Map<String, dynamic> data, {
        bool isPartial = true,
      }) async {
    _setSaving(true);
    _errorMessage = null;
    try {
      await _repository.updateTeamSection(id, data, isPartial: isPartial);
      await fetchManagementSections();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setSaving(false);
    }
  }

  Future<bool> deleteTeamSection(int id) async {
    _setSaving(true);
    _errorMessage = null;
    try {
      await _repository.deleteTeamSection(id);
      await fetchManagementSections();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setSaving(false);
    }
  }

  // ---------------------------------------------------------
  // Team Member Management
  // ---------------------------------------------------------

  Future<void> fetchManagementMembers({String? search, int? sectionId}) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _repository.getManagementMembers(
        search: search,
        sectionId: sectionId,
      );
      if (response is List) {
        _managementMembers = response
            .map((e) => TeamMemberModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createTeamMember(TeamMemberModel member) async {
    _setSaving(true);
    _errorMessage = null;
    try {
      await _repository.createTeamMember(member.toJson());
      await fetchManagementMembers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setSaving(false);
    }
  }

  Future<bool> updateTeamMember(
      int id,
      Map<String, dynamic> data, {
        bool isPartial = true,
      }) async {
    _setSaving(true);
    _errorMessage = null;
    try {
      await _repository.updateTeamMember(id, data, isPartial: isPartial);
      await fetchManagementMembers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setSaving(false);
    }
  }

  Future<bool> deleteTeamMember(int id) async {
    _setSaving(true);
    _errorMessage = null;
    try {
      await _repository.deleteTeamMember(id);
      await fetchManagementMembers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setSaving(false);
    }
  }

  // ---------------------------------------------------------
  // Bulk Operations & Choices
  // ---------------------------------------------------------

  Future<bool> performBulkMemberOperation(
      String action,
      List<int> memberIds,
      ) async {
    _setSaving(true);
    _errorMessage = null;
    try {
      await _repository.performBulkMemberOperation(action, memberIds);
      await fetchManagementMembers();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setSaving(false);
    }
  }

  Future<void> fetchImageShapeChoices() async {
    _errorMessage = null;
    try {
      final response = await _repository.getImageShapeChoices();
      if (response != null && response['choices'] != null) {
        final list = response['choices'] as List;
        _imageShapeChoices = list
            .map((e) => ImageShapeChoiceModel.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
}