import 'package:flutter/material.dart';

class StaffServicesPage extends StatefulWidget {
  const StaffServicesPage({super.key});

  @override
  State<StaffServicesPage> createState() => _StaffServicesPageState();
}

class _StaffServicesPageState extends State<StaffServicesPage> {
  String _selectedCategory = 'Packages';

  // 1. The main visible tabs
  final List<String> _mainCategories = [
    'Packages', 'Souvenir', 'Invitation', 'Candle', 'Ref Magnet', 'T-Shirt', 'Chip Bag'
  ];

  // 2. The extra categories hidden inside the "More" dropdown
  final List<String> _moreCategories = [
    'Button Badge', 'Button Pin', 'Party Hat', 'Jigsaw Puzzle', 
    'Banner', 'Calendar', 'Hair Brush', 'Clock'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryTabs(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: [
                  // DYNAMIC: Passes the currently selected category to change the UI
                  _buildSectionBlock(_selectedCategory),
                  const SizedBox(height: 20),
                  _buildSectionBlock(_selectedCategory), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TOP CATEGORY TABS ---
  Widget _buildCategoryTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Build the standard tabs
            ..._mainCategories.map((cat) => _buildTabItem(
              title: cat,
              isSelected: _selectedCategory == cat,
              onTap: () => setState(() => _selectedCategory = cat),
            )),
            
            // Build the dynamic "More" Dropdown tab
            _buildMoreTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(horizontal: 2), 
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

  // --- THE "MORE" DROPDOWN MENU ---
  Widget _buildMoreTab() {
    // Check if the currently selected category belongs to the "More" list
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
                  // Highlight the text blue if it's currently selected in the menu
                  fontWeight: _selectedCategory == choice ? FontWeight.bold : FontWeight.normal,
                  color: _selectedCategory == choice ? Colors.blue : Colors.black,
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isMoreSelected ? const Color(0xFF9BA7C0) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                // If a "More" item is selected, show its name on the button, otherwise just show "More"
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

  // --- SECTION BLOCK (Header + Grid) ---
  Widget _buildSectionBlock(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header with the bright blue top border
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF4C5A79),
            border: Border(
              top: BorderSide(color: Colors.blueAccent, width: 3),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            title, // ✅ DYNAMIC TITLE
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        
        // 2. Main Content Body for this block
        Container(
          color: Colors.white.withOpacity(0.6), 
          padding: const EdgeInsets.all(15),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, 
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.65, 
            ),
            itemCount: 8, 
            itemBuilder: (context, index) => _buildViewOnlyItemCard(title, index),
          ),
        ),
      ],
    );
  }

  // --- FLAT VIEW-ONLY ITEM CARD ---
  Widget _buildViewOnlyItemCard(String categoryName, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF67728E),
            ),
          ),
        ),
        const SizedBox(height: 6),
        
        // ✅ DYNAMIC ITEM NAME
        Text(
          "$categoryName ${index + 1}", 
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontStyle: FontStyle.italic, 
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        
        const Text(
          "₱1,000",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}