import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin_services/presentation/admin_services_page.dart';
import 'package:flutter_application_1/features/auth/presentation/login_screen.dart';
import 'package:flutter_application_1/features/shell/presentation/app_shell_page.dart';
import 'package:flutter_application_1/features/services/presentation/services_page.dart';

class AppRouter {
  // ✅ DITO MANGGAGALING ANG INITIAL ROUTE
  static const String login = '/';
  static const String adminDashboard = '/admin';
  static const String staffDashboard = '/staff';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AppShellPage(
            isAdmin: true, 
            child: AdminServicesPage(), // O AdminServicesPage
          ),
        );

      case staffDashboard:
        return MaterialPageRoute(
          builder: (_) => const AppShellPage(
            isAdmin: false, 
            child: StaffServicesPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}