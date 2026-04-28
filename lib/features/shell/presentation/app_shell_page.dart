import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/navigation/app_module.dart';
import 'package:flutter_application_1/features/notification/presentation/notifications_page.dart';

class AppShellPage extends StatefulWidget {
  final bool isAdmin;
  final Widget child;

  const AppShellPage({
    super.key,
    required this.isAdmin,
    required this.child,
  });

  @override
  State<AppShellPage> createState() => _AppShellPageState(); // ✅ TAMA NA ITO
}

// ⚠️ DAPAT MAGTUGMA ANG PANGALAN DITO AT SA CREATESTATE
class _AppShellPageState extends State<AppShellPage> { 
  int _selectedIndex = 0;
  late List<AppModule> _menuItems;
  bool _isNotificationView = false;

  @override
  void initState() {
    super.initState();
    // Initialize menu items base sa role
    if (widget.isAdmin) {
      _menuItems = [
        AppModule.overallInventory,
        AppModule.services,
        AppModule.salary,
        AppModule.orders,
        AppModule.schedule,
        AppModule.reports,
      ];
    } else {
      // ✅ Staff Navigation line-up updated
      _menuItems = [
        AppModule.dailyInventory,    // Daily Inventory
        AppModule.services,          // Services
        AppModule.salary,            // Salary
        AppModule.consumptionTracker,// Consumption Tracker
        AppModule.customizedOrders,  // Customized Orders
        AppModule.schedule,          // Schedule
      ];
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${weekdays[now.weekday - 1]}/ ${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // --- SIDEBAR ---
          Container(
            width: 250,
            color: const Color(0xFF5A6B8A), 
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // --- LOGO SECTION ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24, 
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'logo.png', 
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.print, color: Colors.white, size: 25);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Cam2Print System",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                const Divider(color: Colors.white24, indent: 20, endIndent: 20),
                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final module = _menuItems[index];
                      final isSelected = index == _selectedIndex && !_isNotificationView;
                      return ListTile(
                        leading: Icon(
                          module.icon, 
                          color: isSelected ? Colors.black : Colors.white
                        ),
                        title: Text(
                          module.label, 
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontSize: 13,
                          )
                        ),
                        tileColor: isSelected ? const Color(0xFFE5E7EB) : Colors.transparent,
                        onTap: () => setState(() {
                          _selectedIndex = index;
                          _isNotificationView = false;
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // --- MAIN CONTENT AREA ---
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8FB9FF), Color(0xFFEAEFF8)],
                ),
              ),
              child: Column(
                children: [
                  // --- TOP HEADER ---
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85), 
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_getFormattedDate(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.notifications, 
                                  color: _isNotificationView ? Colors.blue : Colors.black
                                ),
                                onPressed: () => setState(() => _isNotificationView = true),
                              ),
                              const SizedBox(width: 20),
                              const CircleAvatar(
                                backgroundColor: Colors.black, 
                                child: Icon(Icons.person, color: Colors.white, size: 20)
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ✅ DYNAMIC NAME: 'Admin' or 'Staff'
                                  Text(
                                    widget.isAdmin ? 'Admin' : 'Staff', 
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 13, 
                                      height: 1.0,
                                      color: Colors.black
                                    )
                                  ),
                                  const SizedBox(height: 2),
                                  // ✅ DYNAMIC ROLE: 'Admin' or 'Staff'
                                  Text(
                                    widget.isAdmin ? 'Admin' : 'Staff', 
                                    style: const TextStyle(
                                      color: Colors.black54, 
                                      fontSize: 11
                                    )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- DYNAMIC PAGE BODY ---
                  Expanded(
                    child: _isNotificationView 
                      ? NotificationPage(isAdmin: widget.isAdmin) 
                      : widget.child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}