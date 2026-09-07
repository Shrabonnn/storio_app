import 'package:flutter/material.dart';


import '../../core/utils/parse_helper.dart';
import '../../data/model/Content/notice/notice_model.dart';
import '../../data/model/Content/notice/status_choice_model.dart';
import '../../data/repository/content/notice_repository.dart';
import '../../widget/universal/date_time_formate.dart';

class NoticeViewModel extends ChangeNotifier {
  final NoticeRepository _repository = NoticeRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  List<NoticeModel> noticeList = [];

  List<StatusChoiceModel> statusChoices = [];
  bool statusLoading = false;

  Future<void> getStatusChoices() async {
    statusLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getNoticeStatusChoicesApi();
      final List choices = response['choices'];

      statusChoices = choices
          .map((item) => StatusChoiceModel.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint("STATUS CHOICES: ${statusChoices.map((e) => e.value).toList()}");
    } catch (e) {
      debugPrint("STATUS CHOICES ERROR: $e");
    } finally {
      statusLoading = false;
      notifyListeners();
    }
  }





  Future<void> getNoticeApi({String? status, String? search}) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getManagementNoticeApi(
        status: status,
        search: search,
      );

      debugPrint("NOTICE RESPONSE: $response");
      debugPrint("NOTICE LIST LENGTH: ${noticeList.length}");

      final items = parseApiList(response);

      noticeList = items
          .map((item) => NoticeModel.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint("NOTICE LIST LENGTH: ${noticeList.length}");
    } catch (e) {
      debugPrint("NOTICE ERROR: $e");
      _errorMessage = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }



  // create notice
  Future<bool> createNoticeApi({
    required String title,
    required String content,
    required String status,
    DateTime? publishDate,
    List<int>? attachments,
  }) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.createNoticeApi(
        title: title,
        content: content,
        status: status,
        publishDate: publishDate?.toIso8601String(),
        attachments: attachments,
      );

      debugPrint("CREATE NOTICE RESPONSE: $response");

      return true;
    } catch (e) {
      debugPrint("CREATE NOTICE ERROR: $e");
      _errorMessage = e.toString();

      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }



  //update notice

  Future<bool> updateNoticeApi({
    required int id,
    required String title,
    required String content,
    required String status,
    DateTime? publishDate,
    List<int>? attachments,
    bool? pdfViewMode,
  }) async {
    try {
      _errorMessage = null;

      final response = await _repository.updateNoticeApi(
        id: id,
        title: title,
        content: content,
        status: status,
        publishDate: publishDate?.toIso8601String(),
        attachments: attachments,
        pdfViewMode: pdfViewMode,
      );

      debugPrint("UPDATE NOTICE RESPONSE: $response");

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint("UPDATE NOTICE ERROR: $e");

      notifyListeners();

      return false;
    }
  }



  Future<bool> archiveNotice(int id) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.archiveNoticeApi(id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("ARCHIVE NOTICE ERROR: $e");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> restoreNotice(int id) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.restoreNoticeApi(id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("RESTORE NOTICE ERROR: $e");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> bulkAction({
    required String action,
    required List<int> noticeIds,
  }) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.bulkNoticeApi(
        action: action,
        noticeIds: noticeIds,
      );
      debugPrint("BULK ACTION RESPONSE: $response");
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("BULK ACTION ERROR: $e");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }


  Future<List<int>> fetchBinnedNoticeIds() async {
    try {
      final response = await _repository.getManagementNoticeApi(status: "binned");

      final List items = response is List ? response : (response['results'] ?? []);

      return items
          .map((item) => item['id'])
          .whereType<int>()
          .toList();
    } catch (e) {
      debugPrint("FETCH BINNED IDS ERROR: $e");
      return [];
    }
  }
}