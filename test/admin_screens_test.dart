import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/screens/admin/admin_main_screen.dart';
import 'package:smartfleet_flutter/screens/admin/tabs/admin_home_tab.dart';
import 'package:smartfleet_flutter/screens/admin/tabs/admin_trips_tab.dart';
import 'package:smartfleet_flutter/screens/admin/tabs/admin_fleet_tab.dart';
import 'package:smartfleet_flutter/screens/admin/tabs/admin_drivers_tab.dart';
import 'package:smartfleet_flutter/screens/admin/trip_detail_screen.dart';
import 'package:smartfleet_flutter/screens/admin/create_trip_screen.dart';

Widget _buildTestApp({
  required Widget child,
  required Locale locale,
  required double textScale,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    locale: locale,
    supportedLocales: const [Locale('ml'), Locale('en')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(360, 800),
        textScaler: TextScaler.linear(textScale),
        padding: const EdgeInsets.only(top: 24, bottom: 16),
      ),
      child: child,
    ),
  );
}

void main() {
  setUpAll(() async {
    await LocalFleetRepository.instance.getTrips();
  });

  group('Admin App - 360dp Zero-Overflow & Multi-Scale Tests', () {
    final configs = [
      {'lang': 'ml', 'scale': 1.0, 'desc': 'Malayalam 1.0x'},
      {'lang': 'ml', 'scale': 1.5, 'desc': 'Malayalam 1.5x (Large Text)'},
      {'lang': 'en', 'scale': 1.0, 'desc': 'English 1.0x'},
      {'lang': 'en', 'scale': 1.5, 'desc': 'English 1.5x (Large Text)'},
    ];

    for (final cfg in configs) {
      final lang = cfg['lang'] as String;
      final scale = cfg['scale'] as double;
      final desc = cfg['desc'] as String;
      final loc = Locale(lang);

      testWidgets('Admin Main Screen - $desc (360dp)', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _buildTestApp(
            child: const AdminMainScreen(),
            locale: loc,
            textScale: scale,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('Admin Home Tab (3 Big Cards & Needs Attention) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _buildTestApp(
            child: Scaffold(
              body: AdminHomeTab(
                onNewTrip: () {},
                onViewAllTrips: () {},
              ),
            ),
            locale: loc,
            textScale: scale,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('Admin Trips Tab (Search, Filters, Cards) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: AdminTripsTab()),
            locale: loc,
            textScale: scale,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('Trip Detail Screen (Route, Vertical Timeline, WhatsApp) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _buildTestApp(
            child: const TripDetailScreen(tripId: 'TR-1025'),
            locale: loc,
            textScale: scale,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('Create Trip Screen (4 Pickers & Confirmation) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _buildTestApp(
            child: const CreateTripScreen(),
            locale: loc,
            textScale: scale,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('Admin Fleet Tab (Trucks & Statuses) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: AdminFleetTab()),
            locale: loc,
            textScale: scale,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('Admin Drivers Tab (Directory & Direct Call) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: AdminDriversTab()),
            locale: loc,
            textScale: scale,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });
    }
  });
}
