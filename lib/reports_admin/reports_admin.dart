import 'package:flutter/material.dart';

class ReportsAdminPage extends StatefulWidget {
  const ReportsAdminPage({super.key});

  @override
  State<ReportsAdminPage> createState() => _ReportsAdminPageState();
}

class _ReportsAdminPageState extends State<ReportsAdminPage> {
  String _selectedTab = "Attendance";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E4FF), // Soft blue background
      body: SafeArea(
        child: Row(
          children: [
            // --- SIDEBAR ---
            _buildSidebar(),
            
            // --- MAIN CONTENT ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  _buildTopHeader(),
                  const SizedBox(height: 16),
                  
                  // Main White Container
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tabs and Action Buttons Row
                          Row(
                            children: [
                              // Tabs
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
                                    // Branch Performance removed
                                    _buildTabItem("Activity Log"),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              // Action Buttons
                              ElevatedButton(
                                onPressed: () => _showFilterDialog(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4B5580), // Purple/Dark Blue
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Filter", style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00C853), // Green
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Export", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Dynamic Table based on selected tab
                          Expanded(
                            child: _buildTable(),
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
          _buildSidebarItem("Overall Inventory", Icons.inventory),
          _buildSidebarItem("Services", Icons.settings),
          _buildSidebarItem("Salary", Icons.attach_money),
          _buildSidebarItem("Consumption Tracker", Icons.bar_chart),
          _buildSidebarItem("Customized Orders", Icons.shopping_cart),
          _buildSidebarItem("Schedule", Icons.calendar_today),
          _buildSidebarItem("Reports", Icons.report, isActive: true), // Reports is active
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
    const headerStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: ["Date", "Branch", "Shift", "Staff Name", "Time In", "Time Out", "Status", "Lateness (mins)", "Deduction (₱)"],
      // Updated flexes: Increased last two columns from 2 to 3 to fix spacing
      flexes: [2, 2, 2, 3, 2, 2, 2, 3, 3],
      headerStyle: headerStyle,
      bodyStyle: bodyStyle,
    );
  }

  // 2. Inventory Table
  Widget _buildInventoryTable() {
    const headerStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: ["Date", "Branch", "Item Category", "Item Name", "Start Quantity", "End Quantity", "Discrepancy", "Threshold Level", "Status", "Last Restocked Date"],
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
    const headerStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: ["Pay Period", "Branch", "Staff Name", "Total Sales", "Total Commission", "Custom Orders Quantity", "Deductions", "Cash Advance", "Percentage"],
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
    const headerStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
    const bodyStyle = TextStyle(color: Color(0xFF334155), fontSize: 12);
    return _buildGenericTable(
      headers: ["Date Received", "Customer Name", "Branch", "Service Type", "Status", "Down Payment", "Balance", "Payment Status", "Item Quantity", "Posted by"],
      // Updated flexes to ensure appropriate spacing and prevent wrapping:
      // Increased 'Balance', 'Status', and 'Branch' so they aren't squashed.
      flexes: [3, 4, 2, 3, 2, 3, 2, 4, 3, 3], 
      headerStyle: headerStyle,
      bodyStyle: bodyStyle,
    );
  }
  // 5. Activity Log Table
  Widget _buildActivityLogTable() {
    const headerStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
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
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: const Color(0xFFB0C4DE), width: 1),
                    ),
                    color: index.isEven ? Colors.white : const Color(0xFFE8F0FE),
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
      builder: (context) {
        return Dialog(
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
                  color: Colors.black.withOpacity(0.1),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E3A59)),
                ),
                const SizedBox(height: 20),
                
                // Wrap in SingleChildScrollView in case screen is small
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Shop Branch
                        _buildDropdownField("Shop Branch", ["All Branches", "Campo", "Main"]),
                        const SizedBox(height: 16),
                        
                        // Pay Period / Date Range & Employee Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Pay Period/Date Range", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(child: _buildDatePicker()),
                                      const SizedBox(width: 8),
                                      const Text("-"),
                                      const SizedBox(width: 8),
                                      Expanded(child: _buildDatePicker()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDropdownField("Employee Status", ["Active", "Inactive", "All"])),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Item Category & Shift
                        Row(
                          children: [
                            Expanded(child: _buildDropdownField("Item Category", ["All", "Packages", "Souvenirs"])),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDropdownField("Shift", ["Opening/Closing", "Morning", "Afternoon"])),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Staff Name & Service Type
                        Row(
                          children: [
                            Expanded(child: _buildDropdownField("Staff Name", ["All Staff", "Jane Admin"])),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDropdownField("Service Type", ["All", "Printing", "Custom"])),
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
                                  const Text("Threshold Level", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB0B8D0),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: const Center(child: Text("0", style: TextStyle(color: Colors.white))), // Placeholder
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDropdownField("Service Status", ["All", "Completed", "Pending"])),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Inventory Status & Log Activity Action Type
                        Row(
                          children: [
                            Expanded(child: _buildDropdownField("Inventory Status", ["All", "Low Stock", "In Stock"])),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDropdownField("Log Activity Action Type", ["All", "Login", "Transaction"])),
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Add filter logic here
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B5580), // Purple/Blue from image
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Apply Filter", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget for Dropdowns
  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        const SizedBox(height: 5),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFB0B8D0), // Blue-grey box
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(items[0], style: const TextStyle(color: Colors.white)), // Show first item
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for Date Picker simulation
  Widget _buildDatePicker() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFB0B8D0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: const [
          Icon(Icons.calendar_today, size: 16, color: Colors.white),
        ],
      ),
    );
  }
}