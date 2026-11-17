import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartfleet_flutter/core/design/theme/app_theme_v2.dart';
import 'package:smartfleet_flutter/screens/dev/component_gallery_screen.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';

void main() {
  testWidgets('ComponentGalleryScreen renders all components without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemeV2.buildTheme(Brightness.light),
        darkTheme: AppThemeV2.buildTheme(Brightness.dark),
        themeMode: ThemeMode.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const ComponentGalleryScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Design Component Gallery'), findsOneWidget);
    expect(find.text('1. Status Headline'), findsOneWidget);
    expect(find.text('2. Live Badges'), findsOneWidget);
    expect(find.text('3. Status Chips'), findsOneWidget);
    expect(find.text('4. Action Buttons (56dp)'), findsOneWidget);

    for (final title in [
      '5. KPI Tile (Animated Count-up)',
      '6. Trip Card',
      '7. Truck Card (Resolved Driver Name)',
      '8. Driver Card',
      '9. Tracking Timeline (Amazon/Shiprocket Style)',
      '10. Skeleton Loader (Shimmer)',
      '11. Empty State',
      '12. Error State',
      '13. Settings Tile',
    ]) {
      await tester.scrollUntilVisible(find.text(title), 200);
      await tester.pump();
      expect(find.text(title), findsOneWidget);
    }
  });
}
