import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijizli/l10n/app_localizations.dart';
import '../main.dart'; // لاستدعاء MyApp.setLocale

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

  Widget buildLanguageCard({
    required BuildContext context,
    required String languageKey, // المفتاح المستخدم في الترجمة
    required String flagPath,
    required Locale locale,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          MyApp.setLocale(context, locale);
        },
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            // تخطيط ثابت: العلم يساراً، النص في الوسط، السهم يميناً
            children: [
              // العلم مع مسافة يسارية ثابتة
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Image.asset(
                  flagPath,
                  width: 40.w,
                  height: 25.h,
                  fit: BoxFit.cover,
                ),
              ),
              // النص المترجم في الوسط
              Expanded(
                child: Center(
                  child: Text(
                    _getLanguageName(localizations, languageKey),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: const Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // السهم مع مسافة يمينية ثابتة
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFF735C3A),
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة للحصول على اسم اللغة المترجم بناءً على المفتاح
  String _getLanguageName(AppLocalizations localizations, String key) {
    switch (key) {
      case 'arabic':
        return localizations.arabic;
      case 'english':
        return localizations.english;
      case 'turkish':
        return localizations.turkish;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      body: Column(
        children: [
          // ✅ الشريط العلوي بنفس نمط Profile
          SafeArea(
            top: true,
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
              alignment: Alignment.center,
              child: Stack(
                children: [
                  // عنوان الصفحة في المنتصف (مترجم)
                  Center(
                    child: Text(
                      localizations.selectLanguage,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xFFEAEAEA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // زر العودة في اليسار دائماً
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

          // ✅ قائمة اللغات داخل Expanded و SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  buildLanguageCard(
                    context: context,
                    languageKey: 'arabic',
                    flagPath: "images/Syria.png",
                    locale: const Locale('ar'),
                  ),
                  buildLanguageCard(
                    context: context,
                    languageKey: 'english',
                    flagPath: "images/United.png",
                    locale: const Locale('en'),
                  ),
                  buildLanguageCard(
                    context: context,
                    languageKey: 'turkish',
                    flagPath: "images/Turkey.png",
                    locale: const Locale('tr'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
