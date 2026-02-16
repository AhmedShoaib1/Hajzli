import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hajzli/Home/home.dart';
import 'package:hajzli/SearchTrips/SearchTrips.dart';
import 'package:hajzli/UserPage/UserPage.dart';
import 'package:hajzli/SelectTheLoginProcess/SelectTheLoginProcess.dart';
import 'package:hajzli/l10n/app_localizations.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  final int _currentIndex = 2;
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ];

  bool showBusMenu = false;
  bool showFlightMenu = false;
  bool showHotelMenu = false;

  void _navigateToPage(int index) async {
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
        break;
      case 3:
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const SelectTheLoginProcess()),
          );
        }
        break;
    }
  }

  Widget buildMenuButton({
    required IconData iconData,
    required String title,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 1.sw - 32.w,
        height: 80.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Icon(iconData, color: const Color(0xFF735C3A), size: 30.sp),
            SizedBox(width: 15.w),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: const Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Icon(
              isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: const Color(0xFF735C3A),
              size: 30.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubMenu(List<String> items) {
    return Column(
      children: items
          .map(
            (text) => Padding(
              padding: EdgeInsets.only(bottom: 10.h), // مسافة بين عناصر القائمة
              child: Container(
                width: 1.sw - 32.w,
                height: 70.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF333333),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: const Color(0xFF735C3A),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
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
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // المسافة العلوية للشريط
                SizedBox(height: statusBarHeight + 88.h),
                // مسافة إضافية لعدم التصاق المحتوى بالشريط
                SizedBox(height: 20.h),

                // زر الحافلات
                buildMenuButton(
                  iconData: Icons.directions_bus,
                  title: localizations.buses,
                  isOpen: showBusMenu,
                  onTap: () => setState(() => showBusMenu = !showBusMenu),
                ),
                if (showBusMenu) ...[
                  SizedBox(height: 10.h),
                  buildSubMenu([
                    localizations.cancelTicketBus,
                    localizations.changeTicketBus,
                    localizations.refundNotShownBus,
                    localizations.otherBusTopics,
                  ]),
                ],
                SizedBox(height: 20.h),

                // زر الطيران
                buildMenuButton(
                  iconData: Icons.flight,
                  title: localizations.flights,
                  isOpen: showFlightMenu,
                  onTap: () => setState(() => showFlightMenu = !showFlightMenu),
                ),
                if (showFlightMenu) ...[
                  SizedBox(height: 10.h),
                  buildSubMenu([
                    localizations.cancelTicketFlight,
                    localizations.changeTicketFlight,
                    localizations.ticketNotReceived,
                    localizations.otherFlightTopics,
                  ]),
                ],
                SizedBox(height: 20.h),

                // زر الفنادق
                buildMenuButton(
                  iconData: Icons.hotel,
                  title: localizations.hotels,
                  isOpen: showHotelMenu,
                  onTap: () => setState(() => showHotelMenu = !showHotelMenu),
                ),
                if (showHotelMenu) ...[
                  SizedBox(height: 10.h),
                  buildSubMenu([
                    localizations.cancelHotelBooking,
                    localizations.changeHotelBooking,
                    localizations.hotelDocuments,
                    localizations.otherHotelTopics,
                  ]),
                ],
                SizedBox(height: 80.h),
              ],
            ),
          ),

          // الشريط العلوي المثبت
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
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
                    Center(
                      child: Text(
                        localizations.helpCenter,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color(0xFFEAEAEA),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
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
}
