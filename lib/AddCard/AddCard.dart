import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final _formKey = GlobalKey<FormState>();
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setDefaultExpiry();
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _setDefaultExpiry() {
    DateTime now = DateTime.now();
    int nextMonth = now.month == 12 ? 1 : now.month + 1;
    int year = now.month == 12 ? now.year + 1 : now.year;
    String monthStr = nextMonth.toString().padLeft(2, '0');
    String yearStr = (year % 100).toString().padLeft(2, '0');
    _expiryController.text = '$monthStr/$yearStr';
  }

  String formatExpiry(String text) {
    text = text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    if (text.length > 2) {
      return '${text.substring(0, 2)}/${text.substring(2)}';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "إضافة بطاقة جديدة",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: IconButton(
                  icon: Image.asset("images/geri.png", width: 40, height: 40),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Image.asset("images/card.png", width: 350, height: 350),
              ),
              const SizedBox(height: 0),

              // اسم حامل البطاقة على اليمين
              const Text(
                "اسم حامل البطاقة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _cardHolderController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'ادخل اسم حامل البطاقة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'الرجاء إدخال الاسم'
                    : null,
              ),
              const SizedBox(height: 8),

              // رقم البطاقة على اليمين
              const Text(
                "رقم البطاقة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _cardNumberController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 16,
                decoration: InputDecoration(
                  hintText: 'XXXX XXXX XXXX XXXX',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم البطاقة';
                  }
                  if (value.length < 16) {
                    return 'يجب أن يحتوي الرقم على 16 خانة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // صف التاريخ و CVV في الوسط
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          " (MM/YY) تاريخ البطاقة",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _expiryController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: 'MM/YY',
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            onChanged: (val) {
                              String formatted = formatExpiry(val);
                              if (formatted != val) {
                                _expiryController.value = TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.collapsed(
                                    offset: formatted.length,
                                  ),
                                );
                              }
                            },
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'الرجاء إدخال التاريخ';
                              }
                              if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(v)) {
                                return 'التاريخ غير صالح';
                              }
                              int month = int.parse(v.substring(0, 2));
                              if (month < 1 || month > 12) {
                                return 'الشهر غير صالح';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          " CVV رمز",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: _cvvController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: 'XXX',
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'الرجاء إدخال CVV';
                              }
                              if (v.length != 3) {
                                return 'يجب أن يحتوي CVV على 3 أرقام';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // زر حفظ البطاقة أصغر وفي الوسط
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 168, 131, 82),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(200, 50), // عرض أصغر
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newCard = {
                        "number":
                            "**** **** **** ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)}",
                        "type": "Visa",
                        "holder": _cardHolderController.text,
                        "expiry": _expiryController.text,
                        "cvv": _cvvController.text,
                      };

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم حفظ البطاقة بنجاح!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context, newCard);
                    }
                  },
                  child: const Text(
                    'حفظ البطاقة',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
