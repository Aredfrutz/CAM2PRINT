import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final DateTime date = DateTime.now();

// Configurations for the category dropdown list
typedef CategoryEntry = DropdownMenuEntry<CategoryLabel>;

enum CategoryLabel {
  schoolSupplies('School Supplies'),
  partyNeeds('Party Needs');

  const CategoryLabel(this.label);
  final String label;

  static final List<CategoryEntry> entries = UnmodifiableListView<CategoryEntry>(
    values.map<CategoryEntry>(
      (CategoryLabel category) =>
          CategoryEntry(value: category, label: category.label),
    ),
  );
}

// Configurations for the location dropdown list
typedef LocationEntry = DropdownMenuEntry<LocationLabel>;

enum LocationLabel {
  campo('CAMPO'),
  siloam('SILOAM'),
  lanzones('LANZONES'),
  narra('NARRA'),
  phase3('PHASE 3'),
  urban('URBAN'),
  eightB('8B'),
  montalban('MONTALBAN'),
  montalbanBago('MONTALBAN BAGO');

  const LocationLabel(this.label);
  final String label;

  static final List<LocationEntry> entries = UnmodifiableListView<LocationEntry>(
    values.map<LocationEntry>(
      (LocationLabel location) =>
          LocationEntry(value: location, label: location.label),
    ),
  );
}

class InventoryItem {
  InventoryItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  });

  final String name;
  final String price;
  final String quantity;
  final String category;
}

class OverallInventoryPage extends StatefulWidget {
  const OverallInventoryPage({super.key});

  @override
  State<OverallInventoryPage> createState() => _OverallInventoryPageState();
}

class _OverallInventoryPageState extends State<OverallInventoryPage> {
  CategoryLabel _selectedCategory = CategoryLabel.schoolSupplies;
  LocationLabel _selectedLocation = LocationLabel.campo;

  void _navigateTo(String pageName) {
    String? routeName;
    switch (pageName) {
      case 'Staff Management':
        routeName = AppRouter.adminStaffManagement;
        break;
      case 'Overall Inventory':
        routeName = AppRouter.adminServices;
        break;
      case 'Services':
        routeName = AppRouter.adminServices;
        break;
      case 'Salary':
        routeName = AppRouter.adminServices;
        break;
      case 'Customized Orders':
        routeName = AppRouter.adminCustomOrders;
        break;
      case 'Schedule':
        routeName = AppRouter.adminSchedule;
        break;
      case 'Reports':
        routeName = AppRouter.adminreports;
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

  // ✅ ADMIN SIDEBAR ITEM (White active state, Dark text)
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

  // ✅ Add Item Dialog
  void _showAddItemDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    CategoryLabel selectedCategory = _selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Item',
                      style: GoogleFonts.baiJamjuree(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Item Name
                    _buildDialogInputField(
                      context,
                      'Item Name',
                      nameController,
                      'Enter item name',
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    Text(
                      'Category',
                      style: GoogleFonts.baiJamjuree(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButton<CategoryLabel>(
                        value: selectedCategory,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items: CategoryLabel.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.value,
                            child: Text(entry.label),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Price and Quantity Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDialogInputField(
                            context,
                            'Price',
                            priceController,
                            '0.00',
                            isNumeric: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDialogInputField(
                            context,
                            'Quantity',
                            quantityController,
                            '0',
                            isNumeric: true,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                priceController.text.isNotEmpty &&
                                quantityController.text.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Item "${nameController.text}" added!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Add Item', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogInputField(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumeric = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.baiJamjuree(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
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
            // ✅ ADMIN SIDEBAR
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
              ),
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
                      isActive: true,
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
                    
                    const Spacer(),
                    
                    // ✅ LOGOUT BUTTON
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

            // ✅ MAIN CONTENT
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Admin Header Style
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
                    
                    // ✅ HEADER WITH TITLE ON LEFT, DROPDOWNS ON RIGHT
                    Row(
                      children: [
                        // Title on Left
                        Text(
                          'Overall Inventory',
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        
                        // Dropdowns and Button on Right
                        Row(
                          children: [
                            // Category Dropdown - FIXED: inputDecorationTheme instead of decoration
                            SizedBox(
                              width: 180,
                              child: DropdownMenu<CategoryLabel>(
                                width: double.infinity,
                                menuHeight: 120,
                                inputDecorationTheme: InputDecorationTheme( // ✅ FIXED HERE
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  filled: false,
                                ),
                                selectOnly: true,
                                textAlign: TextAlign.left,
                                textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                initialSelection: _selectedCategory,
                                onSelected: (value) {
                                  if (value != null) {
                                    setState(() => _selectedCategory = value);
                                  }
                                },
                                dropdownMenuEntries: CategoryLabel.entries,
                              ),
                            ),
                            const SizedBox(width: 15),
                            
                            // Location Dropdown - FIXED: inputDecorationTheme instead of decoration
                            SizedBox(
                              width: 180,
                              child: DropdownMenu<LocationLabel>(
                                width: double.infinity,
                                menuHeight: 200,
                                inputDecorationTheme: InputDecorationTheme( // ✅ FIXED HERE
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  filled: false,
                                ),
                                selectOnly: true,
                                textAlign: TextAlign.left,
                                textStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                initialSelection: _selectedLocation,
                                onSelected: (value) {
                                  if (value != null) {
                                    setState(() => _selectedLocation = value);
                                  }
                                },
                                dropdownMenuEntries: LocationLabel.entries,
                              ),
                            ),
                            const SizedBox(width: 15),
                            
                            // Add Button
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0.0,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                tooltip: 'Add Item',
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: _showAddItemDialog,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 15),
                    
                    // ✅ Inventory Table with Fixed Column Widths
                    Expanded(
                      child: _SchoolSupplies(
                        title: _selectedCategory.label,
                        selectedLocation: _selectedLocation.label,
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
}

class _SchoolSupplies extends StatefulWidget {
  const _SchoolSupplies({
    required this.title,
    required this.selectedLocation,
  });

  final String title;
  final String selectedLocation;

  @override
  State<_SchoolSupplies> createState() => _SchoolSuppliesState();
}

class _SchoolSuppliesState extends State<_SchoolSupplies> {
  final List<InventoryItem> _items = [
    InventoryItem(name: 'Notebook', price: '120', quantity: '8', category: 'School Supplies'),
    InventoryItem(name: 'Ballpen', price: '15', quantity: '24', category: 'School Supplies'),
    InventoryItem(name: 'Eraser', price: '8', quantity: '12', category: 'School Supplies'),
  ];

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.title} - ${widget.selectedLocation}',
                  style: GoogleFonts.baiJamjuree(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  DateFormat('MMMM d, y').format(DateTime.now()),
                  style: GoogleFonts.baiJamjuree(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(2), // Item
                  1: FixedColumnWidth(120), // Category
                  2: FixedColumnWidth(100), // Price
                  3: FixedColumnWidth(100), // Quantity
                  4: FixedColumnWidth(80), // Actions
                },
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                    ),
                    children: <Widget>[
                      _buildHeaderCell(context, 'Item', Alignment.centerLeft),
                      _buildHeaderCell(context, 'Category', Alignment.center),
                      _buildHeaderCell(context, 'Price', Alignment.center),
                      _buildHeaderCell(context, 'Quantity', Alignment.center),
                      _buildHeaderCell(context, 'Actions', Alignment.center),
                    ],
                  ),
                  ..._items.asMap().entries.map(
                        (entry) => TableRow(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          children: <Widget>[
                            _buildBodyCell(
                              context,
                              entry.value.name,
                              Alignment.centerLeft,
                            ),
                            _buildBodyCell(
                              context,
                              entry.value.category,
                              Alignment.center,
                            ),
                            _buildBodyCell(
                              context,
                              entry.value.price,
                              Alignment.center,
                            ),
                            _buildBodyCell(
                              context,
                              entry.value.quantity,
                              Alignment.center,
                            ),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 18,
                                ),
                                tooltip: 'Delete row',
                                onPressed: () => _removeItem(entry.key),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
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
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String label,
    Alignment alignment,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: alignment,
      child: Text(
        label,
        style: GoogleFonts.baiJamjuree(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
        overflow: TextOverflow.visible,
      ),
    );
  }

  Widget _buildBodyCell(
    BuildContext context,
    String text,
    Alignment alignment,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.baiJamjuree(
          fontSize: 13,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}