import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E4FF),
      body: SafeArea(
        child: Row(
          children: [
            // SIDEBAR
            _buildSidebar(),
            
            // MAIN CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  _buildTopHeader(),
                  const SizedBox(height: 16),
                  
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header Section with Title and Add Button
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.add, color: Colors.white, size: 18),
                                      SizedBox(width: 8),
                                      Text("ADD NEW STAFF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Table
                          Expanded(
                            child: _buildStaffTable(),
                          ),
                        ],
                      ),
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
                    child: const Icon(Icons.person_add_alt_1, color: Color(0xFF4B5580), size: 30),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Create Staff Account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Set up access for newly hired employees",
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Form Fields
                  _buildFormField("STAFF NAME", "Enter Full Name", TextEditingController()),
                  const SizedBox(height: 16),
                  _buildDropdownField("EMPLOYMENT STATUS", ["Select status", "Full-Time", "Part-Time", "Contractual"]),
                  const SizedBox(height: 16),
                  _buildFormField("EMAIL ADDRESS", "email@cam2print.com", TextEditingController()),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("CREATE ACCOUNT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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

  Widget _buildFormField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF4B5580))),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
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
              hint: Text(items[0], style: const TextStyle(color: Color(0xFF9CA3AF))),
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
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        const SizedBox(height: 6),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "••••••••",
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFD1D5DB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF4B5580))),
            suffixIcon: const Icon(Icons.remove_red_eye, color: Color(0xFF9CA3AF), size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Color(0xFF6B7280),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.print, color: Color(0xFF374151)),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Cam2print System",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildSidebarItem("Staff Management", Icons.people, isActive: true),
          _buildSidebarItem("Overall Inventory", Icons.inventory),
          _buildSidebarItem("Services", Icons.settings),
          _buildSidebarItem("Salary", Icons.attach_money),
          _buildSidebarItem("Consumption Tracker", Icons.bar_chart),
          _buildSidebarItem("Customized Orders", Icons.shopping_cart),
          _buildSidebarItem("Schedule", Icons.calendar_today),
          _buildSidebarItem("Reports", Icons.report),
          const Spacer(),
          _buildSidebarItem("Logout", Icons.logout),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.9) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? const Color(0xFF374151) : Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: isActive ? const Color(0xFF374151) : Colors.white,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "Saturday/ January 31, 2026",
                style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4B5563)),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.notifications_outlined, color: Color(0xFF4B5563)),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: const Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Jane", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937), fontSize: 16)),
                      Text("Admin", style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStaffTable() {
    const headerStyle = TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600, fontSize: 12);
    
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
              border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
            ),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Padding(padding: EdgeInsets.only(left: 8), child: Text("STAFF NAME", style: headerStyle))),
                Expanded(flex: 2, child: Text("EMPLOYMENT STATUS", style: headerStyle)),
                Expanded(flex: 4, child: Text("EMAIL ADDRESS", style: headerStyle)),
                Expanded(flex: 2, child: Text("PASSWORD", style: headerStyle)),
                Expanded(flex: 1, child: Text("STATUS", style: headerStyle)),
                SizedBox(width: 16),
                // FIXED: Center the Actions header
                Expanded(
                  flex: 5, 
                  child: Center(
                    child: Text("ACTIONS", style: headerStyle),
                  ),
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
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name
                      Expanded(flex: 3, child: Padding(padding: const EdgeInsets.only(left: 8), child: Text(staff['name'], style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF111827))))),
                      
                      // Employment Status
                      Expanded(flex: 2, child: Text(staff['status'], style: const TextStyle(color: Color(0xFF374151)))),
                      
                      // Email
                      Expanded(flex: 4, child: Text(staff['email'], style: const TextStyle(color: Color(0xFF374151)))),
                      
                      // Password
                      Expanded(flex: 2, child: Text(staff['password'], style: const TextStyle(color: Color(0xFF374151)))),
                      
                      // Status Badge
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              isActive ? "Active" : "Inactive",
                              style: TextStyle(
                                color: isActive ? const Color(0xFF059669) : const Color(0xFFDC2626),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Actions Buttons
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center the button group
                          children: [
                            // Edit Info Button
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                side: BorderSide(color: isActive ? const Color(0xFF2563EB) : const Color(0xFF3B82F6)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Text("EDIT INFO", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 11)),
                            ),
                            const SizedBox(width: 8),
                            
                            // Activate/Deactivate Button
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                side: BorderSide(color: isActive ? const Color(0xFFD97706) : const Color(0xFF059669)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                backgroundColor: Colors.transparent,
                              ),
                              child: Text(
                                isActive ? "DEACTIVATE" : "ACTIVATE",
                                style: TextStyle(color: isActive ? const Color(0xFFD97706) : const Color(0xFF059669), fontWeight: FontWeight.w600, fontSize: 11),
                              ),
                            ),
                            const SizedBox(width: 8),
                            
                            // Delete Button
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                side: const BorderSide(color: Color(0xFFDC2626)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Text("DELETE", style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w600, fontSize: 11)),
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