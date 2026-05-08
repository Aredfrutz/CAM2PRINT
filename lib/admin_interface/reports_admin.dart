import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';


class ReportsAdminPage extends StatefulWidget {
  const ReportsAdminPage({super.key});

  @override
  State<ReportsAdminPage> createState() => _ReportsAdminPageState();
}

class _ReportsAdminPageState extends State<ReportsAdminPage> {
  String _selectedTab = "Attendance";
  String _filterShopBranch = "All Branches";
  String _filterEmployeeStatus = "All";
  String _filterItemCategory = "All";
  String _filterShift = "Opening/Closing";
  String _filterStaffName = "All Staff";
  String _filterServiceType = "All";
  String _filterServiceStatus = "All";
  String _filterInventoryStatus = "All";
  String _filterLogActionType = "All";
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  final TextEditingController _thresholdController = TextEditingController(
    text: "0",
  );

 void _navigateTo(String pageName) {
    String? routeName;
    switch (pageName) {
      case 'Staff Management':
        routeName = AppRouter.adminStaffManagement;
        break;
      case 'Services':
        routeName = AppRouter.adminServices;
        break;
      case 'Schedule':
        routeName = AppRouter.adminSchedule;
        break;
      case 'Reports':
        routeName = AppRouter.adminreports;
        break;
      case 'Customized Orders':
        routeName = AppRouter.adminCustomOrders;
        break;
      case 'Notifications':
        routeName = AppRouter.notifications;
        break;
      case 'Overall Inventory':
        routeName = AppRouter.adminoverallinv;
        break;
      case 'Salary':
        routeName = AppRouter.adminsalary;
        break;
    }
    if (routeName != null) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: routeName == AppRouter.notifications ? true : null,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9FA8DA), Color(0xFFFFFFFF)],
          ),
        ),
        child: Row(
          children: [
            // Sidebar
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
              ),
              child: Container(
                width: 240,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5B6388), Color(0xFF3E4563)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
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
                    _buildSidebarItem(
                      Icons.people,
                      "Staff Management",
                      () => _navigateTo('Staff Management'),
                    ),
                    _buildSidebarItem(
                      Icons.inventory_2,
                      "Overall Inventory",
                      () => _navigateTo('Overall Inventory'),
                    ),
                    _buildSidebarItem(
                      Icons.settings,
                      "Services",
                      () => _navigateTo('Services'),
                    ),
                    _buildSidebarItem(
                      Icons.attach_money,
                      "Salary",
                      () => _navigateTo('Salary'),
                    ),
                    _buildSidebarItem(
                      Icons.shopping_cart,
                      "Customized Orders",
                      () => _navigateTo('Customized Orders'),
                    ),
                    _buildSidebarItem(
                      Icons.calendar_today,
                      "Schedule",
                      () => _navigateTo('Schedule'),
                    ),
                    // Active highlight for Reports
                    _buildSidebarItem(
                      Icons.error_outline,
                      "Reports",
                      () => _navigateTo('Reports'),
                      isActive: true,
                    ),
                    const Spacer(),
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

            // Main Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Saturday/ January 31, 2026",
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
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 26,
                                  color: Color(0xFF1A237E),
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
                                    "Admin",
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
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildTabItem("Attendance"),
                                      const SizedBox(width: 16),
                                      _buildTabItem("Inventory"),
                                      const SizedBox(width: 16),
                                      _buildTabItem("Salary"),
                                      const SizedBox(width: 16),
                                      _buildTabItem("Customized Orders"),
                                      const SizedBox(width: 16),
                                      _buildTabItem("Activity Log"),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () => _showFilterDialog(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4B5580),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Filter",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00C853),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Export",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(child: _buildTable()),
                          ],
                        ),
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

  Widget _buildTabItem(String title) {
    bool isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4B5580) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // --- DYNAMIC TABLE SWITCHER ---
  Widget _buildTable() {
    switch (_selectedTab) {
      case "Inventory":
        return _buildInventoryTable();
      case "Salary":
        return _buildSalaryTable();
      case "Customized Orders":
        return _buildCustomizedOrdersTable();
      case "Activity Log":
        return _buildActivityLogTable();
      default:
        // Default to Attendance for "Attendance"
        return _buildAttendanceTable();
    }
  }

  // 1. Attendance Table (Default)
  Widget _buildAttendanceTable() {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: [
        "Date",
        "Branch",
        "Shift",
        "Staff Name",
        "Time In",
        "Time Out",
        "Status",
        "Lateness (mins)",
        "Deduction (₱)",
      ],
      // Updated flexes: Increased last two columns from 2 to 3 to fix spacing
      flexes: [2, 2, 2, 3, 2, 2, 2, 3, 3],
      headerStyle: headerStyle,
      bodyStyle: bodyStyle,
    );
  }

  // 2. Inventory Table
  Widget _buildInventoryTable() {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: [
        "Date",
        "Branch",
        "Item Category",
        "Item Name",
        "Start Quantity",
        "End Quantity",
        "Discrepancy",
        "Threshold Level",
        "Status",
        "Last Restocked Date",
      ],
      // Updated flexes for balanced spacing:
      // Reduced 'Date' and 'Branch' to 2 so they don't take too much space.
      // Increased 'Last Restocked Date' to 4 so it fits.
      flexes: [2, 2, 3, 3, 3, 3, 3, 3, 2, 4],
      headerStyle: headerStyle,
      bodyStyle: bodyStyle,
    );
  }

  // 3. Salary Table
  Widget _buildSalaryTable() {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: [
        "Pay Period",
        "Branch",
        "Staff Name",
        "Total Sales",
        "Total Commission",
        "Custom Orders Quantity",
        "Deductions",
        "Cash Advance",
        "Percentage",
      ],
      // Updated flexes:
      // Reduced Staff Name from 3 to 2 (removes big gap)
      // Increased Custom Orders Quantity from 3 to 4 (gives more room before Deductions)
      flexes: [2, 2, 2, 2, 3, 4, 2, 2, 2],
      headerStyle: headerStyle,
      bodyStyle: bodyStyle,
    );
  }

  // 4. Customized Orders Table
  Widget _buildCustomizedOrdersTable() {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: [
        "Date Received",
        "Customer Name",
        "Branch",
        "Service Type",
        "Status",
        "Down Payment",
        "Balance",
        "Payment Status",
        "Item Quantity",
        "Posted by",
      ],
      // Updated flexes to ensure appropriate spacing and prevent wrapping:
      // Increased 'Balance', 'Status', and 'Branch' so they aren't squashed.
      flexes: [3, 4, 2, 3, 2, 3, 2, 4, 3, 3],
      headerStyle: headerStyle,
      bodyStyle: bodyStyle,
    );
  }

  // 5. Activity Log Table
  Widget _buildActivityLogTable() {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: ["Date", "Staff Name", "Action Type", "Details/Change"],
      flexes: [2, 3, 3, 6],
      headerStyle: headerStyle,
      bodyStyle: bodyStyle,
    );
  }

  // Generic Table Builder to avoid code repetition
  Widget _buildGenericTable({
    required List<String> headers,
    required List<int> flexes,
    required TextStyle headerStyle,
    required TextStyle bodyStyle,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB0C4DE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF4B5580), // Dark blue header
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Row(
              children: List.generate(headers.length, (index) {
                return Expanded(
                  flex: flexes[index],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(headers[index], style: headerStyle),
                  ),
                );
              }),
            ),
          ),
          // Empty Rows
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFB0C4DE),
                        width: 1,
                      ),
                    ),
                    color: index.isEven
                        ? Colors.white
                        : const Color(0xFFE8F0FE),
                  ),
                  child: Row(
                    children: List.generate(headers.length, (i) {
                      return Expanded(
                        flex: flexes[i],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text("", style: bodyStyle),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // The Filter Dialog that appears when you click Filter
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filter Reports",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                const SizedBox(height: 20),

                // Wrap in SingleChildScrollView in case screen is small
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Shop Branch
                        _buildDropdownField(
                          "Shop Branch",
                          ["All Branches", "Campo", "Main"],
                          _filterShopBranch,
                          (value) =>
                              setDialogState(() => _filterShopBranch = value!),
                        ),
                        const SizedBox(height: 16),

                        // Pay Period / Date Range & Employee Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Pay Period/Date Range",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDatePicker(
                                          _filterStartDate,
                                          (picked) => setDialogState(
                                            () => _filterStartDate = picked,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text("-"),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildDatePicker(
                                          _filterEndDate,
                                          (picked) => setDialogState(
                                            () => _filterEndDate = picked,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownField(
                                "Employee Status",
                                ["All", "Active", "Inactive"],
                                _filterEmployeeStatus,
                                (value) => setDialogState(
                                  () => _filterEmployeeStatus = value!,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Item Category & Shift
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                "Item Category",
                                ["All", "Packages", "Souvenirs"],
                                _filterItemCategory,
                                (value) => setDialogState(
                                  () => _filterItemCategory = value!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownField(
                                "Shift",
                                ["Opening/Closing", "Morning", "Afternoon"],
                                _filterShift,
                                (value) =>
                                    setDialogState(() => _filterShift = value!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Staff Name & Service Type
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                "Staff Name",
                                ["All Staff", "Jane Admin"],
                                _filterStaffName,
                                (value) => setDialogState(
                                  () => _filterStaffName = value!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownField(
                                "Service Type",
                                ["All", "Printing", "Custom"],
                                _filterServiceType,
                                (value) => setDialogState(
                                  () => _filterServiceType = value!,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Threshold Level & Service Status
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Threshold Level",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextField(
                                    controller: _thresholdController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xFFB0B8D0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide.none,
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownField(
                                "Service Status",
                                ["All", "Completed", "Pending"],
                                _filterServiceStatus,
                                (value) => setDialogState(
                                  () => _filterServiceStatus = value!,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Inventory Status & Log Activity Action Type
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                "Inventory Status",
                                ["All", "Low Stock", "In Stock"],
                                _filterInventoryStatus,
                                (value) => setDialogState(
                                  () => _filterInventoryStatus = value!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownField(
                                "Log Activity Action Type",
                                ["All", "Login", "Transaction"],
                                _filterLogActionType,
                                (value) => setDialogState(
                                  () => _filterLogActionType = value!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Add filter logic here
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF4B5580,
                        ), // Purple/Blue from image
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
      },
    );
  }

  // Helper widget for Dropdowns
  Widget _buildDropdownField(
    String label,
    List<String> items,
    String selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFB0B8D0),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: const Color(0xFF8E99BC),
              style: const TextStyle(color: Colors.white),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    DateTime? date,
    ValueChanged<DateTime> onDatePicked,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDatePicked(picked);
        }
      },
      child: Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFB0B8D0),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            date == null
                ? "Select date"
                : "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }
}
