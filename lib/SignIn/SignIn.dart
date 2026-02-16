import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hijizli/l10n/app_localizations.dart';
import '../main.dart';

// ✅ تم حذف استيراد UsersPrivateInformation لأنه لم يعد مستخدماً

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String completePhoneNumber = "";
  String countryCode = "+963";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String errorMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      errorMessage = '';
      _isLoading = true;
    });

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final phone = completePhoneNumber;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if ([firstName, lastName, email, phone, password, confirmPassword]
        .any((e) => e.isEmpty)) {
      setState(() {
        errorMessage = localizations.pleaseFillAllFields;
        _isLoading = false;
      });
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        errorMessage = localizations.invalidEmailFormat;
        _isLoading = false;
      });
      return;
    }

    if (password.length < 6 || RegExp(r'[\u0600-\u06FF]').hasMatch(password)) {
      setState(() {
        errorMessage = localizations.passwordRequirementsText;
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = localizations.passwordsMustMatch;
        _isLoading = false;
      });
      return;
    }

    try {
      // ✅ إنشاء المستخدم في Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // ✅ تحديث اسم المستخدم (الاسم الأول + الأخير)
      await userCredential.user?.updateDisplayName('$firstName $lastName');

      // ✅ إرسال رابط التحقق إلى البريد
      await userCredential.user?.sendEmailVerification();

      // ✅ ❌ تم حذف حفظ البيانات في UsersPrivateInformation (لم نعد بحاجة إليه)

      // ✅ الانتقال إلى صفحة التحقق مع تمرير البريد
      Navigator.pushReplacementNamed(
        context,
        '/emailVerification',
        arguments: {'email': email},
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage = localizations.emailAlreadyRegistered;
      } else if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جداً';
      } else if (e.code == 'invalid-email') {
        errorMessage = localizations.invalidEmailFormat;
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
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const Spacer(),
                                  Text(
                                    localizations.createAccount,
                                    style: TextStyle(
                                      color: const Color(0xFF755E3C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Spacer(),
                                  SizedBox(width: 40.w),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              _buildFieldWithLabel(
                                label: localizations.firstName,
                                controller: firstNameController,
                                hint: localizations.enterFirstName,
                                allowArabic: true,
                              ),
                              SizedBox(height: 12.h),
                              _buildFieldWithLabel(
                                label: localizations.lastName,
                                controller: lastNameController,
                                hint: localizations.enterLastName,
                                allowArabic: true,
                              ),
                              SizedBox(height: 12.h),
                              _buildFieldWithLabel(
                                label: localizations.emailAddress,
                                controller: emailController,
                                hint: 'example@email.com',
                                keyboardType: TextInputType.emailAddress,
                                allowArabic: false,
                              ),
                              SizedBox(height: 12.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: localizations.phoneNumber,
                                        style: const TextStyle(
                                          color: Color(0xFF676767),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " *",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 55.h,
                                      margin: EdgeInsets.only(right: 8.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: const Color(0xFF795622),
                                          width: 1.5.w,
                                        ),
                                      ),
                                      child: CountryCodePicker(
                                        onChanged: (code) {
                                          setState(() {
                                            countryCode =
                                                code.dialCode ?? "+963";
                                            completePhoneNumber =
                                                "$countryCode${phoneController.text}";
                                          });
                                        },
                                        initialSelection: 'SY',
                                        favorite: const ['+963', '+90', 'US'],
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                        textStyle: TextStyle(fontSize: 14.sp),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                        ),
                                        flagWidth: 25.w,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: const Color(0xFF795622),
                                          width: 1.5.w,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        textAlign: TextAlign.right,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                            RegExp(
                                              r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
                                            ),
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: localizations.enterPhone,
                                          hintStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14.sp,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 14.h,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          completePhoneNumber =
                                              "$countryCode$value";
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              _buildPasswordWithLabel(
                                label: localizations.password,
                                controller: passwordController,
                                hint: '********',
                                isVisible: _isPasswordVisible,
                                toggleVisibility: () => setState(
                                  () =>
                                      _isPasswordVisible = !_isPasswordVisible,
                                ),
                                allowArabic: false,
                              ),
                              SizedBox(height: 12.h),
                              _buildPasswordWithLabel(
                                label: localizations.confirmPassword,
                                controller: confirmPasswordController,
                                hint: '********',
                                isVisible: _isConfirmPasswordVisible,
                                toggleVisibility: () => setState(
                                  () => _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible,
                                ),
                                allowArabic: false,
                              ),
                              SizedBox(height: 20.h),
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
                                    onPressed:
                                        _isLoading ? null : _onRegisterPressed,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
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
                                            localizations.signUp,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
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
                              SizedBox(height: 24.h),
                            ],
                          ),
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
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 24,
                  ),
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
                          const Icon(
                            Icons.language,
                            color: Color(0xFF735C3A),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(localizations.arabic),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'en',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language,
                            color: Color(0xFF735C3A),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(localizations.english),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'tr',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language,
                            color: Color(0xFF735C3A),
                            size: 18,
                          ),
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

  Widget _buildFieldWithLabel({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool allowArabic = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  color: Color(0xFF676767),
                  fontSize: 14,
                ),
              ),
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 55.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF795622), width: 1.5.w),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            inputFormatters: allowArabic
                ? null
                : [
                    FilteringTextInputFormatter.deny(
                      RegExp(
                        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
                      ),
                    ),
                  ],
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black54,
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordWithLabel({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    bool allowArabic = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  color: Color(0xFF676767),
                  fontSize: 14,
                ),
              ),
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 55.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF795622), width: 1.5.w),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            inputFormatters: allowArabic
                ? null
                : [
                    FilteringTextInputFormatter.deny(
                      RegExp(
                        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
                      ),
                    ),
                  ],
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black54,
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF795622),
                  size: 20.sp,
                ),
                onPressed: toggleVisibility,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
