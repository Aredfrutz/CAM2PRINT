import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

// DATA MODEL
class ServiceItem {
  final String id;
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

  ServiceItem copyWith({
    String? id,
    String? name,
    String? price,
    String? category,
    String? section,
    String? imageUrl,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      section: section ?? this.section,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class AdminServicesPage extends StatefulWidget {
  const AdminServicesPage({super.key});

  @override
  State<AdminServicesPage> createState() => _AdminServicesPageState();
}

class _AdminServicesPageState extends State<AdminServicesPage> {
  String _selectedCategory = 'Packages';
  bool _isLoading = true;
  bool _isSavingItem = false;
  Uint8List? _newItemPhotoBytes;
  final ImagePicker _picker = ImagePicker();

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

  String? _targetSectionForNewPackage;

  // ==========================================
  // ITEM LOGIC
  // ==========================================
  Future<Uint8List> _compressImage(Uint8List bytes) async {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;
    final resized = decoded.width > 1200
        ? img.copyResize(decoded, width: 1200)
        : decoded;
    return Uint8List.fromList(img.encodeJpg(resized, quality: 75));
  }

  Future<void> _pickServicePhoto() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() {
      _newItemPhotoBytes = bytes;
    });
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
            id: (map['id'] ?? '').toString(),
            name: (map['title'] ?? '').toString(),
            price: (map['price'] ?? '').toString(),
            category: category,
            section: section,
            imageUrl: (map['image_url'] ?? '').toString().isEmpty
                ? null
                : (map['image_url'] ?? '').toString(),
          ),
        );
      }

      // ✅ SORT ALPHABETICALLY BY NAME
      parsed.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      if (!mounted) return;
      setState(() {
        _items..clear()..addAll(parsed);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load services: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addNewPackage() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _targetSectionForNewPackage != null) {
      try {
        setState(() => _isSavingItem = true);
        String? imageUrl;
        if (_newItemPhotoBytes != null) {
          final compressed = await _compressImage(_newItemPhotoBytes!);
          final path =
              'services/${DateTime.now().millisecondsSinceEpoch}_${_nameController.text.trim().replaceAll(' ', '_')}.jpg';
          await Supabase.instance.client.storage
              .from('services-photos')
              .uploadBinary(
                path,
                compressed,
                fileOptions: const FileOptions(
                  contentType: 'image/jpeg',
                  upsert: false,
                ),
              );
          imageUrl = Supabase.instance.client.storage
              .from('services-photos')
              .getPublicUrl(path);
          print('🖼️ IMAGE URL: $imageUrl');
        }

        await Supabase.instance.client.from('services').insert({
          'title': _nameController.text.trim(),
          'price': _priceController.text.trim(),
          'category': _selectedCategory,
          'section': _targetSectionForNewPackage!,
          'image_url': imageUrl,
        });

        _nameController.clear();
        _priceController.clear();
        _newItemPhotoBytes = null;
        if (!mounted) return;
        Navigator.pop(context);
        await _loadServices();
      } catch (e) {
        print('❌ SAVE ERROR: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save item: $e')),
        );
      } finally {
        if (mounted) setState(() => _isSavingItem = false);
      }
    }
  }

  void _showDeleteConfirmation(ServiceItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Service?"),
        content: Text(
          "Are you sure you want to delete '${item.name}'?\nThis cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteItem(item.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(String id) async {
    try {
      await Supabase.instance.client.from('services').delete().eq('id', id);
      if (!mounted) return;
      setState(() {
        _items.removeWhere((element) => element.id == id);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete item: $e')),
      );
    }
  }

  Future<void> _showEditPriceDialog(ServiceItem item) async {
    final controller = TextEditingController(text: item.price);
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Price'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter new price',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPrice = controller.text.trim();
              if (newPrice.isEmpty) return;
              try {
                await Supabase.instance.client
                    .from('services')
                    .update({'price': newPrice})
                    .eq('id', item.id);
                if (!mounted) return;
                setState(() {
                  final idx = _items.indexWhere((x) => x.id == item.id);
                  if (idx >= 0) {
                    _items[idx] = _items[idx].copyWith(price: newPrice);
                  }
                });
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update price: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ✅ SIMPLE FULL-SCREEN IMAGE: Tap outside to close, no X button
  void _showFullImage(ServiceItem item) {
    if (item.imageUrl == null || item.imageUrl!.isEmpty) return;
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(dialogContext),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                item.imageUrl!,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.white70),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SECTION LOGIC
  // ==========================================
  void _addNewSection() {
    if (_sectionController.text.isNotEmpty) {
      setState(() {
        _categorySections[_selectedCategory]!.add(_sectionController.text.trim());
      });
      _sectionController.clear();
      Navigator.pop(context);
    }
  }

  void _deleteSection(String sectionName) {
    setState(() {
      _categorySections[_selectedCategory]!.remove(sectionName);
      _items.removeWhere(
        (item) => item.category == _selectedCategory && item.section == sectionName,
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
        title: const Text("Add New Section", style: TextStyle(fontWeight: FontWeight.bold)),
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
            child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
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
      builder: (context) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
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
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () async {
                          final file = await _picker.pickImage(source: ImageSource.gallery);
                          if (file == null) return;
                          final bytes = await file.readAsBytes();
                          setDialogState(() {
                            _newItemPhotoBytes = bytes;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _newItemPhotoBytes != null
                              ? Image.memory(
                                  _newItemPhotoBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined, size: 35),
                                    SizedBox(height: 5),
                                    Text(
                                      "Upload a Picture",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    onPressed: _isSavingItem ? null : _addNewPackage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF52B788),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      elevation: 0,
                    ),
                    child: _isSavingItem
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text("Save", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
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
      SnackBar(content: Text('$pageName not connected yet.'), duration: const Duration(seconds: 1)),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, VoidCallback onTap, {bool isActive = false}) {
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
                Icon(icon, color: isActive ? const Color(0xFF1A237E) : Colors.white70, size: 20),
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
      backgroundColor: const Color(0xFF9FA8DA),
      body: Container(
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
            // SIDEBAR
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
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
                            child: Image.asset('assets/logo.png', width: 42, height: 42, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Cam2print System',
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildSidebarItem(Icons.people, "Staff Management", () => _navigateTo('Staff Management')),
                          _buildSidebarItem(Icons.inventory_2, "Overall Inventory", () => _navigateTo('Overall Inventory')),
                          _buildSidebarItem(Icons.settings, "Services", () => _navigateTo('Services'), isActive: true),
                          _buildSidebarItem(Icons.attach_money, "Salary", () => _navigateTo('Salary')),
                          _buildSidebarItem(Icons.shopping_cart, "Customized Orders", () => _navigateTo('Customized Orders')),
                          _buildSidebarItem(Icons.calendar_today, "Schedule", () => _navigateTo('Schedule')),
                          _buildSidebarItem(Icons.error_outline, "Reports", () => _navigateTo('Reports')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => Navigator.pushReplacementNamed(context, AppRouter.login),
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.white70, size: 20),
                                SizedBox(width: 12),
                                Text('Logout', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
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

            // MAIN CONTENT
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E)),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _navigateTo('Notifications'),
                                child: const Icon(Icons.notifications_none, color: Color(0xFF1A237E), size: 24),
                              ),
                              const SizedBox(width: 20),
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person, size: 26, color: Color(0xFF1A237E)),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A237E))),
                                  
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildCategoryTabs(),
                          const SizedBox(height: 15),
                          Expanded(child: _buildMainContentPanel()),
                          Padding(padding: const EdgeInsets.only(top: 20), child: _buildBottomActionBtn()),
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

  // ✅ FIXED THEME WIDGET WITH 'data:'
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
              Icon(Icons.keyboard_arrow_down, size: 16, color: isMoreSelected ? Colors.black : Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContentPanel() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    final sections = _categorySections[_selectedCategory] ?? [];
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF1F4F9), borderRadius: BorderRadius.circular(5)),
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _buildSectionBlock(sections[index]),
      ),
    );
  }

  Widget _buildSectionBlock(String sectionName) {
    final currentItems = _items.where((item) => item.category == _selectedCategory && item.section == sectionName).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF4A5777),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            border: Border(top: BorderSide(color: Colors.blueAccent, width: 3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showAddPackageDialog(sectionName),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Colors.green[400], borderRadius: BorderRadius.circular(2)),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => _showDeleteSectionConfirmDialog(sectionName),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        currentItems.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: Text("No items yet. Click '+' to add.", style: TextStyle(color: Colors.black54))),
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
                itemBuilder: (context, index) => _buildMiniServiceCard(currentItems[index]),
              ),
      ],
    );
  }

  // ✅ ORIGINAL SIMPLE CARD DESIGN
  Widget _buildMiniServiceCard(ServiceItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showFullImage(item),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF6A7B9C),
                borderRadius: BorderRadius.circular(4),
                image: item.imageUrl != null
                    ? DecorationImage(image: NetworkImage(item.imageUrl!), fit: BoxFit.cover)
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.name,
          style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => _showEditPriceDialog(item),
              child: Text(item.price, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
            GestureDetector(
              onTap: () => _showDeleteConfirmation(item),
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
        decoration: BoxDecoration(color: const Color(0xFF5E6A82), borderRadius: BorderRadius.circular(25)),
        child: const Center(
          child: Text("+ Add/Update New Section", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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