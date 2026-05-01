import 'package:flutter/material.dart';
// SIGURADUHIN NA TAMA ANG PATH NA ITO. Ito ang 'bridge' para makilala ang AppRouter
import 'package:flutter_application_1/app/app_router.dart'; 

void main() {
  runApp(const Cam2PrintApp());
}

class Cam2PrintApp extends StatelessWidget {
  const Cam2PrintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cam2Print System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/', 
      // Dito mawawala ang red underline dahil sa import sa taas
      onGenerateRoute: AppRouter.onGenerateRoute, 
    );
  }
}