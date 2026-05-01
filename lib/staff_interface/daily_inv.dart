import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';

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
  // State to track which main tab is active
  String _currentTab = 'inventory'; // 'inventory', 'corrections', 'history'
  // State to track if we are actively editing/adding items in the inventory tab
  bool _isEditingInventory = false;

  // Full list of items as requested
  final List<String> _rawItems = [
    "A4 Photopaper",
    "SBP Printing",
    "LBP Printing",
    "A4 Printing",
    "2x2 ID",
    "Mix ID",
    "Long/A4 Film",
    "Short Film",
    "6r Film",
    "5r Film",
    "4r Film",
    "3r Film",
    "cute film",
    "Nametag Film",
    "Sticker Paper",
    "SBP Xerox",
    "LBP Xerox",
    "Calling Card",
    "PVC Set",
    "Double Sided Photopaper",
    "Bottle Opener Keychain",
    "Big Rectangle Keychain",
    "Small Rectangle Keychain",
    "Heart Keychain",
    "Dress Keychain",
    "Small Circle Keychain",
    "Acrylic Pin",
    "Button Pin",
    "CP Holder",
    "3r Envelope",
    "4r Envelope",
    "Frame (100)",
    "Frame (120)",
    "Frame (130)",
    "Frame (150)",
    "Frame (190)",
    "Album",
    "Certificate",
    "Ink",
    "Hotspot",
    "ID Lace",
    "Candle (180,150,120)",
    "RIngbind Spring",
    "A4 Paper Cover",
    "A4 Acetate Cover",
    "Short Paper Cover",
    "Short Acetate Cover",
  ];

  List<Map<String, String>> _inventoryItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize inventory items with default '0' values
    _inventoryItems = _rawItems
        .map(
          (item) => {
            'item': item,
            'packs': '0',
            'pieces': '0',
            'correction': '0',
            'reason': '',
          },
        )
        .toList();
  }

  // Toggles edit mode for the inventory tab
  void _toggleEditInventory() {
    setState(() {
      _isEditingInventory = !_isEditingInventory;
    });
  }

  // Saves data and resets to the default inventory view
  void _saveAndReset() {
    setState(() {
      _currentTab = 'inventory';
      _isEditingInventory = false;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF6A7585),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentTab = 'inventory';
                        _isEditingInventory = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    Expanded(child: _buildInventoryTable()),
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
              _currentTab = 'history';
            });
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
                      'Packs',
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
                      'Pieces',
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
                            item['item']!,
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
                                ? _buildInputFieldWithSpinners(item, 'packs')
                                : _buildStaticInputField(item['packs']!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: isEditable
                                ? _buildInputFieldWithSpinners(item, 'pieces')
                                : _buildStaticInputField(item['pieces']!),
                          ),
                        ),
                        if (showCorrectionColumns) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: isEditable
                                  ? _buildInputFieldWithSpinners(
                                      item,
                                      'correction',
                                    )
                                  : _buildStaticInputField(item['correction']!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: isEditable
                                ? _buildReasonInputField(item)
                                : Text(
                                    item['reason']!.isNotEmpty
                                        ? item['reason']!
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
  Widget _buildInputFieldWithSpinners(Map<String, String> item, String key) {
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
                item[key]!,
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
                      int val = int.tryParse(item[key]!) ?? 0;
                      item[key] = (val + 1).toString();
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
                      int val = int.tryParse(item[key]!) ?? 0;
                      if (val > 0) item[key] = (val - 1).toString();
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

  Widget _buildReasonInputField(Map<String, String> item) {
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