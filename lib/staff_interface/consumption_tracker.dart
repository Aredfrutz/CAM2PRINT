import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:flutter_application_1/staff_interface/order_service.dart';  // Full pathimport 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ConsumptionTracker extends StatefulWidget {
  const ConsumptionTracker({super.key});

  @override
  State<ConsumptionTracker> createState() => _ConsumptionTrackerState();
}

class _ConsumptionTrackerState extends State<ConsumptionTracker> {
  String _activeCategory = 'Printing';
  bool _isSaving = false;
  
  // ✅ Use the singleton service instead of local list
  final OrderService _orderService = OrderService();

  // Helper to get current orders (for UI)
  List<Map<String, dynamic>> get currentOrders => _orderService.orders;

  void _addItem(String name) {
    _orderService.addItem(name);
    setState(() {}); // Refresh UI
  }

  void _incrementItem(int index) {
    _orderService.incrementItem(index);
    setState(() {});
  }

  void _decrementItem(int index) {
    _orderService.decrementItem(index);
    setState(() {});
  }

  void _removeItem(int index) {
    _orderService.removeItem(index);
    setState(() {});
  }

  void _clearAllItems() {
    _orderService.clearAll();
    setState(() {});
  }

  Future<void> _saveAndFinish() async {
    if (_isSaving || _orderService.isEmpty) return;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      setState(() => _isSaving = true);
      
      // ✅ 1. Get user's full name from profiles
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();

      final fullName = (profile['full_name'] ?? 'Staff').toString();
      
      // ✅ 2. Get TODAY's branch assignment from branch_assignments table
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // ✅ FIXED: Use proper .or() syntax with filter
      final assignment = await Supabase.instance.client
          .from('branch_assignments')
          .select('branch_name')
          .eq('assignment_date', today)
          .filter('opening_staff_id', 'eq', user.id)
          .or('closing_staff_id.eq.${user.id}')
          .maybeSingle();
      
      final branch = assignment?['branch_name'] ?? '';
      
      if (branch.isEmpty) {
        throw Exception('No branch assigned for today. Please check your schedule.');
      }

      final missingItems = <String>[];

      // ✅ Use a copy of orders to iterate safely
      for (final order in List<Map<String, dynamic>>.from(_orderService.orders)) {
        final itemName = (order['name'] ?? '').toString().trim();
        final consumedQty = (order['count'] ?? 0) as int;
        if (itemName.isEmpty || consumedQty <= 0) continue;

        // 3. Fetch current inventory item
        final rows = await Supabase.instance.client
            .from('inventory')
            .select('id, pieces, packs')
            .eq('item_name', itemName)
            .eq('branch_name', branch)
            .limit(1);

        if (rows.isEmpty) {
          missingItems.add(itemName);
          continue;
        }

        final inventory = Map<String, dynamic>.from(rows.first);
        final currentPieces = int.tryParse((inventory['pieces'] ?? 0).toString()) ?? 0;
        final currentPacks = int.tryParse((inventory['packs'] ?? 0).toString()) ?? 0;
        
        // Calculate new values (ensure non-negative)
        final newPieces = (currentPieces - consumedQty).clamp(0, 999999999);
        final newPacks = currentPacks;

        // 4. Update the main inventory table
        await Supabase.instance.client
            .from('inventory')
            .update({
              'pieces': newPieces,
              'last_updated_by': fullName,
            })
            .eq('id', inventory['id'].toString());

        // ✅ 5. Insert into inventory_history
        await Supabase.instance.client.from('inventory_history').insert({
          'inventory_id': inventory['id'],
          'item_name': itemName,
          'branch_name': branch,
          'old_packs': currentPacks,
          'new_packs': newPacks,
          'old_pieces': currentPieces,
          'new_pieces': newPieces,
          'action_type': 'Consumption Deduction',
          'reason': 'Deduct from Consumption Tracker',
          'updated_by': fullName,
        });

        // 6. Log in consumption_logs (matching your actual table structure)
        await Supabase.instance.client.from('consumption_logs').insert({
          'item_name': itemName,
          'category': _activeCategory,
          'quantity_used': consumedQty,
          'total_price': 0,
        });
      }

      if (!mounted) return;
      
      // ✅ ONLY clear after successful save
      _orderService.clearAll();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: missingItems.isEmpty ? Colors.green : Colors.orange,
          content: Text(
            missingItems.isEmpty
                ? '✅ Consumption saved! Inventory updated and logged in history.'
                : '⚠️ Saved with warnings. Missing in inventory: ${missingItems.join(', ')}',
          ),
        ),
      );

      Navigator.pushReplacementNamed(context, AppRouter.staffDailyInv);
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to save consumption: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ... [Keep _navigateTo, _buildSidebarItem, build(), _buildCategoryTab, _buildOrderItem EXACTLY AS THEY ARE] ...
  // Just replace all references to `currentOrders` with `_orderService.orders` where needed

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      isActive: true,
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
                          Text(
                            DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
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

                    // ✅ Content - FIXED BRACKET STRUCTURE
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
                                    "$_activeCategory Orders",
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
                                      children: [
                                        // ✅ A4 Photopaper Box
                                        InkWell(
                                          onTap: () => _addItem("A4 Photopaper"),
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.05),
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "A4 Photopaper",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF2E3A59),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // ✅ Other sample items
                                        ...List.generate(7, (index) {
                                          return InkWell(
                                            onTap: () => _addItem("Item ${index + 2}"),
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(alpha: 0.05),
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Item ${index + 2}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF2E3A59),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
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
                                      color: Colors.black.withValues(alpha: 0.1),
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
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                      child: currentOrders.isEmpty
                                          ? const Center(
                                              child: Text(
                                                "No items added yet.\nClick a box to add items.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          : ListView.builder(
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
                                            backgroundColor: const Color(0xFF00C853),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: _isSaving || currentOrders.isEmpty
                                              ? null
                                              : _saveAndFinish,
                                          child: _isSaving
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text(
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
                    ), // ✅ Closes Expanded that wraps Padding
                  ], // ✅ Closes Column children
                ), // ✅ Closes Column
              ), // ✅ Closes Container with padding: EdgeInsets.all(25)
            ), // ✅ Closes Expanded that wraps Container
          ], // ✅ Closes Row children (sidebar + main content)
        ), // ✅ Closes Row
      ), // ✅ Closes Container with gradient
    ); // ✅ Closes Scaffold
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
                    color: Colors.black.withValues(alpha: 0.1),
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