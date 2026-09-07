import 'package:storio_app/core/network/network_api_services.dart';

import '../../res/api_url/app_url.dart';

class AuthRepository {

  final _apiServices = NetworkApiServices();

  Future<dynamic> loginApi(dynamic data) async {

      dynamic response = await _apiServices.postApi(
        AppUrl.loginApi,
        data,
        requiresAuth: false
      );

      return response;
  }
}