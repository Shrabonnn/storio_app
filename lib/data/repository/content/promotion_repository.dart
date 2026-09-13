import 'package:storio_app/core/network/network_api_services.dart';
import 'package:storio_app/data/model/Content/promotion/promotion_model.dart';
import 'package:storio_app/res/api_url/app_url.dart';

class PromotionRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();


  // Track Promotion

   Future<bool> trackPromotionClick(int id) async {
     final response = await _apiServices.postApi(
       AppUrl.promotionClick(id),
       {},
     );

     if(response is Map<String,dynamic>) {
       return response['success'] ==true;
     }

     return false;
   }

   // Get Promotion

   Future<List<PromotionModel>> getManagementPromotions ({
   String? search,
   String? status,
   String? type,
   })async{

     final Map<String,dynamic> queryParams = {};

     if(search!= null && search.isNotEmpty) queryParams['search'] = search;
     if(status!= null && status.isNotEmpty) queryParams['status'] = status;
     if(type!= null && type.isNotEmpty) queryParams['type'] = type;


     final response = await _apiServices.getApi(
       AppUrl.getManagementPromotions,
       queryParams: queryParams.isEmpty ? null : queryParams
     );

     return (response as List)
         .map((e)=> PromotionModel.fromJson(e))
         .toList();
   }


   // Create Pormotion
  Future<PromotionModel> createPromotion(Map<String, dynamic> data) async{
    final response = await _apiServices.postApi(
        AppUrl.createPromotion,
        data
    );

    return PromotionModel.fromJson(response);
  }

  // Publish
   Future<PromotionModel> publishPromotion(int id) async{
     final response = await _apiServices.postApi(
       AppUrl.publishPromotion(id),
        {}
     );

     return PromotionModel.fromJson(response);
   }

   // Archive
  Future<PromotionModel> archivePromotion(int id) async{
    final response = await _apiServices.postApi(
        AppUrl.archivePromotion(id),
        {}
    );

    return PromotionModel.fromJson(response);
  }

  // draft
  Future<PromotionModel> draftPromotion(int id) async{
    final response = await _apiServices.postApi(
        AppUrl.draftPromotion(id),
        {}
    );

    return PromotionModel.fromJson(response);
  }

  // Restore Promotion
  Future<PromotionModel> restorePromotion(int id) async {
    final response = await _apiServices.postApi(
      AppUrl.restorePromotion(id),
      {},
    );

    return PromotionModel.fromJson(response);
  }

  // Get Promotions from Bin
  Future<List<PromotionModel>> getBinPromotions() async {
    final response = await _apiServices.getApi(
      AppUrl.movedToBin,
    );

    return (response as List)
        .map((e) => PromotionModel.fromJson(e))
        .toList();
  }

  // Update Promotion
  Future<PromotionModel> updatePromotion(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.updateManagementPromotions(id),
      data,
    );

    return PromotionModel.fromJson(response);
  }


  // Permanently Delete Promotion
  Future<bool> permanentlyDeletePromotion(int id) async {
    await _apiServices.deleteApi(
      AppUrl.permanentlyDeletePromotion(id),
    );

    return true;
  }

  // Bulk Operation
  Future<Map<String,dynamic>> bulkPromotion ({
    required List<int> ids,
    required String action,
    }) async{

     final Map<String,dynamic> data = {
       "ids": ids,
       "action": action
     };

     final response = await _apiServices.postApi(
         AppUrl.bulkPromotion,
         data
     );

     return Map<String,dynamic>.from(response);
  }
}