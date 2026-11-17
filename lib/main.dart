import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'core/theme/app_colors.dart';
import 'screens/auth/role_select_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.midnightBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SmartFleetApp());
}

class SmartFleetApp extends StatelessWidget {
  const SmartFleetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'SmartFleet',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(
          background: AppColors.midnightBlack,
        ),
      ),
      home: const RoleSelectScreen(),
    );
  }
}
