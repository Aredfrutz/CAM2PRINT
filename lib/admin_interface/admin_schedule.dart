import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';


class AdminSchedule extends StatefulWidget {
  const AdminSchedule({super.key});

  @override
  State<AdminSchedule> createState() => _AdminScheduleState();
}

class _AdminScheduleState extends State<AdminSchedule> {
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

  final Map<String, Map<String, dynamic>> _branchAssignments = {};

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
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatDateLong(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getAssignmentKey(String branch, DateTime date) {
    return '$branch|${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showViewLeaveRequestDialog() {
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pending for Admin Approval',
                  style: TextStyle(fontSize: 12, color: Color(0xFF1A237E)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'STAFF NAME',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text('John Doe', style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'START DATE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Text('mm/dd/yyyy',
                                    style: TextStyle(fontSize: 14)),
                                const Spacer(),
                                const Icon(Icons.calendar_today,
                                    size: 18, color: Color(0xFF1A237E)),
                              ],
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
                          const Text(
                            'END DATE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Text('mm/dd/yyyy',
                                    style: TextStyle(fontSize: 14)),
                                const Spacer(),
                                const Icon(Icons.calendar_today,
                                    size: 18, color: Color(0xFF1A237E)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'REASON FOR LEAVE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(
                    child: Text(
                      'Reason text goes here...',
                      style: TextStyle(color: Colors.grey),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Leave Request Declined')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'DECLINE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Leave Request Approved')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43A047),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'APPROVE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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

  void _showBranchDetails(String branchName, DateTime date) {
    final assignmentKey = _getAssignmentKey(branchName, date);
    final assignment = _branchAssignments[assignmentKey];

    final openingStaff = assignment?['openingStaff'] ?? 'Not Assigned';
    final closingStaff = assignment?['closingStaff'] ?? 'Not Assigned';
    final openingTime = assignment?['openingTime'] ?? '--:--';
    final closingTime = assignment?['closingTime'] ?? '--:--';
    final assignedDate = assignment?['date'];

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
              if (assignedDate != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Color(0xFF1A237E)),
                      const SizedBox(width: 8),
                      Text(
                        'Date: $assignedDate',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ],
                  ),
                ),
              if (assignedDate != null) const SizedBox(height: 12),
              const Text(
                'Opening Shift',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: openingStaff != 'Not Assigned'
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade300,
                          radius: 15,
                          child: Icon(
                            Icons.person,
                            color: openingStaff != 'Not Assigned'
                                ? Colors.white
                                : Colors.grey,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            openingStaff,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: openingStaff != 'Not Assigned'
                                  ? const Color(0xFF1A237E)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Color(0xFF1A237E)),
                        const SizedBox(width: 8),
                        Text(
                          openingTime,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Closing Shift',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: closingStaff != 'Not Assigned'
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade300,
                          radius: 15,
                          child: Icon(
                            Icons.person,
                            color: closingStaff != 'Not Assigned'
                                ? Colors.white
                                : Colors.grey,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            closingStaff,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: closingStaff != 'Not Assigned'
                                  ? const Color(0xFF1A237E)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Color(0xFF1A237E)),
                        const SizedBox(width: 8),
                        Text(
                          closingTime,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

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
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close,
                        size: 24, color: Color(0xFF1A237E)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 4,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF1A237E),
                            radius: 20,
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Staff Name',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _showViewLeaveRequestDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5C6BC0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'View Leave Request',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
        ),
      ),
    );
  }

  void _showAssignStaffDialog() {
    String? selectedBranch;
    String? openingStaff;
    String? closingStaff;
    TimeOfDay? openingTime;
    TimeOfDay? closingTime;
    DateTime? selectedDate;

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
                  const Text(
                    'Select Branch',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E)),
                  ),
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
                        items: _branches.map((branch) {
                          return DropdownMenuItem(
                              value: branch, child: Text(branch));
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedBranch = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Date',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A237E)),
                  ),
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
                        setDialogState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Text(
                            selectedDate == null
                                ? 'Select Date'
                                : _formatDateLong(selectedDate!),
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedDate != null
                                  ? const Color(0xFF1A237E)
                                  : Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.calendar_today,
                              size: 18, color: Color(0xFF1A237E)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    selectedBranch != null
                        ? '$selectedBranch BRANCH'
                        : 'ASSIGN STAFF',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Opening Shift',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1A237E)),
                  ),
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
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 15,
                                child: const Icon(Icons.person,
                                    size: 18, color: Color(0xFF1A237E)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: openingStaff,
                                    isExpanded: true,
                                    hint: const Text('Staff Name',
                                        style: TextStyle(fontSize: 12)),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'John Doe',
                                          child: Text('John Doe')),
                                      DropdownMenuItem(
                                          value: 'Jane Admin',
                                          child: Text('Jane Admin')),
                                      DropdownMenuItem(
                                          value: 'Maria Santos',
                                          child: Text('Maria Santos')),
                                      DropdownMenuItem(
                                          value: 'Pedro Cruz',
                                          child: Text('Pedro Cruz')),
                                    ],
                                    onChanged: (val) {
                                      setDialogState(() => openingStaff = val);
                                    },
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
                            const Text(
                              'Opening Shift Time In',
                              style:
                                  TextStyle(fontSize: 10, color: Color(0xFF1A237E)),
                            ),
                            InkWell(
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: openingTime ?? TimeOfDay.now(),
                                  initialEntryMode: TimePickerEntryMode.input,
                                  builder: (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(alwaysUse24HourFormat: false),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  setDialogState(() => openingTime = picked);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      openingTime != null
                                          ? openingTime!.format(context)
                                          : 'Select Time',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: openingTime != null
                                            ? const Color(0xFF1A237E)
                                            : Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.access_time,
                                        size: 16, color: Color(0xFF1A237E)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Closing Shift',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1A237E)),
                  ),
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
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 15,
                                child: const Icon(Icons.person,
                                    size: 18, color: Color(0xFF1A237E)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: closingStaff,
                                    isExpanded: true,
                                    hint: const Text('Staff Name',
                                        style: TextStyle(fontSize: 12)),
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'John Doe',
                                          child: Text('John Doe')),
                                      DropdownMenuItem(
                                          value: 'Jane Admin',
                                          child: Text('Jane Admin')),
                                      DropdownMenuItem(
                                          value: 'Maria Santos',
                                          child: Text('Maria Santos')),
                                      DropdownMenuItem(
                                          value: 'Pedro Cruz',
                                          child: Text('Pedro Cruz')),
                                    ],
                                    onChanged: (val) {
                                      setDialogState(() => closingStaff = val);
                                    },
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
                            const Text(
                              'Closing Shift Time In',
                              style:
                                  TextStyle(fontSize: 10, color: Color(0xFF1A237E)),
                            ),
                            InkWell(
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: closingTime ?? TimeOfDay.now(),
                                  initialEntryMode: TimePickerEntryMode.input,
                                  builder: (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(alwaysUse24HourFormat: false),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  setDialogState(() => closingTime = picked);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      closingTime != null
                                          ? closingTime!.format(context)
                                          : 'Select Time',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: closingTime != null
                                            ? const Color(0xFF1A237E)
                                            : Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.access_time,
                                        size: 16, color: Color(0xFF1A237E)),
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
                      onPressed: () {
                        if (selectedBranch != null && selectedDate != null) {
                          final formattedDate =
                              _formatDateLong(selectedDate!);
                          final assignmentKey =
                              _getAssignmentKey(selectedBranch!, selectedDate!);

                          setState(() {
                            _branchAssignments[assignmentKey] = {
                              'openingStaff': openingStaff ?? 'Not Assigned',
                              'closingStaff': closingStaff ?? 'Not Assigned',
                              'openingTime': openingTime != null
                                  ? openingTime!.format(context)
                                  : '--:--',
                              'closingTime': closingTime != null
                                  ? closingTime!.format(context)
                                  : '--:--',
                              'date': formattedDate,
                            };
                          });

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Staff assigned to $selectedBranch on $formattedDate successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please select a branch and date first'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Assign and Notify Staff',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ FIX: Stretch row height
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 20.0, left: 20.0),
              child: Container(
                width: 240,
                height: double.infinity, // ✅ FIX: Force full height
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5B6388), Color(0xFF3E4563)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max, // ✅ FIX: Expand to fill height
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
                          _buildSidebarItem(
                            Icons.people,
                            "Staff Management",
                            () => _navigateTo('Staff Management'),
                          ),
                          _buildSidebarItem(
                            Icons.inventory_2,
                            "Overall Inventory",
                            () => _navigateTo('Overall Inventory'),
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
                            isActive: true,
                          ),
                          _buildSidebarItem(
                            Icons.error_outline,
                            "Reports",
                            () => _navigateTo('Reports'),
                          ),
                        ],
                      ),
                    ),
                    
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

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Saturday/ January 31, 2026",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xFF1A237E))),
                          Row(
                            children: [
                              const Icon(Icons.notifications_none,
                                  color: Color(0xFF1A237E), size: 24),
                              const SizedBox(width: 20),
                              const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person,
                                      size: 26, color: Color(0xFF1A237E))),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Jane",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF1A237E))),
                                  Text("Admin",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF1A237E))),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Leave Requests",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _showAssignStaffDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Assign Staff per Branch",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.white, size: 20),
                              onPressed: _previousWeek),
                          Text(
                              "${_formatDate(start).toUpperCase()} - ${_formatDate(end).toUpperCase()}, ${end.year}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 20),
                              onPressed: _nextWeek),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              children: [
                Text(days[date.weekday - 1].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text("${date.day}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Text(_branches[index],
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E)),
                                overflow: TextOverflow.ellipsis)),
                        ElevatedButton(
                          onPressed: () =>
                              _showBranchDetails(_branches[index], date),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            minimumSize: const Size(0, 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: const Text("VIEW",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold)),
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