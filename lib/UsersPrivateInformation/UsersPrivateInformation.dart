// File: lib/UsersPrivateInformation/UsersPrivateInformation.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersPrivateInformation extends StatefulWidget {
  const UsersPrivateInformation({super.key});

  @override
  State<UsersPrivateInformation> createState() =>
      _UsersPrivateInformationState();
}

class _UsersPrivateInformationState extends State<UsersPrivateInformation> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  User? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _initializeControllers();
  }

  void _initializeControllers() {
    // استخراج الاسم الأول واسم العائلة من displayName
    String displayName = _currentUser?.displayName ?? '';
    List<String> nameParts = displayName.split(' ');
    String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    String lastName =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    emailController = TextEditingController(text: _currentUser?.email ?? '');
    phoneController =
        TextEditingController(text: _currentUser?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ✅ تحديث اسم المستخدم في Firebase
  Future<void> _updateDisplayName() async {
    String newDisplayName =
        '${firstNameController.text.trim()} ${lastNameController.text.trim()}'
            .trim();
    if (newDisplayName.isEmpty) return;

    try {
      await _currentUser?.updateDisplayName(newDisplayName);
      await _currentUser?.reload();
      _currentUser = FirebaseAuth.instance.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم تحديث الاسم بنجاح'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ فشل تحديث الاسم: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ إرسال رابط إعادة تعيين كلمة المرور عبر البريد الإلكتروني
  Future<void> _sendPasswordResetEmail() async {
    if (_currentUser?.email == null) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _currentUser!.email!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '📧 تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ فشل إرسال الرابط: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: AppBar(
        title: const Text(
          'معلومات المستخدم',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 145, 123, 89),
        leading: IconButton(
          icon: Image.asset(
            "images/geri.png",
            width: 30,
            height: 30,
            errorBuilder: (c, e, s) =>
                const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                _buildTextField("الاسم الأول", firstNameController),
                _buildTextField("اسم الأب + العائلة", lastNameController),
                _buildTextField(
                  "البريد الإلكتروني",
                  emailController,
                  enabled: false, // البريد لا يمكن تغييره بهذه الطريقة
                ),
                _buildTextField(
                  "رقم الهاتف",
                  phoneController,
                  enabled: false, // رقم الهاتف غير مخزن في Firebase Auth حالياً
                ),
                const SizedBox(height: 10),
                // زر تغيير كلمة المرور عبر البريد
                _buildPasswordResetButton(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateDisplayName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE8143),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "حفظ التعديلات",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: enabled,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: enabled ? const Color(0xFFF5F5F5) : Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordResetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'كلمة المرور',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: InkWell(
              onTap: _isLoading ? null : _sendPasswordResetEmail,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.lock_reset,
                            color: Color(0xFF795622),
                          ),
                    const Text(
                      'تغيير كلمة المرور',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF795622),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF795622),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
