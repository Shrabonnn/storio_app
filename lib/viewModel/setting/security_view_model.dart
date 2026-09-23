import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../data/model/settings/session_model.dart';
import '../../data/repository/settings/security_repository.dart';

class SecurityViewModel extends ChangeNotifier {
  final SecurityRepository _repository = SecurityRepository();

  // ============================================================
  // STATE
  // ============================================================

  bool sessionsLoading = false;
  List<SessionModel> sessionList = [];

  bool isRevokingSession = false;
  bool isLoggingOutOthers = false;

  bool isSendingResetOtp = false;
  bool isConfirmingReset = false;

  String? errorMessage;

  // ============================================================
  // LIST SESSIONS
  // ============================================================
  Future<void> getSessions() async {
    sessionsLoading = true;
    notifyListeners();

    try {
      sessionList = await _repository.getSessions();
      errorMessage = null;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = "Something went wrong. Please try again.";
    } finally {
      sessionsLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // REVOKE A SPECIFIC SESSION
  // ============================================================
  //
  // The current session cannot be revoked through this endpoint — the
  // screen should route that action through AuthViewModel.logoutApi()
  // instead, and simply not show a "revoke" action on the is_current
  // session's row.
  Future<bool> revokeSession(int id) async {
    isRevokingSession = true;
    notifyListeners();

    try {
      await _repository.revokeSession(id);
      sessionList.removeWhere((s) => s.id == id);
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Failed to revoke session.";
      return false;
    } finally {
      isRevokingSession = false;
      notifyListeners();
    }
  }

  // ============================================================
  // LOGOUT ALL OTHER SESSIONS
  // ============================================================
  Future<bool> logoutOtherSessions() async {
    isLoggingOutOthers = true;
    notifyListeners();

    try {
      await _repository.logoutOtherSessions();
      // Keep only the current session locally, matching what the
      // backend just did server-side.
      sessionList = sessionList.where((s) => s.isCurrent == true).toList();
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Failed to log out other sessions.";
      return false;
    } finally {
      isLoggingOutOthers = false;
      notifyListeners();
    }
  }

  // ============================================================
  // REQUEST PASSWORD RESET OTP (logged-out flow)
  // ============================================================
  Future<bool> requestPasswordReset(String email) async {
    isSendingResetOtp = true;
    notifyListeners();

    try {
      await _repository.requestPasswordReset(email);
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Failed to send reset code.";
      return false;
    } finally {
      isSendingResetOtp = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CONFIRM PASSWORD RESET WITH OTP (logged-out flow)
  // ============================================================
  Future<bool> confirmPasswordReset({
    required String email,
    required String otpCode,
    required String newPassword,
  }) async {
    isConfirmingReset = true;
    notifyListeners();

    try {
      await _repository.confirmPasswordReset(
        email: email,
        otpCode: otpCode,
        newPassword: newPassword,
      );
      errorMessage = null;
      return true;
    } on ApiException catch (e) {
      // Surfaces backend messages like "OTP has expired" or
      // "Too many failed attempts. Please try again later." directly.
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = "Failed to reset password.";
      return false;
    } finally {
      isConfirmingReset = false;
      notifyListeners();
    }
  }
}