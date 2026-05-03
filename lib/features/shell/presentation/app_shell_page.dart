import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/navigation/app_module.dart';
import 'package:flutter_application_1/features/daily_inventory/presentation/daily_inventory_page.dart';
import 'package:flutter_application_1/features/orders/presentation/orders_page.dart';
import 'package:flutter_application_1/features/overall_inventory/presentation/overall_inventory_page.dart';
import 'package:flutter_application_1/features/reminder/presentation/reminder_page.dart';
import 'package:flutter_application_1/features/salary/presentation/salary_page.dart';
import 'package:flutter_application_1/features/schedule/presentation/schedule_page.dart';
import 'package:flutter_application_1/features/services/presentation/services_page.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Cam2Print System',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: <Widget>[
          Text(
            DateFormat('MMMM d, y').format(DateTime.now()),
            textAlign: TextAlign.right,
            style: GoogleFonts.baiJamjuree(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          VerticalDivider(
            width: 16,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Jane",
                textAlign: TextAlign.right,
                style: GoogleFonts.baiJamjuree(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                "Admin",
                textAlign: TextAlign.right,
                style: GoogleFonts.baiJamjuree(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            tooltip: 'Settings',
            onPressed: () {
              // Navigate to settings page
            },
          ),

          Container(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 800) {
            return _wideScreenView();
          } else {
            return _thinScreenView();
          }
        },
      ),
    );
  }

  Widget _wideScreenView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenWidth, minWidth: 492),

      child: Row(
        children: [
          NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            extended: true,
            labelType: NavigationRailLabelType.none,
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

          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: screenWidth - 256,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    /*Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)*/ Color(
                      0xFF7ca8f9,
                    ),
                    Theme.of(
                      context,
                    ).colorScheme.tertiary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 0.6),
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight - 56),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: _pageForModule(selected),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thinScreenView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: screenWidth, minWidth: 0),

      child: Row(
        children: [
          NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            extended: false,
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

          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: screenWidth - 80,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    /*Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)*/ Color(
                      0xFF7ca8f9,
                    ),
                    Theme.of(
                      context,
                    ).colorScheme.tertiary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 0.6),
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _pageForModule(selected),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
