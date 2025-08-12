import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:treintaypico/config/routes/router.dart';
import 'package:treintaypico/core/localization/strings.dart';

import 'package:treintaypico/core/providers/storage_providers.dart';
import 'package:treintaypico/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // Cargamos SharedPreferences una sola vez
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, __, ___) => MaterialApp.router(
        title: Strings.appName,
        routerConfig: AppRouter.routes,
        debugShowCheckedModeBanner: false,
        theme: getDarkTheme(),
      ),
    );
  }
}
