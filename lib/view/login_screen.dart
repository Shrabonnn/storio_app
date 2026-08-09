import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
                color: AppColors.secondary.withValues(alpha: 0.28),
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
                color: AppColors.secondary.withValues(alpha: 0.45),
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
                color: AppColors.secondary.withValues(alpha: 0.25),
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
                color: AppColors.primary.withValues(alpha: 0.18),
              ),
            ),
          ),
          SafeArea(child:Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Storio",style: GoogleFonts.libreBaskerville(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp
              ),),
              Text("Please Enter Your Details To Login",style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp

              ),),
              SizedBox(height: 1.5.h,),
              Image.asset("assets/images/login.png",height: 32.h,width: 100.w,fit: BoxFit.fitHeight,color: Colors.white.withValues(alpha:0.7),colorBlendMode: BlendMode.modulate,),
              SizedBox(height: 1.5.h,),

              _AuthTabSwitcher(
                isLogin: _isLogin,
                onChanged: (value) => setState(() => _isLogin = value),
              ),
              SizedBox(height: 2.5.h,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email Address :",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary
                    ),),
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
                        prefixIcon: Icon(Icons.email_outlined,color: AppColors.primary,),

                      ),),

                    SizedBox(height: 1.5.h,),
                    Text("Password :",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary
                    ),),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value){
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
                          prefixIcon: Icon(Icons.password,color: AppColors.primary,)
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: (){}, child: Text("Forgot?",style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),)),
                      ],
                    ),
                    SizedBox(height: 2.h,),
                    ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, RoutesName.nav_bar);
                    }, child: Text("Sign in")),


                    SizedBox(height: 2.h,),

                  ],

                ),
              ),
              Text("Powered By Brainicon")
            ],
          ))
        ],
      ),
    );
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
        _tab("Login", isLogin, () => onChanged(true)),
        SizedBox(width: 10.w),
        _tab("Sign Up", !isLogin, () => onChanged(false)),
      ],
    );
  }

  Widget _tab(String label, bool selected, VoidCallback onTap) {
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
              fontSize: 15.sp
              ,

              color: selected ? AppColors.primary : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: 44,
            color: selected ? AppColors.primary : Colors.transparent,
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
      size.width * 0.25, size.height,
      size.width * 0.5, size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.5,
      size.width, size.height * 0.8,
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
      size.width * 0.3, size.height * 0.95,
      size.width * 0.55, size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.35,
      size.width, size.height * 0.6,
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
      size.width * 0.25, 0,
      size.width * 0.5, size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.55,
      size.width, size.height * 0.25,
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
      size.width * 0.3, size.height * 0.05,
      size.width * 0.55, size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.7,
      size.width, size.height * 0.35,
    );
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
