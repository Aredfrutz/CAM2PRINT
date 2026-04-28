import 'package:flutter/material.dart';

enum AppModule {
  overallInventory('Overall Inventory', Icons.warehouse_outlined),
  dailyInventory('Daily Inventory', Icons.inventory_2_outlined), // Added for Staff
  services('Services', Icons.volunteer_activism_outlined), 
  salary('Salary', Icons.payments_outlined),
  orders('Orders', Icons.shopping_cart_outlined),
  consumptionTracker('Consumption Tracker', Icons.insert_chart_outlined), // Added for Staff
  customizedOrders('Customized Orders', Icons.assignment_outlined),
  schedule('Schedule', Icons.calendar_month_outlined),
  reports('Reports', Icons.description_outlined); 

  const AppModule(this.label, this.icon);

  final String label;
  final IconData icon;
}