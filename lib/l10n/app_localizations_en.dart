// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SmartFleet';

  @override
  String get tagline => 'Move smart. Manage better.';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get malayalam => 'മലയാളം';

  @override
  String get english => 'English';

  @override
  String get driverRole => 'I am a Driver';

  @override
  String get ownerRole => 'I am an Owner';

  @override
  String get driverSelectTitle => 'Select your name to log in';

  @override
  String get demoLoginNotice => '(Demo login)';

  @override
  String get tabTrip => 'Trip';

  @override
  String get tabEarnings => 'Earnings';

  @override
  String get tabProfile => 'Profile';

  @override
  String get tabHome => 'Home';

  @override
  String get tabTrips => 'Trips';

  @override
  String get tabTrucks => 'Trucks';

  @override
  String get tabDrivers => 'Driver';

  @override
  String get tabSettings => 'Settings';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusDelivered => 'Done';

  @override
  String get statusProblem => 'Problem';

  @override
  String get statusInWorkshop => 'In workshop';

  @override
  String get currentTrip => 'Current Trip';

  @override
  String get noTripTitle => 'No trip now';

  @override
  String get noTripSubtitle => 'Wait for the office to send one.';

  @override
  String get cargo => 'Cargo';

  @override
  String get weight => 'Weight';

  @override
  String get distance => 'Distance';

  @override
  String get remaining => 'Remaining';

  @override
  String get eta => 'Estimated arrival (ETA)';

  @override
  String kmDoneOfTotal(Object doneKm, Object totalKm) {
    return '$doneKm of $totalKm km done';
  }

  @override
  String kmRemaining(Object km) {
    return '$km km remaining';
  }

  @override
  String hoursMinutesRemaining(Object hours, Object minutes) {
    return '${hours}h ${minutes}m remaining';
  }

  @override
  String get btnAcceptTrip => 'Accept trip';

  @override
  String get btnRejectTrip => 'Reject';

  @override
  String get btnStartTrip => 'Start trip';

  @override
  String get btnReached => 'I have reached';

  @override
  String get btnUploadProof => 'Upload delivery proof';

  @override
  String get btnShowRoute => 'Show route in Google Maps';

  @override
  String get btnCallOffice => 'Call office';

  @override
  String get btnHelpBreakdown => 'Help / Breakdown';

  @override
  String get confirmBreakdownTitle => 'Report Breakdown?';

  @override
  String get confirmBreakdownMessage =>
      'This will alert the fleet office that your truck needs immediate help.';

  @override
  String get btnConfirm => 'Yes, Send Alert';

  @override
  String get btnCancel => 'Cancel';

  @override
  String proofStepIndicator(Object current) {
    return 'Step $current of 3';
  }

  @override
  String get proofStep1Title => 'Enter 4-digit code from receiver';

  @override
  String get proofStep1Hint => '4-digit code';

  @override
  String get proofStep2Title => 'Take photo of unloaded cargo';

  @override
  String get proofStep2TakePhoto => 'Take photo';

  @override
  String get proofStep2PhotoTaken => 'Photo taken successfully';

  @override
  String get proofStep3Title => 'Receiver signature';

  @override
  String get proofStep3SignHint => 'Sign inside the box';

  @override
  String get proofStep3Clear => 'Clear';

  @override
  String get btnNext => 'Next';

  @override
  String get btnBack => 'Back';

  @override
  String get btnSubmitProof => 'Confirm & Complete';

  @override
  String get proofCompletedToast => 'Delivery proof submitted successfully';

  @override
  String get thisWeekEarnings => 'This week allowance';

  @override
  String nextPayoutDate(Object date) {
    return 'Next payout: $date';
  }

  @override
  String get recentTrips => 'Recent trips';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusPending => 'Pending';

  @override
  String get driverLicence => 'Driving Licence';

  @override
  String licenceValidity(Object date) {
    return 'Valid till: $date';
  }

  @override
  String get assignedTruck => 'Assigned Truck';

  @override
  String get driverExperience => 'Experience';

  @override
  String years(Object count) {
    return '$count years';
  }

  @override
  String get btnChangeLanguage => 'Change Language';

  @override
  String get btnLogout => 'Switch User / Logout';

  @override
  String get runningTrips => 'Running trips';

  @override
  String get freeTrucks => 'Free trucks';

  @override
  String get deliveredThisMonth => 'Delivered this month';

  @override
  String get needsAttention => 'Needs attention';

  @override
  String get btnNewTrip => 'New trip';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get searchTripsHint => 'Search trips';

  @override
  String get filterAll => 'All';

  @override
  String get filterRunning => 'Running';

  @override
  String get filterWaiting => 'Waiting';

  @override
  String get filterDelivered => 'Done';

  @override
  String get btnCallDriver => 'Call driver';

  @override
  String get btnShareWhatsApp => 'Share on WhatsApp';

  @override
  String get stepAssigned => 'Assigned';

  @override
  String get stepLoaded => 'Loaded';

  @override
  String get stepOnTheWay => 'On the way';

  @override
  String get stepDelivered => 'Delivered';

  @override
  String get newTripTitle => 'Create New Trip';

  @override
  String get fromPlace => 'From (Origin)';

  @override
  String get toPlace => 'To (Destination)';

  @override
  String get selectPlace => 'Select place';

  @override
  String get cargoTitleLabel => 'Cargo description';

  @override
  String get cargoWeightLabel => 'Weight (in Tons)';

  @override
  String get assignDriverLabel => 'Driver & Truck';

  @override
  String get selectDriverHint => 'Select available driver';

  @override
  String get btnSendToDriver => 'Send to driver';

  @override
  String get errFromRequired => 'Please select starting place';

  @override
  String get errToRequired => 'Please select destination';

  @override
  String get errSamePlace => 'From and To cannot be the same place';

  @override
  String get errCargoRequired => 'Please enter cargo description';

  @override
  String get errWeightRequired => 'Please enter valid weight in tons';

  @override
  String get errDriverRequired => 'Please assign an available driver';

  @override
  String get confirmTripTitle => 'Confirm Trip Details';

  @override
  String get confirmTripSubtitle => 'Please check before sending to driver:';

  @override
  String get btnConfirmAndSend => 'Confirm & Send';

  @override
  String get truckCapacity => 'Capacity';

  @override
  String get truckStatus => 'Status';

  @override
  String get driversTitle => 'Drivers';

  @override
  String get btnCall => 'Call';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get textSize => 'Text Size';

  @override
  String get textNormal => 'Normal';

  @override
  String get textLarge => 'Large';

  @override
  String get textExtraLarge => 'Extra Large';

  @override
  String get appAbout => 'About SmartFleet';

  @override
  String get appVersion => 'Version 2.0.0';

  @override
  String get statusAvailable => 'Available';
}
