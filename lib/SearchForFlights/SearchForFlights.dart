import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ للتحقق من حالة تسجيل الدخول
import 'dart:ui' as ui;
import 'package:hajzli/SelectFlight/SelectFlight.dart';
import 'package:hajzli/UserPage/UserPage.dart';
import 'package:hajzli/SelectTheLoginProcess/SelectTheLoginProcess.dart';
import 'package:hajzli/l10n/app_localizations.dart';

class SearchForFlights extends StatefulWidget {
  const SearchForFlights({super.key});

  @override
  State<SearchForFlights> createState() => _SearchForFlightsState();
}

class _SearchForFlightsState extends State<SearchForFlights> {
  final List<String> cities = [
    "الرياض - السعودية",
    "جدة - السعودية",
    "الدمام - السعودية",
    "مكة - السعودية",
    "المدينة المنورة - السعودية",
    "أبها - السعودية",
    "القصيم - السعودية",
    "تبوك - السعودية",
    "الكويت - الكويت",
    "الدوحة - قطر",
    "دبي - الإمارات",
    "أبوظبي - الإمارات",
    "الشارقة - الإمارات",
    "مسقط - عمان",
    "صلالة - عمان",
    "المنامة - البحرين",
    "القاهرة - مصر",
    "الإسكندرية - مصر",
    "الغردقة - مصر",
    "شرم الشيخ - مصر",
    "الخرطوم - السودان",
    "طرابلس - ليبيا",
    "تونس - تونس",
    "الجزائر - الجزائر",
    "وهران - الجزائر",
    "الدار البيضاء - المغرب",
    "مراكش - المغرب",
    "الرباط - المغرب",
    "عمان - الأردن",
    "بيروت - لبنان",
    "دمشق - سوريا",
    "حلب - سوريا",
    "اللاذقية - سوريا",
    "بغداد - العراق",
    "أربيل - العراق",
    "النجف - العراق",
    "برلين - ألمانيا",
    "فرانكفورت - ألمانيا",
    "ميونخ - ألمانيا",
    "هامبورغ - ألمانيا",
    "أمستردام - هولندا",
    "روتردام - هولندا",
    "ستوكهولم - السويد",
    "غوتنبرغ - السويد",
    "مالمو - السويد",
    "نيويورك - أمريكا",
    "لوس أنجلوس - أمريكا",
    "شيكاغو - أمريكا",
    "ميامي - أمريكا",
    "واشنطن - أمريكا",
    "سان فرانسيسكو - أمريكا",
  ];

  String? departure;
  String? arrival;
  DateTime? departureDate;
  DateTime? returnDate;
  String? seatType;
  int passengers = 1;
  bool oneWay = false;

  void swapCities() {
    if (departure == arrival) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.sameLocationError),
        ),
      );
      return;
    }
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  // ✅ دالة التعامل مع ضغط زر الإعدادات (أيقونة الترس)
  Future<void> _handleSettingsPressed() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SelectTheLoginProcess(),
        ),
      );
    }
  }

  void searchFlight() {
    final localizations = AppLocalizations.of(context)!;
    if (departure == null ||
        arrival == null ||
        departureDate == null ||
        (!oneWay && returnDate == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.bothRequired)),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectFlight()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                top: true,
                bottom: false,
                child: Container(
                  width: double.infinity,
                  height: 86.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3D352A), Color(0xFFA38D6F)],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    textDirection: ui.TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          "images/geri.png",
                          height: 50.h,
                          width: 50.w,
                        ),
                      ),
                      Image.asset(
                        "images/Flightt.png",
                        height: 55.w,
                        width: 55.w,
                      ),
                      GestureDetector(
                        onTap: _handleSettingsPressed,
                        child: Image.asset(
                          "images/Settings.png",
                          height: 50.h,
                          width: 50.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                "images/haritaa.png",
                width: 1.sw,
                height: 169.h,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 30.h),
            ],
          ),
          Positioned(
            top: 304.h,
            left: 29.w,
            right: 29.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10.r,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Container(
                      width: 315.w,
                      height: 52.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFF795622),
                          width: 2.w,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Center(
                            child: Text(
                              localizations.from,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          value: departure,
                          isExpanded: true,
                          alignment: Alignment.center,
                          icon: Icon(Icons.arrow_drop_down, size: 24.sp),
                          items: cities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Center(
                                child: Text(
                                  city,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF795622),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == arrival) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(localizations.sameLocationError),
                                ),
                              );
                              return;
                            }
                            setState(() => departure = value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    GestureDetector(
                      onTap: swapCities,
                      child: Image.asset(
                        "images/Swap.png",
                        height: 40.w,
                        width: 40.w,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: 315.w,
                      height: 52.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFF795622),
                          width: 2.w,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Center(
                            child: Text(
                              localizations.to,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          value: arrival,
                          isExpanded: true,
                          alignment: Alignment.center,
                          icon: Icon(Icons.arrow_drop_down, size: 24.sp),
                          items: cities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Center(
                                child: Text(
                                  city,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF795622),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == departure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(localizations.sameLocationError),
                                ),
                              );
                              return;
                            }
                            setState(() => arrival = value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double availableWidth = constraints.maxWidth;
                          double dateFieldWidth =
                              (availableWidth - (oneWay ? 0 : 20.w)) /
                                  (oneWay ? 1 : 2);
                          dateFieldWidth = dateFieldWidth.clamp(120.w, 160.w);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!oneWay) ...[
                                SizedBox(
                                  width: dateFieldWidth,
                                  child: _buildDateField(
                                    label: localizations.checkOutDate,
                                    date: returnDate,
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        locale: locale,
                                      );
                                      if (picked != null) {
                                        setState(() => returnDate = picked);
                                      }
                                    },
                                    localizations: localizations,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                              ],
                              SizedBox(
                                width: dateFieldWidth,
                                child: _buildDateField(
                                  label: localizations.checkInDate,
                                  date: departureDate,
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      locale: locale,
                                    );
                                    if (picked != null) {
                                      setState(() => departureDate = picked);
                                    }
                                  },
                                  localizations: localizations,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            localizations.oneWay,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF795622),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Switch(
                            value: oneWay,
                            onChanged: (val) {
                              setState(() {
                                oneWay = val;
                                if (oneWay) returnDate = null;
                              });
                            },
                            thumbColor: WidgetStateProperty.all(
                              const Color(0xFF795622),
                            ),
                            trackOutlineColor: WidgetStateProperty.all(
                              const Color(0xFF795622),
                            ),
                            trackColor: WidgetStateProperty.resolveWith<Color?>(
                              (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return const Color(0xFF795622)
                                      .withOpacity(0.5);
                                }
                                return Colors.grey.shade300;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed: searchFlight,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 144, 120, 84),
                        minimumSize: Size(200.w, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        localizations.search,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required AppLocalizations localizations,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF795622),
          ),
        ),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 45.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFF795622),
                width: 2.w,
              ),
            ),
            child: Center(
              child: Text(
                date != null
                    ? "${date.day}/${date.month}/${date.year}"
                    : localizations.selectDate,
                style: TextStyle(
                  color: const Color(0xFF795622),
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
