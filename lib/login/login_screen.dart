import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Added for keyboard shortcuts
import 'package:flutter_application_1/app/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode(); // ✅ Added for Enter key navigation
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose(); // ✅ Clean up focus node
    super.dispose();
  }

  // ✅ Helper function: triggers login (called by Enter key or button)
  void _tryLogin() {
    if (_formKey.currentState!.validate()) {
      _handleLogin();
    }
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final rememberedEmail = prefs.getString('remembered_email') ?? '';
    final rememberedPassword = prefs.getString('remembered_password') ?? '';

    if (!mounted) return;
    setState(() {
      _rememberMe = rememberMe;
      if (rememberMe) {
        _emailController.text = rememberedEmail;
        _passwordController.text = rememberedPassword;
      }
    });
  }

  Future<void> _persistRememberMeState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', _rememberMe);

    if (_rememberMe) {
      await prefs.setString('remembered_email', _emailController.text.trim());
      await prefs.setString(
        'remembered_password',
        _passwordController.text.trim(),
      );
      return;
    }

    await prefs.remove('remembered_email');
    await prefs.remove('remembered_password');
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
              Color(0xFF7CA8F9),
              Color(0xFFB4C4FC),
              Color(0xFFFFFFFF),
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

    // ✅ Wrap Form with Shortcuts + Actions for physical Enter key support
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _tryLogin();
              return null;
            },
          ),
        },
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Login', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 40),
              Text('Email', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              
              // ✅ EMAIL FIELD - Enter goes to password
              _buildInputField(
                controller: _emailController, 
                hint: 'Enter your email', 
                bgColor: inputBgColor, 
                textColor: textColor,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Please enter a valid email';
                  return null;
                }),
              
              const SizedBox(height: 20),
              Text('Password', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              
              // ✅ PASSWORD FIELD - Enter triggers login!
              _buildInputField(
                controller: _passwordController, 
                hint: 'minimum 8 characters', 
                obscureText: _obscurePassword,
                bgColor: inputBgColor, 
                textColor: textColor,
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _tryLogin();
                },
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
                        onTap: () => setState(() {
                          _rememberMe = !_rememberMe;
                          _persistRememberMeState(); // ✅ Save state when toggled
                        }),
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
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _tryLogin, // ✅ Uses same login function
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
        ),
      ),
    );
  }

  // ✅ Updated to support Enter key navigation
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required Color bgColor,
    required Color textColor,
    TextInputAction? textInputAction,        // ✅ New parameter
    void Function(String)? onFieldSubmitted, // ✅ New parameter
    FocusNode? focusNode,                    // ✅ New parameter
  }) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        validator: validator,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _persistRememberMeState();

      final userRole = response.user?.userMetadata?['role'] ?? 'staff';

      if (!mounted) return;
      Navigator.pop(context);

      if (userRole == 'admin') {
        Navigator.pushReplacementNamed(context, AppRouter.adminStaffManagement);
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.staffProfile);
      }
      
    } on AuthException catch (error) {
      if (!mounted) return;
      Navigator.pop(context);
      
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