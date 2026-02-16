import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:hajzli/SearchTrips/SearchTrips.dart';
import 'package:hajzli/Home/home.dart';
import 'package:hajzli/SignIn/SignIn.dart';
import 'package:hajzli/LogIn/LogIn.dart';
import 'package:hajzli/HelpCenter/HelpCenter.dart';
import 'package:hajzli/l10n/app_localizations.dart';
import '../main.dart';

class SelectTheLoginProcess extends StatefulWidget {
  final int initialIndex;

  const SelectTheLoginProcess({super.key, this.initialIndex = 3});

  @override
  State<SelectTheLoginProcess> createState() => _SelectTheLoginProcessState();
}

class _SelectTheLoginProcessState extends State<SelectTheLoginProcess> {
  late int _currentIndex;
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // ✅ تسجيل الدخول عبر Google
  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      return null;
    }
  }

  // ✅ تسجيل الدخول عبر Facebook (معدل)
  Future<User?> _signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString, // ✅ التصحيح هنا
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      debugPrint('Facebook Sign-In Error: $e');
      return null;
    }
  }

  // ✅ تسجيل الدخول عبر Apple
  Future<User?> _signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
      return userCredential.user;
    } catch (e) {
      debugPrint('Apple Sign-In Error: $e');
      return null;
    }
  }

  // ✅ دالة موحدة للتعامل مع نجاح تسجيل الدخول
  Future<void> _handleSocialLogin(Future<User?> Function() loginMethod) async {
    final user = await loginMethod();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ فشل تسجيل الدخول، حاول مرة أخرى'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildActiveIcon(int index) {
    return SizedBox(
      width: 60.w,
      height: 80.h,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 68.w,
              height: 40.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          Positioned(
            top: -30.h,
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xFFEE8143),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(_icons[index], color: Colors.white, size: 35.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveIcon(int index) {
    return GestureDetector(
      onTap: () => _navigateToPage(index),
      child: Container(
        height: 61.h,
        alignment: Alignment.center,
        child: Icon(
          _icons[index],
          color: Colors.white.withOpacity(0.7),
          size: 30.sp,
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchTrips()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HelpCenter()),
        );
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Image.asset(
                  "images/Hajzli.png",
                  fit: BoxFit.contain,
                  height: 200.h,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Container(
                  width: 1.sw,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h),
                          Text(
                            localizations.createAccountWithHijizli,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            localizations.haveAccount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          _buildActionButton(
                            text: localizations.logIn,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LogIn()),
                              );
                            },
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            localizations.noAccount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          _buildActionButton(
                            text: localizations.createAccount,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignIn()),
                              );
                            },
                          ),
                          SizedBox(height: 40.h),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                    color: Colors.white, thickness: 1.w),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  localizations.orContinueWith,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                    color: Colors.white, thickness: 1.w),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialIcon(
                                "images/facebook.png",
                                onTap: () =>
                                    _handleSocialLogin(_signInWithFacebook),
                              ),
                              SizedBox(width: 20.w),
                              _buildSocialIcon(
                                "images/google.png",
                                onTap: () =>
                                    _handleSocialLogin(_signInWithGoogle),
                              ),
                              SizedBox(width: 20.w),
                              FutureBuilder<bool>(
                                future: SignInWithApple.isAvailable(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data == true) {
                                    return _buildSocialIcon(
                                      "images/apple.png",
                                      onTap: () =>
                                          _handleSocialLogin(_signInWithApple),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50.h,
            right: 20.w,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                color: Color(0xFF735C3A),
                shape: BoxShape.circle,
              ),
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.language, color: Colors.white, size: 24),
                onSelected: (value) {
                  Locale newLocale;
                  if (value == 'ar') {
                    newLocale = const Locale('ar');
                  } else if (value == 'tr') {
                    newLocale = const Locale('tr');
                  } else {
                    newLocale = const Locale('en');
                  }
                  MyApp.setLocale(context, newLocale);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'ar',
                    child: Row(
                      children: [
                        const Icon(Icons.language,
                            color: Color(0xFF735C3A), size: 18),
                        const SizedBox(width: 10),
                        Text(localizations.arabic),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'en',
                    child: Row(
                      children: [
                        const Icon(Icons.language,
                            color: Color(0xFF735C3A), size: 18),
                        const SizedBox(width: 10),
                        Text(localizations.english),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'tr',
                    child: Row(
                      children: [
                        const Icon(Icons.language,
                            color: Color(0xFF735C3A), size: 18),
                        const SizedBox(width: 10),
                        Text(localizations.turkish),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: 1.sw,
        height: 61.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            bool isActive = _currentIndex == index;
            return isActive
                ? _buildActiveIcon(index)
                : _buildInactiveIcon(index);
          }),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 310.w,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD9D9D9), Colors.white],
          ),
          borderRadius: BorderRadius.circular(31.r),
          border: Border.all(color: const Color(0xFF795622), width: 2.w),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF795622),
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
