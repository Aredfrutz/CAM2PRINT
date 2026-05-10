import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CustomizedOrdersPages extends StatefulWidget {
  const CustomizedOrdersPages({super.key});

  @override
  State<CustomizedOrdersPages> createState() => _CustomizedOrdersPageState();
}

class _CustomizedOrdersPageState extends State<CustomizedOrdersPages> {
  String _activeItem = 'Packages';
  bool showTrackSaved = false;
  bool isMoreDropdownOpen = false;
  OverlayEntry? _moreOverlayEntry;
  bool showFloatingOrderDetails = false;
  Map<String, dynamic>? activeFloatingOrder;
  bool showRemainingBalanceInput = false;
  bool _isSaving = false;
  bool _isUploadingImages = false;

  final Map<String, TextEditingController> _dynamicControllers = {
    'name': TextEditingController(),
    'event_date': TextEditingController(),
    'occasion_type': TextEditingController(),
    'church': TextEditingController(),
    'theme': TextEditingController(),
    'reception': TextEditingController(),
    'additional_info': TextEditingController(),
    'details': TextEditingController(),
    'down_payment': TextEditingController(),
    'balance': TextEditingController(),
  };

  List<XFile?> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final supabase = Supabase.instance.client;
  String _userName = 'Loading...';
  final String _userRole = 'Staff';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final profile = await supabase.from('profiles').select('full_name').eq('id', user.id).maybeSingle();
      if (mounted) setState(() => _userName = profile?['full_name'] ?? 'Staff');
    }
  }

  Future<void> _saveOrderToSupabase() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        for (var img in _selectedImages) {
          if (img != null) {
            final bytes = await img.readAsBytes();
            final fileName = '${DateTime.now().millisecondsSinceEpoch}_${img.name}';
            await supabase.storage.from('order-images').uploadBinary(
              fileName, bytes, fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
            imageUrls.add(supabase.storage.from('order-images').getPublicUrl(fileName));
          }
        }
      }

      await supabase.from('customized_orders').insert({
        'order_type': _activeItem,
        'staff_name': _userName,
        'customer_name': _dynamicControllers['name']!.text.trim().isEmpty ? 'None' : _dynamicControllers['name']!.text.trim(),
        'event_date': _dynamicControllers['event_date']!.text.trim().isEmpty ? null : _dynamicControllers['event_date']!.text.trim(),
        'occasion_type': _dynamicControllers['occasion_type']!.text.trim().isEmpty ? 'None' : _dynamicControllers['occasion_type']!.text.trim(),
        'church': _dynamicControllers['church']!.text.trim().isEmpty ? 'None' : _dynamicControllers['church']!.text.trim(),
        'theme': _dynamicControllers['theme']!.text.trim().isEmpty ? 'None' : _dynamicControllers['theme']!.text.trim(),
        'reception': _dynamicControllers['reception']!.text.trim().isEmpty ? 'None' : _dynamicControllers['reception']!.text.trim(),
        'down_payment': double.tryParse(_dynamicControllers['down_payment']!.text) ?? 0,
        'balance': double.tryParse(_dynamicControllers['balance']!.text) ?? 0,
        'remaining_balance': double.tryParse(_dynamicControllers['balance']!.text) ?? 0,
        'payment_status': 'Unpaid',
        'specific_details': {
          'additional_info': _dynamicControllers['additional_info']!.text.trim().isEmpty ? 'None' : _dynamicControllers['additional_info']!.text.trim(),
          'details': _dynamicControllers['details']!.text.trim().isEmpty ? 'None' : _dynamicControllers['details']!.text.trim(),
        },
        'image_urls': imageUrls,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Order Saved to Database!'), backgroundColor: Colors.green));
      _clearForm();
    } catch (e) {
      debugPrint("Error saving: $e");
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _clearForm() {
    _dynamicControllers.forEach((_, c) => c.clear());
    _selectedImages.clear();
    showRemainingBalanceInput = false;
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() => _selectedImages = images);
    }
  }

  final List<String> mainTabs = ["Packages", "Souvenir", "Invitation", "Candle", "Ref Magnet", "Chip Bag", "Button Badge", "Button Pin"];
  final List<String> moreItems = ["T-shirt", "Party Hat", "Jigsaw Puzzle", "Banner", "Calendar", "Hair Brush", "Clock"];

  void _selectItem(String item) {
    setState(() {
      _activeItem = item;
      _closeMoreMenu();
      showTrackSaved = false;
      showFloatingOrderDetails = false;
      _clearForm();
    });
  }

  void _toggleMoreMenu(BuildContext context) {
    if (_moreOverlayEntry != null) _closeMoreMenu(); else _showMoreMenu(context);
  }

  void _showMoreMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);
    _moreOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(top: position.dy + button.size.height + 5, left: position.dx, child: Material(color: Colors.transparent, child: _buildDropdownMenu())),
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
    _dynamicControllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  Widget _buildSidebarItem(IconData icon, String title, VoidCallback onTap, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap, borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(children: [
              Icon(icon, color: isActive ? const Color(0xFF1A237E) : Colors.white70, size: 20),
              const SizedBox(width: 12),
              Text(title, style: TextStyle(color: isActive ? const Color(0xFF1A237E) : Colors.white, fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500)),
            ]),
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
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF7C88C2), Color(0xFFFFFFFF)])),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
              child: Container(
                width: 240, height: double.infinity,
                decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF5B6388), Color(0xFF3E4563)]), borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisSize: MainAxisSize.max, children: [
                    const SizedBox(height: 30),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
                      ClipOval(child: Image.asset('assets/logo.png', width: 42, height: 42, fit: BoxFit.cover)),
                      const SizedBox(width: 10),
                      const Expanded(child: Text('Cam2print System', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic), overflow: TextOverflow.ellipsis)),
                    ])),
                    const SizedBox(height: 40),
                    _buildSidebarItem(Icons.inventory_2, "Daily Inventory", () => _navigateTo('Daily Inventory')),
                    _buildSidebarItem(Icons.design_services, "Services", () => _navigateTo('Services')),
                    _buildSidebarItem(Icons.monetization_on, "Salary", () => _navigateTo('Salary')),
                    _buildSidebarItem(Icons.shopping_cart, "Consumption Tracker", () => _navigateTo('Consumption Tracker')),
                    _buildSidebarItem(Icons.shopping_bag, "Customized Orders", () => _navigateTo('Customized Orders'), isActive: true),
                    _buildSidebarItem(Icons.event_available, "Schedule", () => _navigateTo('Schedule')),
                    const Spacer(),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(12), child: InkWell(onTap: () => Navigator.pushReplacementNamed(context, AppRouter.login), borderRadius: BorderRadius.circular(12), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [Icon(Icons.logout, color: Colors.white70, size: 20), SizedBox(width: 12), Text('Logout', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))]))))),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    decoration: const BoxDecoration(color: Color(0xFFB3D4FF), borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
                      Row(children: [
                        GestureDetector(onTap: () => _navigateTo('Notifications'), child: const Icon(Icons.notifications_none, color: Color(0xFF1A237E), size: 24)),
                        const SizedBox(width: 10),
                        GestureDetector(onTap: () => Navigator.pushReplacementNamed(context, AppRouter.staffProfile), child: const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.person, size: 26, color: Color(0xFF1A237E)))),
                        const SizedBox(width: 10),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A237E))), Text(_userRole, style: TextStyle(fontSize: 11, color: Color(0xFF1A237E)))]),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Column(children: [
                      _buildTopBar(),
                      const SizedBox(height: 12),
                      Expanded(child: showFloatingOrderDetails ? _buildFloatingOrderDetailsView() : (showTrackSaved ? _buildTrackSavedView() : _buildFormView())),
                    ]),
                  ),
                ]),
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
      case 'Daily Inventory': routeName = AppRouter.staffDailyInv; break;
      case 'Services': routeName = AppRouter.staffServices; break;
      case 'Salary': routeName = AppRouter.staffsalary; break;
      case 'Consumption Tracker': routeName = AppRouter.staffConsumptionTracker; break;
      case 'Customized Orders': routeName = AppRouter.staffCustomizedOrders; break;
      case 'Schedule': routeName = AppRouter.staffSchedule; break;
      case 'Notifications': routeName = AppRouter.notifications; break;
    }
    if (routeName != null) {
      Navigator.pushReplacementNamed(context, routeName, arguments: routeName == AppRouter.notifications ? false : null);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$pageName not connected yet.'), duration: const Duration(seconds: 1)));
  }

  Widget _buildFormView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isNarrow = constraints.maxWidth < 600;
          double padding = isNarrow ? 8 : 16;
          double fontSize = isNarrow ? 16 : 18;
          
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Custom Order: $_activeItem', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xFF2E3A59))),
                const SizedBox(height: 12),
                _getItemForm(_activeItem),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveOrderToSupabase,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _getItemForm(String item) {
    switch (item) {
      case 'Packages':
      case 'Invitation':
        return Column(children: [
          _inputRow("Name", "name", "Date of Occasion/Event", "event_date", isDate2: true),
          const SizedBox(height: 8),
          _inputRow("Type of Occasion/Event", "occasion_type", "Church", "church"),
          const SizedBox(height: 8),
          _inputRow("Theme", "theme", "Reception", "reception"),
          const SizedBox(height: 8),
          _singleInput("Additional Info", "additional_info", maxLines: 2),
          const SizedBox(height: 12),
          _imageUpload(5),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Souvenir':
        return Column(children: [
          _inputRow("Name", "name", "Date of Occasion/Event", "event_date", isDate2: true),
          const SizedBox(height: 8),
          _inputRow("Type of Occasion/Event", "occasion_type", "Theme", "theme"),
          const SizedBox(height: 12),
          _imageUpload(1),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Ref Magnet':
        return Column(children: [
          _inputRow("Name", "name", "Date of Occasion/Event", "event_date", isDate2: true),
          const SizedBox(height: 8),
          _inputRow("Type of Occasion/Event", "occasion_type", "Theme", "theme"),
          const SizedBox(height: 8),
          _singleInput("Reception", "reception"),
          const SizedBox(height: 8),
          _singleInput("Additional Info", "additional_info", maxLines: 2),
          const SizedBox(height: 12),
          _imageUpload(5),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Candle':
        return Column(children: [
          _singleInput("Info", "details", maxLines: 2),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'T-shirt':
      case 'Chip Bag':
        return Column(children: [
          _singleInput("Info", "details", maxLines: 2),
          const SizedBox(height: 12),
          _imageUpload(5),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Button Badge':
        return Column(children: [
          _singleInput("Name", "name"),
          const SizedBox(height: 8),
          _singleInput("Additional Info", "additional_info", maxLines: 2),
          const SizedBox(height: 12),
          _imageUpload(1),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Button Pin':
        return Column(children: [
          _singleInput("Name", "name"),
          const SizedBox(height: 8),
          _singleInput("Additional Info", "additional_info", maxLines: 2),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Party Hat':
        return Column(children: [
          _inputRow("Name", "name", "Theme", "theme"),
          const SizedBox(height: 8),
          _singleInput("Additional Info", "additional_info", maxLines: 2),
          const SizedBox(height: 12),
          _imageUpload(5),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Jigsaw Puzzle':
        return Column(children: [
          _inputRow("Theme", "theme", "Info", "details"),
          const SizedBox(height: 12),
          _imageUpload(5),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Banner':
        return Column(children: [
          _inputRow("Info", "details", "Theme", "theme"),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Calendar':
        return Column(children: [
          _singleInput("Name", "name"),
          const SizedBox(height: 8),
          _singleInput("Additional Info", "additional_info", maxLines: 2),
          const SizedBox(height: 12),
          _imageUpload(1),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Hair Brush':
        return Column(children: [
          _singleInput("Name", "name"),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      case 'Clock':
        return Column(children: [
          _singleInput("Name", "name"),
          const SizedBox(height: 12),
          _imageUpload(13),
          const SizedBox(height: 12),
          _paymentRow(),
        ]);
      default:
        return const SizedBox();
    }
  }

  Widget _inputRow(String label1, String key1, String label2, String key2, {bool isDate2 = false}) {
    return Row(children: [
      Expanded(child: _singleInput(label1, key1)),
      const SizedBox(width: 8),
      Expanded(child: isDate2 ? _dateInput(label2, key2) : _singleInput(label2, key2)),
    ]);
  }

  Widget _singleInput(String label, String key, {int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
      const SizedBox(height: 4),
      TextField(controller: _dynamicControllers[key], maxLines: maxLines, decoration: InputDecoration(filled: true, fillColor: const Color(0xFFB0B8D0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10))),
    ]);
  }

  Widget _dateInput(String label, String key) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
      const SizedBox(height: 4),
      GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
          if (picked != null) _dynamicControllers[key]!.text = DateFormat('yyyy-MM-dd').format(picked);
        },
        child: AbsorbPointer(child: TextField(controller: _dynamicControllers[key], readOnly: true, decoration: InputDecoration(hintText: 'Select Date', filled: true, fillColor: const Color(0xFFB0B8D0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)))),
      ),
    ]);
  }

  Widget _imageUpload(int maxImages) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Upload Images", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
      const SizedBox(height: 6),
      GestureDetector(onTap: _pickImages, child: Container(height: 80, decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 2, style: BorderStyle.solid), borderRadius: BorderRadius.circular(12)),
        child: _selectedImages.isEmpty 
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 30), SizedBox(height: 5), Text("Tap to upload images", style: TextStyle(color: Colors.grey))]))
          : SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: _selectedImages.map((img) => Padding(padding: const EdgeInsets.all(4), child: Image.file(File(img!.path), width: 70, height: 70, fit: BoxFit.cover))).toList())),
      )),
      const SizedBox(height: 4),
      Text("Max ${maxImages} images allowed", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
    ]);
  }

  Widget _paymentRow() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Payment Details", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _singleInput("Downpayment", "down_payment")),
        const SizedBox(width: 8),
        Expanded(child: _singleInput("Balance", "balance")),
      ]),
    ]);
  }

  Widget _buildTrackSavedView() {
    return Container(decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('customized_orders').stream(primaryKey: ['id']).order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) return const Center(child: Text('No orders found. Create one to see it here.'));

          return Column(children: [
            Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), decoration: const BoxDecoration(color: Color(0xFF4B5580), borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Row(children: const [
                Expanded(child: Text("Item", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))),
                Expanded(child: Text("Commissioned by", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))),
                Expanded(child: Text("Customer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))),
                Expanded(child: Text("Status", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))),
                Expanded(child: Center(child: Text("Actions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)))),
              ])),
            Expanded(child: ListView.builder(itemCount: orders.length, itemBuilder: (context, index) {
              final order = orders[index];
              return Container(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), decoration: BoxDecoration(color: index % 2 == 0 ? Colors.white : const Color(0xFFE8F0FE), border: Border(bottom: BorderSide(color: const Color(0xFFB0C4DE), width: 1))),
                child: Row(children: [
                  Expanded(child: Text(order['order_type'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
                  Expanded(child: Text(order['staff_name'] ?? 'N/A', style: const TextStyle(fontSize: 12))),
                  Expanded(child: Text(order['customer_name'] ?? 'N/A', style: const TextStyle(fontSize: 12))),
                  Expanded(child: Text(order['payment_status'] ?? 'Unpaid', style: TextStyle(color: order['payment_status'] == 'Paid' ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12))),
                  Expanded(child: Center(child: ElevatedButton(onPressed: () {
                    setState(() { showFloatingOrderDetails = true; activeFloatingOrder = order; showRemainingBalanceInput = false; });
                  }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                    child: const Text("VIEW", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))),
                  ),
                ]),
              );
            })),
          ]);
        },
      ),
    );
  }

  Widget _buildFloatingOrderDetailsView() {
    final order = activeFloatingOrder;
    if (order == null) return const SizedBox();

    final double downPayment = (order['down_payment'] as num?)?.toDouble() ?? 0;
    final double balance = (order['balance'] as num?)?.toDouble() ?? 0;
    final double remainingBalance = (order['remaining_balance'] as num?)?.toDouble() ?? balance;
    final bool isPaid = remainingBalance <= 0;
    final double totalPaid = downPayment + (balance - remainingBalance);
    final details = (order['specific_details'] as Map?) ?? {};

    return Stack(children: [
      GestureDetector(onTap: () => setState(() => showFloatingOrderDetails = false), child: Container(color: Colors.black.withValues(alpha: 0.2))),
      Center(
        child: Container(
          width: double.infinity, constraints: const BoxConstraints(maxWidth: 700), padding: const EdgeInsets.all(16), margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))]),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("${order['order_type'] ?? 'Order Details'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E3A59))),
                IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => showFloatingOrderDetails = false)),
              ]),
              const SizedBox(height: 12),
              _readOnlyInput("Customer Name", order['customer_name'] ?? 'N/A'),
              const SizedBox(height: 8),
              _readOnlyInput("Event Date", order['event_date'] ?? 'N/A'),
              const SizedBox(height: 8),
              _readOnlyInput("Theme", order['theme'] ?? 'N/A'),
              const SizedBox(height: 8),
              _readOnlyInput("Additional Info", details['additional_info'] ?? 'None'),
              const SizedBox(height: 8),
              _readOnlyInput("Details", details['details'] ?? 'None'),
              const SizedBox(height: 12),
              
              Text("Payment Information", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2E3A59))),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _readOnlyInput("Down Payment", "₱${downPayment.toStringAsFixed(2)}")),
                const SizedBox(width: 8),
                Expanded(child: _readOnlyInput(isPaid ? "Total Paid Amount" : "Remaining Balance", isPaid ? "₱${totalPaid.toStringAsFixed(2)}" : "₱${remainingBalance.toStringAsFixed(2)}")),
              ]),
              const SizedBox(height: 12),
              
              if (!isPaid && !showRemainingBalanceInput) ...[
                Row(children: [
                  ElevatedButton(onPressed: () => setState(() => showRemainingBalanceInput = true), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853)), child: const Text("INPUT REMAINING BALANCE", style: TextStyle(color: Colors.white))),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: () => setState(() => showFloatingOrderDetails = false), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: const Text("CLOSE", style: TextStyle(color: Colors.white))),
                ]),
              ] else if (showRemainingBalanceInput) ...[
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFD6E4FF), Color(0xFFFFFFFF)]), borderRadius: BorderRadius.circular(12)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text("Enter Remaining Balance Payment", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E3A59))),
                    const SizedBox(height: 6),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(hintText: 'Amount paid now', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                      onSubmitted: (val) async {
                        double paid = double.tryParse(val) ?? 0;
                        await supabase.from('customized_orders').update({
                          'remaining_balance': remainingBalance - paid,
                          'payment_status': (remainingBalance - paid) <= 0 ? 'Paid' : 'Partial',
                        }).eq('id', order['id']);
                        if (mounted) setState(() {
                          activeFloatingOrder!['remaining_balance'] = remainingBalance - paid;
                          activeFloatingOrder!['payment_status'] = (remainingBalance - paid) <= 0 ? 'Paid' : 'Partial';
                          showRemainingBalanceInput = false;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(child: ElevatedButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please press Enter to save'), backgroundColor: Colors.orange)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8)), child: const Text("SAVE BALANCE", style: TextStyle(color: Colors.white, fontSize: 13)))),
                  ]),
                ),
              ],
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _readOnlyInput(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
      const SizedBox(height: 3),
      Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
    ]);
  }

  Widget _buildTopBar() {
    return Row(children: [
      Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white, width: 1)),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          ...mainTabs.map((tab) => Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: _buildTabChip(tab))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: Builder(builder: (context) => _buildMoreButton(context))),
        ])),
      )),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: () { setState(() { showTrackSaved = !showTrackSaved; showFloatingOrderDetails = false; _closeMoreMenu(); }); },
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: showTrackSaved ? const Color(0xFF55A888) : const Color(0xFF373E4E), borderRadius: BorderRadius.circular(20)),
          child: const Text("Track Saved Orders", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
      ),
    ]);
  }

  Widget _buildMoreButton(BuildContext context) {
    bool isMoreActive = moreItems.contains(_activeItem);
    return InkWell(onTap: () => _toggleMoreMenu(context), borderRadius: BorderRadius.circular(15),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: isMoreActive ? const Color(0xFF373E4E) : Colors.transparent, borderRadius: BorderRadius.circular(15)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(isMoreActive ? _activeItem : "More", style: TextStyle(color: isMoreActive ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(width: 3),
          Icon(isMoreDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: isMoreActive ? Colors.white : Colors.black87, size: 18),
        ]),
      ),
    );
  }

  Widget _buildDropdownMenu() {
    return Material(elevation: 4, borderRadius: BorderRadius.circular(12), color: Colors.white,
      child: Container(width: 150, padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: moreItems.map((item) {
            bool isSelected = item == _activeItem;
            return InkWell(onTap: () => _selectItem(item), child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: isSelected ? Colors.grey.shade300 : Colors.transparent),
              child: Text(item, style: TextStyle(fontSize: 13, color: const Color(0xFF2E3A59), fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
            ));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabChip(String label) {
    bool isActive = _activeItem == label;
    return GestureDetector(onTap: () => _selectItem(label), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: isActive ? const Color(0xFF373E4E) : Colors.transparent, borderRadius: BorderRadius.circular(15)),
      child: Center(child: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 13))),
    ));
  }
}