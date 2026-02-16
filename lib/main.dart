import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:hajzli/splach/splach.dart';
import 'package:hajzli/home/home.dart';
import 'package:hajzli/SearchTrips/SearchTrips.dart';
import 'package:hajzli/SearchForFlights/SearchForFlights.dart';
import 'package:hajzli/HotelReservations/HotelReservations.dart';
import 'package:hajzli/HelpCenter/HelpCenter.dart';
import 'package:hajzli/SelectTheLoginProcess/SelectTheLoginProcess.dart';
import 'package:hajzli/SelectTrips/Choosing.dart';
import 'package:hajzli/SelectFlight/SelectFlight.dart';
import 'package:hajzli/Currencies/Currencies.dart';
import 'package:hajzli/Languages/Languages.dart';
import 'package:hajzli/ResetPassword/ResetPassword.dart';
import 'package:hajzli/AddCard/AddCard.dart';
import 'package:hajzli/EmailVerificationPendingPage.dart';
import 'package:hajzli/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');
  bool _isLocaleLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'ar';
    setState(() {
      _locale = Locale(languageCode);
      _isLocaleLoaded = true;
    });
  }

  Future<void> setLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleLoaded) {
      return Container(color: Colors.white);
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      ensureScreenSize: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hijizli',
          locale: _locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: child!,
            );
          },
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.brown,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF735C3A),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            primaryColor: const Color(0xFF735C3A),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF735C3A),
              secondary: Color(0xFFE6D2B9),
            ),
          ),
          routes: {
            '/home': (context) => const HomePage(),
            '/searchTrips': (context) => const SearchTrips(),
            '/searchFlights': (context) => const SearchForFlights(),
            '/hotelReservations': (context) => const HotelReservations(),
            '/helpCenter': (context) => const HelpCenter(),
            '/selectLogin': (context) => const SelectTheLoginProcess(),
            '/selectFlight': (context) => const SelectFlight(),
            '/currencies': (context) => const CurrenciesPage(),
            '/languages': (context) => const LanguagesPage(),
            '/resetPassword': (context) => const ResetPasswordPage(),
            '/addCard': (context) => const AddCard(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/selectTrips':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => Choosing(
                    from: args['from'],
                    to: args['to'],
                    date: args['date'],
                    tripId: args['tripId'] ?? 'trip_123', // ✅ استلام tripId
                  ),
                );
              case '/nearbyHotels':
                final args = settings.arguments as Map<String, double>;
                return MaterialPageRoute(
                  builder: (context) => NearbyHotelsPage(
                    latitude: args['latitude']!,
                    longitude: args['longitude']!,
                  ),
                );
              case '/emailVerification':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) =>
                      EmailVerificationPendingPage(email: args['email']),
                );
              default:
                return null;
            }
          },
          home: const Splach_screan(),
        );
      },
    );
  }
}
