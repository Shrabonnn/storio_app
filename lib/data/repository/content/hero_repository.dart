import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/hero/hero_slide_model.dart';

class HeroSlideRepository {
  final NetworkApiServices _api = NetworkApiServices();

  /// GET /api/hero-slides/  (public, no auth)
  Future<List<HeroSlideModel>> getHeroSlideList() async {
    final response = await _api.getApi(
      AppUrl.heroSlidesPublicApi,
      requiresAuth: false,
    );

    final list = response as List<dynamic>;
    return list.map((e) => HeroSlideModel.fromJson(e)).toList();
  }

  /// GET /api/management/hero-slides/?search=  (auth required)
  Future<List<HeroSlideModel>> getManagementHeroSlideList(
      {String? search}) async {
    final response = await _api.getApi(
      AppUrl.heroSlidesManagementApi,
      queryParams:
      (search != null && search.isNotEmpty) ? {'search': search} : null,
    );

    final list = response as List<dynamic>;
    return list.map((e) => HeroSlideModel.fromJson(e)).toList();
  }

  /// GET /api/management/hero-slides/{id}/
  Future<HeroSlideModel> getHeroSlideDetail(int id) async {
    final response = await _api.getApi(AppUrl.heroSlideDetailApi(id));
    return HeroSlideModel.fromJson(response);
  }

  /// POST /api/management/hero-slides/create/
  Future<void> createHeroSlide(Map<String, dynamic> data) async {
    await _api.postApi(AppUrl.heroSlideCreateApi, data);
  }

  /// PATCH /api/management/hero-slides/{id}/
  Future<void> updateHeroSlide(int id, Map<String, dynamic> data) async {
    await _api.patchApi(AppUrl.heroSlideDetailApi(id), data);
  }

  /// DELETE /api/management/hero-slides/{id}/
  Future<void> deleteHeroSlide(int id) async {
    await _api.deleteApi(AppUrl.heroSlideDetailApi(id));
  }

  /// POST /api/management/hero-slides/reorder/
  Future<void> reorderHeroSlide(List<int> orderedIds) async {
    await _api.postApi(
      AppUrl.heroSlideReorderApi,
      {'ordered_ids': orderedIds},
    );
  }

  /// POST /api/management/hero-slides/bulk-operations/
  Future<void> bulkOperation(List<int> sectionIds) async {
    await _api.postApi(
      AppUrl.heroSlideBulkOperationsApi,
      {'section_ids': sectionIds},
    );
  }
}