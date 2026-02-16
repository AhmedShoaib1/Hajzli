import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hajzli/SelectTheLoginProcess/SelectTheLoginProcess.dart';
import 'package:hajzli/ForgotYourPassword/ForgotYourPassword.dart';
import 'package:hajzli/UserPage/UserPage.dart';
import 'package:hajzli/l10n/app_localizations.dart';
import '../main.dart';

// ✅ تم حذف الاستيراد غير المستخدم: EmailVerificationPendingPage

class LogIn extends StatefulWidget {
  final String? email;
  final String? password;

  const LogIn({super.key, this.email, this.password});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String errorMessage = '';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      emailController.text = widget.email!;
    }
    if (widget.password != null) {
      passwordController.text = widget.password!;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      errorMessage = '';
      _isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = localizations.pleaseFillAllFields;
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        setState(() {
          errorMessage = localizations.emailNotVerified;
          _isLoading = false;
        });
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserPage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = localizations.accountNotRegistered;
      } else if (e.code == 'wrong-password') {
        errorMessage = localizations.wrongPassword;
      } else if (e.code == 'invalid-email') {
        errorMessage = localizations.invalidEmailFormat;
      } else if (e.code == 'user-disabled') {
        errorMessage = 'تم تعطيل هذا الحساب';
      } else {
        errorMessage = '❌ ${e.message}';
      }
      setState(() {});
    } catch (e) {
      errorMessage = '❌ حدث خطأ غير متوقع';
      setState(() {});
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: statusBarHeight,
              right: 0,
              child: Image.asset(
                "images/harita.png",
                width: 1.sw,
                height: 150.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: statusBarHeight + 140.h,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          (statusBarHeight + 140.h),
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF8BC923),
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SelectTheLoginProcess(),
                                      ),
                                    );
                                  },
                                ),
                                const Spacer(),
                                Text(
                                  localizations.logIn,
                                  style: TextStyle(
                                    color: const Color(0xFF755E3C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.sp,
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(width: 40.w),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  localizations.emailAddress,
                                  style: TextStyle(
                                    color: const Color(0xFF676767),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: const Color(0xFF795622),
                                  width: 1.5.w,
                                ),
                              ),
                              child: TextFormField(
                                controller: emailController,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                    RegExp(
                                      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
                                    ),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'example@email.com',
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: const Color(0xFF795622),
                                    size: 20.sp,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 16.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  localizations.password,
                                  style: TextStyle(
                                    color: const Color(0xFF676767),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: const Color(0xFF795622),
                                  width: 1.5.w,
                                ),
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: !_isPasswordVisible,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                    RegExp(
                                      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
                                    ),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  hintText: '********',
                                  hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.3),
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: const Color(0xFF795622),
                                    size: 20.sp,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xFF795622),
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 16.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotYourPassword(),
                                    ),
                                  );
                                },
                                child: Text(
                                  localizations.forgotPassword,
                                  style: TextStyle(
                                    color: const Color(0xFFA4A4A4),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40.h),
                            Center(
                              child: Container(
                                width: 250.w,
                                height: 45.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF9C3FE4),
                                      Color(0xFFC65647),
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          localizations.logIn,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            if (errorMessage.isNotEmpty)
                              Center(
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: statusBarHeight + 10.h,
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
                  icon:
                      const Icon(Icons.language, color: Colors.white, size: 24),
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
      ),
    );
  }
}
