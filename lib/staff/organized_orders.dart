import 'package:flutter/material.dart';

class CustomizedOrdersPage extends StatefulWidget {
  const CustomizedOrdersPage({super.key});

  @override
  State<CustomizedOrdersPage> createState() => _CustomizedOrdersPageState();
}

class _CustomizedOrdersPageState extends State<CustomizedOrdersPage> {
  String _activeItem = 'Packages';
  bool showTrackSaved = false;
  bool showRemainingInput = false;
  
  // Sample saved orders
  final List<Map<String, dynamic>> savedOrders = [
    {
      'item': 'Package 1',
      'type': 'Packages',
      'date': '2026-01-31',
      'details': 'Name: Juan, Theme: Birthday, Down Payment: ₱500.00',
    },
    {
      'item': 'Souvenir Order',
      'type': 'Souvenir',
      'date': '2026-01-30',
      'details': 'Name: Maria, Theme: Wedding, Down Payment: ₱300.00',
    },
  ];

  final List<String> mainTabs = [
    "Packages", "Souvenir", "Invitation", "Candle", "Ref Magnet"
  ];

  final List<String> moreItems = [
    "T-shirt", "Chip Bag", "Button Badge", "Button Pin", "Party Hat",
    "Jigsaw Puzzle", "Banner", "Calendar", "Hair Brush", "Clock"
  ];

  bool isMoreDropdownOpen = false;
  OverlayEntry? _moreOverlayEntry;

  void _selectItem(String item) {
    setState(() {
      _activeItem = item;
      _closeMoreMenu();
      showTrackSaved = false;
      showRemainingInput = false;
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
    // Get the position of the button that triggered this
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

    _moreOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Position exactly under the button
        top: buttonPosition.dy + button.size.height + 5, 
        left: buttonPosition.dx, 
        child: _buildDropdownMenu(),
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
            child: showTrackSaved 
                ? _buildTrackSavedView() 
                : _buildFormView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        // Tab Navigation
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...mainTabs.map((tab) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _buildTabChip(tab),
                  )),
                  const SizedBox(width: 4),
                  
                  // MORE BUTTON wrapped in Builder to get its specific context
                  Builder(
                    builder: (context) => _buildMoreButton(context),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Track Saved Orders Button
        GestureDetector(
          onTap: () {
            setState(() {
              showTrackSaved = !showTrackSaved;
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              ),
            ),
            Icon(
              isMoreDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: isMoreActive ? Colors.white : Colors.black87,
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
        width: 180, // Fixed width for the dropdown
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: moreItems.map((item) {
            return InkWell(
              onTap: () => _selectItem(item),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E3A59),
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
      child: Chip(
        label: Text(label),
        backgroundColor: isActive
            ? const Color(0xFF373E4E)
            : Colors.transparent,
        labelStyle: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFormView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              moreItems.contains(_activeItem) ? 'Custom Order: $_activeItem' : _activeItem,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 20),
            
            // Dynamic Form based on selected item
            _getFormForItem(_activeItem),
            
            const SizedBox(height: 20),
            
            // Common: Downpayment and Balance
            _formRow("Downpayment", "Remaining Balance"),
            
            const SizedBox(height: 20),
            
            // Remaining Balance Toggle
            Row(
              children: [
                const Text("Input Remaining Balance?", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF2E3A59))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => showRemainingInput = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text("YES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => showRemainingInput = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text("NO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            
            if (showRemainingInput) ...[
              const SizedBox(height: 10),
              _buildInput("Remaining Balance"),
            ],
            
            const SizedBox(height: 30),
            
            // Bottom Section: Image Upload and Save Button
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    // Determine max images based on item type
    int maxImages = 1;
    if (_activeItem == 'Packages' || _activeItem == 'Invitation' || _activeItem == 'Ref Magnet' ||
        _activeItem == 'T-shirt' || _activeItem == 'Chip Bag' || _activeItem == 'Party Hat' || 
        _activeItem == 'Jigsaw Puzzle') {
      maxImages = 5;
    } else if (_activeItem == 'Clock') {
      maxImages = 13;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Upload Label
        const Text("Upload Image", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 10),

        // Row containing Image Uploaders and Save Button
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Left Side: Image Uploaders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid of dashed boxes
                  Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    children: List.generate(maxImages > 5 ? 5 : maxImages, (index) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        child: CustomPaint(
                          painter: DashedBorderPainter(),
                          child: const Center(
                            child: Icon(Icons.add, color: Colors.black, size: 30),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Choose Files  No file chosen",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Right Side: Save Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  savedOrders.add({
                    'item': _activeItem,
                    'type': moreItems.contains(_activeItem) ? 'More Item' : _activeItem,
                    'date': DateTime.now().toString().split(' ')[0],
                    'details': 'Saved order details...',
                  });
                  showTrackSaved = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("SAVE", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getFormForItem(String item) {
    switch (item) {
      case 'Packages':
        return _buildPackagesForm();
      case 'Souvenir':
        return _buildSouvenirForm();
      case 'Invitation':
        return _buildInvitationForm();
      case 'Candle':
        return _buildCandleForm();
      case 'Ref Magnet':
        return _buildRefMagnetForm();
      case 'T-shirt':
        return _buildTshirtForm();
      case 'Chip Bag':
        return _buildChipBagForm();
      case 'Button Badge':
        return _buildButtonBadgeForm();
      case 'Button Pin':
        return _buildButtonPinForm();
      case 'Party Hat':
        return _buildPartyHatForm();
      case 'Jigsaw Puzzle':
        return _buildJigsawPuzzleForm();
      case 'Banner':
        return _buildBannerForm();
      case 'Calendar':
        return _buildCalendarForm();
      case 'Hair Brush':
        return _buildHairBrushForm();
      case 'Clock':
        return _buildClockForm();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPackagesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Name", "Date of Occasion/Event"),
        const SizedBox(height: 12),
        _formRow("Theme", "Type of Occasion/Event"),
        const SizedBox(height: 12),
        _formRow("Reception Venue", "Church Venue"),
        const SizedBox(height: 12),
        _buildTextArea("Additional Info", "Enter any additional details here....."),
      ],
    );
  }

  Widget _buildSouvenirForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Name", "Date of Occasion/Event"),
        const SizedBox(height: 12),
        _formRow("Theme", "Type of Occasion/Event"),
      ],
    );
  }

  Widget _buildInvitationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Name", "Date of Occasion/Event"),
        const SizedBox(height: 12),
        _formRow("Theme", "Type of Occasion/Event"),
        const SizedBox(height: 12),
        _formRow("Reception Venue", "Church Venue"),
        const SizedBox(height: 12),
        _buildTextArea("Additional Info", "Enter any additional details here....."),
      ],
    );
  }

  Widget _buildCandleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextArea("Info", "Enter order info here....."),
      ],
    );
  }

  Widget _buildRefMagnetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formRow("Name", "Date of Occasion/Event"),
        const SizedBox(height: 12),
        _formRow("Theme", "Type of Occasion/Event"),
        const SizedBox(height: 12),
        _formRow("Reception Venue", ""),
        const SizedBox(height: 12),
        _buildTextArea("Additional Info", "Enter any additional details here....."),
      ],
    );
  }

  Widget _buildTshirtForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextArea("Info", "Enter order info here....."),
      ],
    );
  }

  Widget _buildChipBagForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextArea("Info", "Enter order info here....."),
      ],
    );
  }

  Widget _buildButtonBadgeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Name"),
        const SizedBox(height: 12),
        _buildTextArea("Additional Info", "Enter additional info here....."),
      ],
    );
  }

  Widget _buildButtonPinForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Name"),
        const SizedBox(height: 12),
        _buildTextArea("Additional Info", "Enter additional info here....."),
      ],
    );
  }

  Widget _buildPartyHatForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Name"),
        const SizedBox(height: 12),
        _buildInput("Theme"),
        const SizedBox(height: 12),
        _buildTextArea("Additional Info", "Enter additional info here....."),
      ],
    );
  }

  Widget _buildJigsawPuzzleForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Theme"),
        const SizedBox(height: 12),
        _buildTextArea("Info", "Enter order info here....."),
      ],
    );
  }

  Widget _buildBannerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextArea("Info", "Enter order info here....."),
        const SizedBox(height: 12),
        _buildInput("Theme"),
      ],
    );
  }

  Widget _buildCalendarForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Name"),
        const SizedBox(height: 12),
        _buildTextArea("Additional Info", "Enter additional info here....."),
      ],
    );
  }

  Widget _buildHairBrushForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Name"),
      ],
    );
  }

  Widget _buildClockForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInput("Name"),
      ],
    );
  }

  Widget _formRow(String leftLabel, String rightLabel) {
    return Row(
      children: [
        Expanded(child: _buildInput(leftLabel)),
        const SizedBox(width: 12),
        Expanded(child: rightLabel.isEmpty ? const SizedBox.shrink() : _buildInput(rightLabel)),
      ],
    );
  }

  Widget _buildInput(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 5),
        TextField(
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

  Widget _buildTextArea(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        const SizedBox(height: 5),
        TextField(
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Track Saved Orders",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3A59),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF373E4E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: const [
                Expanded(child: Text("Item", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                Expanded(child: Text("Type", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                Expanded(child: Text("Date Saved", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                Expanded(child: Text("Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savedOrders.length,
              itemBuilder: (context, index) {
                final order = savedOrders[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.1))),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(order['item']!, style: const TextStyle(fontWeight: FontWeight.w500))),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF55A888).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order['type']!,
                            style: const TextStyle(
                              color: Color(0xFF55A888),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Text(order['date']!)),
                      Expanded(
                        child: Text(
                          order['details']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
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

// Custom Painter for Dashed Border
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

    // Top
    while (currentX < size.width) {
      path.moveTo(currentX, 0);
      currentX = currentX + dashWidth < size.width ? currentX + dashWidth : size.width;
      path.lineTo(currentX, 0);
      currentX += dashSpace;
    }

    // Right
    currentY = 0;
    while (currentY < size.height) {
      path.moveTo(size.width, currentY);
      currentY = currentY + dashWidth < size.height ? currentY + dashWidth : size.height;
      path.lineTo(size.width, currentY);
      currentY += dashSpace;
    }

    // Bottom
    currentX = size.width;
    while (currentX > 0) {
      path.moveTo(currentX, size.height);
      currentX = currentX - dashWidth > 0 ? currentX - dashWidth : 0;
      path.lineTo(currentX, size.height);
      currentX -= dashSpace;
    }

    // Left
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