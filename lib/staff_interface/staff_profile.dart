import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

class StaffProfile extends StatefulWidget {
  const StaffProfile({super.key});

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  bool _showEntryForm = false;
  bool _isProcessing = false;
  

  // Photo data
  Uint8List? _verificationPhotoBytes;
  Uint8List? _followUpPhotoBytes;
  File? _verificationPhoto;
  File? _followUpPhoto;
  final ImagePicker _picker = ImagePicker();

  // Auto-extracted times & dates
  DateTime? _verificationPhotoDate;
  DateTime? _followUpPhotoDate;
  String? _autoTimeIn;

  final TextEditingController _typeController = TextEditingController();


  final supabase = Supabase.instance.client;

 
  String _staffName = 'Loading...';
  String _employeeId = '';
  String _employeeType = 'Full Time Employee';
  String _shopBranch = 'Loadding...';
  // 1. Change this to DateTime.now() so it doesn't default to April
  DateTime _currentMonth = DateTime.now(); 
  Map<String, Map<String, dynamic>> _attendanceData = {};

  // 2. MERGED initState
  @override
  void initState() {  
    super.initState();
    _currentMonth = DateTime.now(); // Set to current date (May 2026)
    _loadStaffData();               // Keep your existing data loader
  }
  
Future<void> _loadStaffData() async {
  final user = supabase.auth.currentUser;
  if (user == null) return;

  try {
    // 1. Fetch Profile Data (Name, Branch, etc.)
    final profileData = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    // 2. Fetch Attendance History from your new table
    final List<dynamic> attendanceRows = await supabase
        .from('attendance')
        .select()
        .eq('staff_id', user.id);

    // 3. Map the database rows to your Calendar's format
    final Map<String, Map<String, dynamic>> loadedHistory = {};
    
    for (var row in attendanceRows) {
      // row['date'] comes from Supabase as 'yyyy-mm-dd'
      final String dateKey = row['date'] ?? ''; 
      if (dateKey.isNotEmpty) {
        loadedHistory[dateKey] = {
          'timeIn': row['time_in'] ?? '--:--',
          'type': row['entry_type'] ?? 'Unknown',
          'hasProofPhoto': 'true',
        };
      }
    }

    // 4. Update the UI all at once
    if (mounted) {
      setState(() {
        _staffName = profileData['full_name'] ?? 'Staff';
        _employeeId = (profileData['employee_id'] ?? user.id).toString();
        _employeeType = profileData['employment_status'] ?? 'Full Time';
        _shopBranch = profileData['assigned_branch'] ?? 'Loading...';
        
        // This line is what makes the old logs show up on the calendar!
        _attendanceData = loadedHistory; 
      });
    }
  } catch (e) {
    debugPrint("Error loading staff data: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading history: $e')),
      );
    }
  }
}

  Future<Uint8List> _compressAttendanceImage(Uint8List input) async {
    final decoded = img.decodeImage(input);
    if (decoded == null) return input;

    final resized = decoded.width > 1280
        ? img.copyResize(decoded, width: 1280)
        : decoded;
    return Uint8List.fromList(img.encodeJpg(resized, quality: 75));
  }

  Future<void> _handleAttendanceSelfie(String attendanceType) async {
    if (_isProcessing) return;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      setState(() => _isProcessing = true);

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      if (pickedFile == null) return;

      final originalBytes = await pickedFile.readAsBytes();
      final compressedBytes = await _compressAttendanceImage(originalBytes);
      final filePath =
          '${user.id}/${attendanceType}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('attendance-photos').uploadBinary(
            filePath,
            compressedBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );

      final imageUrl =
          supabase.storage.from('attendance-photos').getPublicUrl(filePath);

      await supabase.from('attendance_logs').insert({
        'employee_id': _employeeId.isEmpty ? user.id : _employeeId,
        'image_url': imageUrl,
        'attendance_type': attendanceType,
        // Intentionally omit created_at so DB default now() is used.
      });

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).maybePop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            attendanceType == 'time_in'
                ? 'Time In selfie recorded successfully.'
                : 'Time Out selfie recorded successfully.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to record attendance: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showAttendanceActionDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Attendance Selfie'),
        content: const Text(
          'Choose attendance type. This opens your camera and uploads the selfie to Supabase.',
        ),
        actions: [
          TextButton(
            onPressed: _isProcessing
                ? null
                : () async {
                    Navigator.of(dialogContext).pop();
                    await _handleAttendanceSelfie('time_in');
                  },
            child: const Text('Time In'),
          ),
          TextButton(
            onPressed: _isProcessing
                ? null
                : () async {
                    Navigator.of(dialogContext).pop();
                    await _handleAttendanceSelfie('time_out');
                  },
            child: const Text('Time Out'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _extractDateFromPhoto(Uint8List imageBytes) async {
    try {
      final exifData = await readExifFromBytes(imageBytes);

      if (exifData.containsKey('EXIF DateTimeOriginal')) {
        final dateTimeString = exifData['EXIF DateTimeOriginal']?.toString();
        if (dateTimeString != null && dateTimeString.isNotEmpty) {
          try {
            final parts = dateTimeString.split(' ');
            if (parts.length == 2) {
              final dateParts = parts[0].split(':');
              final timeParts = parts[1].split(':');
              if (dateParts.length == 3 && timeParts.length >= 2) {
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
            debugPrint('Error parsing EXIF: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error reading EXIF: $e');
    }
    return null;
  }

  DateTime? _parseDateFromOcrText(String text) {
    final normalized = text.replaceAll('\n', ' ');
    final numericDate = RegExp(
      r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})',
    ).firstMatch(normalized);
    if (numericDate != null) {
      int month = int.parse(numericDate.group(1)!);
      int day = int.parse(numericDate.group(2)!);
      int year = int.parse(numericDate.group(3)!);
      if (year < 100) year += 2000;
      if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
        return DateTime(year, month, day);
      }
    }

    final monthNameDate = RegExp(
      r'(January|February|March|April|May|June|July|August|September|October|November|December)\s+(\d{1,2}),\s*(\d{4})',
      caseSensitive: false,
    ).firstMatch(normalized);
    if (monthNameDate != null) {
      final monthName = monthNameDate.group(1)!.toLowerCase();
      final months = {
        'january': 1,
        'february': 2,
        'march': 3,
        'april': 4,
        'may': 5,
        'june': 6,
        'july': 7,
        'august': 8,
        'september': 9,
        'october': 10,
        'november': 11,
        'december': 12,
      };
      final month = months[monthName];
      if (month != null) {
        final day = int.parse(monthNameDate.group(2)!);
        final year = int.parse(monthNameDate.group(3)!);
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _extractTimeFromImageUsingOCR(
    Uint8List imageBytes,
  ) async {
    try {
      if (kIsWeb) return null;

      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File(
        '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(imageBytes);

      final inputImage = InputImage.fromFile(tempFile);
      final textRecognizer = TextRecognizer();
      try {
        final RecognizedText recognizedText = await textRecognizer.processImage(
          inputImage,
        );

        final List<Map<String, dynamic>> candidates = [];
        final timeRegex = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM|am|pm)?');
        DateTime? parsedDate = _parseDateFromOcrText(recognizedText.text);

        for (final block in recognizedText.blocks) {
          for (final line in block.lines) {
            final match = timeRegex.firstMatch(line.text);
            if (match == null) continue;

            int hour = int.parse(match.group(1)!);
            final int minute = int.parse(match.group(2)!);
            final String? period = match.group(3)?.toUpperCase();

            if (hour > 23 || minute > 59) continue;
            if (period == 'PM' && hour < 12) hour += 12;
            if (period == 'AM' && hour == 12) hour = 0;

            final box = line.boundingBox;
            final double areaScore = (box.width * box.height) / 150.0;
            final double positionScore = box.top > 60 ? 15 : -10;
            final double meridiemScore = 35;
            final double lengthScore = line.text.trim().length <= 12 ? 10 : 0;

            candidates.add({
              'time':
                  '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
              'score': areaScore + positionScore + meridiemScore + lengthScore,
              'raw': line.text,
            });
          }
        }

        if (candidates.isNotEmpty) {
          candidates.sort(
            (a, b) => (b['score'] as double).compareTo(a['score'] as double),
          );
          final best = candidates.first;
          debugPrint('OCR best time candidate: ${best['raw']}');
          return {'time': best['time'], 'date': parsedDate};
        }
      } finally {
        await textRecognizer.close();
        if (await tempFile.exists()) await tempFile.delete();
        if (await tempDir.exists()) await tempDir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('OCR Error: $e');
    }
    return null;
  }

  Future<void> _pickImage(bool isVerificationPhoto) async {
    try {
      setState(() => _isProcessing = true);

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        DateTime? photoDate = await _extractDateFromPhoto(bytes);
        String? timeString;

        if (photoDate != null) {
          timeString =
              '${photoDate.hour.toString().padLeft(2, '0')}:${photoDate.minute.toString().padLeft(2, '0')}';
          debugPrint('EXIF found: $timeString');
        } else {
          final ocrResult = await _extractTimeFromImageUsingOCR(bytes);
          if (ocrResult != null && ocrResult['time'] != null) {
            timeString = ocrResult['time'];
            final baseDate = (ocrResult['date'] as DateTime?) ?? DateTime.now();
            final parts = timeString!.split(':');
            photoDate = DateTime(
              baseDate.year,
              baseDate.month,
              baseDate.day,
              int.parse(parts[0]),
              int.parse(parts[1]),
            );
            debugPrint('OCR found time: $timeString');
          }
        }

        if (timeString != null && photoDate != null) {
          if (!mounted) return;
          setState(() {
            if (isVerificationPhoto) {
              _verificationPhotoDate = photoDate;
              _autoTimeIn = timeString;
              _verificationPhotoBytes = bytes;
              _verificationPhoto = null;
            } else {
              _followUpPhotoDate = photoDate;
              _followUpPhotoBytes = bytes;
              _followUpPhoto = null;
            }
          });

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Time extracted: $timeString on ${photoDate.day}/${photoDate.month}/${photoDate.year}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          final now = DateTime.now();
          final currentTimeString =
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

          if (!mounted) return;
          setState(() {
            if (isVerificationPhoto) {
              _verificationPhotoDate = now;
              _autoTimeIn = currentTimeString;
              _verificationPhotoBytes = bytes;
              _verificationPhoto = null;
            } else {
              _followUpPhotoDate = now;
              _followUpPhotoBytes = bytes;
              _followUpPhoto = null;
            }
          });

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⏰ Using current time: $currentTimeString (could not extract from image)',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _previousMonth() => setState(
    () => _currentMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month - 1,
      1,
    ),
  );

  void _nextMonth() => setState(
    () => _currentMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      1,
    ),
  );

 // Small fix: Ensure date format is always YYYY-MM-DD for the database
  String _getAttendanceKey(int day, {DateTime? photoDate}) {
    final refDate = photoDate ?? _currentMonth;
    // padLeft(2, '0') ensures months like May show as "05" instead of "5"
    return '${refDate.year}-${refDate.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

Future<void> _submitAttendance() async { // 1. Added async
    if (!mounted) return;
    
    final user = supabase.auth.currentUser; // 2. Get current user
    final typeOfEntry = _typeController.text.trim();

    // --- Keep your existing validation checks ---
    if (_verificationPhotoDate == null || _autoTimeIn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Verification Photo first'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_followUpPhotoDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Follow-up Proof Photo'), backgroundColor: Colors.red),
      );
      return;
    }

    if (typeOfEntry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Type of Entry'), backgroundColor: Colors.red),
      );
      return;
    }

    final day = _verificationPhotoDate!.day;
    final key = _getAttendanceKey(day, photoDate: _verificationPhotoDate);
    final dayAttendance = _attendanceData[key] ?? {};
    final hasTimeIn = (dayAttendance['timeIn'] ?? '').isNotEmpty;

    if (hasTimeIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time In already recorded'), backgroundColor: Colors.orange),
      );
      return;
    }

    // --- 3. Save to Supabase Table ---
    try {
      setState(() => _isProcessing = true);
       String? imageUrl;
      if (_verificationPhotoBytes != null) {
  final fileName = '${user!.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  
  await supabase.storage.from('attendance_proofs').uploadBinary(
    fileName,
    _verificationPhotoBytes!,
  );

  imageUrl = supabase.storage.from('attendance_proofs').getPublicUrl(fileName);
}

// --- IMAGE 2: Follow-up Proof Photo (Add this block!) ---
String? followUpUrl;
if (_followUpPhotoBytes != null) {
  final fileName = '${user!.id}/followup_${DateTime.now().millisecondsSinceEpoch}.jpg';
  await supabase.storage.from('attendance_proofs').uploadBinary(fileName, _followUpPhotoBytes!);
  followUpUrl = supabase.storage.from('attendance_proofs').getPublicUrl(fileName);
}

      await supabase.from('attendance').insert({
        'staff_id': user?.id,
        'full_name': _staffName,      // Chabe
        'entry_type': typeOfEntry,     // Nozzle, Pad Lock, etc.
        'time_in': _autoTimeIn,        // Extracted from photo
        'date': key,                   // yyyy-mm-dd
        'proof_url': imageUrl, // This saves the link in your table
        'follow_up_url': followUpUrl // New secondary photo column
      });

      // --- 4. Update UI only if Database save succeeds ---
      setState(() {
        if (_attendanceData[key] == null) _attendanceData[key] = {};
        _attendanceData[key]!['timeIn'] = _autoTimeIn!;
        _attendanceData[key]!['type'] = typeOfEntry;
       _attendanceData[key]!['proofUrl'] = imageUrl; // Store locally for the calendar

        _showEntryForm = false;
        
        // Save these for the success message before clearing
        final displayTime = _autoTimeIn;
        final displayDate = _verificationPhotoDate;

        // Reset the form
        _verificationPhoto = null;
        _verificationPhotoBytes = null;
        _followUpPhoto = null;
        _followUpPhotoBytes = null;
        _typeController.clear();
        _autoTimeIn = null;
        _verificationPhotoDate = null;
        _followUpPhotoDate = null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Time In logged to Database: $displayTime on ${displayDate!.day}/${displayDate.month}'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error saving to Database: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _navigateTo(String pageName) {
    if (!mounted) return;
    String? routeName;
    switch (pageName) {
      case 'Services':
        routeName = AppRouter.staffServices;
        break;
      case 'Daily Inventory':
        routeName = AppRouter.staffDailyInv;
        break;
      case 'Salary':
        routeName = AppRouter.staffsalary;
        break;
      case 'Consumption Tracker':
        routeName = AppRouter.staffConsumptionTracker;
        break;
      case 'Customized Orders':
        routeName = AppRouter.staffCustomizedOrders;
        break;
      case 'Schedule':
        routeName = AppRouter.staffSchedule;
        break;
      case 'Profile':
        routeName = AppRouter.staffProfile;
        break;
      case 'Notifications':
        routeName = AppRouter.notifications;
        break;
    }

    if (routeName != null) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: routeName == AppRouter.notifications ? false : null,
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

  // ✅ ADMIN/DAILYINV STYLE SIDEBAR ITEM
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
    final daysInMonth = _getDaysInMonth();
    final firstDayOfWeek = _getFirstDayOfMonth();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7C88C2), Color(0xFFFFFFFF)],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ FIX: Stretch row height
          children: [
            // ✅ SIDEBAR - Staff Style Applied
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
              ),
              child: Container(
                width: 240,
                height: double.infinity, // ✅ FIX: Force full height
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
                            child: Image.asset(
                              'assets/logo.png',
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
                    
                    // ✅ STAFF NAVIGATION - DailyInv Style
                    _buildSidebarItem(
                      Icons.inventory_2,
                      "Daily Inventory",
                      () => _navigateTo('Daily Inventory'),
                    ),
                    _buildSidebarItem(
                      Icons.design_services,
                      "Services",
                      () => _navigateTo('Services'),
                    ),
                    _buildSidebarItem(
                      Icons.monetization_on,
                      "Salary",
                      () => _navigateTo('Salary'),
                    ),
                    _buildSidebarItem(
                      Icons.shopping_cart,
                      "Consumption Tracker",
                      () => _navigateTo('Consumption Tracker'),
                    ),
                    _buildSidebarItem(
                      Icons.shopping_bag,
                      "Customized Orders",
                      () => _navigateTo('Customized Orders'),
                    ),
                    _buildSidebarItem(
                      Icons.event_available,
                      "Schedule",
                      () => _navigateTo('Schedule'),
                    ),
                    _buildSidebarItem(
                      Icons.person,
                      "Profile",
                      () => _navigateTo('Profile'),
                      isActive: true, // ✅ Active highlight for Profile page
                    ),
                    
                    const Spacer(), // ✅ Pushes logout to bottom
                    
                    // ✅ LOGOUT BUTTON - Staff Style
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () async {
                            try {
                              await supabase.auth.signOut();
                            } catch (_) {
                              // Continue navigation even if remote sign-out fails.
                            }
                            if (!context.mounted) return;
                            Navigator.pushReplacementNamed(
                              context,
                              AppRouter.login,
                            );
                          },
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
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFB3D4FF),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _navigateTo('Notifications'),
                                child: const Icon(
                                  Icons.notifications_none,
                                  color: Color(0xFF1A237E),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => _navigateTo('Profile'),
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    size: 26,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    _staffName, // Changed from "Jane"
                                   style: const TextStyle(
                                     fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                   const Text(
                                     "Staff",
                                     style: TextStyle(
                                     fontSize: 11,
                                     color: Color(0xFF1A237E),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Profile Card
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF5C6BC0),
                            ),
                          ),
                          const SizedBox(width: 25),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _staffName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _employeeType,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Shop Branch: $_shopBranch',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: _showAttendanceActionDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Log Attendance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Calendar
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Attendance Log - ${_formatMonthYear()}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.chevron_left,
                                          color: Color(0xFF1A237E),
                                          size: 20,
                                        ),
                                        onPressed: _previousMonth,
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.chevron_right,
                                          color: Color(0xFF1A237E),
                                          size: 20,
                                        ),
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
                                Expanded(
                                  child: Text(
                                    "SUN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "MON",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "TUE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "WED",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "THU",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "FRI",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "SAT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
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
                                  ...List.generate(
                                    firstDayOfWeek,
                                    (index) => Container(),
                                  ),
                                  ...List.generate(daysInMonth, (index) {
                                    int day = index + 1;
                                    String key = _getAttendanceKey(day);
                                    final data = _attendanceData[key] ?? {};
                                    final timeIn = data['timeIn'];
                                    final type = data['type'];
                                    final hasProofPhoto =
                                        data['hasProofPhoto'] == 'true';

                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[50],
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              day.toString(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          if (timeIn != null) ...[
                                            Text(
                                              '$_shopBranch Branch',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF3F3F74),
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (type != null && type.isNotEmpty)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 2,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[100],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  type,
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF1A237E),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            _buildAttendanceBarWithTime(
                                              "IN: $timeIn",
                                              Colors.green,
                                            ),
                                            if (hasProofPhoto)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 2,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange[100],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.photo_library,
                                                      size: 10,
                                                      color: Color(0xFF1A237E),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Text(
                                                      'Proof',
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xFF1A237E,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
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

            // Entry Form Panel
            if (_showEntryForm)
              Container(
                width: 450,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFFFF), Color(0xFF7C88C2)],
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 20),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Log Attendance",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 28),
                            onPressed: () =>
                                setState(() => _showEntryForm = false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Time Display Section
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            _autoTimeIn != null &&
                                _verificationPhotoDate != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "⏱️ Time In",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1A237E),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _autoTimeIn!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        '${_verificationPhotoDate!.day}/${_verificationPhotoDate!.month}/${_verificationPhotoDate!.year}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const Text(
                                "Upload verification photo to detect time",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "Type of Entry",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField(
                        initialValue: _typeController.text.isNotEmpty
                            ? _typeController.text
                            : null,
                        items: ["Nozzle", "Pad Lock", "Pocket Money"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) => _typeController.text = val ?? '',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Select type',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "📷 Verification Photo (Time In)",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Upload screenshot showing time & date",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      _buildUploadBox(
                        "Upload time/date screenshot",
                        kIsWeb ? _verificationPhotoBytes : null,
                        kIsWeb ? null : _verificationPhoto,
                        () => _pickImage(true),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "📷 Follow-up Proof Photo",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Photo showing shop opening",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      _buildUploadBox(
                        "Upload proof photo",
                        kIsWeb ? _followUpPhotoBytes : null,
                        kIsWeb ? null : _followUpPhoto,
                        () => _pickImage(false),
                      ),
                      const SizedBox(height: 20),

                      if (_isProcessing)
                        const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : _submitAttendance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "SUBMIT ATTENDANCE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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

  int _getDaysInMonth() =>
      DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  int _getFirstDayOfMonth() =>
      DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;

  String _formatMonthYear() {
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
      'December',
    ];
    return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  Widget _buildAttendanceBarWithTime(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildUploadBox(
    String hint,
    Uint8List? webImage,
    File? mobileImage,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.8),
        ),
        child: webImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(webImage, fit: BoxFit.cover),
              )
            : mobileImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(mobileImage, fit: BoxFit.cover),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.grey[600],
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hint,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}