import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hajzli/home/home.dart';
import 'package:hajzli/l10n/app_localizations.dart';

class Splach_screan extends StatefulWidget {
  const Splach_screan({super.key});

  @override
  State<Splach_screan> createState() => _Splach_screanState();
}

class _Splach_screanState extends State<Splach_screan> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white, // سيتم تغطيته بالكامل بالـ Column
      body: Padding(
        padding: EdgeInsets.only(top: topPadding), // ✅ تجنب شريط الحالة فقط
        child: Column(
          children: [
            // 🔹 الصورة في الأعلى
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Image.asset(
                "images/harita.png",
                fit: BoxFit.contain,
                height: 120.h,
              ),
            ),
            SizedBox(height: 10.h),

            // 🔹 المستطيل المائل – يملأ باقي المساحة بالكامل
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight;
                  final imageHeight = availableHeight * 0.55;
                  final imageWidth = imageHeight * 0.75;

                  return ClipPath(
                    clipper: SlantedClipper(),
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                localizations.splashText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Image.asset(
                                "images/chanta.png",
                                width: imageWidth,
                                height: imageHeight,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 كلاس الميلان – يخلق حافة علوية مائلة
class SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
