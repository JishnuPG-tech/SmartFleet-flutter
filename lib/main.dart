import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';
import 'package:smartfleet_flutter/l10n/app_localizations.dart';
import 'package:smartfleet_flutter/screens/auth/role_select_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartFleetApp());
}

class SmartFleetApp extends StatefulWidget {
  const SmartFleetApp({super.key});

  @override
  State<SmartFleetApp> createState() => _SmartFleetAppState();
}

class _SmartFleetAppState extends State<SmartFleetApp> {
  Locale _locale = const Locale('ml'); // Default to Malayalam for Kerala users

  void _setLocale(Locale loc) {
    setState(() => _locale = loc);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFleet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: _locale,
      supportedLocales: const [
        Locale('ml'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: RoleSelectScreen(
        currentLocale: _locale,
        onLocaleChanged: _setLocale,
      ),
    );
  }
}
