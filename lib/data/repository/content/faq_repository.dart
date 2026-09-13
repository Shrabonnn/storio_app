import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/Content/faq/faq_model.dart';

class FaqRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // FAQ LIST (Management)
  // ============================================================
  Future<List<FaqModel>> getFaqList() async {
    final response = await _apiServices.getApi(AppUrl.getManagementFaqs);

    return (response as List).map((e) => FaqModel.fromJson(e)).toList();
  }

  // ============================================================
  // FAQ LIST (Public)
  // ============================================================
  Future<List<FaqModel>> getPublicFaqList() async {
    final response = await _apiServices.getApi(
      AppUrl.getFaqs,
      requiresAuth: false,
    );

    return (response as List).map((e) => FaqModel.fromJson(e)).toList();
  }

  // ============================================================
  // FAQ DETAIL
  // ============================================================
  Future<FaqModel> getFaqDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.faqDetail(id));
    return FaqModel.fromJson(response);
  }

  // ============================================================
  // CREATE FAQ
  // ============================================================
  Future<FaqModel> createFaq(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createFaq, data);
    return FaqModel.fromJson(response['faq']);
  }

  // ============================================================
  // UPDATE FAQ (PATCH)
  // ============================================================
  Future<FaqModel> updateFaq(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.faqDetail(id), data);
    return FaqModel.fromJson(response['faq']);
  }

  // ============================================================
  // DELETE FAQ
  // ============================================================
  Future<Map<String, dynamic>> deleteFaq(int id) async {
    final response = await _apiServices.deleteApi(AppUrl.faqDetail(id));
    return response;
  }
}