import 'package:flutter/material.dart';

class SelectFlight extends StatefulWidget {
  const SelectFlight({super.key});

  @override
  State<SelectFlight> createState() => _SelectFlightState();
}

class _SelectFlightState extends State<SelectFlight> {
  DateTime selectedDate = DateTime.now();

  void _decrementDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _incrementDate() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void selectMorning() {}
  void selectNoon() {}
  void selectEvening() {}
  void sortPrices() {}

  // مربعات الوقت العادية
  Widget _buildBox(String text) {
    return Container(
      width: 87,
      height: 34,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF795622), width: 1.5),
        color: Colors.transparent,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF795622),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // مربع ترتيب مع أيقونة/صورة
  Widget _buildBoxWithImage(String text, String imagePath) {
    return Container(
      width: 88,
      height: 34,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF795622), width: 1.5),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 22,
            width: 22,
            fit: BoxFit.contain, // لضبط حجم الصورة داخل المربع
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF795622),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // إعلانات أفقية
  Widget _buildAdBox(Color color, String text) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // المربع العلوي الكبير
            Container(
              width: double.infinity,
              height: 165,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3D352A), Color(0xFFA38D6F)],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          "images/geri.png",
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Image.asset(
                        "images/Flightt.png",
                        height: 65,
                        width: 65,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        "images/Settings.png",
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _decrementDate,
                        child: Container(
                          width: 96,
                          height: 34,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              SizedBox(width: 8),
                              Icon(Icons.arrow_left, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "قبل",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          width: 165,
                          height: 34,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/Data.png",
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _incrementDate,
                        child: Container(
                          width: 90,
                          height: 34,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                "بعد",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_right, color: Colors.white),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // أزرار الصباح / الظهر / المساء / ترتيب مع صورة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: selectMorning,
                    child: _buildBox("الصباح"),
                  ),
                  GestureDetector(onTap: selectNoon, child: _buildBox("الظهر")),
                  GestureDetector(
                    onTap: selectEvening,
                    child: _buildBox("المساء"),
                  ),
                  GestureDetector(
                    onTap: sortPrices,
                    child: _buildBoxWithImage("ترتيب", "images/Swap.png"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // الإعلانات الأفقية
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _buildAdBox(Colors.orange, "إعلان 1"),
                  const SizedBox(width: 10),
                  _buildAdBox(Colors.green, "كوبون خصم"),
                  const SizedBox(width: 10),
                  _buildAdBox(Colors.blue, "إعلان 3"),
                  const SizedBox(width: 10),
                  _buildAdBox(Colors.red, "كوبون 2"),
                  const SizedBox(width: 10),
                  _buildAdBox(Colors.purple, "إعلان 5"),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
