import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/settings/session_model.dart';

class SecurityRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // LIST ACTIVE SESSIONS
  // ============================================================
  Future<List<SessionModel>> getSessions() async {
    final response = await _apiServices.getApi(AppUrl.authSessions);

    return (response as List)
        .map((e) => SessionModel.fromJson(e))
        .toList();
  }

  // ============================================================
  // REVOKE A SPECIFIC SESSION
  // ============================================================
  //
  // NOTE: the backend rejects revoking the CURRENT session here (400
  // "Cannot revoke current session here. Use standard logout.") — the
  // calling side should filter out is_current sessions from any
  // "revoke" action and route those through the normal logout flow
  // instead (AuthRepository/AuthViewModel.logoutApi).
  Future<Map<String, dynamic>> revokeSession(int id) async {
    final response = await _apiServices.postApi(
      AppUrl.authSessionLogout(id),
      {},
    );
    return response;
  }

  // ============================================================
  // LOGOUT ALL OTHER SESSIONS
  // ============================================================
  Future<Map<String, dynamic>> logoutOtherSessions() async {
    final response = await _apiServices.postApi(
      AppUrl.authSessionsLogoutOthers,
      {},
    );
    return response;
  }

  // ============================================================
  // REQUEST PASSWORD RESET OTP (Public — logged-out flow)
  // ============================================================
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    final response = await _apiServices.postApi(
      AppUrl.passwordResetRequest,
      {"email": email},
      requiresAuth: false,
    );
    return response;
  }

  // ============================================================
  // CONFIRM PASSWORD RESET WITH OTP (Public — logged-out flow)
  // ============================================================
  Future<Map<String, dynamic>> confirmPasswordReset({
    required String email,
    required String otpCode,
    required String newPassword,
  }) async {
    final response = await _apiServices.postApi(
      AppUrl.passwordResetConfirm,
      {
        "email": email,
        "otp_code": otpCode,
        "new_password": newPassword,
      },
      requiresAuth: false,
    );
    return response;
  }
}