import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'حجزلي'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @homeTitle.
  ///
  /// In ar, this message translates to:
  /// **'حجزلي !'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تذاكرك بين يديك في ثوانٍ'**
  String get homeSubtitle;

  /// No description provided for @bookingExperience.
  ///
  /// In ar, this message translates to:
  /// **'تجربة حجز سريعة، آمنة، وبخطوات بسيطة مع حجزلي'**
  String get bookingExperience;

  /// No description provided for @busTickets.
  ///
  /// In ar, this message translates to:
  /// **'تذاكر الحافلات'**
  String get busTickets;

  /// No description provided for @flightTickets.
  ///
  /// In ar, this message translates to:
  /// **'تذاكر الطيران'**
  String get flightTickets;

  /// No description provided for @hotelBooking.
  ///
  /// In ar, this message translates to:
  /// **'حجز الفنادق'**
  String get hotelBooking;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @selectLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اختيار اللغة'**
  String get selectLanguage;

  /// No description provided for @currencies.
  ///
  /// In ar, this message translates to:
  /// **'العملات'**
  String get currencies;

  /// No description provided for @changePassword.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة السر'**
  String get changePassword;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'وضع داكن'**
  String get darkMode;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'الإنجليزية'**
  String get english;

  /// No description provided for @turkish.
  ///
  /// In ar, this message translates to:
  /// **'التركية'**
  String get turkish;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @helpCenter.
  ///
  /// In ar, this message translates to:
  /// **'مركز المساعدة'**
  String get helpCenter;

  /// No description provided for @searchTrips.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن رحلات'**
  String get searchTrips;

  /// No description provided for @from.
  ///
  /// In ar, this message translates to:
  /// **'المغادرة من'**
  String get from;

  /// No description provided for @to.
  ///
  /// In ar, this message translates to:
  /// **'الوصول إلى'**
  String get to;

  /// No description provided for @selectDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر التاريخ'**
  String get selectDate;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غدًا'**
  String get tomorrow;

  /// No description provided for @busTicketsSearch.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن تذاكر الحافلات'**
  String get busTicketsSearch;

  /// No description provided for @selectDeparture.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار المغادرة'**
  String get selectDeparture;

  /// No description provided for @selectArrival.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار الوصول'**
  String get selectArrival;

  /// No description provided for @bothRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار كل من المغادرة والوصول'**
  String get bothRequired;

  /// No description provided for @sameLocationError.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن اختيار نفس المنطقة للمغادرة والوصول'**
  String get sameLocationError;

  /// No description provided for @busService.
  ///
  /// In ar, this message translates to:
  /// **'أنت الآن في صفحة حجز الباصات'**
  String get busService;

  /// No description provided for @underDevelopment.
  ///
  /// In ar, this message translates to:
  /// **'هذه الخدمة تحت التطوير'**
  String get underDevelopment;

  /// No description provided for @airplane.
  ///
  /// In ar, this message translates to:
  /// **'طائرة'**
  String get airplane;

  /// No description provided for @bus.
  ///
  /// In ar, this message translates to:
  /// **'حافلة'**
  String get bus;

  /// No description provided for @car.
  ///
  /// In ar, this message translates to:
  /// **'سيارة'**
  String get car;

  /// No description provided for @hotel.
  ///
  /// In ar, this message translates to:
  /// **'فندق'**
  String get hotel;

  /// No description provided for @chooseDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر التاريخ'**
  String get chooseDate;

  /// No description provided for @dateSelected.
  ///
  /// In ar, this message translates to:
  /// **'تم اختيار التاريخ'**
  String get dateSelected;

  /// No description provided for @departureCity.
  ///
  /// In ar, this message translates to:
  /// **'مدينة المغادرة'**
  String get departureCity;

  /// No description provided for @arrivalCity.
  ///
  /// In ar, this message translates to:
  /// **'مدينة الوصول'**
  String get arrivalCity;

  /// No description provided for @swapLocations.
  ///
  /// In ar, this message translates to:
  /// **'تبديل المواقع'**
  String get swapLocations;

  /// No description provided for @currentPage.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة الحالية'**
  String get currentPage;

  /// No description provided for @availableSoon.
  ///
  /// In ar, this message translates to:
  /// **'ستتوفر قريباً'**
  String get availableSoon;

  /// No description provided for @createAccountWithHijizli.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك مع حجزلي'**
  String get createAccountWithHijizli;

  /// No description provided for @haveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل'**
  String get haveAccount;

  /// No description provided for @noAccount.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد لديك حساب'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get createAccount;

  /// No description provided for @orContinueWith.
  ///
  /// In ar, this message translates to:
  /// **'أو الاستمرار مع'**
  String get orContinueWith;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signIn;

  /// No description provided for @logIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get logIn;

  /// No description provided for @continueWithFacebook.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة مع فيسبوك'**
  String get continueWithFacebook;

  /// No description provided for @continueWithGoogle.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة مع جوجل'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة مع آبل'**
  String get continueWithApple;

  /// No description provided for @socialLogin.
  ///
  /// In ar, this message translates to:
  /// **'الدخول عبر وسائل التواصل'**
  String get socialLogin;

  /// No description provided for @accountCreation.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get accountCreation;

  /// No description provided for @accountLogin.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول للحساب'**
  String get accountLogin;

  /// No description provided for @selectLocation.
  ///
  /// In ar, this message translates to:
  /// **'انقر لتحديد الموقع'**
  String get selectLocation;

  /// No description provided for @checkInDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الدخول'**
  String get checkInDate;

  /// No description provided for @checkOutDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الخروج'**
  String get checkOutDate;

  /// No description provided for @selectRooms.
  ///
  /// In ar, this message translates to:
  /// **'اختر الغرف والضيوف'**
  String get selectRooms;

  /// No description provided for @hideRooms.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء اختيار الغرف'**
  String get hideRooms;

  /// No description provided for @room.
  ///
  /// In ar, this message translates to:
  /// **'غرفة'**
  String get room;

  /// No description provided for @adults.
  ///
  /// In ar, this message translates to:
  /// **'بالغين'**
  String get adults;

  /// No description provided for @children.
  ///
  /// In ar, this message translates to:
  /// **'أطفال'**
  String get children;

  /// No description provided for @addRoom.
  ///
  /// In ar, this message translates to:
  /// **'إضافة غرفة'**
  String get addRoom;

  /// No description provided for @bookNow.
  ///
  /// In ar, this message translates to:
  /// **'حجز الآن'**
  String get bookNow;

  /// No description provided for @bookingConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'تم الحجز ✅ الغرف:'**
  String get bookingConfirmed;

  /// No description provided for @rooms.
  ///
  /// In ar, this message translates to:
  /// **'غرف'**
  String get rooms;

  /// No description provided for @locationError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الموقع'**
  String get locationError;

  /// No description provided for @inDevelopment.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة قيد التطوير'**
  String get inDevelopment;

  /// No description provided for @currentHotelPage.
  ///
  /// In ar, this message translates to:
  /// **'أنت في صفحة الفنادق'**
  String get currentHotelPage;

  /// No description provided for @carService.
  ///
  /// In ar, this message translates to:
  /// **'خدمة السيارات'**
  String get carService;

  /// No description provided for @hotelsIn.
  ///
  /// In ar, this message translates to:
  /// **'الفنادق في'**
  String get hotelsIn;

  /// No description provided for @noHotelsFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على فنادق'**
  String get noHotelsFound;

  /// No description provided for @hotelDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الفندق'**
  String get hotelDetails;

  /// No description provided for @selectGuests.
  ///
  /// In ar, this message translates to:
  /// **'اختر الضيوف'**
  String get selectGuests;

  /// No description provided for @searchHotels.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن فنادق'**
  String get searchHotels;

  /// No description provided for @nearbyHotels.
  ///
  /// In ar, this message translates to:
  /// **'الفنادق القريبة'**
  String get nearbyHotels;

  /// No description provided for @allHotels.
  ///
  /// In ar, this message translates to:
  /// **'جميع الفنادق'**
  String get allHotels;

  /// No description provided for @filter.
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get filter;

  /// No description provided for @sortBy.
  ///
  /// In ar, this message translates to:
  /// **'ترتيب حسب'**
  String get sortBy;

  /// No description provided for @priceLowHigh.
  ///
  /// In ar, this message translates to:
  /// **'السعر من الأقل للأعلى'**
  String get priceLowHigh;

  /// No description provided for @priceHighLow.
  ///
  /// In ar, this message translates to:
  /// **'السعر من الأعلى للأقل'**
  String get priceHighLow;

  /// No description provided for @rating.
  ///
  /// In ar, this message translates to:
  /// **'التقييم'**
  String get rating;

  /// No description provided for @distance.
  ///
  /// In ar, this message translates to:
  /// **'المسافة'**
  String get distance;

  /// No description provided for @helpSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'إجابات لجميع استفساراتك'**
  String get helpSubtitle;

  /// No description provided for @buses.
  ///
  /// In ar, this message translates to:
  /// **'الحافلات'**
  String get buses;

  /// No description provided for @flights.
  ///
  /// In ar, this message translates to:
  /// **'الطيران'**
  String get flights;

  /// No description provided for @hotels.
  ///
  /// In ar, this message translates to:
  /// **'الفنادق'**
  String get hotels;

  /// No description provided for @generalQuestions.
  ///
  /// In ar, this message translates to:
  /// **'أسئلة عامة'**
  String get generalQuestions;

  /// No description provided for @cancelTicketBus.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني إلغاء التذكرة الخاصة بي؟'**
  String get cancelTicketBus;

  /// No description provided for @changeTicketBus.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني تغيير تذكرة الحافلة الخاصة بي؟'**
  String get changeTicketBus;

  /// No description provided for @refundNotShownBus.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم عرض المبلغ المسترد في حسابي، ماذا يجب أن أفعل؟'**
  String get refundNotShownBus;

  /// No description provided for @otherBusTopics.
  ///
  /// In ar, this message translates to:
  /// **'مواضيع أخرى للحافلات'**
  String get otherBusTopics;

  /// No description provided for @cancelTicketFlight.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني إلغاء تذكرة الطيران الخاصة بي؟'**
  String get cancelTicketFlight;

  /// No description provided for @changeTicketFlight.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني تغيير تذكرة الطيران الخاصة بي؟'**
  String get changeTicketFlight;

  /// No description provided for @ticketNotReceived.
  ///
  /// In ar, this message translates to:
  /// **'تم خصم المبلغ من بطاقتي ولكن لم تصلني معلومات التذكرة، ماذا أفعل؟'**
  String get ticketNotReceived;

  /// No description provided for @otherFlightTopics.
  ///
  /// In ar, this message translates to:
  /// **'مواضيع أخرى للطيران'**
  String get otherFlightTopics;

  /// No description provided for @cancelHotelBooking.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني إلغاء حجز الفندق الخاص بي؟'**
  String get cancelHotelBooking;

  /// No description provided for @changeHotelBooking.
  ///
  /// In ar, this message translates to:
  /// **'هل يمكنني إجراء تغييرات على حجز الفندق الخاص بي؟'**
  String get changeHotelBooking;

  /// No description provided for @hotelDocuments.
  ///
  /// In ar, this message translates to:
  /// **'ما هي الوثائق التي يجب أن تكون معي عند التسجيل؟'**
  String get hotelDocuments;

  /// No description provided for @otherHotelTopics.
  ///
  /// In ar, this message translates to:
  /// **'مواضيع أخرى للفنادق'**
  String get otherHotelTopics;

  /// No description provided for @howToContactSupport.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني التواصل مع الدعم الفني؟'**
  String get howToContactSupport;

  /// No description provided for @paymentMethods.
  ///
  /// In ar, this message translates to:
  /// **'ما هي طرق الدفع المتاحة؟'**
  String get paymentMethods;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In ar, this message translates to:
  /// **'الشروط والأحكام'**
  String get termsAndConditions;

  /// No description provided for @contactSupport.
  ///
  /// In ar, this message translates to:
  /// **'الاتصال بالدعم الفني'**
  String get contactSupport;

  /// No description provided for @questionDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل السؤال'**
  String get questionDetails;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In ar, this message translates to:
  /// **'الأسئلة الشائعة'**
  String get frequentlyAskedQuestions;

  /// No description provided for @searchHelp.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في مركز المساعدة'**
  String get searchHelp;

  /// No description provided for @needMoreHelp.
  ///
  /// In ar, this message translates to:
  /// **'هل تحتاج إلى مساعدة إضافية؟'**
  String get needMoreHelp;

  /// No description provided for @emailSupport.
  ///
  /// In ar, this message translates to:
  /// **'الدعم عبر البريد الإلكتروني'**
  String get emailSupport;

  /// No description provided for @phoneSupport.
  ///
  /// In ar, this message translates to:
  /// **'الدعم الهاتفي'**
  String get phoneSupport;

  /// No description provided for @liveChat.
  ///
  /// In ar, this message translates to:
  /// **'الدردشة الحية'**
  String get liveChat;

  /// No description provided for @supportHours.
  ///
  /// In ar, this message translates to:
  /// **'ساعات الدعم: 9 صباحًا - 6 مساءً'**
  String get supportHours;

  /// No description provided for @commonIssues.
  ///
  /// In ar, this message translates to:
  /// **'المشاكل الشائعة'**
  String get commonIssues;

  /// No description provided for @troubleshooting.
  ///
  /// In ar, this message translates to:
  /// **'استكشاف الأخطاء وإصلاحها'**
  String get troubleshooting;

  /// No description provided for @userGuide.
  ///
  /// In ar, this message translates to:
  /// **'دليل المستخدم'**
  String get userGuide;

  /// No description provided for @videoTutorials.
  ///
  /// In ar, this message translates to:
  /// **'فيديوهات تعليمية'**
  String get videoTutorials;

  /// No description provided for @addNewCard.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بطاقة جديدة'**
  String get addNewCard;

  /// No description provided for @cardHolderName.
  ///
  /// In ar, this message translates to:
  /// **'اسم حامل البطاقة'**
  String get cardHolderName;

  /// No description provided for @enterCardHolderName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم حامل البطاقة'**
  String get enterCardHolderName;

  /// No description provided for @pleaseEnterName.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال الاسم'**
  String get pleaseEnterName;

  /// No description provided for @cardNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم البطاقة'**
  String get cardNumber;

  /// No description provided for @enterCardNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم البطاقة'**
  String get enterCardNumber;

  /// No description provided for @pleaseEnterCardNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم البطاقة'**
  String get pleaseEnterCardNumber;

  /// No description provided for @cardNumberMustBe16Digits.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يحتوي رقم البطاقة على 16 رقمًا'**
  String get cardNumberMustBe16Digits;

  /// No description provided for @expiryDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء'**
  String get expiryDate;

  /// No description provided for @pleaseEnterExpiryDate.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال تاريخ الانتهاء'**
  String get pleaseEnterExpiryDate;

  /// No description provided for @invalidExpiryDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ انتهاء غير صالح'**
  String get invalidExpiryDate;

  /// No description provided for @invalidMonth.
  ///
  /// In ar, this message translates to:
  /// **'شهر غير صالح'**
  String get invalidMonth;

  /// No description provided for @pleaseEnterCVV.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رمز CVV'**
  String get pleaseEnterCVV;

  /// No description provided for @cvvMustBe3Digits.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يحتوي رمز CVV على 3 أرقام'**
  String get cvvMustBe3Digits;

  /// No description provided for @securityInfo.
  ///
  /// In ar, this message translates to:
  /// **'بيانات بطاقتك آمنة ومشفرة. نحن لا نخزن معلومات بطاقتك الكاملة على خوادمنا.'**
  String get securityInfo;

  /// No description provided for @saveCard.
  ///
  /// In ar, this message translates to:
  /// **'حفظ البطاقة'**
  String get saveCard;

  /// No description provided for @cardSavedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ البطاقة بنجاح!'**
  String get cardSavedSuccessfully;

  /// No description provided for @cardType.
  ///
  /// In ar, this message translates to:
  /// **'نوع البطاقة'**
  String get cardType;

  /// No description provided for @visa.
  ///
  /// In ar, this message translates to:
  /// **'فيزا'**
  String get visa;

  /// No description provided for @mastercard.
  ///
  /// In ar, this message translates to:
  /// **'ماستركارد'**
  String get mastercard;

  /// No description provided for @americanExpress.
  ///
  /// In ar, this message translates to:
  /// **'أمريكان إكسبريس'**
  String get americanExpress;

  /// No description provided for @discover.
  ///
  /// In ar, this message translates to:
  /// **'ديسكفر'**
  String get discover;

  /// No description provided for @unknownCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة غير معروفة'**
  String get unknownCard;

  /// No description provided for @cardPreview.
  ///
  /// In ar, this message translates to:
  /// **'معاينة البطاقة'**
  String get cardPreview;

  /// No description provided for @enterValidCardNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم بطاقة صالح'**
  String get enterValidCardNumber;

  /// No description provided for @cardExpired.
  ///
  /// In ar, this message translates to:
  /// **'البطاقة منتهية الصلاحية'**
  String get cardExpired;

  /// No description provided for @cardWillExpire.
  ///
  /// In ar, this message translates to:
  /// **'ستنتهي صلاحية البطاقة قريبًا'**
  String get cardWillExpire;

  /// No description provided for @cardValid.
  ///
  /// In ar, this message translates to:
  /// **'البطاقة صالحة'**
  String get cardValid;

  /// No description provided for @saveForFuturePayments.
  ///
  /// In ar, this message translates to:
  /// **'حفظ للدفعات المستقبلية'**
  String get saveForFuturePayments;

  /// No description provided for @scanCard.
  ///
  /// In ar, this message translates to:
  /// **'مسح البطاقة'**
  String get scanCard;

  /// No description provided for @manualEntry.
  ///
  /// In ar, this message translates to:
  /// **'إدخال يدوي'**
  String get manualEntry;

  /// No description provided for @cardDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل البطاقة'**
  String get cardDetails;

  /// No description provided for @defaultCard.
  ///
  /// In ar, this message translates to:
  /// **'البطاقة الافتراضية'**
  String get defaultCard;

  /// No description provided for @editCard.
  ///
  /// In ar, this message translates to:
  /// **'تعديل البطاقة'**
  String get editCard;

  /// No description provided for @deleteCard.
  ///
  /// In ar, this message translates to:
  /// **'حذف البطاقة'**
  String get deleteCard;

  /// No description provided for @setAsDefault.
  ///
  /// In ar, this message translates to:
  /// **'تعيين كافتراضي'**
  String get setAsDefault;

  /// No description provided for @paymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get paymentMethod;

  /// No description provided for @addPaymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'إضافة طريقة دفع'**
  String get addPaymentMethod;

  /// No description provided for @creditDebitCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة ائتمان/خصم'**
  String get creditDebitCard;

  /// No description provided for @selectDefaultCurrency.
  ///
  /// In ar, this message translates to:
  /// **'اختر العملة الافتراضية'**
  String get selectDefaultCurrency;

  /// No description provided for @currentCurrency.
  ///
  /// In ar, this message translates to:
  /// **'العملة الحالية'**
  String get currentCurrency;

  /// No description provided for @availableCurrencies.
  ///
  /// In ar, this message translates to:
  /// **'العملات المتاحة'**
  String get availableCurrencies;

  /// No description provided for @syrianPound.
  ///
  /// In ar, this message translates to:
  /// **'الليرة السورية'**
  String get syrianPound;

  /// No description provided for @turkishLira.
  ///
  /// In ar, this message translates to:
  /// **'الليرة التركية'**
  String get turkishLira;

  /// No description provided for @usDollar.
  ///
  /// In ar, this message translates to:
  /// **'الدولار الأمريكي'**
  String get usDollar;

  /// No description provided for @saudiRiyal.
  ///
  /// In ar, this message translates to:
  /// **'الريال السعودي'**
  String get saudiRiyal;

  /// No description provided for @euro.
  ///
  /// In ar, this message translates to:
  /// **'اليورو'**
  String get euro;

  /// No description provided for @britishPound.
  ///
  /// In ar, this message translates to:
  /// **'الجنيه الإسترليني'**
  String get britishPound;

  /// No description provided for @kuwaitiDinar.
  ///
  /// In ar, this message translates to:
  /// **'الدينار الكويتي'**
  String get kuwaitiDinar;

  /// No description provided for @uaeDirham.
  ///
  /// In ar, this message translates to:
  /// **'الدرهم الإماراتي'**
  String get uaeDirham;

  /// No description provided for @currency.
  ///
  /// In ar, this message translates to:
  /// **'العملة'**
  String get currency;

  /// No description provided for @exchangeRate.
  ///
  /// In ar, this message translates to:
  /// **'سعر الصرف'**
  String get exchangeRate;

  /// No description provided for @updatedRecently.
  ///
  /// In ar, this message translates to:
  /// **'تم التحديث مؤخرًا'**
  String get updatedRecently;

  /// No description provided for @selectCurrency.
  ///
  /// In ar, this message translates to:
  /// **'اختر العملة'**
  String get selectCurrency;

  /// No description provided for @currencySelectedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم اختيار العملة بنجاح'**
  String get currencySelectedSuccessfully;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @currencyDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل العملة'**
  String get currencyDetails;

  /// No description provided for @convertCurrency.
  ///
  /// In ar, this message translates to:
  /// **'تحويل العملة'**
  String get convertCurrency;

  /// No description provided for @currencyConverter.
  ///
  /// In ar, this message translates to:
  /// **'محول العملات'**
  String get currencyConverter;

  /// No description provided for @amount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get amount;

  /// No description provided for @convert.
  ///
  /// In ar, this message translates to:
  /// **'تحويل'**
  String get convert;

  /// No description provided for @conversionResult.
  ///
  /// In ar, this message translates to:
  /// **'نتيجة التحويل'**
  String get conversionResult;

  /// No description provided for @liveRates.
  ///
  /// In ar, this message translates to:
  /// **'الأسعار المباشرة'**
  String get liveRates;

  /// No description provided for @historicalRates.
  ///
  /// In ar, this message translates to:
  /// **'الأسعار التاريخية'**
  String get historicalRates;

  /// No description provided for @favoriteCurrencies.
  ///
  /// In ar, this message translates to:
  /// **'العملات المفضلة'**
  String get favoriteCurrencies;

  /// No description provided for @addToFavorites.
  ///
  /// In ar, this message translates to:
  /// **'إضافة إلى المفضلة'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In ar, this message translates to:
  /// **'إزالة من المفضلة'**
  String get removeFromFavorites;

  /// No description provided for @currencySymbol.
  ///
  /// In ar, this message translates to:
  /// **'رمز العملة'**
  String get currencySymbol;

  /// No description provided for @currencyCode.
  ///
  /// In ar, this message translates to:
  /// **'كود العملة'**
  String get currencyCode;

  /// No description provided for @country.
  ///
  /// In ar, this message translates to:
  /// **'الدولة'**
  String get country;

  /// No description provided for @flag.
  ///
  /// In ar, this message translates to:
  /// **'العلم'**
  String get flag;

  /// No description provided for @nameAZ.
  ///
  /// In ar, this message translates to:
  /// **'الاسم أ-ي'**
  String get nameAZ;

  /// No description provided for @nameZA.
  ///
  /// In ar, this message translates to:
  /// **'الاسم ي-أ'**
  String get nameZA;

  /// No description provided for @searchCurrencies.
  ///
  /// In ar, this message translates to:
  /// **'بحث في العملات'**
  String get searchCurrencies;

  /// No description provided for @noResultsFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على نتائج'**
  String get noResultsFound;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور'**
  String get forgotPassword;

  /// No description provided for @enterEmailForReset.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور'**
  String get enterEmailForReset;

  /// No description provided for @emailAddress.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get emailAddress;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال البريد الإلكتروني'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In ar, this message translates to:
  /// **'صيغة البريد الإلكتروني غير صالحة'**
  String get invalidEmailFormat;

  /// No description provided for @resetPassword.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get resetPassword;

  /// No description provided for @resetLinkSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني'**
  String get resetLinkSent;

  /// No description provided for @backToLogin.
  ///
  /// In ar, this message translates to:
  /// **'العودة لتسجيل الدخول'**
  String get backToLogin;

  /// No description provided for @emailSentSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال البريد الإلكتروني بنجاح!'**
  String get emailSentSuccessfully;

  /// No description provided for @checkYourEmail.
  ///
  /// In ar, this message translates to:
  /// **'يرجى التحقق من صندوق الوارد لبريدك الإلكتروني واتباع التعليمات لإعادة تعيين كلمة المرور.'**
  String get checkYourEmail;

  /// No description provided for @emailSentTo.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال البريد الإلكتروني إلى:'**
  String get emailSentTo;

  /// No description provided for @resendEmail.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال البريد'**
  String get resendEmail;

  /// No description provided for @emailNotReceived.
  ///
  /// In ar, this message translates to:
  /// **'إذا لم تتلق البريد الإلكتروني، تحقق من مجلد البريد العشوائي أو حاول إعادة الإرسال.'**
  String get emailNotReceived;

  /// No description provided for @importantNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة هامة'**
  String get importantNote;

  /// No description provided for @passwordResetInstructions.
  ///
  /// In ar, this message translates to:
  /// **'سيتم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى اتباع التعليمات في البريد الإلكتروني لإنشاء كلمة مرور جديدة. الرابط ساري لمدة 24 ساعة.'**
  String get passwordResetInstructions;

  /// No description provided for @userNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على مستخدم بهذا البريد الإلكتروني'**
  String get userNotFound;

  /// No description provided for @tooManyRequests.
  ///
  /// In ar, this message translates to:
  /// **'لقد قمت بمحاولات كثيرة، يرجى المحاولة مرة أخرى لاحقًا'**
  String get tooManyRequests;

  /// No description provided for @networkError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الاتصال بالشبكة'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير معروف'**
  String get unknownError;

  /// No description provided for @passwordReset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get passwordReset;

  /// No description provided for @securityVerification.
  ///
  /// In ar, this message translates to:
  /// **'التحقق الأمني'**
  String get securityVerification;

  /// No description provided for @enterVerificationCode.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز التحقق'**
  String get enterVerificationCode;

  /// No description provided for @verify.
  ///
  /// In ar, this message translates to:
  /// **'تحقق'**
  String get verify;

  /// No description provided for @codeExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية الرمز'**
  String get codeExpired;

  /// No description provided for @requestNewCode.
  ///
  /// In ar, this message translates to:
  /// **'طلب رمز جديد'**
  String get requestNewCode;

  /// No description provided for @codeSentTo.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الرمز إلى'**
  String get codeSentTo;

  /// No description provided for @resetComplete.
  ///
  /// In ar, this message translates to:
  /// **'اكتمل إعادة التعيين'**
  String get resetComplete;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير كلمة المرور بنجاح'**
  String get passwordChangedSuccessfully;

  /// No description provided for @createNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء كلمة مرور جديدة'**
  String get createNewPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور الجديدة'**
  String get confirmNewPassword;

  /// No description provided for @passwordsMustMatch.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تتطابق كلمات المرور'**
  String get passwordsMustMatch;

  /// No description provided for @passwordRequirements.
  ///
  /// In ar, this message translates to:
  /// **'متطلبات كلمة المرور'**
  String get passwordRequirements;

  /// No description provided for @passwordRequirementsText.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل، وتشمل حروف كبيرة وصغيرة وأرقام.'**
  String get passwordRequirementsText;

  /// No description provided for @resetSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت إعادة التعيين بنجاح'**
  String get resetSuccess;

  /// No description provided for @youCanNowLogin.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة'**
  String get youCanNowLogin;

  /// No description provided for @selectPreferredLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اختر لغتك المفضلة'**
  String get selectPreferredLanguage;

  /// No description provided for @currentLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة الحالية'**
  String get currentLanguage;

  /// No description provided for @availableLanguages.
  ///
  /// In ar, this message translates to:
  /// **'اللغات المتاحة'**
  String get availableLanguages;

  /// No description provided for @languageChangedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير اللغة بنجاح'**
  String get languageChangedSuccessfully;

  /// No description provided for @languageInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات اللغة'**
  String get languageInfo;

  /// No description provided for @languageSelectionInfo.
  ///
  /// In ar, this message translates to:
  /// **'سيتم تغيير اللغة في جميع أنحاء التطبيق. إذا كنت بحاجة إلى مساعدة، يمكنك العودة إلى اللغة السابقة في أي وقت.'**
  String get languageSelectionInfo;

  /// No description provided for @changeLanguage.
  ///
  /// In ar, this message translates to:
  /// **'تغيير اللغة'**
  String get changeLanguage;

  /// No description provided for @languageSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات اللغة'**
  String get languageSettings;

  /// No description provided for @appLanguage.
  ///
  /// In ar, this message translates to:
  /// **'لغة التطبيق'**
  String get appLanguage;

  /// No description provided for @systemLanguage.
  ///
  /// In ar, this message translates to:
  /// **'لغة النظام'**
  String get systemLanguage;

  /// No description provided for @followSystem.
  ///
  /// In ar, this message translates to:
  /// **'اتباع لغة النظام'**
  String get followSystem;

  /// No description provided for @restartRequired.
  ///
  /// In ar, this message translates to:
  /// **'يتطلب إعادة التشغيل'**
  String get restartRequired;

  /// No description provided for @restartAppForChanges.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إعادة تشغيل التطبيق لتطبيق تغييرات اللغة'**
  String get restartAppForChanges;

  /// No description provided for @defaultLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة الافتراضية'**
  String get defaultLanguage;

  /// No description provided for @addLanguage.
  ///
  /// In ar, this message translates to:
  /// **'إضافة لغة'**
  String get addLanguage;

  /// No description provided for @removeLanguage.
  ///
  /// In ar, this message translates to:
  /// **'إزالة لغة'**
  String get removeLanguage;

  /// No description provided for @editLanguage.
  ///
  /// In ar, this message translates to:
  /// **'تعديل اللغة'**
  String get editLanguage;

  /// No description provided for @languagePack.
  ///
  /// In ar, this message translates to:
  /// **'حزمة اللغة'**
  String get languagePack;

  /// No description provided for @downloadLanguage.
  ///
  /// In ar, this message translates to:
  /// **'تحميل اللغة'**
  String get downloadLanguage;

  /// No description provided for @languageUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث اللغة'**
  String get languageUpdated;

  /// No description provided for @translation.
  ///
  /// In ar, this message translates to:
  /// **'الترجمة'**
  String get translation;

  /// No description provided for @translator.
  ///
  /// In ar, this message translates to:
  /// **'المترجم'**
  String get translator;

  /// No description provided for @contributeTranslation.
  ///
  /// In ar, this message translates to:
  /// **'المساهمة في الترجمة'**
  String get contributeTranslation;

  /// No description provided for @reportTranslationIssue.
  ///
  /// In ar, this message translates to:
  /// **'الإبلاغ عن مشكلة في الترجمة'**
  String get reportTranslationIssue;

  /// No description provided for @languageCommunity.
  ///
  /// In ar, this message translates to:
  /// **'مجتمع اللغة'**
  String get languageCommunity;

  /// No description provided for @helpTranslate.
  ///
  /// In ar, this message translates to:
  /// **'ساعدنا في الترجمة'**
  String get helpTranslate;

  /// No description provided for @languageSupport.
  ///
  /// In ar, this message translates to:
  /// **'دعم اللغة'**
  String get languageSupport;

  /// No description provided for @rtlSupport.
  ///
  /// In ar, this message translates to:
  /// **'دعم النصوص من اليمين لليسار'**
  String get rtlSupport;

  /// No description provided for @ltrSupport.
  ///
  /// In ar, this message translates to:
  /// **'دعم النصوص من اليسار لليمين'**
  String get ltrSupport;

  /// No description provided for @textDirection.
  ///
  /// In ar, this message translates to:
  /// **'اتجاه النص'**
  String get textDirection;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'بعد'**
  String get next;

  /// No description provided for @splashText.
  ///
  /// In ar, this message translates to:
  /// **'أسهل وأسرع طريقة\n لحجز تذاكرك ... مع حجزلي!'**
  String get splashText;

  /// No description provided for @oneWay.
  ///
  /// In ar, this message translates to:
  /// **'ذهاب فقط'**
  String get oneWay;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @firstName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الأول'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الأب + اسم العائلة'**
  String get lastName;

  /// No description provided for @enterFirstName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسمك الأول'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الأب والعائلة'**
  String get enterLastName;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumber;

  /// No description provided for @enterPhone.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الهاتف'**
  String get enterPhone;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @signUp.
  ///
  /// In ar, this message translates to:
  /// **'التسجيل'**
  String get signUp;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ الرجاء ملء جميع الحقول المطلوبة'**
  String get pleaseFillAllFields;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'✅ تم إنشاء حسابك بنجاح'**
  String get accountCreatedSuccessfully;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ هذا البريد الإلكتروني مسجل مسبقاً'**
  String get emailAlreadyRegistered;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ رقم الهاتف هذا مسجل مسبقاً'**
  String get phoneAlreadyRegistered;

  /// No description provided for @accountNotRegistered.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ هذا الحساب لم يتم التسجيل به من قبل'**
  String get accountNotRegistered;

  /// No description provided for @wrongPassword.
  ///
  /// In ar, this message translates to:
  /// **'❌ كلمة المرور التي أدخلتها خاطئة، تأكد من كلمة المرور'**
  String get wrongPassword;

  /// No description provided for @myAccount.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get myAccount;

  /// No description provided for @myTickets.
  ///
  /// In ar, this message translates to:
  /// **'تذاكري'**
  String get myTickets;

  /// No description provided for @favorites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get favorites;

  /// No description provided for @whoWeAre.
  ///
  /// In ar, this message translates to:
  /// **'من نحن'**
  String get whoWeAre;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @ticketsPagePlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'صفحة التذاكر'**
  String get ticketsPagePlaceholder;

  /// No description provided for @favoritesPagePlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'صفحة المفضلة'**
  String get favoritesPagePlaceholder;

  /// No description provided for @emailVerificationPending.
  ///
  /// In ar, this message translates to:
  /// **'انتظار التحقق من البريد'**
  String get emailVerificationPending;

  /// No description provided for @verificationEmailSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رابط التفعيل إلى بريدك الإلكتروني'**
  String get verificationEmailSent;

  /// No description provided for @verifyEmail.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل البريد الإلكتروني'**
  String get verifyEmail;

  /// No description provided for @resendVerification.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال رابط التفعيل'**
  String get resendVerification;

  /// No description provided for @checkVerification.
  ///
  /// In ar, this message translates to:
  /// **'تم التفعيل'**
  String get checkVerification;

  /// No description provided for @emailNotVerified.
  ///
  /// In ar, this message translates to:
  /// **'⚠️ بريدك الإلكتروني غير مفعل. يرجى تفعيله أولاً.'**
  String get emailNotVerified;

  /// No description provided for @verifyAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الحساب'**
  String get verifyAccountTitle;

  /// No description provided for @verificationInstructions.
  ///
  /// In ar, this message translates to:
  /// **'يرجى فتح بريدك الإلكتروني والضغط على رابط التفعيل، ثم العودة هنا واضغط على \"تم التفعيل\".'**
  String get verificationInstructions;

  /// No description provided for @checkVerificationButton.
  ///
  /// In ar, this message translates to:
  /// **'تم التفعيل'**
  String get checkVerificationButton;

  /// No description provided for @resendLinkButton.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال رابط التفعيل'**
  String get resendLinkButton;

  /// No description provided for @signOutButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get signOutButton;

  /// No description provided for @resendLinkSuccess.
  ///
  /// In ar, this message translates to:
  /// **'✅ تم إعادة إرسال رابط التحقق'**
  String get resendLinkSuccess;

  /// No description provided for @resendLinkFailed.
  ///
  /// In ar, this message translates to:
  /// **'❌ فشل إعادة الإرسال'**
  String get resendLinkFailed;

  /// No description provided for @verificationNotComplete.
  ///
  /// In ar, this message translates to:
  /// **'❌ لم يتم التحقق بعد، حاول مرة أخرى'**
  String get verificationNotComplete;

  /// No description provided for @checkSpamFolder.
  ///
  /// In ar, this message translates to:
  /// **'إذا لم تجد الرسالة في صندوق الوارد، يرجى التحقق من مجلد \"الرسائل غير المرغوب فيها\" (Spam/Junk) أو الأرشيف.'**
  String get checkSpamFolder;

  /// No description provided for @personalInformation.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get personalInformation;

  /// No description provided for @paymentInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الدفع'**
  String get paymentInformation;

  /// No description provided for @travelInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات قيد السفر'**
  String get travelInformation;

  /// No description provided for @change.
  ///
  /// In ar, this message translates to:
  /// **'التغير'**
  String get change;

  /// No description provided for @tryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get tryAgain;

  /// No description provided for @currentPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الحالية'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور الحالية'**
  String get enterCurrentPassword;

  /// No description provided for @newPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور الجديدة'**
  String get enterNewPassword;

  /// No description provided for @repeatNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور الجديدة مرة أخرى'**
  String get repeatNewPassword;

  /// No description provided for @updatePassword.
  ///
  /// In ar, this message translates to:
  /// **'تحديث كلمة المرور'**
  String get updatePassword;

  /// No description provided for @requiresRecentLogin.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تسجيل الدخول مرة أخرى قبل تغيير كلمة المرور'**
  String get requiresRecentLogin;

  /// No description provided for @ourVision.
  ///
  /// In ar, this message translates to:
  /// **'رؤيتنا'**
  String get ourVision;

  /// No description provided for @ourMission.
  ///
  /// In ar, this message translates to:
  /// **'رسالتنا'**
  String get ourMission;

  /// No description provided for @aboutUsDescription.
  ///
  /// In ar, this message translates to:
  /// **'نحن فريق متخصص يهدف إلى تقديم أفضل الخدمات لعملائنا، من خلال الجمع بين الخبرة، الابتكار، والالتزام بالجودة. نسعى دائمًا لتوفير حلول عملية وموثوقة تناسب احتياجاتكم اليومية وتسهم في تحسين حياتكم.'**
  String get aboutUsDescription;

  /// No description provided for @visionDescription.
  ///
  /// In ar, this message translates to:
  /// **'أن نكون الخيار الأول والمفضل لجميع عملائنا من خلال بناء الثقة وتقديم قيمة حقيقية.'**
  String get visionDescription;

  /// No description provided for @missionDescription.
  ///
  /// In ar, this message translates to:
  /// **'العمل بجد وإبداع لتقديم منتجات وخدمات عالية الجودة تجعل حياتكم أسهل وأكثر راحة.'**
  String get missionDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
