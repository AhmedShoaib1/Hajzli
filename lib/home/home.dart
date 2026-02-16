import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hajzli/SearchTrips/SearchTrips.dart';
import 'package:hajzli/SearchForFlights/SearchForFlights.dart';
import 'package:hajzli/HotelReservations/HotelReservations.dart';
import 'package:hajzli/l10n/app_localizations.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Image.asset(
                  "images/Hajzli.png",
                  fit: BoxFit.contain,
                  height: 200.h,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Container(
                  width: 1.sw,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: Text(
                            localizations.homeTitle,
                            style: const TextStyle(
                              color: Color(0xFFEEE9E2),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          localizations.homeSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFEEE9E2),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            localizations.bookingExperience,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFEEE9E2),
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              height: 1.4,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        _buildButton(
                          context,
                          text: localizations.busTickets,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchTrips()),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildButton(
                          context,
                          text: localizations.flightTickets,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchForFlights()),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildButton(
                          context,
                          text: localizations.hotelBooking,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HotelReservations()),
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50.h,
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
                icon: const Icon(Icons.language, color: Colors.white, size: 24),
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
                        const Icon(Icons.language,
                            color: Color(0xFF735C3A), size: 18),
                        const SizedBox(width: 10),
                        Text(localizations.arabic),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'en',
                    child: Row(
                      children: [
                        const Icon(Icons.language,
                            color: Color(0xFF735C3A), size: 18),
                        const SizedBox(width: 10),
                        Text(localizations.english),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'tr',
                    child: Row(
                      children: [
                        const Icon(Icons.language,
                            color: Color(0xFF735C3A), size: 18),
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
    );
  }

  Widget _buildButton(BuildContext context,
      {required String text, required VoidCallback onPressed}) {
    return Container(
      height: 56.h,
      width: 348.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFD9D9D9), Colors.white],
        ),
        border: Border.all(color: const Color(0xFF795622), width: 2.w),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(31.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF795622),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
