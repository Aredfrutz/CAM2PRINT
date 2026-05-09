import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // ✅ Added

class AdminSchedule extends StatefulWidget {
  const AdminSchedule({super.key});

  @override
  State<AdminSchedule> createState() => _AdminScheduleState();
}

class _AdminScheduleState extends State<AdminSchedule> {
  DateTime _currentDate = DateTime.now();
  final _supabase = Supabase.instance.client; // ✅ Supabase client

  final List<String> _branches = [
    "CAMPO", "SILOAM", "LANZONES", "NARRA", "PHASE 3",
    "URBAN", "8B", "MONTALBAN", "MONTALBAN BAGO",
  ];

  // ✅ Removed local _branchAssignments map — now using Supabase

  DateTime get _startOfWeek => _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
  DateTime get _endOfWeek => _startOfWeek.add(const Duration(days: 6));

  void _previousWeek() => setState(() => _currentDate = _currentDate.subtract(const Duration(days: 7)));
  void _nextWeek() => setState(() => _currentDate = _currentDate.add(const Duration(days: 7)));

  String _formatDate(DateTime date) {
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatDateLong(DateTime date) {
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getAssignmentKey(String branch, DateTime date) {
    return '$branch|${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

Future<List<Map<String, dynamic>>> _fetchPendingLeaveRequests() async {
  try {
    final response = await _supabase
        .from('leave_requests')
        .select('id, staff_id, staff_name, start_date, end_date, reason, status, created_at')
        .eq('status', 'pending')
        .order('created_at', ascending: false);
    
    return response;
  } catch (e) {
    debugPrint('❌ Error fetching leave requests: $e');
    return [];
  }
}

// Helper to format date as "Jan 15"
String _formatDateShort(dynamic dateValue) {
  if (dateValue == null) return '--';
  try {
    final date = dateValue is String ? DateTime.parse(dateValue) : dateValue;
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}';
  } catch (_) {
    return '--';
  }
}

Future<bool> _updateLeaveRequestStatus(String requestId, String newStatus) async {
  try {
    debugPrint('📝 Updating leave request $requestId to $newStatus');
    
    final response = await _supabase
        .from('leave_requests')
        .update({'status': newStatus})
        .eq('id', requestId);
    
    debugPrint('✅ Update response: $response');
    return true;
  } catch (e) {
    debugPrint('❌ Error updating leave request: $e');
    return false;
  }
}



  // ✅ Fetch staff list from Supabase (adjust query based on your schema)
Future<List<Map<String, dynamic>>> _fetchStaffList() async {
  try {
    // ✅ Query auth.users directly where role = 'staff' in metadata
    final response = await _supabase
        .from('auth.users')
        .select('id, email, raw_user_meta_data')
        .contains('raw_user_meta_data', {'role': 'staff'}); // ✅ Filter by role in JSON

    return response.map((user) {
      final meta = user['raw_user_meta_data'] as Map<String, dynamic>?;
      return {
        'id': user['id'] as String,
        'name': meta?['display_name'] ?? user['email'] ?? 'Unnamed Staff',
      };
    }).toList();
  } catch (e) {
    debugPrint('❌ Error fetching staff: $e');
    // ✅ Fallback to dummy data if query fails
    return [
      {'id': '1', 'name': 'MJ'},
      {'id': '2', 'name': 'Toni'},
      {'id': '3', 'name': 'Jane'},
      {'id': '4', 'name': 'Ange'},
      {'id': '5', 'name': 'Dhell'},
      {'id': '6', 'name': 'Ruby'},
      {'id': '7', 'name': 'Jessa'},
      {'id': '8', 'name': 'Chabe'},
      {'id': '9', 'name': 'Daniela'},
      {'id': '10', 'name': 'Danica'},
      {'id': '11', 'name': 'Gabriel'},
      {'id': '12', 'name': 'Diya'},
      {'id': '13', 'name': 'Jhuanna'},
    ];
  }
}

  // ✅ Insert assignment into Supabase
  Future<bool> _saveAssignment({
  required String branch,
  required DateTime date,
  String? openingStaffId,
  String? closingStaffId,
  TimeOfDay? openingTime,
  TimeOfDay? closingTime,
}) async {
  try {
    debugPrint('📝 Starting assignment save for $branch on $date');
    
    String? formatTime(TimeOfDay? t) => t != null 
        ? '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00' 
        : null;

    debugPrint('🕐 Opening: $openingStaffId at ${formatTime(openingTime)}');
    debugPrint('🌙 Closing: $closingStaffId at ${formatTime(closingTime)}');

    final response = await _supabase.from('branch_assignments').upsert({
      'branch_name': branch,
      'assignment_date': DateFormat('yyyy-MM-dd').format(date),
      'opening_staff_id': openingStaffId,
      'opening_time_in': formatTime(openingTime),
      'closing_staff_id': closingStaffId,
      'closing_time_in': formatTime(closingTime),
    }, onConflict: 'branch_name,assignment_date');

    debugPrint('✅ Supabase response: $response');
    return true;
  } catch (e) {
    debugPrint('❌ Save assignment error: $e');
    return false;
  }
}

  // ✅ Fetch assignment for a branch + date
  Future<Map<String, dynamic>?> _fetchAssignment(String branch, DateTime date) async {
  try {
    debugPrint('🔍 Fetching assignment for $branch on ${DateFormat('yyyy-MM-dd').format(date)}');

    // ✅ First, fetch the assignment
    final response = await _supabase
        .from('branch_assignments')
        .select('''
          opening_staff_id,
          closing_staff_id,
          opening_time_in,
          closing_time_in,
          assignment_date
        ''')
        .eq('branch_name', branch)
        .eq('assignment_date', DateFormat('yyyy-MM-dd').format(date))
        .maybeSingle();

    if (response == null) {
      debugPrint('❌ No assignment found');
      return null;
    }

    debugPrint('✅ Assignment found: $response');

    // ✅ Fetch opening staff name from profiles
    String? openingStaffName = 'Not Assigned';
    if (response['opening_staff_id'] != null) {
      final openingStaff = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', response['opening_staff_id'])
          .single();
      
      openingStaffName = openingStaff['full_name'] ?? 'Unnamed Staff';
      debugPrint('👤 Opening staff: $openingStaffName');
    }

    // ✅ Fetch closing staff name from profiles
    String? closingStaffName = 'Not Assigned';
    if (response['closing_staff_id'] != null) {
      final closingStaff = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', response['closing_staff_id'])
          .single();
      
      closingStaffName = closingStaff['full_name'] ?? 'Unnamed Staff';
      debugPrint('👤 Closing staff: $closingStaffName');
    }

    // ✅ Format times
    String? formatTimeFromDb(String? timeStr) {
      if (timeStr == null || timeStr.length < 5) return '--:--';
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      return '$displayHour:$minute $period';
    }

    return {
      'openingStaff': openingStaffName,
      'closingStaff': closingStaffName,
      'openingTime': formatTimeFromDb(response['opening_time_in']),
      'closingTime': formatTimeFromDb(response['closing_time_in']),
      'date': _formatDateLong(date),
    };
  } catch (e) {
    debugPrint('❌ Fetch assignment error: $e');
    return null;
  }
}

  // ✅ [UNCHANGED UI] Leave Request Dialog (kept identical)
void _showViewLeaveRequestDialog(Map<String, dynamic> request) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB3D4FF), Colors.white],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Leave Request',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pending for Admin Approval',
                style: TextStyle(fontSize: 12, color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 24),
              
              // Staff Name
              const Text('STAFF NAME',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(request['staff_name'] ?? 'Unknown', style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 20),
              
              // Date Range
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('START DATE',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(_formatDateShort(request['start_date']), style: const TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('END DATE',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(_formatDateShort(request['end_date']), style: const TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Reason
              const Text('REASON FOR LEAVE',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
              const SizedBox(height: 8),
              Container(
                height: 150,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  request['reason'] ?? 'No reason provided',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A237E)),
                ),
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _updateLeaveRequestStatus(request['id'], 'rejected');
                        if (mounted) {
                          Navigator.of(context).pop(); // Close detail dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Leave Request Declined'), backgroundColor: Colors.red),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('DECLINE',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _updateLeaveRequestStatus(request['id'], 'approved');
                        if (mounted) {
                          Navigator.of(context).pop(); // Close detail dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Leave Request Approved'), backgroundColor: Colors.green),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF43A047),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('APPROVE',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
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

  // ✅ UPDATED: Fetch from Supabase when viewing branch details
  void _showBranchDetails(String branchName, DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          '$branchName BRANCH',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A237E)),
        ),
        content: FutureBuilder<Map<String, dynamic>?>(
          future: _fetchAssignment(branchName, date),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final assignment = snapshot.data;
            final openingStaff = assignment?['openingStaff'] ?? 'Not Assigned';
            final closingStaff = assignment?['closingStaff'] ?? 'Not Assigned';
            final openingTime = assignment?['openingTime'] ?? '--:--';
            final closingTime = assignment?['closingTime'] ?? '--:--';
            final assignedDate = assignment?['date'];

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (assignedDate != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Color(0xFF1A237E)),
                          const SizedBox(width: 8),
                          Text('Date: $assignedDate',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
                        ],
                      ),
                    ),
                  if (assignedDate != null) const SizedBox(height: 12),
                  const Text('Opening Shift',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: openingStaff != 'Not Assigned' ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                              radius: 15,
                              child: Icon(Icons.person,
                                  color: openingStaff != 'Not Assigned' ? Colors.white : Colors.grey, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(openingStaff,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: openingStaff != 'Not Assigned' ? const Color(0xFF1A237E) : Colors.grey,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Color(0xFF1A237E)),
                            const SizedBox(width: 8),
                            Text(openingTime,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Closing Shift',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: closingStaff != 'Not Assigned' ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                              radius: 15,
                              child: Icon(Icons.person,
                                  color: closingStaff != 'Not Assigned' ? Colors.white : Colors.grey, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(closingStaff,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: closingStaff != 'Not Assigned' ? const Color(0xFF1A237E) : Colors.grey,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Color(0xFF1A237E)),
                            const SizedBox(width: 8),
                            Text(closingTime,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  // ✅ [UNCHANGED UI] Leave Requests Dialog
void _showLeaveRequestsDialog() {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB3D4FF), Colors.white],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Leave Requests',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const Text(
                      'Pending for Admin Approval',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1A237E)),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 24, color: Color(0xFF1A237E)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchPendingLeaveRequests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}', 
                        style: const TextStyle(color: Colors.red)),
                    );
                  }
                  
                  final requests = snapshot.data ?? [];
                  if (requests.isEmpty) {
                    return const Center(
                      child: Text('No pending leave requests', 
                        style: TextStyle(color: Color(0xFF1A237E))),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: requests.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ]),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF1A237E),
                              radius: 20,
                              child: const Icon(Icons.person, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request['staff_name'] ?? 'Unknown Staff',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                  Text(
                                    '${_formatDateShort(request['start_date'])} - ${_formatDateShort(request['end_date'])}',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close list dialog
                                _showViewLeaveRequestDialog(request); // Open detail dialog
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5C6BC0),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text(
                                'View',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // ✅ UPDATED: Assign Staff Dialog with Supabase save
void _showAssignStaffDialog() async {
  // ✅ Show loading dialog first
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  // ✅ Fetch staff data
  List<Map<String, String>> staffList = [];
  try {
    final response = await _supabase
        .from('profiles')
        .select('id, full_name')
        .eq('role', 'staff');
    
    staffList = response.map((p) => {
      'id': p['id'] as String,
      'name': (p['full_name'] as String?) ?? 'Unnamed',
    }).toList();
    
    debugPrint('✅ Fetched ${staffList.length} staff members');
  } catch (e) {
    debugPrint('❌ Error: $e');
    // Fallback data
    staffList = [
      {'id': '1', 'name': 'MJ'},
      {'id': '2', 'name': 'Toni'},
      {'id': '3', 'name': 'Jane'},
      {'id': '4', 'name': 'Ange'},
      {'id': '5', 'name': 'Dhell'},
      {'id': '6', 'name': 'Ruby'},
      {'id': '7', 'name': 'Jessa'},
      {'id': '8', 'name': 'Chabe'},
      {'id': '9', 'name': 'Daniela'},
      {'id': '10', 'name': 'Danica'},
      {'id': '11', 'name': 'Gabriel'},
      {'id': '12', 'name': 'Diya'},
      {'id': '13', 'name': 'Jhuanna'},
    ];
  }

  // ✅ Close loading dialog
  if (mounted) Navigator.of(context).pop();

  // ✅ Variables for dialog
  String? selectedBranch;
  String? openingStaffId;
  String? closingStaffId;
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;
  DateTime? selectedDate;

  // ✅ NOW show the actual dialog with data already loaded
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Branch',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedBranch,
                      isExpanded: true,
                      hint: const Text('Choose a branch...'),
                      items: _branches.map((branch) => DropdownMenuItem(value: branch, child: Text(branch))).toList(),
                      onChanged: (value) => setDialogState(() => selectedBranch = value),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Select Date',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setDialogState(() => selectedDate = picked);
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
                          selectedDate == null ? 'Select Date' : _formatDateLong(selectedDate!),
                          style: TextStyle(fontSize: 14, color: selectedDate != null ? const Color(0xFF1A237E) : Colors.grey),
                        ),
                        const Spacer(),
                        const Icon(Icons.calendar_today, size: 18, color: Color(0xFF1A237E)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  selectedBranch != null ? '$selectedBranch BRANCH' : 'ASSIGN STAFF',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),

                // Opening Shift
                const Text('Opening Shift',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 15,
                              child: Icon(Icons.person, size: 18, color: Color(0xFF1A237E)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: openingStaffId,
                                  isExpanded: true,
                                  hint: const Text('Staff Name', style: TextStyle(fontSize: 12)),
                                  items: staffList.map((s) => 
                                    DropdownMenuItem<String>(
                                      value: s['id'],
                                      child: Text(s['name'] ?? 'Unnamed'),
                                    )
                                  ).toList(),
                                  onChanged: (val) => setDialogState(() => openingStaffId = val),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Opening Shift Time In', style: TextStyle(fontSize: 10, color: Color(0xFF1A237E))),
                          InkWell(
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: openingTime ?? TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.input,
                                builder: (ctx, child) => MediaQuery(
                                  data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
                                  child: child!,
                                ),
                              );
                              if (picked != null) setDialogState(() => openingTime = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    openingTime != null ? openingTime!.format(context) : 'Select Time',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: openingTime != null ? const Color(0xFF1A237E) : Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.access_time, size: 16, color: Color(0xFF1A237E)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Closing Shift
                const SizedBox(height: 16),
                const Text('Closing Shift',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A237E))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 15,
                              child: Icon(Icons.person, size: 18, color: Color(0xFF1A237E)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: closingStaffId,
                                  isExpanded: true,
                                  hint: const Text('Staff Name', style: TextStyle(fontSize: 12)),
                                  items: staffList.map((s) => 
                                    DropdownMenuItem<String>(
                                      value: s['id'],
                                      child: Text(s['name'] ?? 'Unnamed'),
                                    )
                                  ).toList(),
                                  onChanged: (val) => setDialogState(() => closingStaffId = val),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Closing Shift Time In', style: TextStyle(fontSize: 10, color: Color(0xFF1A237E))),
                          InkWell(
                            onTap: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: closingTime ?? TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.input,
                                builder: (ctx, child) => MediaQuery(
                                  data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
                                  child: child!,
                                ),
                              );
                              if (picked != null) setDialogState(() => closingTime = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    closingTime != null ? closingTime!.format(context) : 'Select Time',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: closingTime != null ? const Color(0xFF1A237E) : Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.access_time, size: 16, color: Color(0xFF1A237E)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
  if (selectedBranch == null || selectedDate == null) {
    // ✅ Use context immediately (not after async)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a branch and date first'), backgroundColor: Colors.red),
    );
    return;
  }

  // ✅ Close the assign dialog
  Navigator.of(context).pop();

  // ✅ Wait a tiny bit for dialog to close
  await Future.delayed(const Duration(milliseconds: 200));

  // ✅ Check if widget is still mounted
  if (!mounted) return;

  // ✅ Create a navigator key to avoid context issues
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  // ✅ Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    // ✅ Perform the save
    final success = await _saveAssignment(
      branch: selectedBranch!,
      date: selectedDate!,
      openingStaffId: openingStaffId,
      closingStaffId: closingStaffId,
      openingTime: openingTime,
      closingTime: closingTime,
    );

    // ✅ Check mounted before using context
    if (!mounted) return;

    // ✅ Close loading dialog
    Navigator.of(context).pop();

    // ✅ Show result message
    if (success) {
      final formattedDate = _formatDateLong(selectedDate!);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Staff assigned to $selectedBranch on $formattedDate successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {});
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to save assignment'), backgroundColor: Colors.red),
      );
    }
  } catch (e) {
    debugPrint('❌ Assignment error: $e');
    
    // ✅ Check mounted before using context
    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog
      messenger.showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Assign and Notify Staff',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  void _navigateTo(String pageName) {
    String? routeName;
    switch (pageName) {
      case 'Staff Management':
        routeName = AppRouter.adminStaffManagement;
        break;
      case 'Overall Inventory':
        routeName = AppRouter.adminoverallinv;
        break;
      case 'Services':
        routeName = AppRouter.adminServices;
        break;
      case 'Salary':
        routeName = AppRouter.adminsalary;
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
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$pageName not connected yet.'),
            duration: const Duration(seconds: 1),
          ),
        );
        return;
    }
    
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: routeName == AppRouter.notifications ? true : null,
    );
  }




  // ✅ [FIXED] _buildSidebarItem method - properly closed
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
  } // ✅ <-- This closing brace was missing or misplaced!

  // ✅ [FIXED] build method - contains ALL UI code
  @override
  Widget build(BuildContext context) {
    DateTime start = _startOfWeek;
    DateTime end = _endOfWeek;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
            // ✅ SIDEBAR
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
              child: Container(
                width: 240,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
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
                              child: Image.asset('assets/logo.png',
                                  width: 42, height: 42, fit: BoxFit.cover)),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Cam2print System',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
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
                          _buildSidebarItem(Icons.settings, "Services", () => _navigateTo('Services')),
                          _buildSidebarItem(Icons.attach_money, "Salary", () => _navigateTo('Salary')),
                          _buildSidebarItem(Icons.shopping_cart, "Customized Orders", () => _navigateTo('Customized Orders')),
                          _buildSidebarItem(Icons.calendar_today, "Schedule", () => _navigateTo('Schedule'), isActive: true),
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

            // ✅ MAIN CONTENT - NOW PROPERLY INSIDE build() METHOD
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
                          Text(DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
                          Row(
                            children: [
                              const Icon(Icons.notifications_none, color: Color(0xFF1A237E), size: 24),
                              const SizedBox(width: 20),
                              const CircleAvatar(radius: 18, backgroundColor: Colors.white,
                                  child: Icon(Icons.person, size: 26, color: Color(0xFF1A237E))),
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
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: _showLeaveRequestsDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5C6BC0),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Leave Requests", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _showAssignStaffDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Assign Staff per Branch", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(color: const Color(0xFF5C6BC0), borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: _previousWeek),
                          Text("${_formatDate(start).toUpperCase()} - ${_formatDate(end).toUpperCase()}, ${end.year}",
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20), onPressed: _nextWeek),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
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
            ), // ✅ End of Expanded (Main Content)
          ], // ✅ End of Row children
        ), // ✅ End of Row
      ), // ✅ End of Container (body)
    ); // ✅ End of Scaffold
  } // ✅ End of build() method - THIS WAS MISSING!

  // ✅ Day Card (unchanged UI, VIEW button triggers _showBranchDetails which now fetches from Supabase)
  Widget _buildDayCard(DateTime date) {
    const days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              children: [
                Text(days[date.weekday - 1].toUpperCase(),
                    style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text("${date.day}", style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFF9FA8DA), borderRadius: BorderRadius.all(Radius.circular(20))),
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
                        Flexible(
                            child: Text(_branches[index],
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                                overflow: TextOverflow.ellipsis)),
                        ElevatedButton(
                          onPressed: () => _showBranchDetails(_branches[index], date),
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