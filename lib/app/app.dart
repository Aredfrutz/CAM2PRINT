import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:flutter_application_1/core/config/app_env.dart';

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
      theme: ThemeData(useMaterial3: true),
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
