import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('ml'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SmartFleet'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Move smart. Manage better.'**
  String get tagline;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @malayalam.
  ///
  /// In en, this message translates to:
  /// **'മലയാളം'**
  String get malayalam;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @driverRole.
  ///
  /// In en, this message translates to:
  /// **'I am a Driver'**
  String get driverRole;

  /// No description provided for @ownerRole.
  ///
  /// In en, this message translates to:
  /// **'I am an Owner'**
  String get ownerRole;

  /// No description provided for @driverSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your name to log in'**
  String get driverSelectTitle;

  /// No description provided for @demoLoginNotice.
  ///
  /// In en, this message translates to:
  /// **'(Demo login)'**
  String get demoLoginNotice;

  /// No description provided for @tabTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get tabTrip;

  /// No description provided for @tabEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get tabEarnings;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tabTrips;

  /// No description provided for @tabTrucks.
  ///
  /// In en, this message translates to:
  /// **'Trucks'**
  String get tabTrucks;

  /// No description provided for @tabDrivers.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get tabDrivers;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get statusRunning;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDelivered;

  /// No description provided for @statusProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get statusProblem;

  /// No description provided for @statusInWorkshop.
  ///
  /// In en, this message translates to:
  /// **'In workshop'**
  String get statusInWorkshop;

  /// No description provided for @currentTrip.
  ///
  /// In en, this message translates to:
  /// **'Current Trip'**
  String get currentTrip;

  /// No description provided for @noTripTitle.
  ///
  /// In en, this message translates to:
  /// **'No trip now'**
  String get noTripTitle;

  /// No description provided for @noTripSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wait for the office to send one.'**
  String get noTripSubtitle;

  /// No description provided for @cargo.
  ///
  /// In en, this message translates to:
  /// **'Cargo'**
  String get cargo;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @eta.
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival (ETA)'**
  String get eta;

  /// No description provided for @kmDoneOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{doneKm} of {totalKm} km done'**
  String kmDoneOfTotal(Object doneKm, Object totalKm);

  /// No description provided for @kmRemaining.
  ///
  /// In en, this message translates to:
  /// **'{km} km remaining'**
  String kmRemaining(Object km);

  /// No description provided for @hoursMinutesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m remaining'**
  String hoursMinutesRemaining(Object hours, Object minutes);

  /// No description provided for @btnAcceptTrip.
  ///
  /// In en, this message translates to:
  /// **'Accept trip'**
  String get btnAcceptTrip;

  /// No description provided for @btnRejectTrip.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get btnRejectTrip;

  /// No description provided for @btnStartTrip.
  ///
  /// In en, this message translates to:
  /// **'Start trip'**
  String get btnStartTrip;

  /// No description provided for @btnReached.
  ///
  /// In en, this message translates to:
  /// **'I have reached'**
  String get btnReached;

  /// No description provided for @btnUploadProof.
  ///
  /// In en, this message translates to:
  /// **'Upload delivery proof'**
  String get btnUploadProof;

  /// No description provided for @btnShowRoute.
  ///
  /// In en, this message translates to:
  /// **'Show route in Google Maps'**
  String get btnShowRoute;

  /// No description provided for @btnCallOffice.
  ///
  /// In en, this message translates to:
  /// **'Call office'**
  String get btnCallOffice;

  /// No description provided for @btnHelpBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Help / Breakdown'**
  String get btnHelpBreakdown;

  /// No description provided for @confirmBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Breakdown?'**
  String get confirmBreakdownTitle;

  /// No description provided for @confirmBreakdownMessage.
  ///
  /// In en, this message translates to:
  /// **'This will alert the fleet office that your truck needs immediate help.'**
  String get confirmBreakdownMessage;

  /// No description provided for @btnConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Send Alert'**
  String get btnConfirm;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @proofStepIndicator.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of 3'**
  String proofStepIndicator(Object current);

  /// No description provided for @proofStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-digit code from receiver'**
  String get proofStep1Title;

  /// No description provided for @proofStep1Hint.
  ///
  /// In en, this message translates to:
  /// **'4-digit code'**
  String get proofStep1Hint;

  /// No description provided for @proofStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Take photo of unloaded cargo'**
  String get proofStep2Title;

  /// No description provided for @proofStep2TakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get proofStep2TakePhoto;

  /// No description provided for @proofStep2PhotoTaken.
  ///
  /// In en, this message translates to:
  /// **'Photo taken successfully'**
  String get proofStep2PhotoTaken;

  /// No description provided for @proofStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Receiver signature'**
  String get proofStep3Title;

  /// No description provided for @proofStep3SignHint.
  ///
  /// In en, this message translates to:
  /// **'Sign inside the box'**
  String get proofStep3SignHint;

  /// No description provided for @proofStep3Clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get proofStep3Clear;

  /// No description provided for @btnNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get btnNext;

  /// No description provided for @btnBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get btnBack;

  /// No description provided for @btnSubmitProof.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Complete'**
  String get btnSubmitProof;

  /// No description provided for @proofCompletedToast.
  ///
  /// In en, this message translates to:
  /// **'Delivery proof submitted successfully'**
  String get proofCompletedToast;

  /// No description provided for @thisWeekEarnings.
  ///
  /// In en, this message translates to:
  /// **'This week allowance'**
  String get thisWeekEarnings;

  /// No description provided for @nextPayoutDate.
  ///
  /// In en, this message translates to:
  /// **'Next payout: {date}'**
  String nextPayoutDate(Object date);

  /// No description provided for @recentTrips.
  ///
  /// In en, this message translates to:
  /// **'Recent trips'**
  String get recentTrips;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @driverLicence.
  ///
  /// In en, this message translates to:
  /// **'Driving Licence'**
  String get driverLicence;

  /// No description provided for @licenceValidity.
  ///
  /// In en, this message translates to:
  /// **'Valid till: {date}'**
  String licenceValidity(Object date);

  /// No description provided for @assignedTruck.
  ///
  /// In en, this message translates to:
  /// **'Assigned Truck'**
  String get assignedTruck;

  /// No description provided for @driverExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get driverExperience;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'{count} years'**
  String years(Object count);

  /// No description provided for @btnChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get btnChangeLanguage;

  /// No description provided for @btnLogout.
  ///
  /// In en, this message translates to:
  /// **'Switch User / Logout'**
  String get btnLogout;

  /// No description provided for @runningTrips.
  ///
  /// In en, this message translates to:
  /// **'Running trips'**
  String get runningTrips;

  /// No description provided for @freeTrucks.
  ///
  /// In en, this message translates to:
  /// **'Free trucks'**
  String get freeTrucks;

  /// No description provided for @deliveredThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Delivered this month'**
  String get deliveredThisMonth;

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get needsAttention;

  /// No description provided for @btnNewTrip.
  ///
  /// In en, this message translates to:
  /// **'+ New trip'**
  String get btnNewTrip;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @searchTripsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by trip id, place or driver...'**
  String get searchTripsHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get filterRunning;

  /// No description provided for @filterWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get filterWaiting;

  /// No description provided for @filterDelivered.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get filterDelivered;

  /// No description provided for @btnCallDriver.
  ///
  /// In en, this message translates to:
  /// **'Call driver'**
  String get btnCallDriver;

  /// No description provided for @btnShareWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get btnShareWhatsApp;

  /// No description provided for @stepAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get stepAssigned;

  /// No description provided for @stepLoaded.
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get stepLoaded;

  /// No description provided for @stepOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get stepOnTheWay;

  /// No description provided for @stepDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get stepDelivered;

  /// No description provided for @newTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Trip'**
  String get newTripTitle;

  /// No description provided for @fromPlace.
  ///
  /// In en, this message translates to:
  /// **'From (Origin)'**
  String get fromPlace;

  /// No description provided for @toPlace.
  ///
  /// In en, this message translates to:
  /// **'To (Destination)'**
  String get toPlace;

  /// No description provided for @selectPlace.
  ///
  /// In en, this message translates to:
  /// **'Select place'**
  String get selectPlace;

  /// No description provided for @cargoTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Cargo description'**
  String get cargoTitleLabel;

  /// No description provided for @cargoWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (in Tons)'**
  String get cargoWeightLabel;

  /// No description provided for @assignDriverLabel.
  ///
  /// In en, this message translates to:
  /// **'Driver & Truck'**
  String get assignDriverLabel;

  /// No description provided for @selectDriverHint.
  ///
  /// In en, this message translates to:
  /// **'Select available driver'**
  String get selectDriverHint;

  /// No description provided for @btnSendToDriver.
  ///
  /// In en, this message translates to:
  /// **'Send to driver'**
  String get btnSendToDriver;

  /// No description provided for @errFromRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select starting place'**
  String get errFromRequired;

  /// No description provided for @errToRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select destination'**
  String get errToRequired;

  /// No description provided for @errSamePlace.
  ///
  /// In en, this message translates to:
  /// **'From and To cannot be the same place'**
  String get errSamePlace;

  /// No description provided for @errCargoRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter cargo description'**
  String get errCargoRequired;

  /// No description provided for @errWeightRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid weight in tons'**
  String get errWeightRequired;

  /// No description provided for @errDriverRequired.
  ///
  /// In en, this message translates to:
  /// **'Please assign an available driver'**
  String get errDriverRequired;

  /// No description provided for @confirmTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Trip Details'**
  String get confirmTripTitle;

  /// No description provided for @confirmTripSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check before sending to driver:'**
  String get confirmTripSubtitle;

  /// No description provided for @btnConfirmAndSend.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Send'**
  String get btnConfirmAndSend;

  /// No description provided for @truckCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get truckCapacity;

  /// No description provided for @truckStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get truckStatus;

  /// No description provided for @driversTitle.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get driversTitle;

  /// No description provided for @btnCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get btnCall;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// No description provided for @textNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get textNormal;

  /// No description provided for @textLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get textLarge;

  /// No description provided for @textExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get textExtraLarge;

  /// No description provided for @appAbout.
  ///
  /// In en, this message translates to:
  /// **'About SmartFleet'**
  String get appAbout;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 2.0.0'**
  String get appVersion;
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
      <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
