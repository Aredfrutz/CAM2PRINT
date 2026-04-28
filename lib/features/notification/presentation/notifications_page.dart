import 'package:flutter/material.dart';

// 1. DATA MODEL
class NotificationModel {
  final int id; // Dagdag ID para sa deletion logic
  final String date;
  final String shop;
  final String staffName;
  final String details;
  final String amount;
  final String reason;

  NotificationModel({
    required this.id,
    required this.date,
    required this.shop,
    required this.staffName,
    required this.details,
    this.amount = "0.00",
    this.reason = "No reason provided",
  });
}

class NotificationPage extends StatefulWidget {
  final bool isAdmin;
  const NotificationPage({super.key, required this.isAdmin});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // 2. MUTABLE LIST: Dito nanggagaling ang data na pwede nating i-delete
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 1,
      date: "04/20/2026",
      shop: "Campo",
      staffName: "Shamel Lacuesta",
      details: "Cash Advance Request",
      amount: "500.00",
      reason: "Emergency transportation funds.",
    ),
    NotificationModel(
      id: 2,
      date: "04/21/2026",
      shop: "SM North",
      staffName: "Jane Doe",
      details: "Supply Requisition",
      amount: "1,200.00",
      reason: "Need more ink and glossy paper.",
    ),
    NotificationModel(
      id: 3,
      date: "04/25/2026",
      shop: "Fairview",
      staffName: "John Smith",
      details: "Maintenance Alert",
      reason: "Printer head needs cleaning.",
    ),
  ];

  // FUNCTIONAL DELETE LOGIC
  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((item) => item.id == id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Notification deleted"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        children: [
          // --- TABLE HEADER ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF4A5777),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                _headerText('Date', 2),
                _headerText('Shop', 2),
                _headerText('Staff', 3),
                _headerText('Details', 4),
                // Header spacer para sa mga buttons sa kanan
                const SizedBox(width: 40), // Space para sa Delete Icon
                if (widget.isAdmin) const SizedBox(width: 70), // Space para sa VIEW button
              ],
            ),
          ),
          
          // --- NOTIFICATION LIST ---
          Expanded(
            child: Container(
              color: Colors.white.withOpacity(0.9),
              child: _notifications.isEmpty 
                ? const Center(child: Text("No notifications found"))
                : ListView.separated(
                    itemCount: _notifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      return _buildNotificationRow(context, item);
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerText(String label, int flex) {
    return Expanded(
      flex: flex,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildNotificationRow(BuildContext context, NotificationModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          // DYNAMIC DATA
          Expanded(flex: 2, child: _dataBox(item.date)),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: _dataBox(item.shop)),
          const SizedBox(width: 10),
          Expanded(flex: 3, child: _dataBox(item.staffName)),
          const SizedBox(width: 10),
          Expanded(flex: 4, child: _dataBox(item.details)),
          const SizedBox(width: 10),

          // ✅ ACTION BUTTONS ON THE RIGHT SIDE
          
          // 1. VIEW BUTTON (Admin Only)
          if (widget.isAdmin) ...[
            GestureDetector(
              onTap: () => _showDetailsForm(context, item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF81C784),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('VIEW', 
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 15),
          ],

          // 2. FUNCTIONAL DELETE ICON (Para sa lahat)
          GestureDetector(
            onTap: () => _deleteNotification(item.id),
            child: const Icon(Icons.delete, color: Colors.red, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _dataBox(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF6A7B9C).withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.black87), overflow: TextOverflow.ellipsis),
    );
  }

  // DIALOG FORM (Admin View)
  void _showDetailsForm(BuildContext context, NotificationModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(item.details, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _formLabel("DATE OF REQUEST"),
            _formField(item.date, icon: Icons.calendar_today),
            const SizedBox(height: 15),
            _formLabel("REQUESTED AMOUNT"),
            _formField(item.amount),
            const SizedBox(height: 15),
            _formLabel("REASON / CONCERN"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[200], border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
              child: Text(item.reason, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400), child: const Text("Reject", style: TextStyle(color: Colors.white)))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C853)), child: const Text("Approve", style: TextStyle(color: Colors.white)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)));

  Widget _formField(String value, {IconData? icon}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(color: Colors.grey[200], border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(value, style: const TextStyle(fontSize: 13)), if (icon != null) Icon(icon, size: 16, color: Colors.grey[600])]),
  );
}