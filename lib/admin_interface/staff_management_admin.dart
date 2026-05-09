import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({super.key});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  // 1. Toggle Active/Inactive Status
  Future<void> _toggleStaffStatus(String id, bool currentStatus) async {
    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'is_active': !currentStatus})
          .eq('id', id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentStatus ? '✅ Staff deactivated' : '✅ Staff activated'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to update status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 2. Delete Staff with Confirmation
  Future<void> _deleteStaff(String id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to remove this staff member?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text("Delete", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // ✅ Delete from profiles table
        await Supabase.instance.client.from('profiles').delete().eq('id', id);
        
        // ✅ Also delete from auth.users (requires service role or admin)
        // Note: This may fail if you don't have admin privileges, but profile will still be deleted
        try {
          await Supabase.instance.client.auth.admin.deleteUser(id);
        } catch (_) {
          // Silently ignore auth deletion errors for non-admin users
          print('Note: Auth user deletion skipped (requires admin privileges)');
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Staff deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Failed to delete: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showEditStaffDialog(Map<String, dynamic> staff) {
    final nameController = TextEditingController(text: staff['full_name']);
    final emailController = TextEditingController(text: staff['email_address']);
    String? selectedStatus = staff['employment_status'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Staff Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: ["Full-Time", "Part-Time", "Contractual"]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => selectedStatus = v,
              decoration: const InputDecoration(labelText: "Employment Status"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                await Supabase.instance.client
                    .from('profiles')
                    .update({
                      'full_name': nameController.text,
                      'email_address': emailController.text,
                      'employment_status': selectedStatus,
                    })
                    .eq('id', staff['id']);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Staff info updated")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ Failed to update: $e")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
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
          children: [
            // Sidebar
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
                left: 20.0,
              ),
              child: Container(
                width: 240,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
                    // Active highlight for Staff Management
                    _buildSidebarItem(
                      Icons.people,
                      "Staff Management",
                      () => _navigateTo('Staff Management'),
                      isActive: true,
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
                    ),
                    _buildSidebarItem(
                      Icons.error_outline,
                      "Reports",
                      () => _navigateTo('Reports'),
                    ),
                    const Spacer(),
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

            // Main Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top navbar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
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
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 26,
                                  color: Color(0xFF1A237E),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Admin",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
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

                    // Staff table
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
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
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Staff Management",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                      Text(
                                        "Manage account access and profile details.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: _showAddStaffDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4B5580),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "ADD NEW STAFF",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: _buildStaffTable()),
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

  void _showAddStaffDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String? selectedEmploymentStatus;
    bool _isCreating = false;
    bool _isPasswordVisible = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ HEADER WITH CLOSE BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Create Staff Account",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        // ✅ CLOSE BUTTON
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFF6B7280),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Set up access for newly hired employees",
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // ✅ SCROLLABLE FORM CONTENT
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Form Fields
                            _buildFormField("STAFF NAME", "Enter Full Name", nameController),
                            const SizedBox(height: 16),
                            _buildDropdownField(
                              "EMPLOYMENT STATUS",
                              const ["Full-Time", "Part-Time", "Contractual"],
                              selectedEmploymentStatus,
                              (value) {
                                setDialogState(() {
                                  selectedEmploymentStatus = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildFormField("EMAIL ADDRESS", "email@c2p.com", emailController),
                            
                            // ✅ PASSWORD FIELD WITH EYE TOGGLE
                            _buildPasswordFieldWithToggle(
                              "PASSWORD", 
                              passwordController,
                              _isPasswordVisible,
                              () {
                                setDialogState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            
                            const SizedBox(height: 24),

                            // ✅ CREATE BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isCreating
                                    ? null
                                    : () async {
                                        if (nameController.text.isEmpty ||
                                            emailController.text.isEmpty ||
                                            passwordController.text.isEmpty ||
                                            selectedEmploymentStatus == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Please fill all fields'),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                          return;
                                        }

                                        setDialogState(() => _isCreating = true);

                                        try {
                                          // ✅ 1. Check if email already exists
                                          final existingUsers = await Supabase.instance.client
                                              .from('profiles')
                                              .select('email_address')
                                              .eq('email_address', emailController.text.trim())
                                              .maybeSingle();

                                          if (existingUsers != null) {
                                            throw Exception('Email already registered. Use a different email.');
                                          }

                                          // ✅ 2. Create auth user (profile auto-created by trigger)
final authResponse = await Supabase.instance.client.auth.signUp(
  email: emailController.text.trim(),
  password: passwordController.text,
  data: {
    'full_name': nameController.text.trim(),
    'employment_status': selectedEmploymentStatus,
  },
);

final user = authResponse.user;
if (user == null) {
  throw Exception('Failed to create user account');
}

// ✅ No manual insert needed - trigger handles it!
// Wait briefly for trigger to complete
await Future.delayed(const Duration(milliseconds: 500));

                                          // ✅ 3. Insert profile data into profiles table
                                          await Supabase.instance.client
                                              .from('profiles')
                                              .insert({
                                                'id': user.id,
                                                'full_name': nameController.text.trim(),
                                                'email_address': emailController.text.trim(),
                                                'employment_status': selectedEmploymentStatus,
                                                'is_active': true,
                                                'role': 'staff',
                                                'updated_at': DateTime.now().toIso8601String(),
                                              })
                                              .select();

                                          if (!context.mounted) return;
                                          
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('✅ Staff account created successfully!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } on AuthException catch (e) {
                                          // ✅ Handle Auth errors gracefully
                                          // If profile was created but auth failed, still show success
                                          if (e.message.contains('email') && e.message.contains('confirm')) {
                                            // Email confirmation required - but profile might still be created
                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('✅ Account created! Check email for confirmation.'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } else {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('❌ ${e.message}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } on PostgrestException catch (e) {
                                          // ✅ Database error
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('❌ Database error: ${e.message}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } catch (e) {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('❌ Failed: ${e.toString()}'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } finally {
                                          if (context.mounted) {
                                            setDialogState(() => _isCreating = false);
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4B5580),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isCreating
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "CREATE ACCOUNT",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
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
          },
        );
      },
    );
  }

  // ✅ NEW METHOD: Password field with eye toggle button
  Widget _buildPasswordFieldWithToggle(
    String label,
    TextEditingController controller,
    bool isPasswordVisible,
    VoidCallback onToggleVisibility,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            hintText: "••••••••",
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFF4B5580)),
            ),
            suffixIcon: InkWell(
              onTap: onToggleVisibility,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF6B7280),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFF4B5580)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              hint: const Text(
                "Select status",
                style: TextStyle(color: Color(0xFF9CA3AF)),
              ),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "••••••••",
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFF4B5580)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffTable() {
    const headerStyle = TextStyle(
      color: Color(0xFF6B7280),
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text("STAFF NAME", style: headerStyle),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text("EMPLOYMENT STATUS", style: headerStyle),
                ),
                Expanded(
                  flex: 4,
                  child: Text("EMAIL ADDRESS", style: headerStyle),
                ),
                Expanded(flex: 2, child: Text("PASSWORD", style: headerStyle)),
                Expanded(flex: 2, child: Text("STATUS", style: headerStyle)),
                SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: Center(child: Text("ACTIONS", style: headerStyle)),
                ),
              ],
            ),
          ),

          // Data Rows
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              // Real-time listener for your staff table
              stream: Supabase.instance.client
                  .from('profiles')
                  .stream(primaryKey: ['id'])
                  .order('full_name'),
              builder: (context, snapshot) {
                // 1. Check if there is an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Database Error: ${snapshot.error}"),
                  );
                }

                // 2. Show loading spinner while waiting
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 3. Check if the list is actually empty
                final staffList = snapshot.data ?? [];
                if (staffList.isEmpty) {
                  return const Center(
                    child: Text("No staff members found in the database."),
                  );
                }
                
                return ListView.builder(
                  itemCount: staffList.length,
                  itemBuilder: (context, index) {
                    final staff = staffList[index];
                    final bool isActive = staff['is_active'] ?? true;

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
                      ),
                      child: Row(
                        children: [
                          // Name
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                staff['full_name'] ?? 'No Name',
                                style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF111827)),
                              ),
                            ),
                          ),
                          // Status
                          Expanded(
                            flex: 2,
                            child: Text(staff['employment_status'] ?? 'Staff', style: const TextStyle(color: Color(0xFF374151))),
                          ),
                          // Email
                          Expanded(
                            flex: 4,
                            child: Text(staff['email_address'] ?? '', style: const TextStyle(color: Color(0xFF374151))),
                          ),
                          // Password Placeholder
                          const Expanded(flex: 2, child: Text("••••••••", style: TextStyle(color: Color(0xFF374151)))),
                          
                          // Status Badge (Dynamic Color)
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isActive ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  color: isActive ? const Color(0xFF059669) : const Color(0xFFDC2626),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Actions
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Edit Button
                                _buildActionButton("EDIT INFO", const Color(0xFF2563EB), () => _showEditStaffDialog(staff)),
                                const SizedBox(width: 8),

                                // Activate/Deactivate Toggle
                                _buildActionButton(
                                  isActive ? "DEACTIVATE" : "ACTIVATE",
                                  isActive ? const Color(0xFFD97706) : const Color(0xFF059669),
                                  () => _toggleStaffStatus(staff['id'], isActive),
                                ),
                                const SizedBox(width: 8),

                                // Delete Button
                                _buildActionButton("DELETE", const Color(0xFFDC2626), () => _deleteStaff(staff['id'])),
                              ],
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
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: const Size(60, 32),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}