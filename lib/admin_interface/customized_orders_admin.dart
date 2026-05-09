import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:intl/intl.dart';


class CustomizedOrdersPage extends StatefulWidget {
  const CustomizedOrdersPage({super.key});

  @override
  State<CustomizedOrdersPage> createState() => _CustomizedOrdersPageState();
}

class _CustomizedOrdersPageState extends State<CustomizedOrdersPage> {
  // Overlay entry for the "More" dropdown menu
  OverlayEntry? _moreOverlayEntry;

  // List of items inside "More" dropdown
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

  // Master list of ALL orders (Database simulation)
  final List<Map<String, dynamic>> _allOrders = [
    {
      'item': 'Package 1',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Package 2',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Souvenir',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Souvenir',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Invitation',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Candle',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Ref Magnet',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'T-shirt',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Chip Bag',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Button Badge',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Button Pin',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Party Hat',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Jigsaw Puzzle',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Banner',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Calendar',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Hair Brush',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
    {
      'item': 'Clock',
      'commissioned': 'Staff Name',
      'branch': 'CAMPO',
      'downpayment': '₱000.00',
    },
  ];

  // State for the Floating View
  bool _showFloatingDetails = false;
  Map<String, dynamic>? _selectedOrder;

  // Tab state
  final List<String> _tabs = [
    "Packages",
    "Souvenir",
    "Invitation",
    "Candle",
    "Ref Magnet",
    "T-shirt",
    "Chip Bag",
  ];
  String _activeTab = "Packages";
  bool _isMoreOpen = false;

  @override
  void dispose() {
    _closeMoreMenu();
    super.dispose();
  }

  // Filter the orders based on the active tab
  List<Map<String, dynamic>> get _filteredOrders {
    if (_activeTab == "Packages") {
      // Show all items that are Packages
      return _allOrders
          .where(
            (order) =>
                order['item'] == 'Package 1' ||
                order['item'].toString().startsWith('Package'),
          )
          .toList();
    } else if (_activeTab == "More") {
      // If "More" is somehow selected, show all items in the moreItems list
      return _allOrders
          .where((order) => moreItems.contains(order['item']))
          .toList();
    } else {
      // Show items that match the specific tab name (e.g., "Souvenir")
      return _allOrders.where((order) => order['item'] == _activeTab).toList();
    }
  }

  void _selectItem(String item) {
    setState(() {
      _activeTab = item;
      _closeMoreMenu();
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
        left: position.dx + button.size.width - 160, // Align to right
        child: Material(color: Colors.transparent, child: _buildDropdownMenu()),
      ),
    );

    Overlay.of(context).insert(_moreOverlayEntry!);
    setState(() => _isMoreOpen = true);
  }

  void _closeMoreMenu() {
    _moreOverlayEntry?.remove();
    _moreOverlayEntry = null;
    if (mounted) {
      setState(() => _isMoreOpen = false);
    }
  }

  Widget _buildDropdownMenu() {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: moreItems.map((item) {
          bool isSelected = item == _activeTab;
          return InkWell(
            onTap: () => _selectItem(item),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.grey.shade200 : Colors.transparent,
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF2E3A59),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

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
      case 'Overall Inventory':
        routeName = AppRouter.adminoverallinv;
        break;
      case 'Salary':
        routeName = AppRouter.adminsalary;
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
        child: Stack(
          children: [
            Row(
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
                        // Active highlight for Customized Orders
                        _buildSidebarItem(
                          Icons.shopping_cart,
                          "Customized Orders",
                          () => _navigateTo('Customized Orders'),
                          isActive: true,
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
                      children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Admin",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
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
                        _buildTabsBar(),
                        const SizedBox(height: 16),
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
                                _buildTableHeader(),
                                Expanded(child: _buildTableBody()),
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
            if (_showFloatingDetails) _buildFloatingView(),
          ],
        ),
      ),
    );
  }

  // --- TABS BAR ---
  Widget _buildTabsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(
          0xFFE8F0FE,
        ), // Light blue background for tabs container
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Main Tabs - Wrapped in Expanded to fill space evenly
          ..._tabs.map(
            (tab) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _buildTabChip(tab),
              ),
            ),
          ),

          // More Button
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Builder(builder: (context) => _buildMoreButton(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label) {
    bool isActive = _activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF374151)
              : Colors.transparent, // Dark pill
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    bool isMoreActive = moreItems.contains(_activeTab);
    return InkWell(
      onTap: () => _toggleMoreMenu(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isMoreActive ? const Color(0xFF374151) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "More",
                style: TextStyle(
                  color: isMoreActive ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isMoreOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: isMoreActive ? Colors.white : Colors.black87,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TABLE ---
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF4B5580), // Dark blue header
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Text(
              "Item",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Commissioned by",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Shop Branch",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Downpayment",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Detailed Information",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody() {
    final displayOrders = _filteredOrders;

    if (displayOrders.isEmpty) {
      return const Center(
        child: Text("No items found", style: TextStyle(color: Colors.black54)),
      );
    }

    return ListView.builder(
      itemCount: displayOrders.length,
      itemBuilder: (context, index) {
        final order = displayOrders[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: index.isEven ? Colors.white : const Color(0xFFE8F0FE),
            border: Border(
              bottom: BorderSide(color: const Color(0xFFB0C4DE), width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  order['item'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(order['commissioned'], textAlign: TextAlign.center),
              ),
              Expanded(
                flex: 2,
                child: Text(order['branch'], textAlign: TextAlign.center),
              ),
              Expanded(
                flex: 2,
                child: Text(order['downpayment'], textAlign: TextAlign.center),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _showDetails(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "VIEW",
                      style: TextStyle(
                        color: Colors.white,
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
    );
  }

  void _showDetails(Map<String, dynamic> order) {
    setState(() {
      _selectedOrder = order;
      _showFloatingDetails = true;
    });
  }

  Widget _buildFloatingView() {
    if (!_showFloatingDetails || _selectedOrder == null) {
      return const SizedBox.shrink();
    }

    final String itemType = _selectedOrder!['item'] ?? '';

    final bool isPackages =
        itemType == 'Packages' ||
        itemType == 'Package 1' ||
        itemType.startsWith('Package');
    final bool isCandle = itemType == 'Candle';
    final bool isSouvenir = itemType == 'Souvenir';
    final bool isRefMagnet = itemType == 'Ref Magnet';
    final bool isTshirtOrChipBag =
        itemType == 'T-shirt' || itemType == 'Chip Bag';
    final bool isButtonBadge = itemType == 'Button Badge';
    final bool isButtonPin = itemType == 'Button Pin';
    final bool isPartyHat = itemType == 'Party Hat';
    final bool isJigsawPuzzle = itemType == 'Jigsaw Puzzle';
    final bool isBanner = itemType == 'Banner';
    final bool isCalendarOrClock =
        itemType == 'Calendar' || itemType == 'Clock';
    final bool isHairBrush = itemType == 'Hair Brush';

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 700,
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
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
                      itemType,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          setState(() => _showFloatingDetails = false),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (isPackages) ...[
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
                    "Down Payment - Full Payment",
                    "Remaining Balance",
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
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
                    ],
                  ),
                ] else if (isCandle) ...[
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
                  _formRow("Downpayment", "Remaining Balance", readOnly: true),
                  const SizedBox(height: 20),
                ] else if (isSouvenir) ...[
                  _formRow("Name", "Event Date", readOnly: true),
                  const SizedBox(height: 12),
                  _formRow("Theme", "Occasion Type", readOnly: true),
                  const SizedBox(height: 12),
                  _formRow("Down Payment", "Remaining Balance", readOnly: true),
                  const SizedBox(height: 20),
                ] else if (isRefMagnet) ...[
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
                  _formRow("Down Payment", "Remaining Balance", readOnly: true),
                  const SizedBox(height: 20),
                ] else if (isTshirtOrChipBag) ...[
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
                ] else if (isButtonBadge) ...[
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
                ] else if (isButtonPin) ...[
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
                ] else if (isPartyHat) ...[
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
                ] else if (isJigsawPuzzle) ...[
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
                ] else if (isBanner) ...[
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
                ] else if (isCalendarOrClock) ...[
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
                ] else if (isHairBrush) ...[
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
                ] else ...[
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
                  _formRow("Down Payment", "Remaining Balance", readOnly: true),
                  const SizedBox(height: 20),
                ],

                if (!isPackages) ...[
                  const SizedBox(height: 20),
                  const Text(
                    "Uploaded Images",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_getImageCount(itemType), (index) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB0B8D0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getImageCount(String type) {
    switch (type) {
      case 'Clock':
        return 13;
      case 'T-shirt':
      case 'Chip Bag':
      case 'Ref Magnet':
      case 'Party Hat':
        return 5;
      case 'Packages':
      case 'Invitation':
        return 4;
      case 'Souvenir':
      case 'Button Badge':
      case 'Calendar':
        return 1;
      default:
        return 0;
    }
  }

  Widget _formRow(
    String leftLabel,
    String rightLabel, {
    required bool readOnly,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leftLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E3A59),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                readOnly: readOnly,
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
              Text(
                rightLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E3A59),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                readOnly: readOnly,
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
    );
  }

  Widget _buildTextArea(String label, String hint, {required bool readOnly}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          readOnly: readOnly,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
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
    );
  }
}
