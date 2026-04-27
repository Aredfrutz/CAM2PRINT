import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:flutter_application_1/core/config/app_env.dart';
import 'package:google_fonts/google_fonts.dart';

class Cam2PrintApp extends StatelessWidget {
  const Cam2PrintApp({super.key});

  static void bootstrap() {
    final env = AppEnv.fromDartDefine();
    runApp(Cam2PrintApp(key: ValueKey(env.name)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cam2print System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xff101540),
          onPrimary: const Color(0xffffffff),
          secondary: const Color.fromARGB(223, 46, 72, 145),
          onSecondary: const Color(0xA6ffffff),
          error: const Color(0xffff0000),
          onError: const Color(0xA6000000),
          surface: const Color(0xff101540),
          onSurface: const Color(0xFFffffff),
          tertiary: const Color(0xFFffffff),
        ),

        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            filled: true,
          ),

          textStyle: GoogleFonts.baiJamjuree(fontSize: 16),
        ),

        //Text Theme
        textTheme: TextTheme(
          // Title Text
          titleLarge: GoogleFonts.baiJamjuree(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          titleMedium: GoogleFonts.courierPrime(),
          titleSmall: GoogleFonts.courierPrime(),

          // Body Text
          bodyLarge: GoogleFonts.courierPrime(),
          bodyMedium: GoogleFonts.courierPrime(),
          bodySmall: GoogleFonts.courierPrime(),

          // Display Text
          displayLarge: GoogleFonts.courierPrime(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.courierPrime(
            fontSize: 36,
            fontStyle: FontStyle.italic,
          ),
          displaySmall: GoogleFonts.courierPrime(),
        ),
      ),

      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
