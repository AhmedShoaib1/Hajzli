import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hajzli/Home/home.dart';
import 'package:hajzli/SearchTrips/SearchTrips.dart';
import 'package:hajzli/HelpCenter/HelpCenter.dart';
import 'package:hajzli/Profile/Profile.dart';
import 'package:hajzli/Settings/Settings.dart';
import 'package:hajzli/WhoWeAre/WhoWeAre.dart';
import 'package:hajzli/SelectTheLoginProcess/SelectTheLoginProcess.dart';
import 'package:hajzli/l10n/app_localizations.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.myTickets),
        backgroundColor: const Color(0xFF735C3A),
      ),
      body: Center(child: Text(localizations.ticketsPagePlaceholder)),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.favorites),
        backgroundColor: const Color(0xFF735C3A),
      ),
      body: Center(child: Text(localizations.favoritesPagePlaceholder)),
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final int _currentIndex = 3;
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // لا حاجة للتوجيه هنا لأن StreamBuilder سيلتقط التغيير
  }

  void _navigateToPage(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchTrips()),
        );
        break;
      case 2:
        Navigator.push(
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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SelectTheLoginProcess()),
            );
          });
          return const SizedBox();
        }
        return _buildUserPageContent(context);
      },
    );
  }

  Widget _buildUserPageContent(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      body: Column(
        children: [
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
              child: Text(
                localizations.myAccount,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFFEAEAEA),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildMenuButton(
                    icon: Icons.person,
                    title: localizations.profile,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Profile()),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildMenuButton(
                    icon: Icons.settings,
                    title: localizations.settings,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Settings()),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildMenuButton(
                    icon: Icons.confirmation_number,
                    title: localizations.myTickets,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TicketsPage()),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildMenuButton(
                    icon: Icons.favorite,
                    title: localizations.favorites,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoritesPage()),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildMenuButton(
                    icon: Icons.help_outline,
                    title: localizations.helpCenter,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpCenter()),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildMenuButton(
                    icon: Icons.info_outline,
                    title: localizations.whoWeAre,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WhoWeAre()),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  _buildMenuButton(
                    icon: Icons.logout,
                    title: localizations.logout,
                    onTap: _logout,
                    isLogout: true,
                  ),
                  SizedBox(height: 80.h),
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

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        height: 60.h,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: isLogout ? const Color(0xFFFFE5E5) : Colors.white,
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
            Icon(
              icon,
              color: isLogout ? Colors.red : const Color(0xFF735C3A),
              size: 28.sp,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                color: isLogout ? Colors.red : const Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isLogout ? Colors.red : const Color(0xFF735C3A),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
