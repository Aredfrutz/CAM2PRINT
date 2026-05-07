import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


/* Status ng Salary (Staff View):
  Kulang nalang ng actual data from the database to fill the variable values.
  This is the Read-Only (RO) view for Staff to view their computed salary.
*/

//Variable Values (Placeholders until DB connection)
num TSPrintValue = 0;
num TSXeroxValue = 0;
num TSSuppliesValue = 0;
num TSPartyValue = 0;
num CAmountValue = 0;
num DViolationsValue = 0;
num DPhilHealthValue = 0;
num DSSSValue = 0;
num LDeductionValue = 0;
num CAdvanceValue = 0;

num TSPrintPercentageValue = 100;
num TSXeroxPercentageValue = 100;
num TSSuppliesPercentageValue = 100;
num TSPartyPercentageValue = 100;

num SalaryComputed = 0;
num BasicPay = 0;
num TotalDeductions = 0;
String NRemindersValue = "";
bool isFullTime = false;

//DropDownValues
SelectedStaff? selectedStaff = SelectedStaff.name1;
IsFullTimeStaff? staffBoolean = IsFullTimeStaff.no;

//For Textboxes to Input Salary Data (Not used in RO view but kept for structure)
CurrencyTextInputFormatter CurrencyFormatter = CurrencyTextInputFormatter(
  NumberFormat.decimalPatternDigits(decimalDigits: 2),
);

//DropdownMenu for Selecting Staff
typedef StaffEntry = DropdownMenuEntry<SelectedStaff>;

enum SelectedStaff {
  name1('ABCD'),
  name2('EFGH');

  const SelectedStaff(this.label);
  final String label;

  static final List<StaffEntry> entries = UnmodifiableListView<StaffEntry>(
    values.map<StaffEntry>(
      (SelectedStaff name) => StaffEntry(value: name, label: name.label),
    ),
  );
}

typedef StaffBool = DropdownMenuEntry<IsFullTimeStaff>;

enum IsFullTimeStaff {
  yes('Full-time Staff'),
  no('Part-time Staff');

  const IsFullTimeStaff(this.label);
  final String label;

  static final List<StaffBool> entries = UnmodifiableListView<StaffBool>(
    values.map<StaffBool>(
      (IsFullTimeStaff boolean) =>
          StaffBool(value: boolean, label: boolean.label),
    ),
  );
}

class StaffSalaryPage extends StatefulWidget {
  const StaffSalaryPage({super.key});

  @override
  State<StaffSalaryPage> createState() => _StaffSalaryPageState();
}

class _StaffSalaryPageState extends State<StaffSalaryPage> {
  //Formula para macompute Salary
  void formula() {
    if (staffBoolean == IsFullTimeStaff.yes) {
      BasicPay =
          (TSPrintValue * TSPrintPercentageValue / 100) +
          (TSXeroxValue * TSXeroxPercentageValue / 100) +
          (TSSuppliesValue * TSSuppliesPercentageValue / 100) +
          (TSPartyValue * TSPartyPercentageValue / 100);

      TotalDeductions =
          (DViolationsValue + DPhilHealthValue + DSSSValue + LDeductionValue);

      SalaryComputed =
          (BasicPay + CAmountValue - TotalDeductions - CAdvanceValue);
    } else {
      BasicPay =
          (TSPrintValue * TSPrintPercentageValue / 100) +
          (TSXeroxValue * TSXeroxPercentageValue / 100) +
          (TSSuppliesValue * TSSuppliesPercentageValue / 100) +
          (TSPartyValue * TSPartyPercentageValue / 100);

      TotalDeductions = (DViolationsValue + LDeductionValue);

      SalaryComputed =
          (BasicPay + CAmountValue - TotalDeductions - CAdvanceValue);
    }
  }

  void _navigateTo(String pageName) {
    if (!mounted) return;
    String? routeName;
    switch (pageName) {
      case 'Services':
        routeName = AppRouter.staffServices;
        break;
      case 'Daily Inventory':
        routeName = AppRouter.staffDailyInv;
        break;
      case 'Salary':
        routeName = AppRouter.staffsalary;
        break;
      case 'Consumption Tracker':
        routeName = AppRouter.staffConsumptionTracker;
        break;
      case 'Customized Orders':
        routeName = AppRouter.staffCustomizedOrders;
        break;
      case 'Schedule':
        routeName = AppRouter.staffSchedule;
        break;
      case 'Profile':
        routeName = AppRouter.staffProfile;
        break;
      case 'Notifications':
        routeName = AppRouter.notifications;
        break;
    }

    if (routeName != null) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: routeName == AppRouter.notifications ? false : null,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$pageName not connected yet.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ✅ STAFF SIDEBAR ITEM (Copied from StaffProfile)
  Widget _buildSidebarItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? const Color(0xFF1A237E) : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? const Color(0xFF1A237E) : Colors.white,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Staff Section (Read-Only)
  Widget _ROStaffSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Icon(
              size: 56,
              Icons.account_circle,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedStaff!.label,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    staffBoolean!.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Calculation Section (Read-Only)
  Widget _ROCalculationSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Earnings',
                style: GoogleFonts.baiJamjuree(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            Divider(height: 20, color: Theme.of(context).colorScheme.onPrimary),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _RODataItem(context, 'Total Sales for Printing',
                          '₱ ' + TSPrintValue.toStringAsFixed(2),
                          TSPrintPercentageValue.toString() + '%'),
                      _RODataItem(context, 'Total Sales for Photocopy/Xerox',
                          '₱ ' + TSXeroxValue.toStringAsFixed(2),
                          TSXeroxPercentageValue.toString() + '%'),
                      _RODataItem(context, 'Total Sales for School Supplies',
                          '₱ ' + TSSuppliesValue.toStringAsFixed(2),
                          TSSuppliesPercentageValue.toString() + '%'),
                      _RODataItem(context, 'Total Sales for Party Needs',
                          '₱ ' + TSPartyValue.toStringAsFixed(2),
                          TSPartyPercentageValue.toString() + '%'),
                      _RODataItem(context, 'Commission Amount',
                          '₱ ' + CAmountValue.toStringAsFixed(2), ''),
                      _RODataItem(context, 'Deductions from Violations',
                          '₱ ' + DViolationsValue.toStringAsFixed(2), ''),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _RODataItem(context, 'Deductions from PhilHealth',
                          staffBoolean == IsFullTimeStaff.yes
                              ? '₱ ' + DPhilHealthValue.toStringAsFixed(2)
                              : 'N/A',
                          ''),
                      _RODataItem(context, 'Deductions from SSS',
                          staffBoolean == IsFullTimeStaff.yes
                              ? '₱ ' + DSSSValue.toStringAsFixed(2)
                              : 'N/A',
                          ''),
                      _RODataItem(context, 'Late Deduction',
                          '₱ ' + LDeductionValue.toStringAsFixed(2), ''),
                      _RODataItem(context, 'Cash Advance',
                          '₱ ' + CAdvanceValue.toStringAsFixed(2), ''),
                      _RONotesItem(context, 'Notes and Reminders',
                          NRemindersValue == "" ? "No notes." : NRemindersValue),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _RODataItem(BuildContext context, String label, String value, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.baiJamjuree(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              if (percentage.isNotEmpty) SizedBox(width: 8),
              if (percentage.isNotEmpty)
                Text(
                  percentage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _RONotesItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.baiJamjuree(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  //Salary Section
  Widget _SalarySection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Salary Computed",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "₱ ${SalaryComputed.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Divider(height: 1),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SalaryBreakdownRow(context, "Basic Pay",
                      "₱ ${BasicPay.toStringAsFixed(2)}",
                      const Color.fromARGB(255, 0, 255, 30)),
                  const SizedBox(height: 14),
                  _SalaryBreakdownRow(context, "Commissions",
                      "₱ ${CAmountValue.toStringAsFixed(2)}",
                      const Color.fromARGB(255, 0, 255, 30)),
                  const SizedBox(height: 14),
                  _SalaryBreakdownRow(context, "Cash Advance",
                      "₱ ${CAdvanceValue.toStringAsFixed(2)}",
                      const Color.fromARGB(255, 255, 0, 0)),
                  const SizedBox(height: 14),
                  _SalaryBreakdownRow(context, "Other Deductions",
                      "₱ ${TotalDeductions.toStringAsFixed(2)}",
                      const Color.fromARGB(255, 255, 0, 0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _SalaryBreakdownRow(
      BuildContext context, String label, String value, Color valueColor) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(width: 16),
        Expanded(flex: 1, child: Divider(height: 1)),
        SizedBox(width: 16),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7C88C2), Color(0xFFFFFFFF)],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ STAFF SIDEBAR (Copied from StaffProfile)
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
              ),
              child: Container(
                width: 240,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5B6388), Color(0xFF3E4563)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/logo.png',
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Cam2print System',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // ✅ STAFF NAVIGATION - Same as StaffProfile
                    _buildSidebarItem(
                      Icons.inventory_2,
                      "Daily Inventory",
                      () => _navigateTo('Daily Inventory'),
                    ),
                    _buildSidebarItem(
                      Icons.design_services,
                      "Services",
                      () => _navigateTo('Services'),
                    ),
                    _buildSidebarItem(
                      Icons.monetization_on,
                      "Salary",
                      () => _navigateTo('Salary'),
                      isActive: true,
                    ),
                    _buildSidebarItem(
                      Icons.shopping_cart,
                      "Consumption Tracker",
                      () => _navigateTo('Consumption Tracker'),
                    ),
                    _buildSidebarItem(
                      Icons.shopping_bag,
                      "Customized Orders",
                      () => _navigateTo('Customized Orders'),
                    ),
                    _buildSidebarItem(
                      Icons.event_available,
                      "Schedule",
                      () => _navigateTo('Schedule'),
                    ),
                    
                    const Spacer(),
                    
                    // ✅ LOGOUT BUTTON - Same as StaffProfile
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            AppRouter.login,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ MAIN CONTENT
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar (Same style as StaffProfile)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFB3D4FF),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Saturday, January 31, 2026",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _navigateTo('Notifications'),
                                child: const Icon(
                                  Icons.notifications_none,
                                  color: Color(0xFF1A237E),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => _navigateTo('Profile'),
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    size: 26,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jane",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                  Text(
                                    "Staff",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Content - Compact layout without scrolling
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ROStaffSection(context),
                                Expanded(
                                  child: _ROCalculationSection(context),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: _SalarySection(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}