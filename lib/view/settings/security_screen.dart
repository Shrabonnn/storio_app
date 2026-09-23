import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/settings/session_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Authenticaion/auth_view_model.dart';
import '../../viewModel/setting/security_view_model.dart';
import '../../viewModel/user_manage/user_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {

  int _visibleCount = 10;

  // 2FA has NO backend endpoint in the current Security API doc — this
  // is a local-only toggle until a real endpoint exists. Wire it up to
  // an actual API call the moment one is added.
  bool _is2FAEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SecurityViewModel>().getSessions();
    });
  }

  // ============================================================
  // 2FA (local-only — no backend endpoint documented yet)
  // ============================================================
  Future<void> _handleToggle2FA() async {
    final color = context.Appcolor;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: color.cardBackground,
          title: Text(
            _is2FAEnabled
                ? "Disable Two-Factor Authentication?"
                : "Enable Two-Factor Authentication?",
          ),
          content: TextBodyStyleWidget(
            title: _is2FAEnabled
                ? "You will no longer be asked for a verification code when signing in."
                : "You will be asked for a verification code from your mobile device when signing in.",
            fontbold: false,
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const TextTitleWidget(title: "No"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const TextTitleWidget(title: "Yes"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {
        _is2FAEnabled = !_is2FAEnabled;
      });

      if (!mounted) return;
      SnackBarMessage.showSnackBar(
        context,
        _is2FAEnabled
            ? "Two-Factor Authentication enabled"
            : "Two-Factor Authentication disabled",
      );
    }
  }

  // ============================================================
  // CHANGE PASSWORD (logged-in user's own password)
  // ============================================================
  void _showChangePasswordDialog() {
    final color = context.Appcolor;

    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: color.cardBackground,
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFieldWidget(
                controller: currentPasswordController,
                hintText: "Current Password",
                obscureText: true,
              ),
              SizedBox(height: AppSizes.sectionGap),
              CustomTextFieldWidget(
                controller: newPasswordController,
                hintText: "New Password",
                obscureText: true,
              ),
              SizedBox(height: AppSizes.sectionGap),
              CustomTextFieldWidget(
                controller: confirmPasswordController,
                hintText: "Confirm New Password",
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const TextTitleWidget(title: "Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final currentPassword =
                currentPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();
                final confirmPassword =
                confirmPasswordController.text.trim();

                if (currentPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty) {
                  SnackBarMessage.showSnackBar(
                    context,
                    "Please fill in all fields",
                  );
                  return;
                }

                if (newPassword != confirmPassword) {
                  SnackBarMessage.showSnackBar(
                    context,
                    "New passwords do not match",
                  );
                  return;
                }

                if (newPassword.length < 8) {
                  SnackBarMessage.showSnackBar(
                    context,
                    "Password must be at least 8 characters",
                  );
                  return;
                }

                final slug =
                    context.read<AuthViewModel>().currentUser?.username;

                if (slug == null || slug.isEmpty) {
                  SnackBarMessage.showSnackBar(
                    context,
                    "Could not identify your account. Please re-login and try again.",
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                final userVM = context.read<UserViewModel>();

                final success = await userVM.changePassword(
                  slug,
                  currentPassword,
                  newPassword,
                  confirmPassword,
                );

                if (!mounted) return;

                if (success) {
                  // Changing the password invalidates all issued JWT
                  // tokens server-side — so the current session's
                  // token is already dead. Log out locally and send
                  // the user back to login instead of leaving them on
                  // a screen that will just start failing with 401s.
                  SnackBarMessage.showSnackBar(
                    context,
                    "Password changed successfully. Please log in again.",
                  );

                  await context.read<AuthViewModel>().logoutApi();

                  if (!mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.login,
                        (route) => false,
                  );
                } else {
                  SnackBarMessage.showSnackBar(
                    context,
                    userVM.errorMessage ?? "Failed to change password",
                  );
                }
              },
              child: const TextTitleWidget(title: "Change"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SESSIONS: revoke one / logout all others
  // ============================================================

  Future<void> _handleRevokeSession(SessionModel session) async {
    if (session.id == null) return;

    final confirmed = await confirmAction(
      context,
      title: "Log Out Device",
      message:
      "Log out \"${session.device ?? 'this device'}\"? It will need to sign in again.",
    );

    if (!mounted || !confirmed) return;

    final securityVM = context.read<SecurityViewModel>();
    final success = await securityVM.revokeSession(session.id!);

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      success
          ? "Device logged out"
          : securityVM.errorMessage ?? "Failed to log out device",
    );
  }

  Future<void> _handleLogoutOthers() async {
    final confirmed = await confirmAction(
      context,
      title: "Log Out All Other Devices",
      message:
      "This will sign out every other device currently logged into your account. Continue?",
    );

    if (!mounted || !confirmed) return;

    final securityVM = context.read<SecurityViewModel>();
    final success = await securityVM.logoutOtherSessions();

    if (!mounted) return;

    if (success) {
      setState(() {
        _visibleCount = 10; // reset pagination — list just shrank
      });
    }

    SnackBarMessage.showSnackBar(
      context,
      success
          ? "Logged out of all other devices"
          : securityVM.errorMessage ?? "Failed to log out other devices",
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Security & Access",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // ==========================================
                    // Authentication & Recovery
                    // ==========================================
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextBodyStyleWidget(title: "Authentication & Recovery", color: color.primary,size: AppSizes.sectionTitle,),
                        Divider(
                          color: color.lightVersionOfPrimaryLightVersion,
                          height: 1, ),

                        // Title
                        TextBodyStyleWidget(title: "Password Change", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        TextBodyStyleWidget(title: "Update your primary login password regularly to keep your account safe.",size: AppSizes.cardTitle,fontbold: false,maxLines: 2,),
                        SizedBox(height: AppSizes.smallGap,),
                        CustomButton(
                          icon: Icons.key_outlined,
                          text: "Change Password",
                          onTap: _showChangePasswordDialog,
                        ),
                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    // ==========================================
                    // 2FA
                    // ==========================================
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextBodyStyleWidget(title: "Two-Factor Authentication (2FA)", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        TextBodyStyleWidget(title: "Add an extra layer of security to your account by requiring a code from your mobile device.",size: AppSizes.cardTitle,fontbold: false,maxLines: 2,),
                        SizedBox(height: AppSizes.smallGap,),
                        CustomButton(
                          icon: _is2FAEnabled ? Icons.lock_open_outlined : Icons.security,
                          text: _is2FAEnabled ? "Disable 2FA" : "Enable 2FA",
                          backgroundColor: _is2FAEnabled
                              ? color.lightVersionOfPrimaryLightVersion
                              : null,
                          foregroundColor: _is2FAEnabled
                              ? Colors.redAccent
                              : null,
                          onTap: _handleToggle2FA,
                        ),
                      ],
                    )),

                    SizedBox(height: AppSizes.sectionGap,),

                    // ==========================================
                    // Device Management
                    // ==========================================
                    Consumer<SecurityViewModel>(
                      builder: (context, securityVM, child) {
                        final totalCount = securityVM.sessionList.length;
                        final visibleSessions = securityVM.sessionList
                            .take(_visibleCount)
                            .toList();
                        final hasMore = _visibleCount < totalCount;

                        return CustomCard(child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            TextBodyStyleWidget(title: "Device Management", color: color.primary,size: AppSizes.sectionTitle,),
                            Divider(
                              color: color.lightVersionOfPrimaryLightVersion,
                              height: 1, ),

                            // Title
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                TextBodyStyleWidget(
                                  title: securityVM.sessionsLoading && totalCount == 0
                                      ? "Active Login Sessions"
                                      : "Active Login Sessions ($totalCount)",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            TextBodyStyleWidget(title: "Devices currently logged into your account.",size: AppSizes.cardTitle,fontbold: false,maxLines: 2,),
                            SizedBox(height: AppSizes.smallGap,),
                            CustomButton(
                              icon: Icons.logout,
                              text: "Log out All Others",
                              backgroundColor: color.lightVersionOfPrimaryLightVersion,
                              foregroundColor: Colors.redAccent,
                              onTap: securityVM.isLoggingOutOthers
                                  ? () {}
                                  : _handleLogoutOthers,
                            ),

                            SizedBox(height: AppSizes.smallGap,),
                            Divider(
                              color: color.lightVersionOfPrimaryLightVersion,
                              height: 1, ),

                            SizedBox(height: AppSizes.smallGap,),

                            if (securityVM.sessionsLoading && totalCount == 0)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            else if (securityVM.errorMessage != null && totalCount == 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: TextBodyStyleWidget(
                                    title: securityVM.errorMessage!,
                                  ),
                                ),
                              )
                            else if (totalCount == 0)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: TextBodyStyleWidget(
                                      title: "No active sessions found",
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: visibleSessions.length,
                                  itemBuilder: (context, index) {
                                    final session = visibleSessions[index];
                                    final isCurrent = session.isCurrent == true;

                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: index == visibleSessions.length - 1
                                            ? 0
                                            : AppSizes.sectionGap,
                                      ),
                                      child: CustomCard2(child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 6.h,
                                                  width: 12.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: color.cardBackground,
                                                    border: Border.all(
                                                      color: isCurrent
                                                          ? color.primary
                                                          : Colors.grey.shade200,
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    _deviceIcon(session.device),
                                                    color: color.primary,
                                                    size: AppSizes.iconLarge,
                                                  ),
                                                ),

                                                SizedBox(width: AppSizes.itemGap),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: TextBodyStyleWidget(
                                                              title: session.device ?? "Unknown device",
                                                              color: color.primary,
                                                              size: AppSizes.cardTitle,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          if (isCurrent) ...[
                                                            SizedBox(width: AppSizes.smallGap),
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal: 2.w,
                                                                vertical: 0.3.h,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                color: color.lightVersionOfPrimaryLightVersion,
                                                                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                                                              ),
                                                              child: Text(
                                                                "This Device",
                                                                style: TextStyle(
                                                                  fontSize: 10.sp,
                                                                  color: color.primary,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),

                                                      SizedBox(height: 0.5.h),

                                                      TextBodyStyleWidget(
                                                        title: "${session.location ?? 'Unknown location'} · ${session.ipAddress ?? ''}",
                                                        fontbold: false,
                                                        size: AppSizes.cardSubTitle,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            if (!isCurrent) ...[
                                              SizedBox(height: AppSizes.itemGap),
                                              CustomButton(
                                                text: securityVM.isRevokingSession
                                                    ? "Logging out..."
                                                    : "Log out",
                                                onTap: securityVM.isRevokingSession
                                                    ? () {}
                                                    : () => _handleRevokeSession(session),
                                              ),
                                            ],
                                          ],
                                        ),
                                      )),
                                    );
                                  },
                                ),

                            if (hasMore) ...[
                              SizedBox(height: AppSizes.smallGap),
                              CustomButton(
                                text: "Load More (${totalCount - _visibleCount} more)",
                                backgroundColor: color.cardBackground,
                                foregroundColor: color.primary,
                                onTap: () {
                                  setState(() {
                                    _visibleCount += 10;
                                  });
                                },
                              ),
                            ],
                          ],
                        ));
                      },
                    ),

                  ],
                )
              ]),
            ),
          ),


        ],
      ),
    );
  }

  IconData _deviceIcon(String? device) {
    final normalized = device?.toLowerCase() ?? '';
    if (normalized.contains('android') || normalized.contains('iphone') || normalized.contains('mobile')) {
      return Icons.smartphone_outlined;
    }
    if (normalized.contains('ipad') || normalized.contains('tablet')) {
      return Icons.tablet_mac_outlined;
    }
    return Icons.desktop_windows_outlined;
  }
}