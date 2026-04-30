import 'package:flutter/material.dart';

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

class StaffServicesPage extends StatefulWidget {
  const StaffServicesPage({super.key});

  @override
  State<StaffServicesPage> createState() => _StaffServicesPageState();
}

class _StaffServicesPageState extends State<StaffServicesPage> {
  String _selectedCategory = 'Packages';

  final List<String> _mainCategories = [
    'Packages', 'Souvenir', 'Invitation', 'Candle', 'Ref Magnet', 
    'T-Shirt', 'Chip Bag', 'Button Badge'
  ];

  final List<String> _moreCategories = [
    'Button Pin', 'Party Hat','Jigsaw Puzzle', 
    'Banner','Calendar', 'Hair Brush', 'Clock'
  ];

  final Map<String, List<String>> _categorySections = {};

  // DUMMY DATABASE
  final List<ServiceItem> _items = [
    ServiceItem(id: 1, name: "Basic Package", price: "1,000", category: "Packages", section: "Packages"),
    ServiceItem(id: 2, name: "Premium Package", price: "2,500", category: "Packages", section: "Premium Packages"),
    ServiceItem(id: 3, name: "Wedding Souvenir", price: "50", category: "Souvenir", section: "Souvenir"),
    ServiceItem(id: 4, name: "Birthday Invite", price: "30", category: "Invitation", section: "Invitation"),
  ];

  @override
  void initState() {
    super.initState();
    for (var cat in [..._mainCategories, ..._moreCategories]) {
      _categorySections[cat] = [cat]; 
    }
    _categorySections['Packages']!.add('Premium Packages'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryTabs(),
            Expanded(
              child: _buildMainContentPanel(),
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
        color: Colors.white.withOpacity(0.85),
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

  Widget _buildTabItem({required String title, required bool isSelected, required VoidCallback onTap}) {
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
                  fontWeight: _selectedCategory == choice ? FontWeight.bold : FontWeight.normal,
                  color: _selectedCategory == choice ? Colors.blue : Colors.black,
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(left: 12, right: 8), 
          decoration: BoxDecoration(
            color: isMoreSelected ? const Color(0xFF9BA7C0) : Colors.transparent,
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
                  fontWeight: isMoreSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down, 
                size: 16, 
                color: isMoreSelected ? Colors.black : Colors.black54
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ PERFECT ADMIN MATCH: The solid F1F4F9 container that wraps everything
  Widget _buildMainContentPanel() {
    final sections = _categorySections[_selectedCategory] ?? [];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9), 
        borderRadius: BorderRadius.circular(5)
      ),
      child: ListView.separated(
        itemCount: sections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10), // Matches Admin block spacing
        itemBuilder: (context, index) {
          return _buildSectionBlock(sections[index]);
        },
      ),
    );
  }

  // --- INDIVIDUAL SECTION CONTAINER ---
  Widget _buildSectionBlock(String sectionName) {
    final currentItems = _items.where((item) => item.category == _selectedCategory && item.section == sectionName).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ✅ PERFECT ADMIN MATCH: Header sizing and colors
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF4A5777),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            border: Border(
              top: BorderSide(color: Colors.blueAccent, width: 3),
            ),
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
        
        // ✅ PERFECT ADMIN MATCH: No white background, just the grid padding!
        currentItems.isEmpty 
          ? const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text("No items available in this section.", style: TextStyle(color: Colors.black54))),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20), // Matches Admin padding
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8, 
                crossAxisSpacing: 12,    // Matches Admin
                mainAxisSpacing: 20,     // Matches Admin
                childAspectRatio: 0.62,  // Matches Admin
              ),
              itemCount: currentItems.length, 
              itemBuilder: (context, index) => _buildViewOnlyItemCard(currentItems[index]), 
            ),
      ],
    );
  }

  // ✅ PERFECT ADMIN MATCH: Plain items without the white card borders
  Widget _buildViewOnlyItemCard(ServiceItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF6A7B9C), // Admin grey-blue
              borderRadius: BorderRadius.circular(4), // Admin radius
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
            // Staff does not have the delete icon
          ],
        ),
      ],
    );
  }
}