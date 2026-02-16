import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hajzli/HotelReservations/HotelReservations.dart';
import 'package:hajzli/SearchForFlights/SearchForFlights.dart';
import 'package:hajzli/SelectTheLoginProcess/SelectTheLoginProcess.dart';
import 'package:hajzli/HelpCenter/HelpCenter.dart';
import 'package:hajzli/home/home.dart';
import 'package:hajzli/UserPage/UserPage.dart';
import 'package:hajzli/l10n/app_localizations.dart';

const List<String> locations = [
  "دمشق",
  "ريف دمشق",
  "حلب",
  "حمص",
  "حماة",
  "اللاذقية",
  "طرطوس",
  "إدلب",
  "الرقة",
  "دير الزور",
  "الحسكة",
  "السويداء",
  "درعا",
  "القنيطرة",
  "إسطنبول",
  "الرياض",
];

class SearchTrips extends StatefulWidget {
  const SearchTrips({super.key});

  @override
  State<SearchTrips> createState() => _SearchTripsState();
}

class _SearchTripsState extends State<SearchTrips> {
  final int _currentIndex = 1;
  String? departure;
  String? arrival;
  DateTime? selectedDate;

  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ];

  // دوال التنقل بين الصفحات (شريط التنقل السفلي)
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
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HelpCenter()),
        );
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
              builder: (context) => const SelectTheLoginProcess(),
            ),
          );
        }
        break;
    }
  }

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

  void swapLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  Future<void> _pickDate() async {
    final locale = Localizations.localeOf(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: locale,
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void selectToday() {
    final now = DateTime.now();
    setState(() => selectedDate = DateTime(now.year, now.month, now.day));
  }

  void selectTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    setState(() =>
        selectedDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day));
  }

  void goToChoosingPage() {
    final localizations = AppLocalizations.of(context)!;
    if (departure == null || arrival == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.bothRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (departure == arrival) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.sameLocationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // ✅ استخدام pushNamed لتمرير tripId عبر arguments
    Navigator.pushNamed(
      context,
      '/selectTrips',
      arguments: {
        'from': departure,
        'to': arrival,
        'date': selectedDate,
        'tripId':
            'trip_123', // هنا معرف الرحلة (يجب أن يأتي من قاعدة البيانات لاحقاً)
      },
    );
  }

  Widget buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF795622), width: 2.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Center(
            child: Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ),
          items: items.map((loc) {
            return DropdownMenuItem<String>(
              value: loc,
              child: Center(
                child: Text(
                  loc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF795622),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          selectedItemBuilder: (context) {
            return items.map((loc) {
              return Center(
                child: Text(
                  loc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF795622),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              );
            }).toList();
          },
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
    final departureOptions = locations.where((l) => l != arrival).toList();
    final arrivalOptions = locations.where((l) => l != departure).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                  stops: [0.0, 0.6],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                textDirection: TextDirection.ltr,
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
                    "images/otobus.png",
                    height: 90.w,
                    width: 90.w,
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 25.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildServiceIcon(
                          "images/Flight.png",
                          localizations.airplane,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchForFlights()),
                          ),
                        ),
                        _buildServiceIcon(
                          "images/otob.png",
                          localizations.bus,
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.busService),
                              backgroundColor: const Color(0xFF735C3A),
                            ),
                          ),
                        ),
                        _buildServiceIcon(
                          "images/araba.png",
                          localizations.car,
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.underDevelopment),
                              backgroundColor: const Color(0xFF735C3A),
                            ),
                          ),
                        ),
                        _buildServiceIcon(
                          "images/Hotel.png",
                          localizations.hotel,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HotelReservations()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 23.w),
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10.r,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/location.png",
                          height: 110.h,
                          width: 40.w,
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildDropdown(
                                hint: localizations.from,
                                value: departure,
                                items: departureOptions,
                                onChanged: (val) {
                                  setState(() {
                                    departure = val;
                                    if (arrival == departure) arrival = null;
                                  });
                                },
                              ),
                              SizedBox(height: 25.h),
                              buildDropdown(
                                hint: localizations.to,
                                value: arrival,
                                items: arrivalOptions,
                                onChanged: (val) {
                                  setState(() {
                                    arrival = val;
                                    if (departure == arrival) departure = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: swapLocations,
                          child: Image.asset(
                            "images/Swap.png",
                            height: 140.h,
                            width: 40.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 23.w),
                    padding: EdgeInsets.all(20.w),
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
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            height: 52.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFF795622),
                                width: 2.w,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/Data.png",
                                  height: 24.h,
                                  width: 24.w,
                                  color: const Color(0xFF795622),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      selectedDate == null
                                          ? localizations.selectDate
                                          : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                                      style: TextStyle(
                                        color: const Color(0xFF795622),
                                        fontSize: 14.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: const Color(0xFF795622),
                                  size: 24.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double availableWidth = constraints.maxWidth;
                            double buttonWidth = (availableWidth - 50.w) / 2;
                            buttonWidth = buttonWidth.clamp(110.w, 136.w);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      localizations.today,
                                      style: TextStyle(
                                        color: const Color(0xFF795622),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    GestureDetector(
                                      onTap: selectToday,
                                      child: Container(
                                        width: buttonWidth,
                                        height: 46.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: const Color(0xFF795622),
                                            width: 2.w,
                                          ),
                                        ),
                                        child: Text(
                                          localizations.today,
                                          style: TextStyle(
                                            color: const Color(0xFF795622),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 50.w),
                                Column(
                                  children: [
                                    Text(
                                      localizations.tomorrow,
                                      style: TextStyle(
                                        color: const Color(0xFF795622),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    GestureDetector(
                                      onTap: selectTomorrow,
                                      child: Container(
                                        width: buttonWidth,
                                        height: 46.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: const Color(0xFF795622),
                                            width: 2.w,
                                          ),
                                        ),
                                        child: Text(
                                          localizations.tomorrow,
                                          style: TextStyle(
                                            color: const Color(0xFF795622),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 50.h),
                        GestureDetector(
                          onTap: goToChoosingPage,
                          child: Container(
                            width: 279.w,
                            height: 42.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 182, 157, 123),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color.fromARGB(255, 92, 65, 24),
                                width: 2.w,
                              ),
                            ),
                            child: Text(
                              localizations.search,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
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

  Widget _buildServiceIcon(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            height: 70.w,
            width: 70.w,
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF795622),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
