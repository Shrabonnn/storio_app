import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/Content/contact/contact_model.dart';

class ContactRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // public — auth লাগে না, ওয়েবসাইটের contact form থেকে আসে
  Future<bool> submitContactMessage({
    required String name,
    required String email,
    String? mobile,
    required String subject,
    required String message,
    String? recaptchaToken,
  }) async {
    final Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "subject": subject,
      "message": message,
    };

    if (mobile != null && mobile.isNotEmpty) {
      data["mobile"] = mobile;
    }
    if (recaptchaToken != null && recaptchaToken.isNotEmpty) {
      data["recaptcha_token"] = recaptchaToken;
    }

    final response = await _apiServices.postApi(
      AppUrl.getContactMessages,
      data,
      requiresAuth: false,
    );

    if (response is Map<String, dynamic>) {
      return response['success'] == true;
    }

    return false;
  }

  Future<List<ContactMessageModel>> getContactMessages({
    String? status,
    String? search,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiServices.getApi(
      AppUrl.getContactMessages,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List)
        .map((e) => ContactMessageModel.fromJson(e))
        .toList();
  }

  Future<ContactMessageModel> getContactMessageDetail(int id) async {
    final response =
    await _apiServices.getApi(AppUrl.contactMessageDetail(id));
    return ContactMessageModel.fromJson(response);
  }

  Future<bool> markAsRead(int id) async {
    final response = await _apiServices.postApi(
      AppUrl.markContactAsRead(id),
      {},
    );

    if (response is Map<String, dynamic>) {
      return response['success'] == true;
    }

    return false;
  }

  Future<bool> markAsReplied(int id) async {
    final response = await _apiServices.postApi(
      AppUrl.markContactAsReplied(id),
      {},
    );

    if (response is Map<String, dynamic>) {
      return response['success'] == true;
    }

    return false;
  }

  Future<bool> markAsArchived(int id) async {
    final response = await _apiServices.postApi(
      AppUrl.markContactAsArchived(id),
      {},
    );

    if (response is Map<String, dynamic>) {
      return response['success'] == true;
    }

    return false;
  }


  // doc অনুযায়ী 204 No Content — body খালি থাকতে পারে
  Future<void> deleteContactMessage(int id) async {
    await _apiServices.deleteApi(AppUrl.contactMessageDetail(id));
  }
}