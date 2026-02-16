import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sizer/sizer.dart';
import 'config/routes/router.dart';
import 'theme/app_theme.dart'; // getDarkTheme(), getLightTheme()

void main() async {
  // Esto es necesario antes de llamar a Firebase.initializeApp
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Inicializa Firebase con la config generada por FlutterFire
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {                                                                                                                                                                                                    
    const MyApp({super.key});
                                                                                                                                                                                                                                           
    @override                                                                                                                                                                                                                              
    Widget build(BuildContext context) {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            title: 'EVNTS POS',
            debugShowCheckedModeBanner: false,
            theme: getDarkTheme(),
            routerConfig: AppRouter.routes,
          );
        },
      );
    }
  }
