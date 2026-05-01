import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';

class ConsumptionTracker extends StatefulWidget {
  const ConsumptionTracker({super.key});

  @override
  State<ConsumptionTracker> createState() => _ConsumptionTrackerState();
}

class _ConsumptionTrackerState extends State<ConsumptionTracker> {
  String _activeCategory = 'Printing';

  // State for the "Current Order" list
  List<Map<String, dynamic>> currentOrders = [
    {'name': 'Sample Order', 'count': 1},
    {'name': 'Sample Order', 'count': 2},
  ];

  void _addItem(String name) {
  setState(() {
    // ✅ Check if item already exists in currentOrders
    final existingIndex = currentOrders.indexWhere((item) => item['name'] == name);
    
    if (existingIndex != -1) {
      // ✅ Item exists, just increment the count
      currentOrders[existingIndex]['count'] = (currentOrders[existingIndex]['count'] as int) + 1;
    } else {
      // ✅ Item doesn't exist, add new row
      currentOrders.add({'name': name, 'count': 1});
    }
  });
}

  void _incrementItem(int index) {
    setState(() {
      currentOrders[index]['count']++;
    });
  }

  void _decrementItem(int index) {
    setState(() {
      if (currentOrders[index]['count'] > 0) {
        currentOrders[index]['count']--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      currentOrders.removeAt(index);
    });
  }

  void _clearAllItems() {
    setState(() {
      currentOrders.clear();
    });
  }

  void _navigateTo(String pageName) {
    String? routeName;
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

  // ✅ ADMIN/DAILYINV STYLE SIDEBAR ITEM
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
            colors: [Color(0xFF7C88C2), Color(0xFFFFFFFF)],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ FIX: Stretch row height
          children: [
            // ✅ SIDEBAR - DailyInv Style Applied
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
                    
                    // ✅ STAFF NAVIGATION - DailyInv Style
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
                      isActive: true, // ✅ Active highlight
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
                    
                    const Spacer(), // ✅ Pushes logout to bottom
                    
                    // ✅ LOGOUT BUTTON - DailyInv Style
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
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
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
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.staffProfile,
                                ),
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
                    const SizedBox(height: 20),

                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LEFT SIDE
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                  "${_activeCategory} Orders",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E3A59),
                                  ),
                                ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      _buildCategoryTab("Printing"),
                                      const SizedBox(width: 8),
                                      _buildCategoryTab("Xerox/Photocopy"),
                                      const SizedBox(width: 8),
                                      _buildCategoryTab("School Supplies"),
                                      const SizedBox(width: 8),
                                      _buildCategoryTab("Party Needs"),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Expanded(
                                    child: GridView.count(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 1.5,
                                      children: List.generate(8, (index) {
                                        return InkWell(
                                          onTap: () =>
                                              _addItem("Item ${index + 1}"),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.05),
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 24),

                            // RIGHT SIDE
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF2C3E87),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Current Order",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            onTap: _clearAllItems,
                                            child: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(16),
                                        itemCount: currentOrders.length,
                                        itemBuilder: (context, index) {
                                          return _buildOrderItem(index);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF00C853,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            "Save and Finish",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
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
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPER METHODS =================

  Widget _buildCategoryTab(String label) {
    bool isActive = _activeCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _activeCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isActive ? Border.all(color: Colors.transparent) : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.black54,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(int index) {
    final order = currentOrders[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                order['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E3A59),
                ),
              ),
            ),
            // Remove Item Button (Small X next to name)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 16),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _removeItem(index),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // MINUS BUTTON
            InkWell(
              onTap: () => _decrementItem(index),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7EB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    "-",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "${order['count']}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(width: 12),
            // PLUS BUTTON
            InkWell(
              onTap: () => _incrementItem(index),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7EB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    "+",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 25),
      ],
    );
  }
}