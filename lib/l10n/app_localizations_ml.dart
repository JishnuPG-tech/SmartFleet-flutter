// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'സ്മാർട്ട്ഫ്ലീറ്റ്';

  @override
  String get tagline => 'മികച്ച രീതിയിൽ ലോറികൾ നിയന്ത്രിക്കാം';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get malayalam => 'മലയാളം';

  @override
  String get english => 'English';

  @override
  String get driverRole => 'ഞാൻ ഡ്രൈവറാണ്';

  @override
  String get ownerRole => 'ഞാൻ ഉടമയാണ്';

  @override
  String get driverSelectTitle => 'ലോഗിൻ ചെയ്യാൻ നിങ്ങളുടെ പേര് തിരഞ്ഞെടുക്കുക';

  @override
  String get demoLoginNotice => '(ഡെമോ ലോഗിൻ)';

  @override
  String get tabTrip => 'ട്രിപ്പ്';

  @override
  String get tabEarnings => 'വരുമാനം';

  @override
  String get tabProfile => 'പ്രൊഫൈൽ';

  @override
  String get tabHome => 'ഹോം';

  @override
  String get tabTrips => 'ട്രിപ്പുകൾ';

  @override
  String get tabTrucks => 'ലോറികൾ';

  @override
  String get tabDrivers => 'ഡ്രൈവർ';

  @override
  String get tabSettings => 'സെറ്റിംഗ്സ്';

  @override
  String get statusWaiting => 'കാത്തിരിക്കുന്നു';

  @override
  String get statusAccepted => 'സ്വീകരിച്ചു';

  @override
  String get statusRunning => 'ഓടുന്നു';

  @override
  String get statusDelivered => 'പൂർത്തിയായി';

  @override
  String get statusProblem => 'പ്രശ്നം';

  @override
  String get statusInWorkshop => 'വർക്ക്‌ഷോപ്പിൽ';

  @override
  String get currentTrip => 'ഇപ്പോഴത്തെ ട്രിപ്പ്';

  @override
  String get noTripTitle => 'ഇപ്പോൾ ട്രിപ്പുകൾ ഒന്നുമില്ല';

  @override
  String get noTripSubtitle => 'ഓഫീസിൽ നിന്ന് അയക്കുന്നത് വരെ കാത്തിരിക്കുക.';

  @override
  String get cargo => 'സാധനം';

  @override
  String get weight => 'ഭാരം';

  @override
  String get distance => 'ദൂരം';

  @override
  String get remaining => 'ബാക്കി';

  @override
  String get eta => 'എത്തിച്ചേരുന്ന സമയം (ETA)';

  @override
  String kmDoneOfTotal(Object doneKm, Object totalKm) {
    return '$totalKm കി.മീറ്ററിൽ $doneKm കി.മീറ്റർ കഴിഞ്ഞു';
  }

  @override
  String kmRemaining(Object km) {
    return '$km കി.മീറ്റർ ബാക്കി';
  }

  @override
  String hoursMinutesRemaining(Object hours, Object minutes) {
    return '$hours മണിക്കൂർ $minutes മിനിറ്റ് ബാക്കി';
  }

  @override
  String get btnAcceptTrip => 'ട്രിപ്പ് സ്വീകരിക്കുക';

  @override
  String get btnRejectTrip => 'നിരസിക്കുക';

  @override
  String get btnStartTrip => 'യാത്ര തുടങ്ങുക';

  @override
  String get btnReached => 'ഞാൻ എത്തിച്ചേർന്നു';

  @override
  String get btnUploadProof => 'ഡെലിവറി തെളിവ് നൽകുക';

  @override
  String get btnShowRoute => 'റൂട്ട് മാപ്പിൽ കാണുക';

  @override
  String get btnCallOffice => 'ഓഫീസിലേക്ക് വിളിക്കുക';

  @override
  String get btnHelpBreakdown => 'സഹായം / വാഹനം തകരാറിലായി';

  @override
  String get confirmBreakdownTitle => 'തകരാർ അറിയിക്കണോ?';

  @override
  String get confirmBreakdownMessage =>
      'നിങ്ങളുടെ ലോറിക്ക് അടിയന്തര സഹായം വേണമെന്ന് ഓഫീസിൽ അറിയിക്കും.';

  @override
  String get btnConfirm => 'അതെ, അറിയിക്കുക';

  @override
  String get btnCancel => 'വേണ്ട';

  @override
  String proofStepIndicator(Object current) {
    return 'ഘട്ടം $current / 3';
  }

  @override
  String get proofStep1Title =>
      'സാധനം വാങ്ങുന്ന ആളിൽ നിന്നുള്ള 4 അക്ക കോഡ് നൽകുക';

  @override
  String get proofStep1Hint => '4 അക്ക കോഡ്';

  @override
  String get proofStep2Title => 'ഇറക്കിയ സാധനങ്ങളുടെ ഫോട്ടോ എടുക്കുക';

  @override
  String get proofStep2TakePhoto => 'ഫോട്ടോ എടുക്കുക';

  @override
  String get proofStep2PhotoTaken => 'ഫോട്ടോ എടുത്തു';

  @override
  String get proofStep3Title => 'സാധനം വാങ്ങിയ ആളുടെ ഒപ്പ്';

  @override
  String get proofStep3SignHint => 'ഇവിടെ ഒപ്പിടുക';

  @override
  String get proofStep3Clear => 'മായ്ക്കുക';

  @override
  String get btnNext => 'അടുത്തത്';

  @override
  String get btnBack => 'പുറകോട്ട്';

  @override
  String get btnSubmitProof => 'ഉറപ്പാക്കി പൂർത്തിയാക്കുക';

  @override
  String get proofCompletedToast => 'ഡെലിവറി തെളിവ് വിജയകരമായി നൽകി';

  @override
  String get thisWeekEarnings => 'ഈ ആഴ്ചയിലെ ബത്ത';

  @override
  String nextPayoutDate(Object date) {
    return 'അടുത്ത പെയ്‌മെന്റ്: $date';
  }

  @override
  String get recentTrips => 'കഴിഞ്ഞ ട്രിപ്പുകൾ';

  @override
  String get statusPaid => 'തന്നു';

  @override
  String get statusPending => 'ലഭിക്കാനുണ്ട്';

  @override
  String get driverLicence => 'ഡ്രൈവിംഗ് ലൈസൻസ്';

  @override
  String licenceValidity(Object date) {
    return 'കാലാവധി: $date';
  }

  @override
  String get assignedTruck => 'തന്നിട്ടുള്ള ലോറി';

  @override
  String get driverExperience => 'പരിചയം';

  @override
  String years(Object count) {
    return '$count വർഷം';
  }

  @override
  String get btnChangeLanguage => 'ഭാഷ മാറ്റുക';

  @override
  String get btnLogout => 'പുറത്തുകടക്കുക';

  @override
  String get runningTrips => 'ഓടുന്ന ട്രിപ്പുകൾ';

  @override
  String get freeTrucks => 'ഒഴിവുള്ള ലോറികൾ';

  @override
  String get deliveredThisMonth => 'ഈ മാസം എത്തിച്ചവ';

  @override
  String get needsAttention => 'ശ്രദ്ധിക്കേണ്ട കാര്യങ്ങൾ';

  @override
  String get btnNewTrip => 'പുതിയ ട്രിപ്പ്';

  @override
  String get greetingMorning => 'സുപ്രഭാതം';

  @override
  String get greetingAfternoon => 'ശുഭദിനം';

  @override
  String get greetingEvening => 'ശുഭസന്ധ്യ';

  @override
  String get searchTripsHint => 'ട്രിപ്പുകൾ തിരയുക';

  @override
  String get filterAll => 'എല്ലാം';

  @override
  String get filterRunning => 'ഓടുന്നു';

  @override
  String get filterWaiting => 'കാത്തിരിക്കുന്നു';

  @override
  String get filterDelivered => 'കഴിഞ്ഞവ';

  @override
  String get btnCallDriver => 'ഡ്രൈവറെ വിളിക്കുക';

  @override
  String get btnShareWhatsApp => 'വാട്സ്ആപ്പിൽ അയക്കുക';

  @override
  String get stepAssigned => 'ഏൽപ്പിച്ചു';

  @override
  String get stepLoaded => 'സാധനം കയറ്റി';

  @override
  String get stepOnTheWay => 'വഴിയിലാണ്';

  @override
  String get stepDelivered => 'എത്തിച്ചു';

  @override
  String get newTripTitle => 'പുതിയ ട്രിപ്പ് തുടങ്ങുക';

  @override
  String get fromPlace => 'എവിടെ നിന്ന്';

  @override
  String get toPlace => 'എങ്ങോട്ട്';

  @override
  String get selectPlace => 'സ്ഥലം തിരഞ്ഞെടുക്കുക';

  @override
  String get cargoTitleLabel => 'സാധനത്തിന്റെ വിവരം';

  @override
  String get cargoWeightLabel => 'ഭാരം (ടൺ)';

  @override
  String get assignDriverLabel => 'ഡ്രൈവറും ലോറിയും';

  @override
  String get selectDriverHint => 'ഒഴിവുള്ള ഡ്രൈവറെ തിരഞ്ഞെടുക്കുക';

  @override
  String get btnSendToDriver => 'ഡ്രൈവർക്ക് അയക്കുക';

  @override
  String get errFromRequired => 'തുടങ്ങുന്ന സ്ഥലം തിരഞ്ഞെടുക്കണം';

  @override
  String get errToRequired => 'പോകേണ്ട സ്ഥലം തിരഞ്ഞെടുക്കണം';

  @override
  String get errSamePlace => 'തുടങ്ങുന്ന സ്ഥലവും പോകേണ്ട സ്ഥലവും ഒന്നാകരുത്';

  @override
  String get errCargoRequired => 'സാധനത്തിന്റെ വിവരം നൽകണം';

  @override
  String get errWeightRequired => 'ശരിയായ ഭാരം ടണ്ണിൽ നൽകണം';

  @override
  String get errDriverRequired => 'ഒരു ഡ്രൈവറെ തിരഞ്ഞെടുക്കണം';

  @override
  String get confirmTripTitle => 'ട്രിപ്പ് വിവരങ്ങൾ ശരിയാണോ?';

  @override
  String get confirmTripSubtitle =>
      'ഡ്രൈവർക്ക് അയക്കുന്നതിന് മുൻപ് ഒത്തുനോക്കുക:';

  @override
  String get btnConfirmAndSend => 'ഉറപ്പിച്ചു അയക്കുക';

  @override
  String get truckCapacity => 'ശേഷി';

  @override
  String get truckStatus => 'നില';

  @override
  String get driversTitle => 'ഡ്രൈവർമാർ';

  @override
  String get btnCall => 'വിളിക്കുക';

  @override
  String get settingsTitle => 'സെറ്റിംഗ്സ്';

  @override
  String get textSize => 'അക്ഷരങ്ങളുടെ വലിപ്പം';

  @override
  String get textNormal => 'സാധാരണ';

  @override
  String get textLarge => 'വലുത്';

  @override
  String get textExtraLarge => 'വളരെ വലുത്';

  @override
  String get appAbout => 'സ്മാർട്ട്ഫ്ലീറ്റിനെക്കുറിച്ച്';

  @override
  String get appVersion => 'പതിപ്പ് 2.0.0';

  @override
  String get statusAvailable => 'ലഭ്യമാണ്';
}
