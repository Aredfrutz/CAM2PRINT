import 'package:flutter/material.dart';

// DATA MODEL
class ServiceItem {
  final int id;
  final String name;
  final String price;
  final String category;

  ServiceItem({
    required this.id, 
    required this.name, 
    required this.price, 
    required this.category
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

  List<String> _mainCategories = [
    'Packages', 'Souvenir', 'Invitation', 'Candle', 'Ref Magnet', 'T-shirt', 'Chip Bag'
  ];

  List<String> _moreCategories = [
    'Button Badge', 'Button Pin', 'Party Hat', 'Jigsaw Puzzle', 
    'Banner', 'Calendar', 'Hair Brush', 'Clock'
  ];

  List<ServiceItem> _items = [
    ServiceItem(id: 1, name: "Souvenir name", price: "1,000", category: "Packages"),
  ];

  // ==========================================
  // ITEM LOGIC (ADD / DELETE)
  // ==========================================
  void _addNewPackage() {
    if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      setState(() {
        _items.add(ServiceItem(
          id: DateTime.now().millisecondsSinceEpoch,
          name: _nameController.text,
          price: _priceController.text,
          category: _selectedCategory, 
        ));
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
  // SECTION LOGIC (ADD / DELETE)
  // ==========================================
  
  // ✅ FUNCTION TO ADD NEW SECTION (Inside "More")
  void _addNewSection() {
    if (_sectionController.text.isNotEmpty) {
      setState(() {
        String newSection = _sectionController.text.trim();
        
        // ✅ Added to the dropdown list!
        _moreCategories.add(newSection); 
        
        _selectedCategory = newSection; 
      });
      _sectionController.clear();
      Navigator.pop(context); // Close dialog
    }
  }

  // ✅ FUNCTION TO DELETE CURRENT SECTION
  void _deleteCurrentSection() {
    if (_mainCategories.length + _moreCategories.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot delete the last remaining section."))
      );
      return;
    }

    setState(() {
      _items.removeWhere((item) => item.category == _selectedCategory);
      _mainCategories.remove(_selectedCategory);
      _moreCategories.remove(_selectedCategory);

      if (_mainCategories.isNotEmpty) {
        _selectedCategory = _mainCategories.first;
      } else if (_moreCategories.isNotEmpty) {
        _selectedCategory = _moreCategories.first;
      }
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
        title: const Text("Add New Section", style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: _sectionController,
          decoration: const InputDecoration(
            hintText: "Enter Section Name (e.g. Mugs)",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: _addNewSection,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF52B788)),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteSectionConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Delete Section?"),
        content: Text("Are you sure you want to delete '$_selectedCategory'?\n\nAll items inside this section will also be deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: _deleteCurrentSection,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddPackageDialog() {
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
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_outlined, size: 35),
                      const SizedBox(height: 5),
                      const Text("Upload a Picture", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(hintText: "Item Name", border: InputBorder.none),
                      ),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(hintText: "Price: 1200", border: InputBorder.none),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  elevation: 0,
                ),
                child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildCategoryTabs(),
            Expanded(child: _buildMainContentPanel()),
            const SizedBox(height: 15),
            _buildBottomActionBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ..._mainCategories.map((cat) => _buildTabItem(
              title: cat,
              isSelected: _selectedCategory == cat,
              onTap: () => setState(() => _selectedCategory = cat),
            )),
            if (_moreCategories.isNotEmpty) _buildMoreTab(),
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

  Widget _buildMoreTab() {
    bool isMoreSelected = _moreCategories.contains(_selectedCategory);

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (String value) => setState(() => _selectedCategory = value),
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
              isMoreSelected ? _selectedCategory : 'More', 
              style: TextStyle(
                color: isMoreSelected ? Colors.black : Colors.black87,
                fontWeight: isMoreSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: isMoreSelected ? Colors.black : Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContentPanel() {
    final currentItems = _items.where((item) => item.category == _selectedCategory).toList();

    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: const BoxDecoration(color: Color(0xFF4A5777), borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedCategory, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                GestureDetector(
                  onTap: _showDeleteSectionConfirmDialog,
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8, 
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.62, 
                  ),
                  itemCount: currentItems.length, 
                  itemBuilder: (context, index) => _buildMiniServiceCard(currentItems[index]), 
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: _showAddPackageDialog, 
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Colors.green[400], borderRadius: BorderRadius.circular(2)),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
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
          style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.black), 
          maxLines: 1, 
          overflow: TextOverflow.ellipsis
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₱${item.price}", style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
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
        width: double.infinity, height: 48,
        decoration: BoxDecoration(color: const Color(0xFF5E6A82), borderRadius: BorderRadius.circular(25)),
        child: const Center(
          child: Text(
            "+ Add/Update New Section", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
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