import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/organization/leader_message/leadership_message_model.dart';
import '../../model/organization/leader_message/leadership_message_status_choice_model.dart';

class LeadershipMessageRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();


  // LIST (Management)

  Future<List<LeadershipMessageModel>> getMessageList({
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
      AppUrl.getManagementLeadershipMessages,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List)
        .map((e) => LeadershipMessageModel.fromJson(e))
        .toList();
  }


  // LIST (Public)

  Future<List<LeadershipMessageModel>> getPublicMessageList() async {
    final response = await _apiServices.getApi(
      AppUrl.getLeadershipMessages,
      requiresAuth: false,
    );

    return (response as List)
        .map((e) => LeadershipMessageModel.fromJson(e))
        .toList();
  }


  // DETAIL

  Future<LeadershipMessageModel> getMessageDetail(int id) async {
    final response =
    await _apiServices.getApi(AppUrl.leadershipMessageDetail(id));
    return LeadershipMessageModel.fromJson(response);
  }


  // CREATE

  Future<LeadershipMessageModel> createMessage(
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.createLeadershipMessage,
      data,
    );


    return LeadershipMessageModel.fromJson(response['data']);
  }


  // UPDATE (PATCH)

  Future<LeadershipMessageModel> updateMessage(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.leadershipMessageDetail(id),
      data,
    );

    return LeadershipMessageModel.fromJson(response['data']);
  }

  
  // DELETE

  Future<Map<String, dynamic>> deleteMessage(int id) async {
    final response =
    await _apiServices.deleteApi(AppUrl.leadershipMessageDetail(id));
    return Map<String, dynamic>.from(response);
  }


  // STATUS CHOICES

  Future<List<LeadershipMessageStatusChoiceModel>> getStatusChoices() async {
    final response =
    await _apiServices.getApi(AppUrl.getLeadershipMessageStatusChoices);

    // doc অনুযায়ী এই endpoint সরাসরি একটা List রিটার্ন করে
    return (response as List)
        .map((e) => LeadershipMessageStatusChoiceModel.fromJson(e))
        .toList();
  }


  // BULK OPERATIONS (publish / draft / delete)

  Future<Map<String, dynamic>> bulkOperation({
    required String action,
    required List<int> ids,
  }) async {
    final response = await _apiServices.postApi(
      AppUrl.leadershipMessageBulkOperations,
      {
        "action": action,
        "ids": ids,
      },
    );

    return Map<String, dynamic>.from(response);
  }


  // REORDER

  Future<Map<String, dynamic>> reorderMessages(
      List<int> orderedIds,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.leadershipMessageReorder,
      {"ordered_ids": orderedIds},
    );

    return Map<String, dynamic>.from(response);
  }
}