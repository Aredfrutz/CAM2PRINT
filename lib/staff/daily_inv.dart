import 'package:flutter/material.dart';

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
    "A4 Photopaper", "SBP Printing", "LBP Printing", "A4 Printing", 
    "2x2 ID", "Mix ID", "Long/A4 Film", "Short Film", "6r Film", 
    "5r Film", "4r Film", "3r Film", "cute film", "Nametag Film", 
    "Sticker Paper", "SBP Xerox", "LBP Xerox", "Calling Card", 
    "PVC Set", "Double Sided Photopaper", "Bottle Opener Keychain", 
    "Big Rectangle Keychain", "Small Rectangle Keychain", "Heart Keychain", 
    "Dress Keychain", "Small Circle Keychain", "Acrylic Pin", "Button Pin", 
    "CP Holder", "3r Envelope", "4r Envelope", "Frame (100)", "Frame (120)", 
    "Frame (130)", "Frame (150)", "Frame (190)", "Album", "Certificate", 
    "Ink", "Hotspot", "ID Lace", "Candle (180,150,120)", "RIngbind Spring", 
    "A4 Paper Cover", "A4 Acetate Cover", "Short Paper Cover", "Short Acetate Cover"
  ];

  List<Map<String, String>> _inventoryItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize inventory items with default '0' values
    _inventoryItems = _rawItems.map((item) => {
      'item': item,
      'packs': '0',
      'pieces': '0',
      'correction': '0',
      'reason': ''
    }).toList();
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF55A888),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Filter',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildInventoryTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    // If in History mode, show History and Filter buttons
    if (_currentTab == 'history') {
      return Row(
        children: [
          // History Label (Green background, White text to match style of active button)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white, // White background indicates active tab
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'History',
              style: TextStyle(
                color: Color(0xFF55A888), // Green text
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          // Filter Button (Green)
          GestureDetector(
            onTap: _showFilterDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      );
    }

    // If in Inventory or Corrections mode
    return Row(
      children: [
        // Left Side: Add/Edit or Save Button (Red)
        GestureDetector(
          onTap: () {
            if (_currentTab == 'inventory') {
              // Toggle edit mode for inventory
              _toggleEditInventory();
            } else {
              // In corrections mode, clicking Save resets everything
              _saveAndReset();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE05555), // Red color
              borderRadius: BorderRadius.circular(25), // Fully rounded
            ),
            child: Text(
              // Logic to decide button text
              (_currentTab == 'inventory' && !_isEditingInventory)
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
        
        // Right Side: Corrections and History Buttons (Green)
        _buildRightSideButtons(),
      ],
    );
  }

  Widget _buildRightSideButtons() {
    return Row(
      children: [
        // Corrections Button
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
                  ? Colors.white // Active state: White bg
                  : const Color(0xFF55A888), // Inactive: Green bg
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Corrections',
              style: TextStyle(
                color: _currentTab == 'corrections'
                    ? const Color(0xFF55A888) // Active text: Green
                    : Colors.white, // Inactive text: White
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        
        // History Button
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
    bool showCorrectionColumns = (_currentTab == 'corrections' || _currentTab == 'history');
    
    // Determine if we should show spinners/inputs (editable mode)
    bool isEditable = (_currentTab == 'inventory' && _isEditingInventory) ||
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
                  flex: 2,
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
                  flex: 2,
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
                    flex: 2,
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                          flex: 2,
                          child: Center(
                            child: isEditable
                                ? _buildInputFieldWithSpinners(item, 'packs')
                                : _buildStaticInputField(item['packs']!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: isEditable
                                ? _buildInputFieldWithSpinners(item, 'pieces')
                                : _buildStaticInputField(item['pieces']!),
                          ),
                        ),
                        if (showCorrectionColumns) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: isEditable
                                  ? _buildInputFieldWithSpinners(item, 'correction')
                                  : _buildStaticInputField(item['correction']!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: isEditable
                                ? _buildReasonInputField(item)
                                : Text(
                                    item['reason']!.isNotEmpty ? item['reason']! : '-', 
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Color(0xFF334155), fontSize: 13),
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
      height: 36,
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
      height: 36,
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
            height: 36,
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
                    height: 18,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: const Color(0xFF5A6580), width: 0.5),
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
                  child: Container(
                    height: 18,
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
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF7C85A0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        textAlign: TextAlign.center, // Text is centered
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
}