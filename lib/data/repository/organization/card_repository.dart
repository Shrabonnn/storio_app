import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/organization/card/card_model.dart';


class CardRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // GET ALL CARDS
  // ============================================================

  Future<List<CardModel>> getCardsApi() async {
    final response = await _apiServices.getApi(
      AppUrl.cardsApi,
      requiresAuth: false,
    );

    final Map<String, dynamic> data =
    response as Map<String, dynamic>;

    final List<dynamic> results =
    data['results'] as List<dynamic>;

    return results
        .map(
          (json) => CardModel.fromJson(
        json as Map<String, dynamic>,
      ),
    ).toList();
  }

  // ============================================================
  // GET CARD DETAIL
  // ============================================================

  Future<CardModel> getCardByIdApi(int id) async {
    final response = await _apiServices.getApi(
      AppUrl.cardDetailApi(id),
      requiresAuth: false,
    );

    return CardModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  // ============================================================
  // CREATE CARD
  // ============================================================

  Future<CardModel> createCardApi(
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.cardsApi,
      data,
      requiresAuth: true,
    );

    return CardModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  // ============================================================
  // PUT CARD
  // ============================================================

  Future<CardModel> updateCardApi(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.putApi(
      AppUrl.cardDetailApi(id),
      data,
      requiresAuth: true,
    );

    return CardModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  // ============================================================
  // PATCH CARD
  // ============================================================

  Future<CardModel> patchCardApi(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.cardDetailApi(id),
      data,
      requiresAuth: true,
    );

    return CardModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  // ============================================================
  // DELETE CARD
  // ============================================================

  Future<void> deleteCardApi(int id) async {
    await _apiServices.deleteApi(
      AppUrl.cardDetailApi(id),
      requiresAuth: true,
    );
  }

  // ============================================================
  // REORDER CARDS
  // ============================================================

  Future<Map<String, dynamic>> reorderCardsApi(
      List<int> ids,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.cardReorderApi,
      {
        'ids': ids,
      },
      requiresAuth: true,
    );

    return response as Map<String, dynamic>;
  }
}