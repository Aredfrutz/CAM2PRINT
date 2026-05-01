import 'package:flutter/material.dart';

enum AppModule {
  daily('Daily', Icons.inventory_2_outlined),
  overall('Overall', Icons.warehouse_outlined),
  reports('Reports', Icons.assessment_outlined),
  reminder('Reminder', Icons.notifications_none_outlined),
  salary('Salary', Icons.attach_money_outlined),
  orders('Orders', Icons.assignment_outlined),
  scheduling('Scheduling', Icons.calendar_month_outlined);

  const AppModule(this.label, this.icon);

  final String label;
  final IconData icon;
}
