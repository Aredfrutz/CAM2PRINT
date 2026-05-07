import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';


class CustomizedOrdersPages extends StatefulWidget {
  const CustomizedOrdersPages({super.key});

  @override
  State<CustomizedOrdersPages> createState() => _CustomizedOrdersPageState();
}

class _CustomizedOrdersPageState extends State<CustomizedOrdersPages> {
  String _activeItem = 'Packages';
  bool showTrackSaved = false;
  bool isMoreDropdownOpen = false;
  OverlayEntry? _moreOverlayEntry;
  bool showFloatingOrderDetails = false;
  Map<String, dynamic>? activeFloatingOrder;
  bool showRemainingBalanceInput = false;

final Map<String, TextEditingController> _dynamicControllers = {
    'name': TextEditingController(),
    'church': TextEditingController(),
    'theme': TextEditingController(),
    'package': TextEditingController(), // Added for "What Package"
    'reception': TextEditingController(),
    'additional': TextEditingController(),
    'details': TextEditingController(), // For "Additional Details"
    'downPayment': TextEditingController(),
    'balance': TextEditingController(),
    'occasion': TextEditingController(),
};

DateTime? _selectedEventDate;
  // ✅ ADDED THESE TWO VARIABLES TO FIX YOUR ERRORS
  String _userName = 'Loading...'; 
  String _userRole = 'Staff';
  
Future<void> _saveOrderToSupabase() async {
  final String currentItem = _activeItem; 
  
  try {
    await Supabase.instance.client.from('customized_orders').insert({
      'order_type': currentItem,
      'staff_name': _userName,
      
      // ✅ Name logic: 'None' for T-shirt/Chipbag
      'customer_name': (currentItem == 'T-shirt' || currentItem == 'Chipbag') 
          ? 'None' 
          : (_dynamicControllers['name']!.text.isEmpty ? 'None' : _dynamicControllers['name']!.text),

      // ✅ Church logic: Only for Packages/Invitations
      'church': (currentItem == 'Packages' || currentItem == 'Invitation') 
          ? (_dynamicControllers['church']!.text.isEmpty ? 'None' : _dynamicControllers['church']!.text)
          : 'None',

      // ✅ Occasion logic: Only for Souvenir/Ref Magnet
      'occasion_type': (currentItem == 'Souvenir' || currentItem == 'Ref Magnet') 
          ? (_dynamicControllers['occasion']!.text.isEmpty ? 'None' : _dynamicControllers['occasion']!.text)
          : 'None',

      'additional_custom_order': _dynamicControllers['additional']!.text.isEmpty ? 'None' : _dynamicControllers['additional']!.text,
      'theme': _dynamicControllers['theme']!.text.isEmpty ? 'None' : _dynamicControllers['theme']!.text,
      'reception': _dynamicControllers['reception']!.text.isEmpty ? 'None' : _dynamicControllers['reception']!.text,
      'event_date': _selectedEventDate?.toIso8601String(),
      'down_payment': double.tryParse(_dynamicControllers['downPayment']!.text) ?? 0,
      'balance': double.tryParse(_dynamicControllers['balance']!.text) ?? 0,
      'payment_status': 'Unpaid',
      
      // ✅ Store T-shirt/Chipbag info in JSON
      'specific_details': {
        'item_details': _dynamicControllers['details']?.text ?? 'None',
      },
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Uploaded!')));
  } catch (e) {
    debugPrint("Error saving to Supabase: $e");
  }
}

  // SAVED ORDERS LIST
  final List<Map<String, dynamic>> savedOrders = [
    // Main Categories
    {
      'item': 'Package 1',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Packages',
    },
    {
      'item': 'Souvenir',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Souvenir',
    },
    {
      'item': 'Invitation',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Invitation',
    },
    {
      'item': 'Candle',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Candle',
    },
    {
      'item': 'Ref Magnet',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Ref Magnet',
    },
    // "More" Items
    {
      'item': 'T-shirt',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'T-shirt',
    },
    {
      'item': 'Chip Bag',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Chip Bag',
    },
    {
      'item': 'Button Badge',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Button Badge',
    },
    {
      'item': 'Button Pin',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Button Pin',
    },
    {
      'item': 'Party Hat',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Party Hat',
    },
    {
      'item': 'Jigsaw Puzzle',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Jigsaw Puzzle',
    },
    {
      'item': 'Banner',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Banner',
    },
    {
      'item': 'Calendar',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Calendar',
    },
    {
      'item': 'Hair Brush',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Hair Brush',
    },
    {
      'item': 'Clock',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱ 0.00',
      'type': 'Clock',
    },
  ];

  final List<String> mainTabs = [
    "Packages",
    "Souvenir",
    "Invitation",
    "Candle",
    "Ref Magnet",
    "T-shirt",
    "Chip Bag",
  ];

  final List<String> moreItems = [
    "Button Badge",
    "Button Pin",
    "Party Hat",
    "Jigsaw Puzzle",
    "Banner",
    "Calendar",
    "Hair Brush",
    "Clock",
  ];

  void _selectItem(String item) {
    setState(() {
      _activeItem = item;
      _closeMoreMenu();
      showTrackSaved = false;
      showFloatingOrderDetails = false;
    });
  }

  void _toggleMoreMenu(BuildContext context) {
    if (_moreOverlayEntry != null) {
      _closeMoreMenu();
    } else {
      _showMoreMenu(context);
    }
  }

  void _showMoreMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    _moreOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + button.size.height + 5,
        left: position.dx,
        child: Material(color: Colors.transparent, child: _buildDropdownMenu()),
      ),
    );
    Overlay.of(context).insert(_moreOverlayEntry!);
    setState(() => isMoreDropdownOpen = true);
  }

  void _closeMoreMenu() {
    _moreOverlayEntry?.remove();
    _moreOverlayEntry = null;
    setState(() => isMoreDropdownOpen = false);
  }

  @override
  void dispose() {
    _closeMoreMenu();
    super.dispose();
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
                    ),
                    _buildSidebarItem(
                      Icons.shopping_bag,
                      "Customized Orders",
                      () => _navigateTo('Customized Orders'),
                      isActive: true, // ✅ Active highlight
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
                    const SizedBox(height: 16),
                    
                    // Page content (tabs + form)
                    Expanded(
                      child: Column(
                        children: [
                          _buildTopBar(),
                          const SizedBox(height: 16),
                          Expanded(
                            child: showFloatingOrderDetails
                                ? _buildFloatingOrderDetailsView()
                                : (showTrackSaved
                                    ? _buildTrackSavedView()
                                    : _buildFormView()),
                          ),
                        ],
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

  Widget _buildFloatingOrderDetailsView() {
    final isSouvenir = activeFloatingOrder?['item'] == 'Souvenir';
    final isCandle = activeFloatingOrder?['item'] == 'Candle';
    final isRefMagnet = activeFloatingOrder?['item'] == 'Ref Magnet';
    final isTshirtOrChipBag =
        activeFloatingOrder?['item'] == 'T-shirt' ||
        activeFloatingOrder?['item'] == 'Chip Bag';
    final isButtonBadge = activeFloatingOrder?['item'] == 'Button Badge';
    final isButtonPin = activeFloatingOrder?['item'] == 'Button Pin';
    final isPartyHat = activeFloatingOrder?['item'] == 'Party Hat';
    final isJigsawPuzzle = activeFloatingOrder?['item'] == 'Jigsaw Puzzle';
    final isBanner = activeFloatingOrder?['item'] == 'Banner';
    final isCalendarOrClock =
        activeFloatingOrder?['item'] == 'Calendar' ||
        activeFloatingOrder?['item'] == 'Clock';
    final isHairBrush = activeFloatingOrder?['item'] == 'Hair Brush';

    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() => showFloatingOrderDetails = false),
          child: Container(color: Colors.black.withValues(alpha: 0.2)),
        ),
        Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${activeFloatingOrder?['item'] ?? 'Order Details'}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            setState(() => showFloatingOrderDetails = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // --- CONDITIONAL LAYOUTS (All readOnly: true) ---
                  // 1. CANDLE
                  if (isCandle) ...[
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      readOnly: true,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter order info here.....",
                        filled: true,
                        fillColor: const Color(0xFFB0B8D0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _formRow(
                      "Downpayment",
                      "Remaining Balance",
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 2. SOUVENIR
                  else if (isSouvenir) ...[
                    _formRow("Name", "Event Date", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Theme", "Occasion Type", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow(
                      "Down Payment",
                      "Remaining Balance",
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 3. REF MAGNET
                  else if (isRefMagnet) ...[
                    _formRow("Name", "Event Date", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Theme", "Occasion Type", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Reception Venue", "", readOnly: true),
                    const SizedBox(height: 12),
                    _buildTextArea(
                      "Additional Details",
                      "Enter any additional details here.....",
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    _formRow(
                      "Down Payment",
                      "Remaining Balance",
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 4. T-SHIRT & CHIP BAG
                  else if (isTshirtOrChipBag) ...[
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      readOnly: true,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter details here.....",
                        filled: true,
                        fillColor: const Color(0xFFB0B8D0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downpayment",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 5. BUTTON BADGE
                  else if (isButtonBadge) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downpayment",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 6. BUTTON PIN
                  else if (isButtonPin) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downpayment",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 7. PARTY HAT
                  else if (isPartyHat) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Theme",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downpayment",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 8. JIGSAW PUZZLE
                  else if (isJigsawPuzzle) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Theme",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downpayment",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 9. BANNER
                  else if (isBanner) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downpayment",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 10. CALENDAR & CLOCK
                  else if (isCalendarOrClock) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downpayment",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 11. HAIR BRUSH
                  else if (isHairBrush) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downpayment",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Balance",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E3A59),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]
                  // 12. DEFAULT (Package 1, Invitation, etc.)
                  else ...[
                    _formRow("Name", "Event Date", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Theme", "What Package", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Reception Venue", "Church Venue", readOnly: true),
                    const SizedBox(height: 12),
                    _buildTextArea(
                      "Additional Details",
                      "Enter any additional details here.....",
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    _formRow(
                      "Down Payment",
                      "Remaining Balance",
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                  ],
                  // --- COMMON SECTION: Toggle & Input ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Uploaded Images",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E3A59),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFB0B8D0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Input Remaining Balance?",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E3A59),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => setState(
                                    () => showRemainingBalanceInput = true,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00C853),
                                  ),
                                  child: const Text(
                                    "YES",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => setState(
                                    () => showRemainingBalanceInput = false,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    "NO",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            if (showRemainingBalanceInput) ...[
                              const SizedBox(height: 15),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFD6E4FF),
                                      Color(0xFFFFFFFF),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Remaining Balance",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E3A59),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      // THIS FIELD REMAINS EDITABLE
                                      child: const TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          hintText: '0.00',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Balance Saved'),
                                              backgroundColor: Color(
                                                0xFF00C853,
                                              ),
                                            ),
                                          );
                                          setState(
                                            () => showRemainingBalanceInput =
                                                false,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF00C853,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          elevation: 4,
                                        ),
                                        child: const Text(
                                          "SAVE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Build Main Tabs
                  ...mainTabs
                      .map(
                        (tab) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildTabChip(tab),
                        ),
                      )
                      .toList(),
                  // Build More Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Builder(
                      builder: (context) => _buildMoreButton(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              showTrackSaved = !showTrackSaved;
              showFloatingOrderDetails = false;
              _closeMoreMenu();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: showTrackSaved
                  ? const Color(0xFF55A888)
                  : const Color(0xFF373E4E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Track Saved Orders",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    bool isMoreActive = moreItems.contains(_activeItem);
    return InkWell(
      onTap: () => _toggleMoreMenu(context),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isMoreActive ? const Color(0xFF373E4E) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isMoreActive ? _activeItem : "More",
              style: TextStyle(
                color: isMoreActive ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isMoreDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: isMoreActive ? Colors.white : Colors.black87,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownMenu() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: moreItems.map((item) {
            bool isSelected = item == _activeItem;
            return InkWell(
              onTap: () => _selectItem(item),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey.shade300 : Colors.transparent,
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2E3A59),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabChip(String label) {
    bool isActive = _activeItem == label;
    return GestureDetector(
      onTap: () => _selectItem(label),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF373E4E) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Order: $_activeItem',
                style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 20),
            // Render the specific item form
            _getFormForItem(_activeItem),
            // Only show standard downpayment row if it's a MAIN item
            if (_activeItem != 'Custom Order: Packages' &&
                _activeItem != 'Custom Order: Invitation' &&
                _activeItem != 'Custom Order: Souvenir' &&
                _activeItem != 'Custom Order: Candle' &&
                _activeItem != 'Custom Order: T-shirt' &&
                _activeItem != 'Custom Order: Chip Bag' &&
                _activeItem != 'Button Badge' &&
                _activeItem != 'Button Pin' &&
                _activeItem != 'Party Hat' &&
                _activeItem != 'Jigsaw Puzzle' &&
                _activeItem != 'Banner' &&
                _activeItem != 'Calendar' &&
                _activeItem != 'Hair Brush' &&
                _activeItem != 'Clock' &&
                _activeItem != 'Ref Magnet') ...[
              const SizedBox(height: 20),
              _formRow("Downpayment", "Remaining Balance"),
            ],
            const SizedBox(height: 30),
            // Only show bottom section (Uploads/Save) for Main items
            if (_activeItem != 'Packages' &&
                _activeItem != 'Invitation' &&
                _activeItem != 'Souvenir' &&
                _activeItem != 'Candle' &&
                _activeItem != 'T-shirt' &&
                _activeItem != 'Chip Bag' &&
                _activeItem != 'Button Badge' &&
                _activeItem != 'Button Pin' &&
                _activeItem != 'Party Hat' &&
                _activeItem != 'Jigsaw Puzzle' &&
                _activeItem != 'Banner' &&
                _activeItem != 'Calendar' &&
                _activeItem != 'Hair Brush' &&
                _activeItem != 'Clock' &&
                _activeItem != 'Ref Magnet')
              _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    int maxImages = 1;
    if (_activeItem == 'Packages' ||
        _activeItem == 'Invitation' ||
        _activeItem == 'Ref Magnet' ||
        _activeItem == 'T-shirt' ||
        _activeItem == 'Chip Bag' ||
        _activeItem == 'Party Hat' ||
        _activeItem == 'Jigsaw Puzzle') {
      maxImages = 5;
    } else if (_activeItem == 'Clock') {
      maxImages = 13;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    children: List.generate(maxImages > 5 ? 5 : maxImages, (
                      index,
                    ) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomPaint(
                          painter: DashedBorderPainter(),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Choose Files  No file chosen",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  savedOrders.add({
                    'item': _activeItem,
                    'type': moreItems.contains(_activeItem)
                        ? 'More Item'
                        : _activeItem,
                    'commissioned': 'Staff Name',
                    'branch': 'CAMPO',
                    'downpayment': '₱ 0.00',
                  });
                  showTrackSaved = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "SAVE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getFormForItem(String item) {
    if (item == 'Packages' || item == 'Invitation') {
      return _buildPackagesOrInvitationMainForm();
    }
    if (item == 'Souvenir') {
      return _buildSouvenirMainForm();
    }
    if (item == 'Candle') return _buildCandleForm();
    if (item == 'T-shirt') return _buildTshirtForm();
    if (item == 'Chip Bag') return _buildChipBagForm();
    if (item == 'Button Badge') return _buildButtonBadgeForm();
    if (item == 'Button Pin') return _buildButtonPinForm();
    if (item == 'Party Hat') return _buildPartyHatForm();
    if (item == 'Jigsaw Puzzle') return _buildJigsawPuzzleForm();
    if (item == 'Banner') return _buildBannerForm();
    if (item == 'Calendar') return _buildCalendarForm();
    if (item == 'Hair Brush') return _buildHairBrushForm();
    if (item == 'Clock') return _buildClockForm();
    if (item == 'Ref Magnet') return _buildRefMagnetForm();
    return const SizedBox();
  }

  Widget _buildPackagesOrInvitationMainForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Name", "Event Date"),
        const SizedBox(height: 12),
        _formRow("Theme", "What Package"),
        const SizedBox(height: 12),
        _formRow("Reception Venue", "Church Venue"),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Details",
          "Enter any additional details here.....",
        ),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Down Payment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(4, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.black, size: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'type': moreItems.contains(_activeItem)
                      ? 'More Item'
                      : _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSouvenirMainForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Name", "Event Date"),
        const SizedBox(height: 12),
        _formRow("Theme", "Occasion Type"),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Down Payment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(
              child: Icon(Icons.add, color: Colors.black, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'type': moreItems.contains(_activeItem)
                      ? 'More Item'
                      : _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCandleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextArea("Details", "Enter details here....."),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Candle',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTshirtForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextArea("Details", "Enter details here....."),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.black, size: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'T-shirt',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipBagForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextArea("Details", "Enter details here....."),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.black, size: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Chip Bag',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonBadgeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Name"),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(
              child: Icon(Icons.add, color: Colors.black, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Button Badge',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonPinForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Name"),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Details",
          "Enter any additional details here.....",
        ),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(
              child: Icon(Icons.add, color: Colors.black, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Button Pin',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPartyHatForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildInput("Name")),
            const SizedBox(width: 12),
            Expanded(child: _buildInput("Theme")),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Details",
          "Enter any additional details here.....",
        ),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.black, size: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Party Hat',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJigsawPuzzleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Theme", "Details"),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.black, size: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Jigsaw Puzzle',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Theme", "Details"),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.black, size: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Banner',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildInput("Name")),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextArea(
                "Additional Custom Order",
                "Enter any additional custom order here.....",
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Details",
          "Enter any additional details here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(
              child: Icon(Icons.add, color: Colors.black, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Calendar',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHairBrushForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildInput("Name")),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextArea(
                "Additional Custom Order",
                "Enter any additional custom order here.....",
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(
              child: Icon(Icons.add, color: Colors.black, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Hair Brush',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClockForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildInput("Name")),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextArea(
                "Additional Custom Order",
                "Enter any additional custom order here.....",
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(13, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.black, size: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Clock',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRefMagnetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Name", "Event Date"),
        const SizedBox(height: 12),
        _formRow("Theme", "Occasion Type"),
        const SizedBox(height: 12),
        _buildInput("Reception Venue"),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Details",
          "Enter any additional details here.....",
        ),
        const SizedBox(height: 12),
        _buildTextArea(
          "Additional Custom Order",
          "Enter any additional custom order here.....",
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Down Payment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Balance after Downpayment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.black, size: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choose Files No file chosen",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                  'type': 'Ref Magnet',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _formRow(String label1, String label2, {TextEditingController? controller1, TextEditingController? controller2, bool readOnly = false}) {
  return Row(
    children: [
      Expanded(child: _buildInput(label1, controller: controller1, readOnly: readOnly)),
      const SizedBox(width: 12),
      Expanded(child: _buildInput(label2, controller: controller2, readOnly: readOnly)),
    ],
  );
}

  Widget _buildInput(String label, {TextEditingController? controller, bool readOnly = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59)),
      ),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        readOnly: readOnly, // ✅ This fixes the error!
        decoration: InputDecoration(
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : const Color(0xFFB0B8D0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    ],
  );
}

Widget _buildTextArea(String label, String hint, {TextEditingController? controller, bool readOnly = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        readOnly: readOnly, // ✅ This fixes the error!
        maxLines: 3,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: readOnly ? Colors.grey[300] : const Color(0xFFB0B8D0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
    ],
  );
}

  Widget _buildTrackSavedView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF4B5580),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    "Item",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Commissioned by",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Shop Branch",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Downpayment",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Detailed Information",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savedOrders.length,
              itemBuilder: (context, index) {
                final order = savedOrders[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? Colors.white
                        : const Color(0xFFE8F0FE),
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFB0C4DE),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          order['item']!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(child: Text(order['commissioned']!)),
                      Expanded(child: Text(order['branch']!)),
                      Expanded(child: Text(order['downpayment']!)),
                      Expanded(
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (order['item'] == 'Package 1' ||
                                  order['item'] == 'Invitation' ||
                                  order['item'] == 'Souvenir' ||
                                  order['item'] == 'Candle' ||
                                  order['item'] == 'Ref Magnet' ||
                                  order['item'] == 'T-shirt' ||
                                  order['item'] == 'Chip Bag' ||
                                  order['item'] == 'Button Badge' ||
                                  order['item'] == 'Button Pin' ||
                                  order['item'] == 'Party Hat' ||
                                  order['item'] == 'Jigsaw Puzzle' ||
                                  order['item'] == 'Banner' ||
                                  order['item'] == 'Calendar' ||
                                  order['item'] == 'Clock' ||
                                  order['item'] == 'Hair Brush') {
                                setState(() {
                                  showFloatingOrderDetails = true;
                                  activeFloatingOrder = order;
                                  showRemainingBalanceInput = false;
                                });
                              } else {
                                setState(() {
                                  showTrackSaved = false;
                                  _activeItem = order['type'];
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C853),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              "VIEW",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path();
    final double dashWidth = 5;
    final double dashSpace = 3;
    double currentX = 0;
    double currentY = 0;
    while (currentX < size.width) {
      path.moveTo(currentX, 0);
      currentX = currentX + dashWidth < size.width
          ? currentX + dashWidth
          : size.width;
      path.lineTo(currentX, 0);
      currentX += dashSpace;
    }
    currentY = 0;
    while (currentY < size.height) {
      path.moveTo(size.width, currentY);
      currentY = currentY + dashWidth < size.height
          ? currentY + dashWidth
          : size.height;
      path.lineTo(size.width, currentY);
      currentY += dashSpace;
    }
    currentX = size.width;
    while (currentX > 0) {
      path.moveTo(currentX, size.height);
      currentX = currentX - dashWidth > 0 ? currentX - dashWidth : 0;
      path.lineTo(currentX, size.height);
      currentX -= dashSpace;
    }
    currentY = size.height;
    while (currentY > 0) {
      path.moveTo(0, currentY);
      currentY = currentY - dashWidth > 0 ? currentY - dashWidth : 0;
      path.lineTo(0, currentY);
      currentY -= dashSpace;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}