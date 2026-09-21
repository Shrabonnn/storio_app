import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../utils/snackbar_message.dart';
import '../utils/theme/theme_ext.dart';
import '../viewModel/Authenticaion/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  void clear() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      backgroundColor: color.cardBackground,

      body: Stack(
        children: [
          // ---------------- top wave decoration ----------------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _TopWaveOuterClipper(),
              child: Container(
                height: 11.5.h,
                color: color.secondary.withValues(alpha: 0.28),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _TopWaveInnerClipper(),
              child: Container(
                height: 10.h,
                color: color.secondary.withValues(alpha: 0.45),
              ),
            ),
          ),

          // ---------------- bottom wave decoration ----------------
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _BottomWaveOuterClipper(),
              child: Container(
                height: 7.5.h,
                color: color.secondary.withValues(alpha: 0.25),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _BottomWaveInnerClipper(),
              child: Container(
                height: 5.5.h,
                color: color.primary.withValues(alpha: 0.18),
              ),
            ),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Storio",
                    style: GoogleFonts.libreBaskerville(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                  Text(
                    "Please Enter Your Details To Login",
                    style: TextStyle(
                      color: color.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Image.asset(
                    "assets/images/login.png",
                    height: 32.h,
                    width: 100.w,
                    fit: BoxFit.fitHeight,
                    color: color.cardBackground.withValues(alpha: 0.7),
                    colorBlendMode: BlendMode.modulate,
                  ),
                  SizedBox(height: 1.5.h),

                  _AuthTabSwitcher(
                    isLogin: _isLogin,
                    onChanged: (value) => setState(() => _isLogin = value),
                  ),
                  SizedBox(height: 2.5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitleWidget(title: "Email Address :"),
                        SizedBox(height: AppSizes.smallGap),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your email";
                            }
                            final emailRegex = RegExp(
                              r'^[\w.\-]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "example@gmail.com",
                            hintStyle: TextStyle(color: color.textSecondary),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: color.textSecondary,
                            ),
                          ),
                        ),

                        SizedBox(height: AppSizes.itemGap),
                        TextTitleWidget(title: "Password :"),
                        SizedBox(height: AppSizes.smallGap),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            }
                            if (value.length < 4) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "*******",
                            hintStyle: TextStyle(color: color.textSecondary),
                            prefixIcon: Icon(
                              Icons.password,
                              color: color.textSecondary,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot ?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        Consumer<AuthViewModel>(
                          builder: (context, auth, child) {
                            return auth.loading
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: () async{
                                     await _loginUser(auth,context);
                                    },
                                    child: Text("Sign in"),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.sectionGap),
                  TextBodyStyleWidget(title: "Powered By Brainicon"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loginUser(AuthViewModel auth, BuildContext context)async{
    if(_formKey.currentState!.validate()){
      Map<String,dynamic>loginData = {
        "email" :_emailController.text.trim(),
        "password": _passwordController.text
      };
      final String?errorMessage =  await auth.loginApi(loginData);

      if(errorMessage == null){
        clear();
        if(mounted){
          Navigator.pushReplacementNamed(context, RoutesName.nav_bar);
        }
      }else{
        if(mounted){
          SnackBarMessage.showSnackBar(
            context,
            errorMessage,
            backgroundColor: Colors.redAccent,
          );
        }
      }
    }
  }
}

/// Underline-style "Login / Sign Up" tab switcher, matching the Figma design.
class _AuthTabSwitcher extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onChanged;

  const _AuthTabSwitcher({required this.isLogin, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tab(context, "Login", isLogin, () => onChanged(true)),
        SizedBox(width: 10.w),
        _tab(context, "Sign Up", !isLogin, () => onChanged(false)),
      ],
    );
  }

  Widget _tab(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    final color = context.Appcolor;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.sectionTitle,

              color: selected ? color.primary : color.secondary,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: 44,
            color: selected ? color.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }


}

class _TopWaveOuterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.65);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.5,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _TopWaveInnerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.55);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.95,
      size.width * 0.55,
      size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.35,
      size.width,
      size.height * 0.6,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BottomWaveOuterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.55,
      size.width,
      size.height * 0.25,
    );
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BottomWaveInnerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.05,
      size.width * 0.55,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width,
      size.height * 0.35,
    );
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
