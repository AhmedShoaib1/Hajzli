import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hajzli/Home/home.dart';
import 'package:hajzli/SearchTrips/SearchTrips.dart';
import 'package:hajzli/HelpCenter/HelpCenter.dart';
import 'package:hajzli/UserPage/UserPage.dart';
import 'package:hajzli/UsersPrivateInformation/UsersPrivateInformation.dart';
import 'package:hajzli/PaymentInformation/PaymentInformation.dart';
import 'package:hajzli/l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      body: Column(
        children: [
          // ✅ الهيدر محمي بـ SafeArea مثل UserPage
          SafeArea(
            top: true,
            bottom: false,
            child: Container(
              width: double.infinity,
              height: 88.h, // نفس ارتفاع UserPage
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
                  // عنوان الصفحة
                  Center(
                    child: Text(
                      localizations.profile,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xFFEAEAEA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // زر العودة
                  Positioned(
                    left: 20.w,
                    top: 24.h, // ضبط ليكون في منتصف الارتفاع
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserPage(),
                          ),
                        );
                      },
                      child: Image.asset(
                        "images/geri.png",
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ✅ المحتوى القابل للتمرير
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    buildMenuButton(
                      Icons.person,
                      localizations.personalInformation,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const UsersPrivateInformation(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15.h),
                    buildMenuButton(
                      Icons.credit_card,
                      localizations.paymentInformation,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentInformation(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15.h),
                    buildMenuButton(
                      Icons.flight_takeoff,
                      localizations.travelInformation,
                      () {},
                    ),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // ✅ شريط التنقل السفلي
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

  // أيقونة نشطة
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

  // أيقونة غير نشطة
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

  // زر القائمة
  Widget buildMenuButton(IconData iconData, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        height: 60.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
              child:
                  Icon(iconData, color: const Color(0xFF735C3A), size: 28.sp),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF735C3A),
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
