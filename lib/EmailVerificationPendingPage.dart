import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijizli/LogIn/LogIn.dart';
import 'package:hijizli/l10n/app_localizations.dart';

class EmailVerificationPendingPage extends StatefulWidget {
  final String email;
  const EmailVerificationPendingPage({super.key, required this.email});

  @override
  State<EmailVerificationPendingPage> createState() =>
      _EmailVerificationPendingPageState();
}

class _EmailVerificationPendingPageState
    extends State<EmailVerificationPendingPage> {
  bool _isResending = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPeriodicCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        timer.cancel();
        Navigator.pop(context);
        return;
      }
      await user.reload();
      if (user.emailVerified) {
        timer.cancel();
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LogIn(email: widget.email, password: ''),
      ),
      (route) => false,
    );
  }

  Future<void> _resendVerification() async {
    setState(() => _isResending = true);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.resendLinkSuccess ??
                  '✅ تم إعادة إرسال رابط التحقق',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)?.resendLinkFailed ?? '❌ فشل إعادة الإرسال'}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  Future<void> _checkVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pop(context);
      return;
    }
    await user.reload();
    user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      _timer?.cancel();
      _navigateToLogin();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.verificationNotComplete ??
                '❌ لم يتم التحقق بعد، حاول مرة أخرى',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.verifyAccountTitle ?? 'تفعيل الحساب'),
        backgroundColor: const Color(0xFF735C3A),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mark_email_unread,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    localizations?.accountCreatedSuccessfully ??
                        'تم إنشاء حسابك بنجاح!',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    localizations?.verificationEmailSent ??
                        'لقد أرسلنا رابط التفعيل إلى بريدك الإلكتروني:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    localizations?.verificationInstructions ??
                        'يرجى فتح بريدك الإلكتروني والضغط على رابط التفعيل، ثم العودة هنا واضغط على "تم التفعيل".',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  // رسالة التوجيه لمجلد البريد العشوائي (Spam/Junk)
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.amber.shade400),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.amber.shade800),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            localizations?.checkSpamFolder ??
                                'إذا لم تجد الرسالة في صندوق الوارد، يرجى التحقق من مجلد "الرسائل غير المرغوب فيها" (Spam/Junk) أو الأرشيف.',
                            style: TextStyle(
                              color: Colors.amber.shade800,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: _checkVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF735C3A),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      localizations?.checkVerificationButton ?? 'تم التفعيل',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: _isResending ? null : _resendVerification,
                    child: _isResending
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            localizations?.resendLinkButton ??
                                'إعادة إرسال رابط التفعيل',
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushReplacementNamed(context, '/selectLogin');
                      }
                    },
                    child: Text(
                      localizations?.signOutButton ?? 'تسجيل الخروج',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  // لا نضيف مسافة إضافية في الأسفل
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
