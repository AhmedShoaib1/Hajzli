import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hijizli/l10n/app_localizations.dart';
import 'package:hijizli/ForgotYourPassword/ForgotYourPassword.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showRepeatPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final localizations = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(localizations.userNotFound);
      return;
    }

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();

    // التحقق من المدخلات
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        repeatPassword.isEmpty) {
      _showMessage(localizations.pleaseFillAllFields);
      return;
    }

    if (newPassword.length < 8) {
      _showMessage(localizations.passwordRequirementsText);
      return;
    }

    if (newPassword != repeatPassword) {
      _showMessage(localizations.passwordsMustMatch);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // إعادة مصادقة المستخدم بالبريد الإلكتروني وكلمة المرور الحالية
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // تغيير كلمة المرور
      await user.updatePassword(newPassword);

      _showMessage(localizations.passwordChangedSuccessfully, isSuccess: true);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = localizations.wrongPassword;
      } else if (e.code == 'weak-password') {
        errorMessage = localizations.passwordRequirementsText;
      } else if (e.code == 'requires-recent-login') {
        errorMessage = localizations.requiresRecentLogin;
      } else {
        errorMessage = '${localizations.unknownError}: ${e.message}';
      }
      _showMessage(errorMessage);
    } catch (e) {
      _showMessage('${localizations.unknownError}: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool showPassword,
    required VoidCallback togglePassword,
    Widget? extraWidget,
    IconData? iconData,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF795622), width: 2.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              extraWidget ?? const SizedBox.shrink(),
              Text(
                labelText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          TextField(
            controller: controller,
            obscureText: !showPassword,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:
                  TextStyle(color: const Color(0xFFC8C8C8), fontSize: 14.sp),
              prefixIcon: iconData != null
                  ? Icon(iconData, color: const Color(0xFF795622), size: 20.sp)
                  : null,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF795622),
                  size: 20.sp,
                ),
                onPressed: togglePassword,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFF795622)),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // الشريط العلوي
                SafeArea(
                  bottom: false,
                  child: Container(
                    width: double.infinity,
                    height: 88.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            localizations.changePassword,
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: const Color(0xFFEAEAEA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20.w,
                          top: 24.h,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              'images/geri.png',
                              width: 40.w,
                              height: 40.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // الشيفرة الحالية مع نص "هل نسيت كلمة السر؟"
                _buildPasswordField(
                  controller: _currentPasswordController,
                  labelText: localizations.currentPassword,
                  hintText: localizations.enterCurrentPassword,
                  showPassword: _showCurrentPassword,
                  togglePassword: () {
                    setState(() {
                      _showCurrentPassword = !_showCurrentPassword;
                    });
                  },
                  extraWidget: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotYourPassword(),
                        ),
                      );
                    },
                    child: Text(
                      localizations.forgotPassword,
                      style: TextStyle(
                        color: const Color(0xFF795622),
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  iconData: Icons.lock,
                ),

                // الشيفرة الجديدة
                _buildPasswordField(
                  controller: _newPasswordController,
                  labelText: localizations.newPassword,
                  hintText: localizations.enterNewPassword,
                  showPassword: _showNewPassword,
                  togglePassword: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                  iconData: Icons.lock_outline,
                ),

                // كرر الشيفرة الجديدة
                _buildPasswordField(
                  controller: _repeatPasswordController,
                  labelText: localizations.confirmNewPassword,
                  hintText: localizations.repeatNewPassword,
                  showPassword: _showRepeatPassword,
                  togglePassword: () {
                    setState(() {
                      _showRepeatPassword = !_showRepeatPassword;
                    });
                  },
                  iconData: Icons.lock_outline,
                ),

                SizedBox(height: 30.h),

                // زر التحديث
                Container(
                  width: 0.6.sw,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            localizations.updatePassword,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
