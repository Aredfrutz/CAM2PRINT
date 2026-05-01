import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_interface/reports_admin.dart';
import 'package:flutter_application_1/login/login_screen.dart';
import 'package:flutter_application_1/staff_interface/services_page.dart';
import 'package:flutter_application_1/staff_interface/staff_profile.dart';
import 'package:flutter_application_1/staff_interface/staff_schedule.dart';
import 'package:flutter_application_1/staff_interface/daily_inv.dart';
import 'package:flutter_application_1/staff_interface/customized_orders.dart';
import 'package:flutter_application_1/staff_interface/consumption_tracker.dart';
import 'package:flutter_application_1/admin_interface/admin_services_page.dart';
import 'package:flutter_application_1/admin_interface/admin_schedule.dart';
import 'package:flutter_application_1/admin_interface/customized_orders_admin.dart';
import 'package:flutter_application_1/admin_interface/staff_management_admin.dart';
import 'package:flutter_application_1/notifications_page.dart';

class AppRouter {
  static const login = '/';
  static const admin = '/admin';
  static const staff = '/staff';
  static const staffServices = '/staff/services';
  static const staffProfile = '/staff/profile';
  static const staffSchedule = '/staff/schedule';
  static const staffDailyInv = '/staff/daily-inventory';
  static const staffCustomizedOrders = '/staff/customized-orders';
  static const staffConsumptionTracker = '/staff/consumption-tracker';
  static const adminServices = '/admin/services';
  static const adminSchedule = '/admin/schedule';
  static const adminStaffManagement = '/admin/staff-management';
  static const adminreports = '/admin/reports_admin';
  static const adminCustomOrders = '/admin/customized_orders_admin';
  static const notifications = '/notifications';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case staff:
        return MaterialPageRoute<void>(
          builder: (_) => const StaffServicesPage(),
          settings: settings,
        );
      case staffServices:
        return MaterialPageRoute<void>(
          builder: (_) => const StaffServicesPage(),
          settings: settings,
        );
      case staffProfile:
        return MaterialPageRoute<void>(
          builder: (_) => const StaffProfile(),
          settings: settings,
        );
      case staffSchedule:
        return MaterialPageRoute<void>(
          builder: (_) => const StaffSchedule(),
          settings: settings,
        );
      case staffDailyInv:
        return MaterialPageRoute<void>(
          builder: (_) => const DailyInventoryPage(),
          settings: settings,
        );
      case staffCustomizedOrders:
        return MaterialPageRoute<void>(
          builder: (_) => const CustomizedOrdersPages(),
          settings: settings,
        );
      case staffConsumptionTracker:
        return MaterialPageRoute<void>(
          builder: (_) => const ConsumptionTracker(),
          settings: settings,
        );
      case adminServices:
      case admin:
        return MaterialPageRoute<void>(
          builder: (_) => const AdminServicesPage(),
          settings: settings,
        );
      case adminSchedule:
        return MaterialPageRoute<void>(
          builder: (_) => const AdminSchedule(),
          settings: settings,
        );
      case adminCustomOrders:
        return MaterialPageRoute<void>(
          builder: (_) => const CustomizedOrdersPage(),
          settings: settings,
        );
      case adminStaffManagement:
        return MaterialPageRoute<void>(
          builder: (_) => const StaffManagementPage(),
          settings: settings,
        );
      case adminreports:
        return MaterialPageRoute<void>(
          builder: (_) => const ReportsAdminPage(),
          settings: settings,
        );
      case notifications:
        final isAdmin = settings.arguments is bool
            ? settings.arguments as bool
            : false;
        return MaterialPageRoute<void>(
          builder: (_) => NotificationPage(isAdmin: isAdmin),
          settings: settings,
        );
      case login:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }
}
