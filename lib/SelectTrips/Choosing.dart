import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'seat_model.dart';

class Choosing extends StatefulWidget {
  final String from;
  final String to;
  final DateTime? date;
  final String tripId;

  const Choosing({
    super.key,
    required this.from,
    required this.to,
    this.date,
    required this.tripId,
  });

  @override
  State<Choosing> createState() => _ChoosingState();
}

class _ChoosingState extends State<Choosing> {
  late DateTime selectedDate;
  int _currentIndex = 1;

  // متغيرات نظام المقاعد
  late String busType;
  List<Seat> seats = [];
  Timer? holdTimer;
  String? selectedSeatId;
  String? selectedTime;
  String? userGender;

  final List<String> times = [
    "06:00",
    "09:00",
    "12:00",
    "15:00",
    "18:00",
    "21:00"
  ];
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.date ?? DateTime.now();
    _loadUserGender();
    _loadBusType();
  }

  @override
  void dispose() {
    holdTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserGender() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName?.contains('أنثى') == true) {
        userGender = 'female';
      } else {
        userGender = 'male';
      }
    }
  }

  Future<void> _loadBusType() async {
    try {
      DocumentSnapshot tripDoc = await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .get();
      if (tripDoc.exists) {
        setState(() {
          busType = tripDoc['busType'] ?? '2+2';
        });
      } else {
        // إذا لم يوجد المستند، استخدم القيمة الافتراضية
        setState(() {
          busType = '2+2';
        });
      }
    } catch (e) {
      print('خطأ في تحميل نوع الباص: $e');
      // في حالة الخطأ، استخدم القيمة الافتراضية
      setState(() {
        busType = '2+2';
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _incrementDate() =>
      setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
  void _decrementDate() => setState(
      () => selectedDate = selectedDate.subtract(const Duration(days: 1)));

  void _onTimeSelected(String time) => setState(() => selectedTime = time);

  Future<void> _onSeatTapped(Seat seat) async {
    if (!seat.isAvailable) {
      _showMessage('هذا المقعد غير متاح');
      return;
    }

    if (userGender == null) {
      _showMessage('يرجى تسجيل الدخول أولاً');
      return;
    }

    if (!_checkNeighbors(seat, userGender!)) {
      _showMessage('لا يمكن الحجز بجانب شخص من الجنس الآخر');
      return;
    }

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحجز'),
        content: Text('هل تريد حجز المقعد رقم ${seat.seatId}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .collection('seats')
          .doc(seat.id)
          .update({
        'status': 'temporary',
        'gender': userGender,
        'holdUntil':
            Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 5))),
      });

      setState(() => selectedSeatId = seat.id);
      _startHoldTimer(seat.id);
    } catch (e) {
      _showMessage('فشل الحجز: $e');
    }
  }

  bool _checkNeighbors(Seat seat, String gender) {
    for (var s in seats) {
      if (s.id == seat.id) continue;
      bool isAdjacentRow = s.row == seat.row &&
          (s.column == seat.column - 1 || s.column == seat.column + 1);
      bool isAdjacentColumn = s.column == seat.column &&
          (s.row == seat.row - 1 || s.row == seat.row + 1);
      if (isAdjacentRow || isAdjacentColumn) {
        if (s.isBooked || s.isTemporary) {
          if (s.gender != Gender.none) {
            String neighborGender = s.gender == Gender.male ? 'male' : 'female';
            if (neighborGender != gender) return false;
          }
        }
      }
    }
    return true;
  }

  void _startHoldTimer(String seatId) {
    holdTimer?.cancel();
    holdTimer = Timer(const Duration(minutes: 5), () {
      FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .collection('seats')
          .doc(seatId)
          .update({'status': 'available', 'gender': null, 'holdUntil': null});
      if (selectedSeatId == seatId) setState(() => selectedSeatId = null);
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(fontSize: 14.sp)),
        backgroundColor: Colors.red,
      ),
    );
  }

  // بناء تخطيط المقاعد
  Widget _buildSeatsStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .collection('seats')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'خطأ في تحميل المقاعد: ${snapshot.error}',
              style: TextStyle(fontSize: 14.sp),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: const Color(0xFF735C3A)),
          );
        }

        seats = snapshot.data!.docs.map((doc) {
          return Seat.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        seats.sort((a, b) => a.seatId.compareTo(b.seatId));

        int crossAxisCount = 4;
        if (busType == '2+1')
          crossAxisCount = 3;
        else if (busType == 'VIP') crossAxisCount = 2;

        return Container(
          padding: EdgeInsets.all(16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
            ),
            itemCount: seats.length,
            itemBuilder: (ctx, index) => _buildSeatItem(seats[index]),
          ),
        );
      },
    );
  }

  Widget _buildSeatItem(Seat seat) {
    Color seatColor = Colors.grey[300]!;
    if (seat.isBooked) {
      seatColor = seat.gender == Gender.male ? Colors.blue : Colors.pink;
    } else if (seat.isTemporary) {
      seatColor = Colors.green;
    } else if (seat.isUnavailable) {
      seatColor = Colors.grey[600]!;
    }

    if (selectedSeatId == seat.id) seatColor = Colors.orange;

    return GestureDetector(
      onTap: () => _onSeatTapped(seat),
      child: Container(
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8.r),
          border: seat.isAvailable
              ? Border.all(color: Colors.green, width: 2.w)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              seat.seatId.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            if (seat.type == SeatType.vip)
              Icon(Icons.star, color: Colors.yellow, size: 14.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (ctx, index) {
          final time = times[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: ChoiceChip(
              label: Text(
                time,
                style: TextStyle(fontSize: 14.sp),
              ),
              selected: selectedTime == time,
              onSelected: (sel) => _onTimeSelected(time),
              backgroundColor: Colors.grey[200],
              selectedColor: const Color(0xFF735C3A),
              labelStyle: TextStyle(
                color: selectedTime == time ? Colors.white : Colors.black,
                fontSize: 14.sp,
              ),
            ),
          );
        },
      ),
    );
  }

  // الهيدر العلوي المحسن (مثل باقي الصفحات)
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 88.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D352A), Color(0xFFA38D6F)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // زر الرجوع
            Positioned(
              left: 16.w,
              top: 24.h,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  "images/geri.png",
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ),
            // صورة الباص في الوسط
            Center(
              child: Image.asset(
                "images/otobus.png",
                height: 50.h,
                width: 50.w,
              ),
            ),
            // زر الإعدادات
            Positioned(
              right: 16.w,
              top: 24.h,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/selectLogin'),
                child: Image.asset(
                  "images/Settings.png",
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // معلومات الرحلة
  Widget _buildTripInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bus,
              color: const Color(0xFF735C3A), size: 16.sp),
          SizedBox(width: 4.w),
          Text(
            '${widget.from} → ${widget.to}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.calendar_today,
              color: const Color(0xFF735C3A), size: 14.sp),
          SizedBox(width: 4.w),
          Text(
            '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required AlignmentGeometry align,
  }) {
    double width = text.length > 10 ? 150.w : 80.w;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 34.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white, width: 1.w),
        ),
        alignment: align,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon == Icons.arrow_left)
              Icon(icon, color: Colors.white, size: 20.sp),
            if (icon == Icons.calendar_today)
              Icon(icon, color: Colors.white, size: 16.sp),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (icon == Icons.arrow_right)
              Icon(icon, color: Colors.white, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDateButton(
            text: "قبل",
            icon: Icons.arrow_left,
            onTap: _decrementDate,
            align: Alignment.centerLeft,
          ),
          SizedBox(width: 8.w),
          _buildDateButton(
            text:
                "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
            icon: Icons.calendar_today,
            onTap: _pickDate,
            align: Alignment.center,
          ),
          SizedBox(width: 8.w),
          _buildDateButton(
            text: "بعد",
            icon: Icons.arrow_right,
            onTap: _incrementDate,
            align: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  Widget _buildAds() {
    return SizedBox(
      height: 120.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildAdBox(Colors.orange, "إعلان 1"),
          SizedBox(width: 10.w),
          _buildAdBox(Colors.green, "كوبون خصم"),
          SizedBox(width: 10.w),
          _buildAdBox(Colors.blue, "إعلان 3"),
          SizedBox(width: 10.w),
          _buildAdBox(Colors.red, "كوبون 2"),
          SizedBox(width: 10.w),
          _buildAdBox(Colors.purple, "إعلان 5"),
        ],
      ),
    );
  }

  Widget _buildAdBox(Color color, String text) {
    return Container(
      width: 130.w,
      height: 120.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
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
              child: Icon(
                _icons[index],
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveIcon(int index) {
    return Container(
      height: 61.h,
      alignment: Alignment.center,
      child: Icon(
        _icons[index],
        color: Colors.white.withOpacity(0.7),
        size: 28.sp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildDateRow(),
          _buildTripInfo(),
          _buildTimeSelector(),
          SizedBox(height: 10.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSeatsStream(),
                  SizedBox(height: 20.h),
                  _buildAds(),
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
            return GestureDetector(
              onTap: () => setState(() => _currentIndex = index),
              child: isActive
                  ? _buildActiveIcon(index)
                  : _buildInactiveIcon(index),
            );
          }),
        ),
      ),
    );
  }
}
