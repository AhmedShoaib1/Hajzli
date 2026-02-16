import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijizli/Home/home.dart';
import 'package:hijizli/SearchTrips/SearchTrips.dart';
import 'package:hijizli/HelpCenter/HelpCenter.dart';
import 'package:hijizli/UserPage/UserPage.dart';
import 'package:hijizli/Currencies/Currencies.dart';
import 'package:hijizli/Languages/Languages.dart';
import 'package:hijizli/ResetPassword/ResetPassword.dart';
import 'package:hijizli/l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  final ValueNotifier<ThemeMode>? themeNotifier;

  const Settings({super.key, this.themeNotifier});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final int _currentIndex = 3;
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ];

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserPage()),
        );
        break;
    }
  }

  bool _isDarkLocal = false;

  bool get _isDark {
    if (widget.themeNotifier != null) {
      return widget.themeNotifier!.value == ThemeMode.dark;
    } else {
      return _isDarkLocal;
    }
  }

  void _setDark(bool value) {
    if (widget.themeNotifier != null) {
      widget.themeNotifier!.value = value ? ThemeMode.dark : ThemeMode.light;
    } else {
      setState(() {
        _isDarkLocal = value;
      });
    }
  }

  Widget buildMenuButton({
    required IconData iconData,
    required String title,
    required VoidCallback onTap,
    required Color cardColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 1.sw - 32.w,
        height: 60.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: cardColor,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Icon(iconData, color: iconColor, size: 28.sp),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child:
                  Icon(Icons.arrow_forward_ios, color: iconColor, size: 20.sp),
            ),
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bgColor = _isDark ? const Color(0xFF121212) : const Color(0xFFEAEAEA);
    final topGradientStart =
        _isDark ? const Color(0xFF2B2B2B) : const Color(0xFF735C3A);
    final topGradientEnd =
        _isDark ? const Color(0xFF3B3B3B) : const Color(0xFFE6D2B9);
    final cardColor = _isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = _isDark ? Colors.white : const Color(0xFF333333);
    final iconColor =
        _isDark ? const Color(0xFFFFB58A) : const Color(0xFF735C3A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                height: 88.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [topGradientStart, topGradientEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'images/geri.png',
                          width: 35.w,
                          height: 35.h,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        localizations.settings,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color(0xFFEAEAEA),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 35.w + 16.w),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            buildMenuButton(
              iconData: Icons.language,
              title: localizations.selectLanguage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguagesPage()),
                );
              },
              cardColor: cardColor,
              iconColor: iconColor,
              textColor: textColor,
            ),

            SizedBox(height: 15.h),

            buildMenuButton(
              iconData: Icons.currency_exchange,
              title: localizations.currencies,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CurrenciesPage()),
                );
              },
              cardColor: cardColor,
              iconColor: iconColor,
              textColor: textColor,
            ),

            SizedBox(height: 15.h),

            // زر تغيير كلمة السر بدون oldPassword
            buildMenuButton(
              iconData: Icons.lock,
              title: localizations.changePassword,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResetPasswordPage()),
                );
              },
              cardColor: cardColor,
              iconColor: iconColor,
              textColor: textColor,
            ),

            SizedBox(height: 15.h),

            Container(
              width: 1.sw - 32.w,
              height: 60.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: cardColor,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Icon(Icons.dark_mode, color: iconColor, size: 28.sp),
                  ),
                  Text(
                    localizations.darkMode,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Switch(
                      value: _isDark,
                      onChanged: (v) => _setDark(v),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
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
}
