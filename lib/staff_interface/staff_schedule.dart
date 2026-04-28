import 'package:flutter/material.dart';

class StaffSchedule extends StatefulWidget {
  const StaffSchedule({super.key});

  @override
  State<StaffSchedule> createState() => _StaffScheduleState();
}

class _StaffScheduleState extends State<StaffSchedule> {
  DateTime _currentDate = DateTime.now();

  final List<String> _branches = [
    "CAMPO",
    "SILOAM",
    "LANZONES",
    "NARRA",
    "PHASE 3",
    "URBAN",
    "8B",
    "MONTALBAN",
    "MONTALBAN BAGO",
  ];

  DateTime get _startOfWeek {
    return _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
  }

  DateTime get _endOfWeek {
    return _startOfWeek.add(const Duration(days: 6));
  }

  void _previousWeek() {
    setState(() {
      _currentDate = _currentDate.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _currentDate = _currentDate.add(const Duration(days: 7));
    });
  }

  String _formatDate(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.day}';
  }

  void _showBranchDetails(String branchName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          '$branchName BRANCH',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A237E),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Opening Shift', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A237E))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    CircleAvatar(backgroundColor: Color(0xFFBDBDBD), child: Icon(Icons.person, color: Color(0x99000000))),
                    SizedBox(width: 12),
                    Text('Staff Name', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Closing Shift', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A237E))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    CircleAvatar(backgroundColor: Color(0xFFBDBDBD), child: Icon(Icons.person, color: Color(0x99000000))),
                    SizedBox(width: 12),
                    Text('Staff Name', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showLeaveRequestForm() {
    DateTime? selectedStartDate;
    DateTime? selectedEndDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Leave Request',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
                const SizedBox(height: 4),
                const Text('Submit for Admin Approval', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 24),

                const Text('STAFF NAME', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    children: [
                      Expanded(child: Text('Select Staff', style: TextStyle(color: Colors.grey))),
                      Icon(Icons.keyboard_arrow_down, color: Color(0xFF1A237E)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('START DATE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setDialogState(() => selectedStartDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    selectedStartDate == null
                                        ? 'mm/dd/yyyy'
                                        : '${selectedStartDate!.month.toString().padLeft(2, '0')}/${selectedStartDate!.day.toString().padLeft(2, '0')}/${selectedStartDate!.year}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: selectedStartDate != null ? const Color(0xFF1A237E) : Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1A237E)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('END DATE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setDialogState(() => selectedEndDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    selectedEndDate == null
                                        ? 'mm/dd/yyyy'
                                        : '${selectedEndDate!.month.toString().padLeft(2, '0')}/${selectedEndDate!.day.toString().padLeft(2, '0')}/${selectedEndDate!.year}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: selectedEndDate != null ? const Color(0xFF1A237E) : Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1A237E)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text('REASON FOR LEAVE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const TextField(
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter reason for leave...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved as Draft')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Save as Draft', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Leave Request Submitted!')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43A047),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Submit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ],
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
    DateTime start = _startOfWeek;
    DateTime end = _endOfWeek;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // ✅ FIXED: Purple-to-White Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9FA8DA), Color(0xFFFFFFFF)], // Purple-ish Blue fading to White
          ),
        ),
        child: Row(
          children: [
            // --- SIDEBAR ---
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
              child: Container(
                width: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5B6388), Color(0xFF3E4563)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          ClipOval(child: Image.asset('assets/logo.jpg', width: 42, height: 42, fit: BoxFit.cover)),
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
                    _buildSidebarItem(Icons.inventory_2, "Daily Inventory", () {}),
                    _buildSidebarItem(Icons.design_services, "Services", () {}),
                    _buildSidebarItem(Icons.monetization_on, "Salary", () {}),
                    _buildSidebarItem(Icons.shopping_cart, "Consumption Tracker", () {}),
                    _buildSidebarItem(Icons.shopping_bag, "Customized Orders", () {}),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      child: Material(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(Icons.event_available, color: Colors.white, size: 20),
                              const SizedBox(width: 12),
                              Text("Schedule", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- MAIN CONTENT ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- TOP HEADER ---
                    // ✅ FIXED: Distinct Light Blue Container to stand out against gradient
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE3F2FD), // Very Light Blue (Visible)
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Saturday/ January 31, 2026", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
                          Row(
                            children: [
                              const Icon(Icons.notifications_none, color: Color(0xFF1A237E), size: 24),
                              const SizedBox(width: 20),
                              const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.person, size: 26, color: Color(0xFF1A237E))),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Jane", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A237E))),
                                  Text("Admin", style: TextStyle(fontSize: 11, color: Color(0xFF1A237E))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // --- LEAVE REQUEST FORM BUTTON ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 25),
                        child: ElevatedButton(
                          onPressed: () => _showLeaveRequestForm(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Leave Request Form", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- SCHEDULE NAVIGATION BAR ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C6BC0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: _previousWeek),
                          Text("${_formatDate(start).toUpperCase()} - ${_formatDate(end).toUpperCase()}, ${end.year}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20), onPressed: _nextWeek),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 15),

                    // --- DAYS GRID ---
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(7, (index) {
                          DateTime dayDate = start.add(Duration(days: index));
                          return Expanded(child: _buildDayCard(dayDate));
                        }),
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

  Widget _buildSidebarItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, color: Colors.white70, size: 20),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(DateTime date) {
    bool isToday = date.day == DateTime.now().day && date.month == DateTime.now().month;
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF7986CB) : const Color(0xFF5C6BC0),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Column(
              children: [
                Text(days[date.weekday - 1].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text("${date.day}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF9FA8DA),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: ListView.builder(
                itemCount: _branches.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text(_branches[index], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)), overflow: TextOverflow.ellipsis)),
                        ElevatedButton(
                          onPressed: () => _showBranchDetails(_branches[index]),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            minimumSize: const Size(0, 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          child: const Text("VIEW", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}