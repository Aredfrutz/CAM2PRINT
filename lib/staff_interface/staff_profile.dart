import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StaffProfile extends StatefulWidget {
  const StaffProfile({super.key});

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  bool _showEntryForm = false;
  Uint8List? _verificationPhotoBytes;
  Uint8List? _followUpPhotoBytes;
  File? _verificationPhoto;
  File? _followUpPhoto;
  final ImagePicker _picker = ImagePicker();
  
  final TextEditingController _timeInController = TextEditingController();
  final TextEditingController _timeOutController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  
  final TextEditingController _staffNameController = TextEditingController(text: 'Name of Staff');
  final TextEditingController _employeeTypeController = TextEditingController(text: 'Full Time Employee');
  final TextEditingController _shopBranchController = TextEditingController(text: 'Main Branch');
  
  DateTime _currentMonth = DateTime(2026, 4, 1);
  final Map<String, Map<String, String>> _attendanceData = {};
  DateTime? _photoDate;

  Future<DateTime?> _extractDateFromPhoto(Uint8List imageBytes) async {
    try {
      final exifData = await readExifFromBytes(imageBytes);
      if (exifData.containsKey('EXIF DateTimeOriginal')) {
        final dateTimeString = exifData['EXIF DateTimeOriginal']?.toString();
        if (dateTimeString != null) {
          final parts = dateTimeString.split(' ');
          final dateParts = parts[0].split(':');
          final timeParts = parts[1].split(':');
          return DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );
        }
      }
    } catch (e) {
      print('Error reading EXIF: $e');
    }
    return null;
  }

  Future<void> _pickImage(bool isVerificationPhoto) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final photoDate = await _extractDateFromPhoto(bytes);
        
        if (photoDate != null) {
          _photoDate = photoDate;
          String timeString = '${photoDate.hour}:${photoDate.minute.toString().padLeft(2, '0')}';
          setState(() {
            if (isVerificationPhoto) {
              _timeInController.text = timeString;
              _verificationPhotoBytes = bytes;
              _verificationPhoto = null;
            } else {
              _timeOutController.text = timeString;
              _followUpPhotoBytes = bytes;
              _followUpPhoto = null;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('📸 Photo time: $timeString on day ${photoDate.day}'), backgroundColor: Colors.green),
          );
        } else {
          _photoDate = null;
          if (kIsWeb) {
            setState(() {
              if (isVerificationPhoto) {
                _verificationPhotoBytes = bytes;
              } else {
                _followUpPhotoBytes = bytes;
              }
            });
          } else {
            final file = File(pickedFile.path);
            setState(() {
              if (isVerificationPhoto) {
                _verificationPhoto = file;
              } else {
                _followUpPhoto = file;
              }
            });
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _editStaffInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Staff Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _staffNameController,
                decoration: const InputDecoration(
                  labelText: 'Staff Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _employeeTypeController.text,
                decoration: const InputDecoration(
                  labelText: 'Employee Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                items: ['Full Time Employee', 'Part Time Employee'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _employeeTypeController.text = newValue!;
                  });
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _shopBranchController,
                decoration: const InputDecoration(
                  labelText: 'Shop Branch',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Staff information updated!'), backgroundColor: Colors.green),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _previousMonth() => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1));
  void _nextMonth() => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1));
  String _getAttendanceKey(int day) => '${_currentMonth.year}-${_currentMonth.month}-$day';

  void _submitAttendance() {
    String timeIn = _timeInController.text.trim();
    String timeOut = _timeOutController.text.trim();
    String typeOfEntry = _typeController.text.trim();
    
    if (timeIn.isEmpty && timeOut.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least Time In or Time Out'), backgroundColor: Colors.red),
      );
      return;
    }
    
    int dayToSave = _photoDate?.day ?? DateTime.now().day;
    String key = _getAttendanceKey(dayToSave);
    
    setState(() {
      if (_attendanceData[key] == null) _attendanceData[key] = {};
      if (timeIn.isNotEmpty) { _attendanceData[key]!['timeIn'] = timeIn; _attendanceData[key]!['type'] = typeOfEntry; }
      if (timeOut.isNotEmpty) { _attendanceData[key]!['timeOut'] = timeOut; _attendanceData[key]!['type'] = typeOfEntry; }
      
      _showEntryForm = false;
      _verificationPhoto = null; _verificationPhotoBytes = null;
      _followUpPhoto = null; _followUpPhotoBytes = null;
      _timeInController.clear(); _timeOutController.clear(); _typeController.clear();
      _photoDate = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Attendance logged on ${_formatMonthYear()} $dayToSave!'), backgroundColor: Colors.green),
    );
  }

  void _navigateTo(String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $pageName...'), backgroundColor: Colors.blue[800], duration: const Duration(seconds: 1)),
    );
  }

  @override
  void dispose() {
    _timeInController.dispose();
    _timeOutController.dispose();
    _typeController.dispose();
    _staffNameController.dispose();
    _employeeTypeController.dispose();
    _shopBranchController.dispose();
    super.dispose();
  }

  int _getDaysInMonth() => DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  int _getFirstDayOfMonth() => DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;
  String _formatMonthYear() {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth();
    final firstDayOfWeek = _getFirstDayOfMonth();
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7C88C2),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
              child: Container(
                width: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF5B6388),
                      Color(0xFF3E4563),
                    ],
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
                          ClipOval(
                            child: Image.asset(
                              'assets/logo.jpg',
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
                    _buildSidebarItem(Icons.inventory_2, "Daily Inventory", () => _navigateTo('Daily Inventory')),
                    _buildSidebarItem(Icons.design_services, "Services", () => _navigateTo('Services')),
                    _buildSidebarItem(Icons.monetization_on, "Salary", () => _navigateTo('Salary')),
                    _buildSidebarItem(Icons.shopping_cart, "Consumption Tracker", () => _navigateTo('Consumption Tracker')),
                    _buildSidebarItem(Icons.shopping_bag, "Customized Orders", () => _navigateTo('Customized Orders')),
                    _buildSidebarItem(Icons.event_available, "Schedule", () => _navigateTo('Schedule')),
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
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: const BoxDecoration(
                        color: Color(0xFFB3D4FF),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Saturday, January 31, 2026", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
                          Row(
                            children: [
                              const Icon(Icons.notifications_none, color: Color(0xFF1A237E), size: 24),
                              const SizedBox(width: 20),
                              const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.person, size: 26, color: Color(0xFF1A237E))),
                              const SizedBox(width: 10),
                              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text("Jane", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A237E))),
                                Text("Admin", style: TextStyle(fontSize: 11, color: Color(0xFF1A237E))),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    GestureDetector(
                      onTap: _editStaffInfo,
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(width: 70, height: 70, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.person, size: 50, color: Color(0xFF5C6BC0))),
                            const SizedBox(width: 25),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _staffNameController.text,
                                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _employeeTypeController.text,
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Shop Branch: ${_shopBranchController.text}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.edit, color: Colors.white70, size: 24),
                            const SizedBox(width: 15),
                            ElevatedButton(
                              onPressed: () => setState(() => _showEntryForm = true),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                              child: const Text("Log Attendance", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 10)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Attendance Log - ${_formatMonthYear()}",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A237E)),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                                      child: IconButton(
                                        icon: const Icon(Icons.chevron_left, color: Color(0xFF1A237E), size: 20),
                                        onPressed: _previousMonth,
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                                      child: IconButton(
                                        icon: const Icon(Icons.chevron_right, color: Color(0xFF1A237E), size: 20),
                                        onPressed: _nextMonth,
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Expanded(child: Text("SUN", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(child: Text("MON", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(child: Text("TUE", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(child: Text("WED", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(child: Text("THU", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(child: Text("FRI", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                                Expanded(child: Text("SAT", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(height: 1),
                            const SizedBox(height: 8),
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 7,
                                childAspectRatio: 1.0,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
                                children: [
                                  ...List.generate(firstDayOfWeek, (index) => Container()),
                                  ...List.generate(daysInMonth, (index) {
                                    int day = index + 1;
                                    String key = _getAttendanceKey(day);
                                    final data = _attendanceData[key] ?? {};
                                    final timeIn = data['timeIn'];
                                    final timeOut = data['timeOut'];
                                    final type = data['type'];
                                    
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[50],
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              day.toString(),
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black54),
                                            ),
                                          ),
                                          const Spacer(),
                                          if (timeIn != null || timeOut != null)
                                            Text(
                                              '${_shopBranchController.text} Branch',
                                              style: const TextStyle(
                                                fontSize: 10, 
                                                fontWeight: FontWeight.bold, 
                                                color: Color(0xFF3F3F74),
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          if (timeIn != null) _buildAttendanceBarWithTime("IN: $timeIn", type, Colors.green),
                                          if (timeOut != null) _buildAttendanceBarWithTime("OUT: $timeOut", type, Colors.red),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_showEntryForm)
              Container(
                width: 450,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFF7C88C2),
                    ],
                  ),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text("Time In and Time Out Entry", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                      IconButton(icon: const Icon(Icons.close, size: 28), onPressed: () => setState(() => _showEntryForm = false)),
                    ]),
                    const SizedBox(height: 25),
                    Row(children: [
                      Expanded(child: _buildTimeField("Time In", "AM", _timeInController)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTimeField("Time Out", "PM", _timeOutController)),
                    ]),
                    const SizedBox(height: 20),
                    const Text("Type of Entry", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      initialValue: _typeController.text.isNotEmpty ? _typeController.text : null,
                      items: ["Nozzle", "Pad Lock", "Pocket Money"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => _typeController.text = val ?? '',
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), hintText: 'Select type', filled: true, fillColor: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 20),
                    const Text("Date and Time Verification Photo", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
                    const SizedBox(height: 10),
                    _buildUploadBox("Upload image as png, jpeg", kIsWeb ? _verificationPhotoBytes : null, kIsWeb ? null : _verificationPhoto, () => _pickImage(true)),
                    const SizedBox(height: 20),
                    const Text("Follow up Proof Photo", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
                    const SizedBox(height: 10),
                    _buildUploadBox("Upload media as png, jpeg, mp4", kIsWeb ? _followUpPhotoBytes : null, kIsWeb ? null : _followUpPhoto, () => _pickImage(false)),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: _submitAttendance,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                        child: const Text("SUBMIT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
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

  Widget _buildTimeField(String label, String suffix, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF1A237E))),
      const SizedBox(height: 8),
      TextField(controller: controller, decoration: InputDecoration(suffixText: suffix, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), hintText: 'e.g., 10:03', filled: true, fillColor: Colors.white.withOpacity(0.8))),
    ]);
  }

  Widget _buildAttendanceBarWithTime(String text, String? type, Color color) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3), 
      margin: const EdgeInsets.only(bottom: 4), 
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (type != null && type.isNotEmpty) 
            Text(
              type, 
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), 
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            text, 
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), 
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String hint, Uint8List? webImage, File? mobileImage, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 2), borderRadius: BorderRadius.circular(12), color: Colors.white.withOpacity(0.8)),
        child: webImage != null
            ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(webImage, fit: BoxFit.cover))
            : mobileImage != null
                ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(mobileImage, fit: BoxFit.cover))
                : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.cloud_upload_outlined, color: Colors.grey[600], size: 40),
                    const SizedBox(height: 8),
                    Text(hint, style: TextStyle(color: Colors.grey[600], fontSize: 12), textAlign: TextAlign.center),
                  ])),
      ),
    );
  }
}