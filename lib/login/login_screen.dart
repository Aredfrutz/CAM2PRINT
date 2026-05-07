import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ This is just the LoginScreen widget - no main() or MyApp needed!
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isForgotHovered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.02, 0.32, 1.0],
            colors: [
              Color(0xFF7CA8F9), // 2%
              Color(0xFFB4C4FC), // 32%
              Color(0xFFFFFFFF), // 100%
            ],
          ),
        ),
        child: SafeArea(
          child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 480,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
          decoration: BoxDecoration(
            color: const Color(0xFF3C3B6E),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _buildLoginForm(isDarkMode: true),
        ),
        const SizedBox(width: 40),
        _buildLogoSection(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildLogoSection(),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF3C3B6E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildLoginForm(isDarkMode: true),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm({required bool isDarkMode}) {
    Color textColor = isDarkMode ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0);
    Color inputBgColor = const Color(0xFFEEEEEE);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Login', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 40),
          Text('Email', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          _buildInputField(controller: _emailController, hint: 'Enter your email', bgColor: inputBgColor, textColor: textColor,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Please enter a valid email';
              return null;
            }),
          const SizedBox(height: 20),
          Text('Password', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          _buildInputField(controller: _passwordController, hint: 'minimum 8 characters', obscureText: _obscurePassword,
            bgColor: inputBgColor, textColor: textColor,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your password';
              return null;
            }),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color: _rememberMe ? Colors.blueAccent : Colors.transparent,
                        border: Border.all(color: textColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _rememberMe ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('Remember me', style: TextStyle(color: textColor)),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (_) => setState(() => _isForgotHovered = true),
                onExit: (_) => setState(() => _isForgotHovered = false),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: textColor,
                      decoration: _isForgotHovered ? TextDecoration.underline : TextDecoration.none,
                      decorationThickness: 2,
                      decorationColor: textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) _handleLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF121238),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 480,
          height: 480,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 30, spreadRadius: 5)],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)));
              },
            ),
          ),
        ),
        const SizedBox(height: 25),
        const Text('© Copyright since 2008', style: TextStyle(color: Colors.black54, fontSize: 14)),
      ],
    );
  }

  Future<void> _handleLogin() async {
    // Show a loading indicator so the user knows something is happening
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Sign in with Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Get the role from the user's metadata
      final userRole = response.user?.userMetadata?['role'] ?? 'staff';

      if (!mounted) return;
      Navigator.pop(context); // Remove the loading indicator

      // 3. Redirect based on the actual role in Supabase
      if (userRole == 'admin') {
        Navigator.pushReplacementNamed(context, AppRouter.adminStaffManagement);
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.staffProfile);
      }
      
    } on AuthException catch (error) {
      if (!mounted) return;
      Navigator.pop(context); // Remove loading indicator
      
      // Show error message (e.g., "Invalid login credentials")
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message), backgroundColor: Colors.red),
      );
    } catch (error) {
      if (!mounted) return;
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred"), backgroundColor: Colors.red),
      );
    }
  }
  }
