import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';

// 1. DATA MODEL
class NotificationModel {
  final int id;
  final String date;
  final String shop;
  final String staffName;
  final String details;
  final String amount;
  final String reason;

  NotificationModel({
    required this.id,
    required this.date,
    required this.shop,
    required this.staffName,
    required this.details,
    this.amount = "0.00",
    this.reason = "No reason provided",
  });
}

class NotificationPage extends StatefulWidget {
  final bool isAdmin;
  const NotificationPage({super.key, required this.isAdmin});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // 2. MUTABLE LIST
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 1,
      date: "04/20/2026",
      shop: "Campo",
      staffName: "Shamel Lacuesta",
      details: "Cash Advance Request",
      amount: "500.00",
      reason: "Emergency transportation funds.",
    ),
    NotificationModel(
      id: 2,
      date: "04/21/2026",
      shop: "SM North",
      staffName: "Jane Doe",
      details: "Supply Requisition",
      amount: "1,200.00",
      reason: "Need more ink and glossy paper.",
    ),
    NotificationModel(
      id: 3,
      date: "04/25/2026",
      shop: "Fairview",
      staffName: "John Smith",
      details: "Maintenance Alert",
      reason: "Printer head needs cleaning.",
    ),
  ];

  // FUNCTIONAL DELETE LOGIC
  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((item) => item.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Notification deleted"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _navigateTo(String pageName) {
    String? routeName;
    if (widget.isAdmin) {
      switch (pageName) {
        case 'Staff Management':
          routeName = AppRouter.adminStaffManagement;
          break;
        case 'Overall Inventory':
          routeName = AppRouter.adminServices;
          break;
        case 'Services':
          routeName = AppRouter.adminServices;
          break;
        case 'Salary':
          routeName = AppRouter.adminServices;
          break;
        case 'Customized Orders':
          routeName = AppRouter.adminCustomOrders;
          break;
        case 'Schedule':
          routeName = AppRouter.adminSchedule;
          break;
        case 'Reports':
          routeName = AppRouter.adminreports;
          break;
        case 'Notifications':
          routeName = AppRouter.notifications;
          break;
      }
    } else {
      switch (pageName) {
        case 'Daily Inventory':
          routeName = AppRouter.staffDailyInv;
          break;
        case 'Services':
          routeName = AppRouter.staffServices;
          break;
        case 'Salary':
          routeName = AppRouter.staffServices;
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
    }

    if (routeName != null) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: routeName == AppRouter.notifications ? widget.isAdmin : null,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$pageName page is not connected yet.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ✅ ADMIN/STAFF STYLE SIDEBAR ITEM
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isAdmin
                ? const [Color(0xFF9FA8DA), Color(0xFFFFFFFF)]
                : const [Color(0xFF7C88C2), Color(0xFFFFFFFF)],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ FIX: Stretch row height
          children: [
            // ✅ SIDEBAR - Staff/Admin Style Applied
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
              ),
              child: Container(
                width: 240,
                height: double.infinity, // ✅ FIX: Force full height
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5B6388), Color(0xFF3E4563)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max, // ✅ FIX: Expand to fill height
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
                    
                    // ✅ ADMIN NAVIGATION
                    if (widget.isAdmin) ...[
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
                      _buildSidebarItem(
                        Icons.error_outline,
                        "Reports",
                        () => _navigateTo('Reports'),
                      ),
                    ] 
                    // ✅ STAFF NAVIGATION
                    else ...[
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
                    ],
                    
                    const Spacer(), // ✅ Pushes logout to bottom
                    
                    // ✅ LOGOUT BUTTON - Staff Style
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
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isAdmin ? 25 : 30,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isAdmin
                            ? const Color(0xFFE3F2FD)
                            : const Color(0xFFB3D4FF),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.isAdmin
                                ? "Saturday/ January 31, 2026"
                                : "Saturday, January 31, 2026",
                            style: const TextStyle(
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Jane",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                  Text(
                                    widget.isAdmin ? "Admin" : "Staff",
                                    style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF4A5777),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  _headerText('Date', 2),
                                  _headerText('Shop', 2),
                                  _headerText('Staff', 3),
                                  _headerText('Details', 4),
                                  const SizedBox(width: 40),
                                  if (widget.isAdmin) const SizedBox(width: 70),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: _notifications.isEmpty
                                    ? const Center(
                                        child: Text("No notifications found"),
                                      )
                                    : ListView.separated(
                                        itemCount: _notifications.length,
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                        itemBuilder: (context, index) {
                                          final item = _notifications[index];
                                          return _buildNotificationRow(
                                            context,
                                            item,
                                          );
                                        },
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerText(String label, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildNotificationRow(BuildContext context, NotificationModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          // DYNAMIC DATA
          Expanded(flex: 2, child: _dataBox(item.date)),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: _dataBox(item.shop)),
          const SizedBox(width: 10),
          Expanded(flex: 3, child: _dataBox(item.staffName)),
          const SizedBox(width: 10),
          Expanded(flex: 4, child: _dataBox(item.details)),
          const SizedBox(width: 10),

          // ✅ ACTION BUTTONS ON THE RIGHT SIDE

          // 1. VIEW BUTTON (Admin Only)
          if (widget.isAdmin) ...[
            GestureDetector(
              onTap: () => _showDetailsForm(context, item),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF81C784),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'VIEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],

          // 2. FUNCTIONAL DELETE ICON (Para sa lahat)
          GestureDetector(
            onTap: () => _deleteNotification(item.id),
            child: const Icon(Icons.delete, color: Colors.red, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _dataBox(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF6A7B9C).withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Colors.black87),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // DIALOG FORM (Admin View)
  void _showDetailsForm(BuildContext context, NotificationModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          item.details,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _formLabel("DATE OF REQUEST"),
            _formField(item.date, icon: Icons.calendar_today),
            const SizedBox(height: 15),
            _formLabel("REQUESTED AMOUNT"),
            _formField(item.amount),
            const SizedBox(height: 15),
            _formLabel("REASON / CONCERN"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(item.reason, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                  ),
                  child: const Text(
                    "Reject",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                  ),
                  child: const Text(
                    "Approve",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
  );

  Widget _formField(String value, {IconData? icon}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value, style: const TextStyle(fontSize: 13)),
        if (icon != null) Icon(icon, size: 16, color: Colors.grey[600]),
      ],
    ),
  );
}