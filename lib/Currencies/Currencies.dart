import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:currency_sdk/currency_sdk.dart';
import 'package:hajzli/l10n/app_localizations.dart';

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({super.key});

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  late CurrencyClient _client;
  Map<String, double> _rates = {};
  bool _isLoading = true;
  String _baseCurrency = 'USD';
  double _amount = 1.0;
  final TextEditingController _amountController =
      TextEditingController(text: '1');
  String _errorMessage = '';
  bool _isRetrying = false; // ✅ متغير لتتبع حالة إعادة المحاولة

  @override
  void initState() {
    super.initState();
    _initializeSDK();
  }

  @override
  void dispose() {
    _client.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // ✅ دالة محسنة مع إعادة المحاولة التلقائية
  Future<void> _initializeSDK({int retryCount = 0}) async {
    // الحد الأقصى لعدد المحاولات (3 محاولات)
    const maxRetries = 3;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      if (retryCount > 0) _isRetrying = true;
    });

    try {
      _client = CurrencyClient();
      await _client.initialize();

      final rates = await _client.getRates(_baseCurrency);

      setState(() {
        _rates = rates.conversionRates;
        _isLoading = false;
        _isRetrying = false;
      });
    } catch (e) {
      // ✅ إذا كان الخطأ هو عدم جاهزية البيانات، حاول مرة أخرى
      if (e.toString().contains('Worker data not ready') &&
          retryCount < maxRetries) {
        // انتظر ثانية واحدة ثم حاول مجدداً
        await Future.delayed(const Duration(seconds: 1));
        return _initializeSDK(retryCount: retryCount + 1);
      }

      // إذا فشلت كل المحاولات، اعرض الخطأ
      setState(() {
        _errorMessage = 'فشل تحميل البيانات: $e';
        _isLoading = false;
        _isRetrying = false;
      });
    }
  }

  Future<void> _changeBaseCurrency(String newCurrency) async {
    if (newCurrency == _baseCurrency) return;

    setState(() {
      _isLoading = true;
      _baseCurrency = newCurrency;
    });

    try {
      final rates = await _client.getRates(newCurrency);
      setState(() {
        _rates = rates.conversionRates;
        _isLoading = false;
      });
    } catch (e) {
      // ✅ أيضاً إعادة محاولة عند تغيير العملة الأساسية
      if (e.toString().contains('Worker data not ready')) {
        await Future.delayed(const Duration(seconds: 1));
        return _changeBaseCurrency(newCurrency); // حاول مرة أخرى
      }
      setState(() {
        _errorMessage = 'فشل تحميل البيانات: $e';
        _isLoading = false;
      });
    }
  }

  double _getConvertedRate(String targetCurrency) {
    if (_rates.isEmpty) return 0.0;
    if (targetCurrency == _baseCurrency) return _amount;
    return _amount * (_rates[targetCurrency] ?? 1.0);
  }

  void _updateAmount(String value) {
    setState(() {
      _amount = double.tryParse(value) ?? 0.0;
    });
  }

  String _getLocalizedCurrencyName(
      String code, AppLocalizations localizations) {
    switch (code) {
      case 'USD':
        return localizations.usDollar;
      case 'TRY':
        return localizations.turkishLira;
      case 'SYP':
        return localizations.syrianPound;
      case 'EUR':
        return localizations.euro;
      case 'GBP':
        return localizations.britishPound;
      case 'SAR':
        return localizations.saudiRiyal;
      case 'KWD':
        return localizations.kuwaitiDinar;
      case 'AED':
        return localizations.uaeDirham;
      default:
        return code;
    }
  }

  Widget _buildCurrencyCard(String code, AppLocalizations localizations) {
    if (_rates.isEmpty) return const SizedBox();

    final rate = _rates[code] ?? 0.0;
    final convertedAmount = _getConvertedRate(code);
    final change = (rate * 100).truncateToDouble() % 10 / 100;
    final changeStr = change >= 0
        ? '+${change.toStringAsFixed(2)}%'
        : '${change.toStringAsFixed(2)}%';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Text(
                code,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF735C3A),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  _getLocalizedCurrencyName(code, localizations),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                convertedAmount.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                changeStr,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: change >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF735C3A),
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              height: 88.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF735C3A), Color(0xFFE6D2B9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      localizations.currencies,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xFFEAEAEA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.w,
                    top: 24.h,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'images/geri.png',
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            color: const Color(0xFF735C3A)),
                        if (_isRetrying) ...[
                          SizedBox(height: 10.h),
                          Text(
                            'جاري التحميل... قد يستغرق بضع ثوان',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  )
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 50.sp, color: Colors.red),
                            SizedBox(height: 10.h),
                            Text(
                              _errorMessage,
                              style: TextStyle(fontSize: 16.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: () => _initializeSDK(),
                              child: Text(localizations.tryAgain),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: const Color(0xFF735C3A)
                                                .withOpacity(0.3)),
                                      ),
                                      child: TextField(
                                        controller: _amountController,
                                        keyboardType: TextInputType.number,
                                        onChanged: _updateAmount,
                                        decoration: InputDecoration(
                                          hintText: localizations.amount,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12.w),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                            color: const Color(0xFF735C3A)
                                                .withOpacity(0.3)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _baseCurrency,
                                          items: [
                                            'USD',
                                            'TRY',
                                            'EUR',
                                            'GBP',
                                            'SAR'
                                          ]
                                              .map((code) => DropdownMenuItem(
                                                    value: code,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.w),
                                                      child: Text(code),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            if (value != null)
                                              _changeBaseCurrency(value);
                                          },
                                          icon: Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.w),
                                            child: Icon(Icons.arrow_drop_down,
                                                color: const Color(0xFF735C3A)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Text('')),
                                  Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: Text(localizations.currency,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      FontWeight.bold)))),
                                  Expanded(
                                      flex: 1,
                                      child: Text(localizations.exchangeRate,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right)),
                                  Expanded(
                                      flex: 1,
                                      child: Text(localizations.change,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right)),
                                  SizedBox(width: 20.w),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            _buildCurrencyCard('TRY', localizations),
                            _buildCurrencyCard('EUR', localizations),
                            _buildCurrencyCard('GBP', localizations),
                            _buildCurrencyCard('SAR', localizations),
                            _buildCurrencyCard('KWD', localizations),
                            _buildCurrencyCard('AED', localizations),
                            _buildCurrencyCard('SYP', localizations),
                            SizedBox(height: 80.h),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
