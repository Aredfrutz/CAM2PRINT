import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math' as math;


// DATA MODEL
class ServiceItem {
  final int id;
  final String name;
  final String price;
  final String category;
  final String section;
  final String? imageUrl;

  ServiceItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.section,
    this.imageUrl,
  });
}

class StaffServicesPage extends StatefulWidget {
  const StaffServicesPage({super.key});

  @override
  State<StaffServicesPage> createState() => _StaffServicesPageState();
}

class _StaffServicesPageState extends State<StaffServicesPage> {
  String _selectedCategory = 'Packages';
  bool _isLoading = true;

  final List<String> _mainCategories = [
    'Packages',
    'Souvenir',
    'Invitation',
    'Candle',
    'Ref Magnet',
    'T-Shirt',
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

  final List<ServiceItem> _items = [];

  @override
  void initState() {
    super.initState();
    for (var cat in [..._mainCategories, ..._moreCategories]) {
      _categorySections[cat] = [cat];
    }
    _categorySections['Packages']!.add('Premium Packages');
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final rows = await Supabase.instance.client
          .from('services')
          .select()
          .order('id');

      final parsed = <ServiceItem>[];
      for (final row in rows) {
        final map = Map<String, dynamic>.from(row);
        final category = (map['category'] ?? 'Packages').toString();
        final section = (map['section'] ?? category).toString();

        if (!_categorySections.containsKey(category)) {
          _categorySections[category] = [category];
        }
        if (!_categorySections[category]!.contains(section)) {
          _categorySections[category]!.add(section);
        }

        parsed.add(
          ServiceItem(
            id: map['id'] is int
                ? map['id'] as int
                : int.tryParse((map['id'] ?? 0).toString()) ?? 0,
            name: (map['name'] ?? '').toString(),
            price: (map['price'] ?? '').toString(),
            category: category,
            section: section,
            imageUrl: (map['image_url'] ?? '').toString().isEmpty
                ? null
                : (map['image_url'] ?? '').toString(),
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(parsed);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load services: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
        content: Text('$pageName page is not connected yet.'),
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
                      isActive: true, // ✅ Active highlight for Services page
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

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildCategoryTabs(),
                            Expanded(child: _buildMainContentPanel()),
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

  Widget _buildCategoryTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 15),
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final sections = _categorySections[_selectedCategory] ?? [];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView.separated(
        itemCount: sections.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: 10),
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
          child: Text(
            sectionName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        currentItems.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "No items available in this section.",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = math.max(
                    2,
                    math.min(8, (constraints.maxWidth / 140).floor()),
                  );
                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) =>
                        _buildViewOnlyItemCard(currentItems[index]),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildViewOnlyItemCard(ServiceItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6A7B9C),
              borderRadius: BorderRadius.circular(4),
              image: item.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
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
              "₱${item.price}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}