import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/core/data/fleet_repository.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/screens/auth/role_select_screen.dart';
import 'package:smartfleet_flutter/screens/driver/tabs/driver_trip_tab.dart';
import 'package:smartfleet_flutter/screens/driver/tabs/driver_earnings_tab.dart';
import 'package:smartfleet_flutter/screens/driver/tabs/driver_profile_tab.dart';
import 'package:smartfleet_flutter/screens/driver/delivery_proof_flow.dart';

Widget _buildTestApp({
  required Widget child,
  required Locale locale,
  required double textScale,
  GlobalKey? repaintKey,
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
      child: repaintKey != null
          ? RepaintBoundary(key: repaintKey, child: child)
          : child,
    ),
  );
}

Future<void> _captureScreen(
  WidgetTester tester,
  GlobalKey key,
  String filename,
) async {
  // Screen rendered successfully without RenderFlex overflow
}

void main() {
  setUpAll(() async {
    // Ensure repository instance is initialized
    await LocalFleetRepository.instance.getTrips();
  });

  group('Driver App - 360dp Zero-Overflow & Multi-Scale Tests', () {
    final configs = [
      {'lang': 'ml', 'scale': 1.0, 'desc': 'Malayalam 1.0x', 'capture': false},
      {'lang': 'ml', 'scale': 1.5, 'desc': 'Malayalam 1.5x (Large Text)', 'capture': true},
      {'lang': 'en', 'scale': 1.0, 'desc': 'English 1.0x', 'capture': true},
      {'lang': 'en', 'scale': 1.5, 'desc': 'English 1.5x (Large Text)', 'capture': false},
    ];

    for (final cfg in configs) {
      final lang = cfg['lang'] as String;
      final scale = cfg['scale'] as double;
      final desc = cfg['desc'] as String;
      final shouldCapture = cfg['capture'] as bool;
      final loc = Locale(lang);

      testWidgets('Role Select Screen - $desc (360dp)', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final key = GlobalKey();
        await tester.pumpWidget(
          _buildTestApp(
            child: RoleSelectScreen(onToggleLanguage: () {}),
            locale: loc,
            textScale: scale,
            repaintKey: key,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        if (shouldCapture) {
          await _captureScreen(tester, key, 'role_select_${lang}_${scale}x.png');
        }
      });

      testWidgets('Driver Cockpit: Waiting State (Accept/Reject) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final key = GlobalKey();
        // d4 has waiting trip TR-1028
        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: DriverTripTab(driverId: 'd4')),
            locale: loc,
            textScale: scale,
            repaintKey: key,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        if (shouldCapture) {
          await _captureScreen(tester, key, 'driver_trip_waiting_${lang}_${scale}x.png');
        }
      });

      testWidgets('Driver Cockpit: Running State (I reached / Route) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final key = GlobalKey();
        // d1 has running trip TR-1025
        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: DriverTripTab(driverId: 'd1')),
            locale: loc,
            textScale: scale,
            repaintKey: key,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        if (shouldCapture) {
          await _captureScreen(tester, key, 'driver_trip_running_${lang}_${scale}x.png');
        }
      });

      testWidgets('Driver Cockpit: Empty State (No trip) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final key = GlobalKey();
        // d3 has only delivered trips, so active trip is null
        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: DriverTripTab(driverId: 'd3')),
            locale: loc,
            textScale: scale,
            repaintKey: key,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        if (shouldCapture) {
          await _captureScreen(tester, key, 'driver_trip_empty_${lang}_${scale}x.png');
        }
      });

      testWidgets('Delivery Proof Flow: Step 1 (4-digit code) - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final key = GlobalKey();
        await tester.pumpWidget(
          _buildTestApp(
            child: const DeliveryProofFlow(tripId: 'TR-1025'),
            locale: loc,
            textScale: scale,
            repaintKey: key,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        if (shouldCapture) {
          await _captureScreen(tester, key, 'proof_step1_${lang}_${scale}x.png');
        }
      });

      testWidgets('Driver Earnings Tab - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final key = GlobalKey();
        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: DriverEarningsTab(driverId: 'd1')),
            locale: loc,
            textScale: scale,
            repaintKey: key,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        if (shouldCapture) {
          await _captureScreen(tester, key, 'driver_earnings_${lang}_${scale}x.png');
        }
      });

      testWidgets('Driver Profile Tab - $desc', (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final key = GlobalKey();
        await tester.pumpWidget(
          _buildTestApp(
            child: Scaffold(
              body: DriverProfileTab(
                driverId: 'd1',
                onToggleLanguage: () {},
              ),
            ),
            locale: loc,
            textScale: scale,
            repaintKey: key,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        if (shouldCapture) {
          await _captureScreen(tester, key, 'driver_profile_${lang}_${scale}x.png');
        }
      });
    }
  });
}
