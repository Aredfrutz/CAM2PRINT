import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:convert';
import 'dart:typed_data';

// --- MODELS ---

class CustomizedOrder {
  final String id;
  final DateTime createdAt;
  final String orderType;
  final String? customerName;
  final DateTime? eventDate;
  final String? theme;
  final String? receptionVenue;
  final String? churchVenue;
  final String? occasionType;
  final String? additionalCustomOrder;
  final double? downPayment;
  final double? balance;
  final String? paymentStatus;
  final DateTime? paymentDate;
  final Map<String, dynamic>? specificDetails;
  final List<String>? imageUrls;
  final String? staffName;
  final String? branchName;
  final DateTime? balanceUpdatedAt;
  final DateTime? downPaymentDate;
  final DateTime? fullyPaidDate;

  CustomizedOrder({
    required this.id,
    required this.createdAt,
    required this.orderType,
    this.customerName,
    this.eventDate,
    this.theme,
    this.receptionVenue,
    this.churchVenue,
    this.occasionType,
    this.additionalCustomOrder,
    this.downPayment,
    this.balance,
    this.paymentStatus,
    this.paymentDate,
    this.specificDetails,
    this.imageUrls,
    this.staffName,
    this.branchName,
    this.balanceUpdatedAt,
    this.downPaymentDate,
    this.fullyPaidDate,
  });

  factory CustomizedOrder.fromJson(Map<String, dynamic> json) {
    return CustomizedOrder(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      orderType: json['order_type'] as String,
      customerName: json['customer_name'] as String?,
      eventDate: json['event_date'] != null ? DateTime.parse(json['event_date'] as String) : null,
      theme: json['theme'] as String?,
      receptionVenue: json['reception_venue'] as String?,
      churchVenue: json['church_venue'] as String?,
      occasionType: json['occasion_type'] as String?,
      additionalCustomOrder: json['additional_custom_order'] as String?,
      downPayment: json['down_payment'] != null ? double.tryParse(json['down_payment'].toString()) : null,
      balance: json['balance'] != null ? double.tryParse(json['balance'].toString()) : null,
      paymentStatus: json['payment_status'] as String?,
      paymentDate: json['payment_date'] != null ? DateTime.parse(json['payment_date'] as String) : null,
      specificDetails: json['specific_details'] as Map<String, dynamic>?,
      imageUrls: (json['image_urls'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      staffName: json['staff_name'] as String?,
      branchName: json['branch_name'] as String?,
      balanceUpdatedAt: json['balance_updated_at'] != null ? DateTime.parse(json['balance_updated_at'] as String) : null,
      downPaymentDate: json['down_payment_date'] != null ? DateTime.parse(json['down_payment_date'] as String) : null,
      fullyPaidDate: json['fully_paid_date'] != null ? DateTime.parse(json['fully_paid_date'] as String) : null,
    );
  }
}

// --- MAIN PAGE ---

class ReportsAdminPage extends StatefulWidget {
  const ReportsAdminPage({super.key});

  @override
  State<ReportsAdminPage> createState() => _ReportsAdminPageState();
}

class _ReportsAdminPageState extends State<ReportsAdminPage> {
  String _selectedTab = "Attendance";
  final TextEditingController _thresholdController = TextEditingController(text: "0");

  void _navigateTo(String pageName) {
    String? routeName;
    switch (pageName) {
      case 'Staff Management': routeName = AppRouter.adminStaffManagement; break;
      case 'Services': routeName = AppRouter.adminServices; break;
      case 'Schedule': routeName = AppRouter.adminSchedule; break;
      case 'Reports': routeName = AppRouter.adminreports; break;
      case 'Customized Orders': routeName = AppRouter.adminCustomOrders; break;
      case 'Notifications': routeName = AppRouter.notifications; break;
      case 'Overall Inventory': routeName = AppRouter.adminoverallinv; break;
      case 'Salary': routeName = AppRouter.adminsalary; break;
    }
    if (routeName != null) {
      Navigator.pushReplacementNamed(context, routeName, arguments: routeName == AppRouter.notifications ? true : null);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$pageName not connected yet.'), duration: const Duration(seconds: 1)));
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
                Text(title, style: TextStyle(color: isActive ? const Color(0xFF1A237E) : Colors.white, fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500)),
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
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF9FA8DA), Color(0xFFFFFFFF)]),
        ),
        child: Row(
          children: [
            // Sidebar
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
              child: Container(
                width: 240,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF5B6388), Color(0xFF3E4563)]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          ClipOval(child: Image.asset('assets/logo.png', width: 42, height: 42, fit: BoxFit.cover)),
                          const SizedBox(width: 10),
                          const Expanded(child: Text('Cam2print System', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildSidebarItem(Icons.people, "Staff Management", () => _navigateTo('Staff Management')),
                    _buildSidebarItem(Icons.inventory_2, "Overall Inventory", () => _navigateTo('Overall Inventory')),
                    _buildSidebarItem(Icons.settings, "Services", () => _navigateTo('Services')),
                    _buildSidebarItem(Icons.attach_money, "Salary", () => _navigateTo('Salary')),
                    _buildSidebarItem(Icons.shopping_cart, "Customized Orders", () => _navigateTo('Customized Orders')),
                    _buildSidebarItem(Icons.calendar_today, "Schedule", () => _navigateTo('Schedule')),
                    _buildSidebarItem(Icons.error_outline, "Reports", () => _navigateTo('Reports'), isActive: true),
                    const Spacer(),
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
            // Main Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      decoration: const BoxDecoration(color: Color(0xFFE3F2FD), borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
                          Row(
                            children: [
                              GestureDetector(onTap: () => _navigateTo('Notifications'), child: const Icon(Icons.notifications_none, color: Color(0xFF1A237E), size: 24)),
                              const SizedBox(width: 20),
                              const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.person, size: 26, color: Color(0xFF1A237E))),
                              const SizedBox(width: 10),
                              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A237E)))]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        _buildTabItem("Attendance"),
                                        const SizedBox(width: 16),
                                        _buildTabItem("Inventory"),
                                        const SizedBox(width: 16),
                                        _buildTabItem("Salary"),
                                        const SizedBox(width: 16),
                                        _buildTabItem("Customized Orders"),
                                        const SizedBox(width: 16),
                                        _buildTabItem("Activity Log"),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_selectedTab != "Customized Orders") ...[
                                  ElevatedButton(
                                    onPressed: () => _showFilterDialog(),
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B5580), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                    child: const Text("Filter", style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                    child: const Text("Export", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(child: _buildTable()),
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

  Widget _buildTabItem(String title) {
    bool isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: isSelected ? const Color(0xFF4B5580) : Colors.transparent, borderRadius: BorderRadius.circular(6)),
        child: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, fontSize: 13)),
      ),
    );
  }

  Widget _buildTable() {
    switch (_selectedTab) {
      case "Inventory": return _buildInventoryTable();
      case "Salary": return _buildSalaryTable();
      case "Customized Orders": return const CustomizedOrdersReportWidget();
      case "Activity Log": return _buildActivityLogTable();
      default: return _buildAttendanceTable();
    }
  }

  Widget _buildAttendanceTable() {
    return _buildGenericTable(
      headers: ["Date", "Branch", "Shift", "Staff Name", "Time In", "Time Out", "Status", "Lateness (mins)", "Deduction (₱)"],
      flexes: [2, 2, 2, 3, 2, 2, 2, 3, 3],
      headerStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      bodyStyle: const TextStyle(color: Color(0xFF334155), fontSize: 12),
    );
  }

  Widget _buildInventoryTable() {
    return _buildGenericTable(
      headers: ["Date", "Branch", "Item Category", "Item Name", "Start Quantity", "End Quantity", "Discrepancy", "Threshold Level", "Status", "Last Restocked Date"],
      flexes: [2, 2, 3, 3, 3, 3, 3, 3, 2, 4],
      headerStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      bodyStyle: const TextStyle(color: Color(0xFF334155), fontSize: 12),
    );
  }

  Widget _buildSalaryTable() {
    return _buildGenericTable(
      headers: ["Pay Period", "Branch", "Staff Name", "Total Sales", "Total Commission", "Custom Orders Quantity", "Deductions", "Cash Advance", "Percentage"],
      flexes: [2, 2, 2, 2, 3, 4, 2, 2, 2],
      headerStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      bodyStyle: const TextStyle(color: Color(0xFF334155), fontSize: 12),
    );
  }

  Widget _buildActivityLogTable() {
    return _buildGenericTable(
      headers: ["Date", "Staff Name", "Action Type", "Details/Change"],
      flexes: [2, 3, 3, 6],
      headerStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      bodyStyle: const TextStyle(color: Color(0xFF334155), fontSize: 12),
    );
  }

  Widget _buildGenericTable({required List<String> headers, required List<int> flexes, required TextStyle headerStyle, required TextStyle bodyStyle}) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFB0C4DE)), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: const BoxDecoration(color: Color(0xFF4B5580), borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7))),
            child: Row(
              children: List.generate(headers.length, (index) {
                return Expanded(flex: flexes[index], child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text(headers[index], style: headerStyle)));
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(border: const Border(bottom: BorderSide(color: Color(0xFFB0C4DE), width: 1)), color: index.isEven ? Colors.white : const Color(0xFFE8F0FE)),
                  child: Row(
                    children: List.generate(headers.length, (i) {
                      return Expanded(flex: flexes[i], child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text("", style: bodyStyle)));
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // Retaining basic dialog structure
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }
}

// --- NEW CUSTOMIZED ORDERS REPORT WIDGET ---

class CustomizedOrdersReportWidget extends StatefulWidget {
  const CustomizedOrdersReportWidget({super.key});

  @override
  State<CustomizedOrdersReportWidget> createState() => _CustomizedOrdersReportWidgetState();
}

class _CustomizedOrdersReportWidgetState extends State<CustomizedOrdersReportWidget> {
  List<CustomizedOrder> _allOrders = [];
  List<CustomizedOrder> _filteredOrders = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_filterData);
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('customized_orders')
          .select()
          .order('created_at', ascending: false);
      
      final List<CustomizedOrder> fetched = (response as List<dynamic>)
          .map((json) => CustomizedOrder.fromJson(json as Map<String, dynamic>))
          .toList();
          
      setState(() {
        _allOrders = fetched;
        _filteredOrders = fetched;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOrders = _allOrders.where((order) {
        final name = order.customerName?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  Future<void> _exportToCsv() async {
    if (_filteredOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to export')),
      );
      return;
    }

    final List<List<dynamic>> csvData = [
      [
        'ID',
        'Created At',
        'Order Type',
        'Customer Name',
        'Event Date',
        'Theme',
        'Reception Venue',
        'Church Venue',
        'Occasion Type',
        'Additional Custom Order',
        'Down Payment',
        'Balance',
        'Payment Status',
        'Payment Date',
        'Specific Details',
        'Image URLs',
        'Staff Name',
        'Branch Name',
        'Balance Updated At',
        'Down Payment Date',
        'Fully Paid Date',
      ]
    ];

    for (var order in _filteredOrders) {
      csvData.add([
        order.id,
        order.createdAt.toIso8601String(),
        order.orderType,
        order.customerName ?? 'N/A',
        order.eventDate?.toIso8601String() ?? 'N/A',
        order.theme ?? 'N/A',
        order.receptionVenue ?? 'N/A',
        order.churchVenue ?? 'N/A',
        order.occasionType ?? 'N/A',
        order.additionalCustomOrder ?? 'N/A',
        order.downPayment ?? 0.0,
        order.balance ?? 0.0,
        order.paymentStatus ?? 'N/A',
        order.paymentDate?.toIso8601String() ?? 'N/A',
        order.specificDetails != null ? jsonEncode(order.specificDetails) : 'N/A',
        order.imageUrls != null ? order.imageUrls!.join(',') : 'N/A',
        order.staffName ?? 'N/A',
        order.branchName ?? 'N/A',
        order.balanceUpdatedAt?.toIso8601String() ?? 'N/A',
        order.downPaymentDate?.toIso8601String() ?? 'N/A',
        order.fullyPaidDate?.toIso8601String() ?? 'N/A',
      ]);
    }

    String csvString = const ListToCsvConverter().convert(csvData);

    try {
      Uint8List bytes = Uint8List.fromList(utf8.encode(csvString));
      await FileSaver.instance.saveFile(
        name: 'customized_orders_report',
        bytes: bytes,
        ext: 'csv',
        mimeType: MimeType.csv,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exported successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MM/dd/yyyy').format(date);
  }

  String _formatCurrency(double? value) {
    if (value == null) return 'N/A';
    return '₱${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Customized Orders Report",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by Customer Name",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _exportToCsv,
                  icon: const Icon(Icons.download, color: Colors.white, size: 18),
                  label: const Text("Export to CSV", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        // Data Table
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.resolveWith<Color>((states) => const Color(0xFF4B5580)),
                        headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        dataRowMinHeight: 40,
                        dataRowMaxHeight: 50,
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Created At')),
                          DataColumn(label: Text('Order Type')),
                          DataColumn(label: Text('Customer Name')),
                          DataColumn(label: Text('Event Date')),
                          DataColumn(label: Text('Theme')),
                          DataColumn(label: Text('Reception Venue')),
                          DataColumn(label: Text('Church Venue')),
                          DataColumn(label: Text('Occasion Type')),
                          DataColumn(label: Text('Additional Order')),
                          DataColumn(label: Text('Down Payment')),
                          DataColumn(label: Text('Balance')),
                          DataColumn(label: Text('Payment Status')),
                          DataColumn(label: Text('Payment Date')),
                          DataColumn(label: Text('Specific Details')),
                          DataColumn(label: Text('Image URLs')),
                          DataColumn(label: Text('Staff Name')),
                          DataColumn(label: Text('Branch Name')),
                          DataColumn(label: Text('Balance Updated At')),
                          DataColumn(label: Text('Down Payment Date')),
                          DataColumn(label: Text('Fully Paid Date')),
                        ],
                        rows: _filteredOrders.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(Text(order.id.length > 8 ? '${order.id.substring(0, 8)}...' : order.id)),
                              DataCell(Text(_formatDate(order.createdAt))),
                              DataCell(Text(order.orderType)),
                              DataCell(Text(order.customerName ?? 'N/A')),
                              DataCell(Text(_formatDate(order.eventDate))),
                              DataCell(Text(order.theme ?? 'N/A')),
                              DataCell(Text(order.receptionVenue ?? 'N/A')),
                              DataCell(Text(order.churchVenue ?? 'N/A')),
                              DataCell(Text(order.occasionType ?? 'N/A')),
                              DataCell(Text(order.additionalCustomOrder ?? 'N/A')),
                              DataCell(Text(_formatCurrency(order.downPayment))),
                              DataCell(Text(_formatCurrency(order.balance))),
                              DataCell(Text(order.paymentStatus ?? 'N/A')),
                              DataCell(Text(_formatDate(order.paymentDate))),
                              DataCell(Text(order.specificDetails != null ? 'JSON...' : 'N/A')),
                              DataCell(Text(order.imageUrls != null ? '${order.imageUrls!.length} images' : 'N/A')),
                              DataCell(Text(order.staffName ?? 'N/A')),
                              DataCell(Text(order.branchName ?? 'N/A')),
                              DataCell(Text(_formatDate(order.balanceUpdatedAt))),
                              DataCell(Text(_formatDate(order.downPaymentDate))),
                              DataCell(Text(_formatDate(order.fullyPaidDate))),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
