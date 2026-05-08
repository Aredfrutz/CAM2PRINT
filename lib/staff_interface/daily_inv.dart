import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ConverprintApp());
}

class ConverprintApp extends StatelessWidget {
  const ConverprintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camprint System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFA5C9FF),
      ),
      home: const DailyInventoryPage(),
    );
  }
}

class DailyInventoryPage extends StatefulWidget {
  const DailyInventoryPage({super.key});

  @override
  State<DailyInventoryPage> createState() => _DailyInventoryPageState();
}

class _DailyInventoryPageState extends State<DailyInventoryPage> {
  String _currentTab = 'inventory';
  bool _isEditingInventory = false;
  List<Map<String, dynamic>> _inventoryItems = []; 
  bool _isLoading = true;

  // ✅ ADDED THESE TWO VARIABLES TO FIX YOUR ERRORS
  String _userName = 'Loading...'; 
  String _userRole = 'Staff';
  DateTime _selectedFilterDate = DateTime.now();

// Since History items have different keys than Live items, use this:
String getDisplayValue(Map<String, dynamic> item, String liveKey, String historyKey) {
  if (_currentTab == 'history') {
    return item[historyKey]?.toString() ?? '0';
  }
  return item[liveKey]?.toString() ?? '0';
}

@override
  void initState() {
    super.initState();
    _fetchInventoryFromSupabase(); 
  }

  Future<void> _fetchInventoryFromSupabase() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        print("No user logged in");
        return;
      }

      // 1. Fetch profile from the 'profiles' table using the Auth ID
      final profileData = await Supabase.instance.client
          .from('profiles')
          .select('full_name, employment_status, assigned_branch')
          .eq('id', user.id)
          .single();

      // 2. Update UI variables with data from Supabase
      setState(() {
        _userName = profileData['full_name'] ?? 'Unknown User';
        _userRole = profileData['employment_status'] ?? 'Staff';
      });

      // 3. Fetch Inventory based on the branch assigned in the profile[cite: 1]
      final inventoryData = await Supabase.instance.client
          .from('inventory')
          .select()
          .eq('branch_name', profileData['assigned_branch']) 
          .order('item_name', ascending: true);

      setState(() {
        _inventoryItems = List<Map<String, dynamic>>.from(inventoryData);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _userName = "Error";
        _isLoading = false;
      });
    }
  }

Future<void> _fetchHistory({DateTime? filterDate}) async {
  setState(() {
    _isLoading = true;
    _currentTab = 'history';
  });

  try {
    // 1. Create the base query
    var query = Supabase.instance.client
        .from('inventory_history')
        .select();

    // 2. Only add date filters if a date is provided
    if (filterDate != null) {
      String startOfDay = DateTime(filterDate.year, filterDate.month, filterDate.day).toIso8601String();
      String endOfDay = DateTime(filterDate.year, filterDate.month, filterDate.day, 23, 59, 59).toIso8601String();
      
      query = query.gte('created_at', startOfDay).lte('created_at', endOfDay);
    }

    // 3. Execute the query with ordering
    final data = await query.order('created_at', ascending: false);

    setState(() {
      _inventoryItems = List<Map<String, dynamic>>.from(data);
      _isLoading = false;
    });
  } catch (e) {
    debugPrint('Error fetching history: $e');
    setState(() => _isLoading = false);
  }
}

  // Toggles edit mode for the inventory tab
  void _toggleEditInventory() {
    setState(() {
      _isEditingInventory = !_isEditingInventory;
    });
  }

Future<void> _saveAndReset() async {
  if (_currentTab == 'history') return; 
  
  setState(() => _isLoading = true);
  
  try {
    for (var item in _inventoryItems) {
      // 1. Fetch current values to check for changes
      final currentData = await Supabase.instance.client
          .from('inventory')
          .select('packs, pieces')
          .eq('id', item['id'].toString()) // ✅ Ensure it's a string for the UUID query
          .single();

      int oldPacks = currentData['packs'] ?? 0;
      int oldPieces = currentData['pieces'] ?? 0;

      // 2. Only proceed if the user actually changed the numbers
      if (oldPacks != item['packs'] || oldPieces != item['pieces']) {
        
        // Update the main inventory table
        await Supabase.instance.client
            .from('inventory')
            .update({
              'packs': item['packs'],
              'pieces': item['pieces'],
              'last_updated_by': _userName,
            })
            .eq('id', item['id'].toString()) // ✅ Match the UUID string
            .select(); // ✅ Adding .select() helps verify if the update actually hit a row
        // Insert the log into history
        await Supabase.instance.client.from('inventory_history').insert({
          'inventory_id': item['id'],
          'item_name': item['item_name'],
          'old_packs': oldPacks,
          'new_packs': item['packs'],
          'old_pieces': oldPieces,
          'new_pieces': item['pieces'],
          'action_type': _currentTab == 'corrections' ? 'Correction' : 'Manual Update',
          'reason': item['reason'] ?? '',
          'updated_by': _userName,
        });
      }
    }

    // ✅ FIX 1: Show the success message after the loop finishes
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inventory updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }

  } catch (e) {
    // ✅ FIX 2: Catch errors (like RLS issues) and show them
    debugPrint('Save Error: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    // ✅ FIX 3: Always stop the loading spinner and exit edit mode
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEditingInventory = false;
        _currentTab = 'inventory';
      });
      // Refresh data to show the latest values from the server
      _fetchInventoryFromSupabase(); 
    }
  }
}

Future<void> _showFilterDialog() async {
    // 1. Show the built-in Flutter Date Picker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4B5580), // Header background
              onPrimary: Colors.white,    // Header text
              onSurface: Color(0xFF1A237E), // Body text
            ),
          ),
          child: child!,
        );
      },
    );

    // 2. If the user picked a date, update the state and fetch new data
    if (picked != null && picked != _selectedFilterDate) {
      setState(() {
        _selectedFilterDate = picked;
      });
      
      // Call your fetch history function with the selected date
      _fetchHistory(filterDate: picked);
    }
  }

  // ✅ ADMIN-STYLE SIDEBAR ITEM (for staff pages too)
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
            // ✅ SIDEBAR - Admin Style Applied
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
                    
                    // ✅ STAFF NAVIGATION - Admin Style
                    _buildSidebarItem(
                      Icons.inventory_2,
                      "Daily Inventory",
                      () => _navigateTo('Daily Inventory'),
                      isActive: _currentTab == 'inventory', // ✅ Active highlight
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
                    
                    const Spacer(), // ✅ Pushes logout to bottom
                    
                    // ✅ LOGOUT BUTTON - Admin Style
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
                                  Text(
                                    _userName, // Use a variable here!
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                  Text(
                                    _userRole, // Use a variable here!
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
                    // Controls row
                    if (_currentTab == 'history')
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'History',
                              style: TextStyle(
                                color: Color(0xFF55A888),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _showFilterDialog,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF55A888),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Filter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _currentTab == 'inventory'
                                ? _toggleEditInventory()
                                : _saveAndReset(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE05555),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                (_currentTab == 'inventory' &&
                                        !_isEditingInventory)
                                    ? 'Add/Edit Packs or Pieces'
                                    : 'Save Items',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          _buildRightSideButtons(),
                        ],
                      ),
                    const SizedBox(height: 12),
                    // Content
                    Expanded(
                      child: _isLoading 
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1A237E),
                          ),
                        )
                      : _buildInventoryTable(),
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

  Widget _buildRightSideButtons() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _currentTab = 'corrections';
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _currentTab == 'corrections'
                  ? Colors.white
                  : const Color(0xFF55A888),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Corrections',
              style: TextStyle(
                color: _currentTab == 'corrections'
                    ? const Color(0xFF55A888)
                    : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditingInventory = false; // Usually history isn't editable
             });
            _fetchHistory(); // 👈 Call the function here!
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _currentTab == 'history'
                  ? Colors.white
                  : const Color(0xFF55A888),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'History',
              style: TextStyle(
                color: _currentTab == 'history'
                    ? const Color(0xFF55A888)
                    : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryTable() {
    // Determine if we should show the Correction columns
    bool showCorrectionColumns =
        (_currentTab == 'corrections' || _currentTab == 'history');

    // Determine if we should show spinners/inputs (editable mode)
    bool isEditable =
        (_currentTab == 'inventory' && _isEditingInventory) ||
        _currentTab == 'corrections' ||
        (_currentTab == 'history' && _isEditingInventory);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB0C4DE)),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF4B5580),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      _currentTab == 'history' ? 'Old / New' : 'Packs', // ✅ Swaps label
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      _currentTab == 'history' ? 'Old / New' : 'Pieces', // ✅ Swaps label
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (showCorrectionColumns) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Correction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        'Reason for Correction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Table Body
          Expanded(
            child: ListView.builder(
              itemCount: _inventoryItems.length,
              itemBuilder: (context, index) {
                final item = _inventoryItems[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFB0C4DE),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            // Use 'item_name' if that is what your Supabase column is called
                            item['item_name']?.toString() ?? 'Unnamed Item',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: isEditable
                                ? _buildInputFieldWithSpinners(item, _currentTab == 'history' ? 'new_packs' : 'packs')
                                : _buildStaticInputField(
                                    _currentTab == 'history' 
                                    // ✅ This shows the transition: "22 → 27"
                                      ? "${item['old_packs'] ?? 0} → ${item['new_packs'] ?? 0}" 
                                      : item['packs']?.toString() ?? '0'
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: isEditable
                                ? _buildInputFieldWithSpinners(item, _currentTab == 'history' ? 'new_pieces' : 'pieces')
                                : _buildStaticInputField(
                                    _currentTab == 'history' 
                                    // ✅ This shows the transition: "27 → 30"
                                      ? "${item['old_pieces'] ?? 0} → ${item['new_pieces'] ?? 0}" 
                                      : item['pieces']?.toString() ?? '0'
                                ),
                          ),
                        ),
                        if (showCorrectionColumns) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: isEditable
                                  ? _buildInputFieldWithSpinners(item, 'correction')
                                  : _buildStaticInputField(item['correction']?.toString() ?? '0'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: isEditable
                                ? _buildReasonInputField(item)
                                : Text(
                                    // Check if reason exists and is not empty
                                    (item['reason'] != null && item['reason'].toString().isNotEmpty)
                                      ? item['reason'].toString()
                                      : '-',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF334155),
                                      fontSize: 13,
                                    ),
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Simple gray box without spinners (Used when just viewing in Inventory mode)
  Widget _buildStaticInputField(String value) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF7C85A0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Input box with up/down arrows (Used in Edit/Correction/History mode)
  Widget _buildInputFieldWithSpinners(Map<String, dynamic> item, String key) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF7C85A0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                item[key]?.toString() ?? '0', // ✅ Safe conversion
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            width: 24,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF6A7590),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // Force it to a string first, then parse to int to do math
                      int val = int.tryParse(item[key].toString()) ?? 0;
                      item[key] = val + 1; // Store it back as an int for Supabase
                    });
                  },
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xFF5A6580),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      size: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // Force it to a string first, then parse to int to do math
                      int val = int.tryParse(item[key].toString()) ?? 0;
                      if (val > 0) { // ✅ FIX: Prevent negative numbers
                      item[key] = val - 1; // Store it back as an int for Supabase
                      }
                    });
                  },
                  child: SizedBox(
                    height: 14,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonInputField(Map<String, dynamic> item) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF7C85A0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 0,
          ),
          hintText: 'Enter reason...',
          hintStyle: const TextStyle(color: Colors.white54),
        ),
        onChanged: (value) {
          setState(() {
            item['reason'] = value;
          });
        },
      ),
    );
  }

  void _navigateTo(String pageName) {
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
}