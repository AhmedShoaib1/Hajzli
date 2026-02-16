import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hajzli/l10n/app_localizations.dart';

class WhoWeAre extends StatelessWidget {
  const WhoWeAre({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(top: 12.h, left: 8.w),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFF735C3A).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFF735C3A),
                size: 24.sp,
              ),
            ),
          ),
        ),
        title: Text(
          localizations.whoWeAre,
          style: TextStyle(
            color: const Color(0xFF735C3A),
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF5E8D9),
              const Color(0xFFE6D2B9),
              const Color(0xFFD4B595),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),

                  // الشعار مع تأثير الظل
                  Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.2),
                          blurRadius: 20.r,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 70.r,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Image.asset(
                          "images/Hajzli.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // بطاقة "من نحن"
                  _buildGlassCard(
                    icon: Icons.people_alt,
                    title: localizations.whoWeAre,
                    content: localizations.aboutUsDescription,
                  ),
                  SizedBox(height: 20.h),

                  // بطاقة "رؤيتنا"
                  _buildGlassCard(
                    icon: Icons.remove_red_eye,
                    title: localizations.ourVision,
                    content: localizations.visionDescription,
                  ),
                  SizedBox(height: 20.h),

                  // بطاقة "رسالتنا"
                  _buildGlassCard(
                    icon: Icons.message,
                    title: localizations.ourMission,
                    content: localizations.missionDescription,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF735C3A).withOpacity(0.2),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF735C3A).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF735C3A),
              size: 35.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A3B2A), // لون بني داكن للنص
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              height: 1.6,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
