import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  // Sample data for the table
  final List<Map<String, dynamic>> staffList = [
    {
      'name': 'Juan Dela Cruz',
      'status': 'Full-Time',
      'email': 'juan.dc@cam2print.com',
      'password': '••••••••••',
      'active': true,
    },
    {
      'name': 'Maria Clara',
      'status': 'Part-Time',
      'email': 'm.clara@cam2print.com',
      'password': '••••••••••',
      'active': false,
    },
    {
      'name': 'Jose Rizal',
      'status': 'Contractual',
      'email': 'j.rizal@cam2print.com',
      'password': '••••••••••',
      'active': true,
    },
  ];

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
                    // Active highlight for Staff Management
                    _buildSidebarItem(
                      Icons.people,
                      "Staff Management",
                      () => _navigateTo('Staff Management'),
                      isActive: true,
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
                    _buildSidebarItem(
                      Icons.error_outline,
                      "Reports",
                      () => _navigateTo('Reports'),
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
                    // Top navbar
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

                    // Staff table
                    Expanded(
                      child: Container(
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Staff Management",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                      Text(
                                        "Manage account access and profile details.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: _showAddStaffDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4B5580),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "ADD NEW STAFF",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: _buildStaffTable()),
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

  void _showAddStaffDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1,
                      color: Color(0xFF4B5580),
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Create Staff Account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Set up access for newly hired employees",
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  _buildFormField(
                    "STAFF NAME",
                    "Enter Full Name",
                    TextEditingController(),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField("EMPLOYMENT STATUS", [
                    "Select status",
                    "Full-Time",
                    "Part-Time",
                    "Contractual",
                  ]),
                  const SizedBox(height: 16),
                  _buildFormField(
                    "EMAIL ADDRESS",
                    "email@cam2print.com",
                    TextEditingController(),
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField("PASSWORD"),
                  const SizedBox(height: 24),

                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B5580),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField(
    String label,
    String hint,
    TextEditingController controller,
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
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFF4B5580)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
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
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                items[0],
                style: const TextStyle(color: Color(0xFF9CA3AF)),
              ),
              items: items.skip(1).map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label) {
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
        const SizedBox(height: 6),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "••••••••",
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFF4B5580)),
            ),
            suffixIcon: const Icon(
              Icons.remove_red_eye,
              color: Color(0xFF9CA3AF),
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

 Widget _buildStaffTable() {
  const headerStyle = TextStyle(
    color: Color(0xFF6B7280),
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFE5E7EB)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        // Header Row
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
            border: Border(
              bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
            ),
          ),
          child: Row(
            children: const [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text("STAFF NAME", style: headerStyle),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text("EMPLOYMENT STATUS", style: headerStyle),
              ),
              Expanded(
                flex: 4,
                child: Text("EMAIL ADDRESS", style: headerStyle),
              ),
              Expanded(flex: 2, child: Text("PASSWORD", style: headerStyle)),
              Expanded(flex: 2, child: Text("STATUS", style: headerStyle)), // Changed flex from 1 to 2
              SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Center(child: Text("ACTIONS", style: headerStyle)),
              ),
            ],
          ),
        ),

        // Data Rows
        Expanded(
          child: ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              final bool isActive = staff['active'];

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Name
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          staff['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ),

                    // Employment Status
                    Expanded(
                      flex: 2,
                      child: Text(
                        staff['status'],
                        style: const TextStyle(color: Color(0xFF374151)),
                      ),
                    ),

                    // Email
                    Expanded(
                      flex: 4,
                      child: Text(
                        staff['email'],
                        style: const TextStyle(color: Color(0xFF374151)),
                      ),
                    ),

                    // Password
                    Expanded(
                      flex: 2,
                      child: Text(
                        staff['password'],
                        style: const TextStyle(color: Color(0xFF374151)),
                      ),
                    ),

                    // Status Badge - Fixed: Increased flex and removed Center wrapper
                    Expanded(
                      flex: 2, // Changed from 1 to 2 for more space
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12, // Increased padding
                          vertical: 6,    // Increased padding
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            color: isActive
                                ? const Color(0xFF059669)
                                : const Color(0xFFDC2626),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                          maxLines: 1, // Force single line
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Actions Buttons - Fixed: Better alignment
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center, // Added vertical alignment
                        children: [
                          // Edit Info Button
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              side: BorderSide(
                                color: isActive
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFF3B82F6),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: Colors.transparent,
                              minimumSize: const Size(70, 32), // Fixed minimum size
                            ),
                            child: const Text(
                              "EDIT INFO",
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Activate/Deactivate Button
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              side: BorderSide(
                                color: isActive
                                    ? const Color(0xFFD97706)
                                    : const Color(0xFF059669),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: Colors.transparent,
                              minimumSize: const Size(75, 32), // Fixed minimum size
                            ),
                            child: Text(
                              isActive ? "DEACTIVATE" : "ACTIVATE",
                              style: TextStyle(
                                color: isActive
                                    ? const Color(0xFFD97706)
                                    : const Color(0xFF059669),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Delete Button
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              side: const BorderSide(
                                color: Color(0xFFDC2626),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: Colors.transparent,
                              minimumSize: const Size(60, 32), // Fixed minimum size
                            ),
                            child: const Text(
                              "DELETE",
                              style: TextStyle(
                                color: Color(0xFFDC2626),
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}
