import 'package:flutter/material.dart';
// SIGURADUHIN NA TAMA ANG PATH NA ITO. Ito ang 'bridge' para makilala ang AppRouter
import 'package:flutter_application_1/app/app_router.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wsgwejwfkjgfyfmkeptm.supabase.co',
    anonKey: 
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndzZ3dlandma2pnZnlmbWtlcHRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzczMDEwODMsImV4cCI6MjA5Mjg3NzA4M30.63Pwp77rhQABoWx9qbRB3RkBLlg3ZIHa4gv9BK7NY78',
  );

try {
    final session = Supabase.instance.client.auth.currentSession;
    print("Supabase connected! Current session: $session");
  } catch (e) {
    print("Connection error: $e");
  }
  runApp(const Cam2PrintApp());
}
class Cam2PrintApp extends StatelessWidget {
  const Cam2PrintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cam2Print System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/', 
      // Dito mawawala ang red underline dahil sa import sa taas
      onGenerateRoute: AppRouter.onGenerateRoute, 
    );
  }
}