// code for log in
// // import 'package:flutter/material.dart';
// // import 'package:flutter_application_1/login/login_screen.dart';

// // void main() {
// //   runApp(MaterialApp(home: LoginScreen()));
// // } 

// "THE CODE FOR SIDEBAR AND TOP BAR DESIGN AND  PAGE LAYOUT FOR STAFF"
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/staff/consumption_tracker.dart';
// import 'package:flutter_application_1/staff/daily_inv.dart';
// import 'package:flutter_application_1/staff/organized_orders.dart';
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Inter',
//         useMaterial3: true,
//       ),
//       home: const MainLayout(),
//     );
//   }
// }

// class MainLayout extends StatefulWidget {
//   const MainLayout({super.key});

//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   int selectedIndex = 0;

//   final List<Widget> pages = const [
//     DailyInventoryPage(),
//     Center(child: Text("Services Page")),
//     Center(child: Text("Salary Page")),
//     ConsumptionTracker(),
//     CustomizedOrdersPage(),
//     Center(child: Text("Schedule Page")),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFA5C9FF), Color(0xFFE8F1FF)],
//           ),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 20),
//             _buildSidebar(),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 children: [
//                   _buildTopBar(),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: IndexedStack(
//                         index: selectedIndex,
//                         children: pages,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Sidebar Card
//   Widget _buildSidebar() {
//     return Container(
//       width: 250,
//       margin: const EdgeInsets.only(top: 20, bottom: 20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF6A7585),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 24),
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFF373E4E),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.local_printshop_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   "Camprint System",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             // Menu Items
//             _sidebarItem(Icons.inventory_2_outlined, "Daily Inventory", 0),
//             _sidebarItem(Icons.miscellaneous_services_outlined, "Services", 1),
//             _sidebarItem(Icons.account_balance_wallet_outlined, "Salary", 2),
//             _sidebarItem(Icons.track_changes_outlined, "Consumption Tracker", 3),
//             _sidebarItem(Icons.shopping_cart_outlined, "Customized Orders", 4),
//             _sidebarItem(Icons.calendar_today_outlined, "Schedule", 5),
            
//             const SizedBox(height: 30),
//             // Logout
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: _sidebarItem(Icons.logout_rounded, "Logout", 99, isLogout: true),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   // Sidebar Item Builder
//   Widget _sidebarItem(IconData icon, String title, int index, {bool isLogout = false}) {
//     final isSelected = selectedIndex == index;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: isSelected ? const Color(0xFFD1D5DB) : Colors.transparent,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ListTile(
//         onTap: () {
//           if (index != 99) {
//             setState(() {
//               selectedIndex = index;
//             });
//           }
//         },
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         leading: Icon(
//           icon,
//           color: isSelected ? const Color(0xFF1F2937) : Colors.white,
//           size: 20,
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: isSelected ? const Color(0xFF1F2937) : Colors.white,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }

//   // Top Bar matching the new design
//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
//       child: Container(
//         height: 64,
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         decoration: BoxDecoration(
//           color: const Color(0xFFE8ECF0),
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: const Color(0xFFD1D9E6), width: 1.0),
//         ),
//         child: Row(
//           children: [
//             // Date Text
//             const Text(
//               "Saturday/ January 31, 2026",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF334155),
//                 letterSpacing: 0.3,
//               ),
//             ),
            
//             const Spacer(),

//             // Notification Bell (Clickable Button)
//             InkWell(
//               onTap: () {
//                 // Action for notification bell goes here
//               },
//               borderRadius: BorderRadius.circular(18),
//               child: Container(
//                 width: 36,
//                 height: 36,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFDDE2E8),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.notifications_active_outlined,
//                   color: Color(0xFF111827),
//                   size: 20,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Profile Section (Clickable Button)
//             InkWell(
//               onTap: () {
//                 // Action for profile goes here
//               },
//               borderRadius: BorderRadius.circular(20),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: const BoxDecoration(
//                       color: Colors.black,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.person,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Text(
//                         "Jane",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF111827),
//                           height: 1.0,
//                         ),
//                       ),
//                       Text(
//                         "Admin",
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF6B7280),
//                           fontWeight: FontWeight.w500,
//                           height: 1.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// THE CODE FOR CUSTOMIZED_ORDERS_ADMIN 
// import 'package:flutter/material.dart';
// import 'customized_orders_admin/customized_orders_admin.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cam2print System',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const CustomizedOrdersPage(),
//     );
//   }
// }

// THE CODE FOR REPORTS_ADMIN
// import 'package:flutter/material.dart';
// import 'reports_admin/reports_admin.dart'; // Make sure this imports your new file

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cam2print System',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Inter',
//       ),
//       // Set the home to your new Reports page
//       home: const ReportsAdminPage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'staff_management/staff_management_admin.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cam2print System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      // This line sets the Staff Management page as the starting screen
      home: const StaffManagementPage(),
    );
  }
}