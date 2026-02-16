import 'package:flutter/material.dart';
import 'package:hijizli/AddCard/AddCard.dart'; // تأكد أن المسار صحيح في مشروعك

class PaymentInformation extends StatefulWidget {
  const PaymentInformation({super.key});

  @override
  State<PaymentInformation> createState() => _PaymentInformationState();
}

class _PaymentInformationState extends State<PaymentInformation> {
  // لائحة البطاقات المحفوظة (كل عنصر خريطة تحتوي رقم البطاقة وآسم النوع)
  List<Map<String, String>> savedCards = [
    {"number": "**** **** **** 1234", "type": "Visa"},
    {"number": "**** **** **** 5678", "type": "MasterCard"},
  ];

  // الفهرس المحدد (أو null إذا لا يوجد تحديد)
  int? selectedIndex;

  // دالة لعرض تأكيد الحذف
  Future<void> _confirmDelete(BuildContext ctx, int index) async {
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (dCtx) => AlertDialog(
        title: const Text("حذف البطاقة"),
        content: Text("هل تريد حذف البطاقة ${savedCards[index]['number']}؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dCtx).pop(false),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () => Navigator.of(dCtx).pop(true),
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        savedCards.removeAt(index);
        // إذا كانت البطاقة المحددة أكبر أو تساوي الطول الجديد أصلاً، نلغي التحديد
        if (selectedIndex != null) {
          if (savedCards.isEmpty) {
            selectedIndex = null;
          } else if (selectedIndex! >= savedCards.length) {
            selectedIndex = null;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 243),

      // الشريط العلوي المخصص
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "معلومات الدفع",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: IconButton(
                  icon: Image.asset("images/geri.png", width: 90, height: 200),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {
                    // خيارات مستقبلية
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // جسم الصفحة
      body: Center(
        child: Container(
          width: 390,
          height: 700,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // أيقونات وسائل الدفع
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/mastercard.png", width: 40, height: 40),
                  const SizedBox(width: 20),
                  Image.asset("images/visa.png", width: 60, height: 60),
                  const SizedBox(width: 20),
                  Image.asset("images/paypal.png", width: 60, height: 60),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 10),

              // عنوان القسم
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "البطاقات المحفوظة",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // حذف الجميع لو حبيت: نفذ منطقك هنا
                      if (savedCards.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (dCtx) => AlertDialog(
                            title: const Text("حذف كل البطاقات"),
                            content: const Text(
                              "هل تريد حذف كل البطاقات المحفوظة؟",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(dCtx).pop(),
                                child: const Text("إلغاء"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    savedCards.clear();
                                    selectedIndex = null;
                                  });
                                  Navigator.of(dCtx).pop();
                                },
                                child: const Text(
                                  "حذف الكل",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // لائحة البطاقات (قابلة للتمرير)
              Expanded(
                child: savedCards.isEmpty
                    ? const Center(
                        child: Text(
                          "لا توجد بطاقات محفوظة",
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: savedCards.length,
                        itemBuilder: (ctx, index) {
                          final card = savedCards[index];
                          final isSelected = selectedIndex == index;

                          return GestureDetector(
                            onTap: () {
                              // عند الضغط على البطاقة: نعرض نافذة تأكيد حذف
                              _confirmDelete(context, index);
                            },
                            onLongPress: () {
                              // بديل: نجعل الضغط الطويل يختار البطاقة بدل الحذف الفوري
                              setState(() {
                                selectedIndex = isSelected ? null : index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF7ECE0)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFFEE8143),
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    card["number"]!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        card["type"]!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF735C3A),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // أيقونة حذف صغيرة لكل بطاقة (يمكن الضغط عليها أيضاً للحذف)
                                      IconButton(
                                        onPressed: () =>
                                            _confirmDelete(context, index),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),

              // زر إضافة بطاقة جديدة
              GestureDetector(
                onTap: () async {
                  // ننتقل لصفحة الإضافة وننتظر النتيجة (خريطة تمثل البطاقة الجديدة)
                  final result = await Navigator.push<Map<String, String>?>(
                    context,
                    MaterialPageRoute(builder: (context) => const AddCard()),
                  );

                  if (result != null) {
                    setState(() {
                      savedCards.add(result);
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEE8143),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "إضافة كرت آخر",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
