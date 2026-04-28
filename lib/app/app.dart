import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart'; // Import ito dapat!

class Cam2PrintApp extends StatelessWidget {
  const Cam2PrintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cam2print System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      
      // ✅ TAMA: Gamitin ang variable name na 'login' mula sa AppRouter
      initialRoute: AppRouter.login, 
      
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}