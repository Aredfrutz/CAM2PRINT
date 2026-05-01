import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';

// DATA MODEL
class ServiceItem {
  final int id;
  final String name;
  final String price;
  final String category;
  final String section;

  ServiceItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.section,
  });
}

class AdminServicesPage extends StatefulWidget {
  const AdminServicesPage({super.key});

  @override
  State<AdminServicesPage> createState() => _AdminServicesPageState();
}

class _AdminServicesPageState extends State<AdminServicesPage> {
  String _selectedCategory = 'Packages';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  final List<String> _mainCategories = [
    'Packages',
    'Souvenir',
    'Invitation',
    'Candle',
    'Ref Magnet',
    'T-shirt',
    'Chip Bag',
    'Button Badge',
  ];

  final List<String> _moreCategories = [
    'Button Pin',
    'Party Hat',
    'Jigsaw Puzzle',
    'Banner',
    'Calendar',
    'Hair Brush',
    'Clock',
  ];

  final Map<String, List<String>> _categorySections = {};

  final List<ServiceItem> _items = [
    ServiceItem(
      id: 1,
      name: "Basic Package",
      price: "1,000",
      category: "Packages",
      section: "Packages",
    ),
    ServiceItem(
      id: 2,
      name: "Premium Package",
      price: "2,500",
      category: "Packages",
      section: "Premium Packages",
    ),
    ServiceItem(
      id: 3,
      name: "Wedding Souvenir",
      price: "50",
      category: "Souvenir",
      section: "Souvenir",
    ),
    ServiceItem(
      id: 4,
      name: "Birthday Invite",
      price: "30",
      category: "Invitation",
      section: "Invitation",
    ),
  ];

  @override
  void initState() {
    super.initState();
    for (var cat in [..._mainCategories, ..._moreCategories]) {
      _categorySections[cat] = [cat];
    }
    _categorySections['Packages']!.add('Premium Packages');
  }

  String? _targetSectionForNewPackage;

  // ==========================================
  // ITEM LOGIC
  // ==========================================
  void _addNewPackage() {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _targetSectionForNewPackage != null) {
      setState(() {
        _items.add(
          ServiceItem(
            id: DateTime.now().millisecondsSinceEpoch,
            name: _nameController.text,
            price: _priceController.text,
            category: _selectedCategory,
            section: _targetSectionForNewPackage!,
          ),
        );
      });
      _nameController.clear();
      _priceController.clear();
      Navigator.pop(context);
    }
  }

  void _deleteItem(int id) {
    setState(() {
      _items.removeWhere((element) => element.id == id);
    });
  }

  // ==========================================
  // SECTION LOGIC
  // ==========================================
  void _addNewSection() {
    if (_sectionController.text.isNotEmpty) {
      setState(() {
        _categorySections[_selectedCategory]!.add(
          _sectionController.text.trim(),
        );
      });
      _sectionController.clear();
      Navigator.pop(context);
    }
  }

  void _deleteSection(String sectionName) {
    setState(() {
      _categorySections[_selectedCategory]!.remove(sectionName);
      _items.removeWhere(
        (item) =>
            item.category == _selectedCategory && item.section == sectionName,
      );
    });
    Navigator.pop(context);
  }

  // ==========================================
  // DIALOGS
  // ==========================================
  void _showAddSectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFD1D9FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Add New Section",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _sectionController,
          decoration: const InputDecoration(
            hintText: "Enter Section Name (e.g. VIP Packages)",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: _addNewSection,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF52B788),
            ),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteSectionConfirmDialog(String sectionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Delete Section?"),
        content: Text(
          "Are you sure you want to delete '$sectionName'?\n\nAll items inside this section will also be deleted.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () => _deleteSection(sectionName),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddPackageDialog(String sectionName) {
    _targetSectionForNewPackage = sectionName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFD1D9FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 110,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFAAB4D1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_outlined, size: 35),
                      const SizedBox(height: 5),
                      const Text(
                        "Upload a Picture",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Item Name",
                          border: InputBorder.none,
                        ),
                      ),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: "Price: 1200",
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _addNewPackage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF52B788),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
      // ✅ FIX 1: Set Scaffold background to gradient start color to prevent white gaps
      backgroundColor: const Color(0xFF9FA8DA), 
      body: Container(
        // ✅ FIX 2: Wrap the whole Row in the gradient container
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9FA8DA), Color(0xFFFFFFFF)],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==========================================
            // SIDEBAR
            // ==========================================
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
              ),
              child: Container(
                width: 240,
                height: double.infinity, // ✅ CRITICAL: Forces full height
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5B6388), Color(0xFF3E4563)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max, // ✅ CRITICAL: Expands to fill container
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
                    
                    // Scrollable Menu
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
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
                            isActive: true,
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
                        ],
                      ),
                    ),

                    // Logout
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

            // ==========================================
            // MAIN CONTENT
            // ==========================================
            Expanded(
              child: Container(
                // ✅ FIX 3: Removed gradient from here so it uses the parent gradient
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navbar
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
                          const Text(
                            "Saturday/ January 31, 2026",
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
                                    "Admin",
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

                    // Content Area
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildCategoryTabs(),
                          const SizedBox(height: 15),
                          
                          // Scrollable List of Sections
                          Expanded(
                            child: _buildMainContentPanel(),
                          ),
                          
                          // Button is now at the bottom of the content area
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: _buildBottomActionBtn(),
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

  Widget _buildCategoryTabs() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _mainCategories.length,
              itemBuilder: (context, index) {
                final cat = _mainCategories[index];
                return _buildTabItem(
                  title: cat,
                  isSelected: _selectedCategory == cat,
                  onTap: () => setState(() => _selectedCategory = cat),
                );
              },
            ),
          ),
          if (_moreCategories.isNotEmpty) _buildMoreTab(),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9BA7C0) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildMoreTab() {
    bool isMoreSelected = _moreCategories.contains(_selectedCategory);

    return Theme(
       data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onSelected: (String value) {
          setState(() {
            _selectedCategory = value;
          });
        },
        itemBuilder: (BuildContext context) {
          return _moreCategories.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(
                choice,
                style: TextStyle(
                  fontWeight: _selectedCategory == choice
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedCategory == choice
                      ? Colors.blue
                      : Colors.black,
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(left: 12, right: 8),
          decoration: BoxDecoration(
            color: isMoreSelected
                ? const Color(0xFF9BA7C0)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isMoreSelected ? _selectedCategory : 'More',
                style: TextStyle(
                  color: isMoreSelected ? Colors.black : Colors.black87,
                  fontWeight: isMoreSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isMoreSelected ? Colors.black : Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContentPanel() {
    final sections = _categorySections[_selectedCategory] ?? [];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return _buildSectionBlock(sections[index]);
        },
      ),
    );
  }

  Widget _buildSectionBlock(String sectionName) {
    final currentItems = _items
        .where(
          (item) =>
              item.category == _selectedCategory && item.section == sectionName,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF4A5777),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            border: Border(top: BorderSide(color: Colors.blueAccent, width: 3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showAddPackageDialog(sectionName),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => _showDeleteSectionConfirmDialog(sectionName),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        currentItems.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "No items yet. Click '+' to add.",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.62,
                ),
                itemCount: currentItems.length,
                itemBuilder: (context, index) =>
                    _buildMiniServiceCard(currentItems[index]),
              ),
      ],
    );
  }

  Widget _buildMiniServiceCard(ServiceItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6A7B9C),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${item.price}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            GestureDetector(
              onTap: () => _deleteItem(item.id),
              child: const Icon(Icons.delete, size: 12, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomActionBtn() {
    return GestureDetector(
      onTap: _showAddSectionDialog,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF5E6A82),
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Text(
            "+ Add/Update New Section",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _sectionController.dispose();
    super.dispose();
  }
}