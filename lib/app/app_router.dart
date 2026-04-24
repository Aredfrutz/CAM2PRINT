import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/login_page.dart';
import 'package:flutter_application_1/features/shell/presentation/app_shell_page.dart';

class AppRouter {
  static const login = '/';
  static const dashboard = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShellPage(),
          settings: settings,
        );
      case login:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
    }
  }
}
