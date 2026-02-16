import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ للتحقق من حالة تسجيل الدخول
import 'package:hijizli/l10n/app_localizations.dart';
import 'package:hijizli/SearchForFlights/SearchForFlights.dart';
import 'package:hijizli/SearchTrips/SearchTrips.dart';
import 'package:hijizli/UserPage/UserPage.dart';
import 'package:hijizli/SelectTheLoginProcess/SelectTheLoginProcess.dart';

class HotelReservations extends StatefulWidget {
  const HotelReservations({super.key});

  @override
  State<HotelReservations> createState() => _HotelReservationsState();
}

class _HotelReservationsState extends State<HotelReservations> {
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 1));
  bool showExtraBox = false;

  List<Map<String, int>> rooms = [
    {"adults": 1, "children": 0},
  ];

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF735C3A),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled)
      return Future.error(AppLocalizations.of(context)!.locationError);

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(AppLocalizations.of(context)!.locationError);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(AppLocalizations.of(context)!.locationError);
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _selectCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: Localizations.localeOf(context),
    );
    if (picked != null && picked != checkInDate) {
      setState(() {
        checkInDate = picked;
        if (checkOutDate.isBefore(checkInDate)) {
          checkOutDate = checkInDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate.isAfter(checkInDate)
          ? checkOutDate
          : checkInDate.add(const Duration(days: 1)),
      firstDate: checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime(2100),
      locale: Localizations.localeOf(context),
    );
    if (picked != null && picked != checkOutDate) {
      setState(() {
        checkOutDate = picked;
      });
    }
  }

  // ✅ دالة التعامل مع ضغط زر الإعدادات (تعتمد على Firebase)
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== الهيدر الثابت =====
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
                    "images/Hotell.png",
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

          // ===== المحتوى القابل للتمرير =====
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  SizedBox(height: 5.h),

                  // ===== أيقونات الخدمات =====
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
                              builder: (context) => const SearchForFlights(),
                            ),
                          ),
                        ),
                        _buildServiceIcon(
                          "images/otob.png",
                          localizations.bus,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchTrips(),
                            ),
                          ),
                        ),
                        _buildServiceIcon(
                          "images/araba.png",
                          localizations.car,
                          () => _showMessage(
                              context, localizations.underDevelopment),
                        ),
                        _buildServiceIcon(
                          "images/Hotel.png",
                          localizations.hotel,
                          () => _showMessage(
                              context, localizations.currentHotelPage),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // ===== اختيار الموقع =====
                  GestureDetector(
                    onTap: () async {
                      try {
                        Position position = await _determinePosition();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NearbyHotelsPage(
                              latitude: position.latitude,
                              longitude: position.longitude,
                            ),
                          ),
                        );
                      } catch (e) {
                        _showMessage(
                            context, "${localizations.locationError}: $e");
                      }
                    },
                    child: Container(
                      width: 350.w,
                      height: 80.h,
                      margin: EdgeInsets.symmetric(horizontal: 23.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFF795622),
                          width: 2.w,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Image.asset(
                            "images/Vector.png",
                            height: 30.h,
                            width: 30.w,
                            color: const Color(0xFF795622),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              localizations.selectLocation,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF795622),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ===== التواريخ =====
                  Container(
                    width: 350.w,
                    margin: EdgeInsets.symmetric(horizontal: 23.w),
                    height: 160.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFF795622),
                        width: 2.w,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: _selectCheckInDate,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localizations.checkInDate,
                                style: TextStyle(
                                  color: const Color(0xFF795622),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                DateFormat('yyyy-MM-dd').format(checkInDate),
                                style: TextStyle(
                                  color: const Color(0xFF795622),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 2.w,
                          height: 100.h,
                          color: const Color(0xFF795622),
                        ),
                        GestureDetector(
                          onTap: _selectCheckOutDate,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localizations.checkOutDate,
                                style: TextStyle(
                                  color: const Color(0xFF795622),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                DateFormat('yyyy-MM-dd').format(checkOutDate),
                                style: TextStyle(
                                  color: const Color(0xFF795622),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ===== الغرف (المربع المتوسع) =====
                  GestureDetector(
                    onTap: () => setState(() => showExtraBox = !showExtraBox),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 350.w,
                      margin: EdgeInsets.symmetric(horizontal: 23.w),
                      height:
                          showExtraBox ? (230.h * rooms.length + 120.h) : 60.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFF795622),
                          width: 2.w,
                        ),
                      ),
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "images/kisi.png",
                                height: 30.h,
                                width: 30.w,
                                color: const Color(0xFF795622),
                              ),
                              Text(
                                showExtraBox
                                    ? localizations.hideRooms
                                    : localizations.selectRooms,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF795622),
                                ),
                              ),
                              Icon(
                                showExtraBox
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 30.sp,
                                color: const Color(0xFF795622),
                              ),
                            ],
                          ),
                          if (showExtraBox) ...[
                            const Divider(
                                color: Color(0xFF795622), thickness: 2),
                            SizedBox(height: 10.h),
                            ...rooms.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, int> room = entry.value;
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                child: Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${localizations.room} ${index + 1}",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF795622),
                                            ),
                                          ),
                                          if (rooms.length > 1)
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  rooms.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              iconSize: 20.sp,
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            localizations.adults,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF795622),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (room["adults"]! > 1) {
                                                      room["adults"] =
                                                          room["adults"]! - 1;
                                                    }
                                                  });
                                                },
                                                icon: const Icon(Icons.remove),
                                                color: const Color(0xFF795622),
                                                iconSize: 20.sp,
                                              ),
                                              Text("${room["adults"]}"),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    room["adults"] =
                                                        room["adults"]! + 1;
                                                  });
                                                },
                                                icon: const Icon(Icons.add),
                                                color: const Color(0xFF795622),
                                                iconSize: 20.sp,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            localizations.children,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF795622),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (room["children"]! > 0) {
                                                      room["children"] =
                                                          room["children"]! - 1;
                                                    }
                                                  });
                                                },
                                                icon: const Icon(Icons.remove),
                                                color: const Color(0xFF795622),
                                                iconSize: 20.sp,
                                              ),
                                              Text("${room["children"]}"),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    room["children"] =
                                                        room["children"]! + 1;
                                                  });
                                                },
                                                icon: const Icon(Icons.add),
                                                color: const Color(0xFF795622),
                                                iconSize: 20.sp,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  rooms.add({"adults": 1, "children": 0});
                                });
                              },
                              icon: const Icon(Icons.add,
                                  color: Color(0xFF795622)),
                              label: Text(
                                localizations.addRoom,
                                style:
                                    const TextStyle(color: Color(0xFF795622)),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF6F6F6),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 60.w,
                                  vertical: 7.h,
                                ),
                              ),
                              onPressed: () {
                                _showMessage(
                                  context,
                                  "${localizations.bookingConfirmed} ${rooms.length} ${localizations.rooms}",
                                );
                              },
                              child: Text(
                                localizations.bookNow,
                                style: TextStyle(
                                  color: const Color(0xFF795622),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
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

// ===== صفحة الفنادق القريبة =====
class NearbyHotelsPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const NearbyHotelsPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<NearbyHotelsPage> createState() => _NearbyHotelsPageState();
}

class _NearbyHotelsPageState extends State<NearbyHotelsPage> {
  List<dynamic> hotels = [];
  String city = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHotels();
  }

  Future<void> loadHotels() async {
    try {
      String data = await rootBundle.loadString('assets/hotels.json');
      final jsonResult = json.decode(data);

      List<String> cities = ["دمشق", "حلب", "حمص", "اللاذقية", "حماة"];
      double minDistance = double.infinity;
      String nearestCity = cities[0];

      for (String c in cities) {
        final hotelCity = jsonResult.firstWhere(
          (h) => h['city'] == c,
          orElse: () => null,
        );
        if (hotelCity != null) {
          double distance = Geolocator.distanceBetween(
            widget.latitude,
            widget.longitude,
            hotelCity['latitude'],
            hotelCity['longitude'],
          );
          if (distance < minDistance) {
            minDistance = distance;
            nearestCity = c;
          }
        }
      }

      setState(() {
        hotels = jsonResult.where((h) => h['city'] == nearestCity).toList();
        city = nearestCity;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text("${localizations.hotelsIn} $city"),
        backgroundColor: const Color(0xFF795622),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF795622),
              ),
            )
          : hotels.isEmpty
              ? Center(
                  child: Text(
                    localizations.noHotelsFound,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = hotels[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: ListTile(
                        leading: Icon(
                          Icons.hotel,
                          color: const Color(0xFF795622),
                          size: 30.sp,
                        ),
                        title: Text(
                          hotel['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        subtitle: Text(
                          hotel['city'],
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: const Color(0xFF795622),
                          size: 16.sp,
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
    );
  }
}
