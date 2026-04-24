import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/navigation/app_module.dart';
import 'package:flutter_application_1/features/daily_inventory/presentation/daily_inventory_page.dart';
import 'package:flutter_application_1/features/orders/presentation/orders_page.dart';
import 'package:flutter_application_1/features/overall_inventory/presentation/overall_inventory_page.dart';
import 'package:flutter_application_1/features/reminder/presentation/reminder_page.dart';
import 'package:flutter_application_1/features/salary/presentation/salary_page.dart';
import 'package:flutter_application_1/features/schedule/presentation/schedule_page.dart';
import 'package:flutter_application_1/features/services/presentation/services_page.dart';

class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key});

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  AppModule selected = AppModule.daily;

  Widget _pageForModule(AppModule module) {
    switch (module) {
      case AppModule.daily:
        return const DailyInventoryPage();
      case AppModule.overall:
        return const OverallInventoryPage();
      case AppModule.reports:
        return const ServicesPage();
      case AppModule.reminder:
        return const ReminderPage();
      case AppModule.salary:
        return const SalaryPage();
      case AppModule.orders:
        return const OrdersPage();
      case AppModule.scheduling:
        return const SchedulePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            selectedIndex: AppModule.values.indexOf(selected),
            onDestinationSelected: (index) {
              setState(() => selected = AppModule.values[index]);
            },
            destinations: AppModule.values
                .map(
                  (module) => NavigationRailDestination(
                    icon: Icon(module.icon),
                    label: Text(module.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _pageForModule(selected),
            ),
          ),
        ],
      ),
    );
  }
}
