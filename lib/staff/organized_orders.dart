import 'package:flutter/material.dart';

class CustomizedOrdersPage extends StatefulWidget {
  const CustomizedOrdersPage({super.key});

  @override
  State<CustomizedOrdersPage> createState() => _CustomizedOrdersPageState();
}

class _CustomizedOrdersPageState extends State<CustomizedOrdersPage> {
  String _activeItem = 'Packages';
  bool showTrackSaved = false;
  bool isMoreDropdownOpen = false;

  // Overlay entry for the "More" dropdown menu
  OverlayEntry? _moreOverlayEntry;

  // State for the Floating Order Details View
  bool showFloatingOrderDetails = false;
  Map<String, dynamic>? activeFloatingOrder;
  bool showRemainingBalanceInput = false;

  // SAVED ORDERS LIST
  final List<Map<String, dynamic>> savedOrders = [
    // Main Categories
    {'item': 'Package 1', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Packages'},
    {'item': 'Souvenir', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Souvenir'},
    {'item': 'Invitation', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Invitation'},
    {'item': 'Candle', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Candle'},
    {'item': 'Ref Magnet', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Ref Magnet'},
    
    // "More" Items
    {'item': 'T-shirt', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'T-shirt'},
    {'item': 'Chip Bag', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Chip Bag'},
    {'item': 'Button Badge', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Button Badge'},
    {'item': 'Button Pin', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Button Pin'},
    {'item': 'Party Hat', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Party Hat'},
    {'item': 'Jigsaw Puzzle', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Jigsaw Puzzle'},
    {'item': 'Banner', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Banner'},
    {'item': 'Calendar', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Calendar'},
    {'item': 'Hair Brush', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Hair Brush'},
    {'item': 'Clock', 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Clock'},
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
    "Hair Brush", // Moved back here to fix overflow
    "Clock"
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
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

    _moreOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + button.size.height + 5,
        left: position.dx,
        child: Material(
          color: Colors.transparent,
          child: _buildDropdownMenu(),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // TOP BAR
          _buildTopBar(),
          const SizedBox(height: 16),

          // MAIN CONTENT
          Expanded(
            child: showFloatingOrderDetails
                ? _buildFloatingOrderDetailsView()
                : (showTrackSaved
                    ? _buildTrackSavedView()
                    : _buildFormView()),
          ),
        ],
      ),
    );
  }

    Widget _buildFloatingOrderDetailsView() {
    final isSouvenir = activeFloatingOrder?['item'] == 'Souvenir';
    final isCandle = activeFloatingOrder?['item'] == 'Candle';
    final isRefMagnet = activeFloatingOrder?['item'] == 'Ref Magnet';
    final isTshirtOrChipBag = activeFloatingOrder?['item'] == 'T-shirt' || activeFloatingOrder?['item'] == 'Chip Bag';
    final isButtonBadge = activeFloatingOrder?['item'] == 'Button Badge';
    final isButtonPin = activeFloatingOrder?['item'] == 'Button Pin';
    final isPartyHat = activeFloatingOrder?['item'] == 'Party Hat';
    final isJigsawPuzzle = activeFloatingOrder?['item'] == 'Jigsaw Puzzle';
    final isBanner = activeFloatingOrder?['item'] == 'Banner';
    final isCalendarOrClock = activeFloatingOrder?['item'] == 'Calendar' || activeFloatingOrder?['item'] == 'Clock';
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
                        onPressed: () => setState(() => showFloatingOrderDetails = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- CONDITIONAL LAYOUTS (All readOnly: true) ---
                  
                  // 1. CANDLE
                  if (isCandle) ...[
                    const Text("Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                    const SizedBox(height: 8),
                    TextField(
                      readOnly: true,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter order info here.....",
                        filled: true,
                        fillColor: const Color(0xFFB0B8D0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _formRow("Downpayment", "Remaining Balance", readOnly: true),
                    const SizedBox(height: 20),
                  ] 
                  // 2. SOUVENIR
                  else if (isSouvenir) ...[
                    _formRow("Name", "Event Date", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Theme", "Occasion Type", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Down Payment", "Remaining Balance", readOnly: true),
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
                    _buildTextArea("Additional Details", "Enter any additional details here.....", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Down Payment", "Remaining Balance", readOnly: true),
                    const SizedBox(height: 20),
                  ]
                  // 4. T-SHIRT & CHIP BAG
                  else if (isTshirtOrChipBag) ...[
                    const Text("Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                    const SizedBox(height: 8),
                    TextField(
                      readOnly: true,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter details here.....",
                        filled: true,
                        fillColor: const Color(0xFFB0B8D0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Remaining Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        const Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Remaining Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        const Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Remaining Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Theme", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        const Text("Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Remaining Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        const Text("Theme", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Remaining Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        const Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Enter details here.....",
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Remaining Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        const Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Remaining Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        const Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                        const SizedBox(height: 5),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFB0B8D0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const Text("Remaining Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                              const SizedBox(height: 5),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFB0B8D0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    _buildTextArea("Additional Details", "Enter any additional details here.....", readOnly: true),
                    const SizedBox(height: 12),
                    _formRow("Down Payment", "Remaining Balance", readOnly: true),
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
                            const Text("Uploaded Images", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
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
                            const Text("Input Remaining Balance?", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => setState(() => showRemainingBalanceInput = true),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853)),
                                  child: const Text("YES", style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => setState(() => showRemainingBalanceInput = false),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text("NO", style: TextStyle(color: Colors.white)),
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
                                    colors: [Color(0xFFD6E4FF), Color(0xFFFFFFFF)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Remaining Balance", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E3A59))),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                                      ),
                                      // THIS FIELD REMAINS EDITABLE
                                      child: const TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                          hintText: '0.00',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Balance Saved'), backgroundColor: Color(0xFF00C853)),
                                          );
                                          setState(() => showRemainingBalanceInput = false);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF00C853),
                                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 4,
                                        ),
                                        child: const Text("SAVE", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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
                  ...mainTabs.map((tab) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildTabChip(tab),
                      )).toList(),
                  
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
              color: showTrackSaved ? const Color(0xFF55A888) : const Color(0xFF373E4E),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Increased padding
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
                fontSize: 14, // Increased font size
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
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.grey.shade300
                      : Colors.transparent,
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2E3A59),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Increased padding
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
              fontSize: 14, // Increased font size
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
              moreItems.contains(_activeItem)
                  ? 'Custom Order: $_activeItem'
                  : _activeItem,
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
            // Exclude Packages, Invitation, Souvenir (they have own layouts)
            // Exclude all "More" items (Candle, T-shirt, etc.) because they handle it themselves
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
        const Text("Upload Image",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E3A59))),
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
                    children:
                        List.generate(maxImages > 5 ? 5 : maxImages, (index) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: CustomPaint(
                          painter: DashedBorderPainter(),
                          child: const Center(
                            child: Icon(Icons.add,
                                color: Colors.black, size: 30),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  const Text("Choose Files  No file chosen",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("SAVE",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
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
        _buildTextArea("Additional Details", "Enter any additional details here....."),
        const SizedBox(height: 12),
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Down Payment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(4, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'type': moreItems.contains(_activeItem) ? 'More Item' : _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
                  const Text("Down Payment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({
                  'item': _activeItem,
                  'type': moreItems.contains(_activeItem) ? 'More Item' : _activeItem,
                  'commissioned': 'Staff Name',
                  'branch': 'CAMPO',
                  'downpayment': '₱ 0.00',
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  'type': 'Candle'
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ],
    );
  }
  Widget _buildTshirtForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Details
        _buildTextArea("Details", "Enter details here....."),
        const SizedBox(height: 12),
        // Additional Custom Order
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        // Payment Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Upload Image (5 Boxes)
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        // Save Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'T-shirt'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ],
    );
  }
 Widget _buildChipBagForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Details
        _buildTextArea("Details", "Enter details here....."),
        const SizedBox(height: 12),
        // Additional Custom Order
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        // Payment Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Upload Image (5 Boxes)
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        // Save Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'T-shirt'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ],
    );
  }


 Widget _buildButtonBadgeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        _buildInput("Name"),
        const SizedBox(height: 12),
        // Additional Custom Order
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        // Payment Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Upload Image (1 Box)
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        // Save Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Button Badge'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ],
    );
  }

     Widget _buildButtonPinForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        _buildInput("Name"),
        const SizedBox(height: 12),
        // Additional Details
        _buildTextArea("Additional Details", "Enter any additional details here....."),
        const SizedBox(height: 12),
        // Additional Custom Order
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        // Payment Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Upload Image (1 Box)
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        // Save Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Button Pin'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ],
    );
  }

 Widget _buildPartyHatForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name & Theme Row
        Row(
          children: [
            Expanded(child: _buildInput("Name")),
            const SizedBox(width: 12),
            Expanded(child: _buildInput("Theme")),
          ],
        ),
        const SizedBox(height: 12),
        // Additional Details
        _buildTextArea("Additional Details", "Enter any additional details here....."),
        const SizedBox(height: 12),
        // Additional Custom Order
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        // Payment Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Upload Image (5 Boxes)
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        // Save Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Party Hat'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Jigsaw Puzzle'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Jigsaw Puzzle'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
            Expanded(child: _buildTextArea("Additional Custom Order", "Enter any additional custom order here.....")),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextArea("Additional Details", "Enter any additional details here....."),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Calendar'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
            Expanded(child: _buildTextArea("Additional Custom Order", "Enter any additional custom order here.....")),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: CustomPaint(
            painter: DashedBorderPainter(),
            child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Hair Brush'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
            Expanded(child: _buildTextArea("Additional Custom Order", "Enter any additional custom order here.....")),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(13, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                savedOrders.add({'item': _activeItem, 'commissioned': 'Staff Name', 'branch': 'CAMPO', 'downpayment': '₱ 0.00', 'type': 'Clock'});
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
        _buildTextArea("Additional Details", "Enter any additional details here....."),
        const SizedBox(height: 12),
        _buildTextArea("Additional Custom Order", "Enter any additional custom order here....."),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Down Payment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  const Text("Balance after Downpayment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 5),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Amount",
                      filled: true,
                      fillColor: const Color(0xFFB0B8D0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: List.generate(5, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: const Center(child: Icon(Icons.add, color: Colors.black, size: 30)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text("Choose Files No file chosen", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                  'type': 'Ref Magnet'
                });
                showTrackSaved = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ],
    );
  }

  Widget _formRow(String leftLabel, String rightLabel, {bool readOnly = false}) {
    return Row(
      children: [
        Expanded(child: _buildInput(leftLabel, readOnly: readOnly)),
        const SizedBox(width: 12),
        Expanded(child: rightLabel.isEmpty ? const SizedBox.shrink() : _buildInput(rightLabel, readOnly: readOnly)),
      ],
    );
  }

  Widget _buildInput(String label, {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 5),
        TextField(
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: label == "Date of Occasion/Event" ? "mm/dd/yyyy" : null,
            filled: true,
            fillColor: const Color(0xFFB0B8D0),
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

  Widget _buildTextArea(String label, String hint, {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                    child: Text("Item",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
                Expanded(
                    child: Text("Commissioned by",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
                Expanded(
                    child: Text("Shop Branch",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
                Expanded(
                    child: Text("Downpayment",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
                Expanded(
                    child: Center(
                        child: Text("Detailed Information",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)))),
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
                      vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? Colors.white
                        : const Color(0xFFE8F0FE),
                    border: Border(
                      bottom: BorderSide(
                          color: const Color(0xFFB0C4DE), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(order['item']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500))),
                      Expanded(child: Text(order['commissioned']!)),
                      Expanded(child: Text(order['branch']!)),
                      Expanded(child: Text(order['downpayment']!)),
                      Expanded(
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Updated Condition: Include Party Hat
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
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(6)),
                            ),
                            child: const Text("VIEW",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
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