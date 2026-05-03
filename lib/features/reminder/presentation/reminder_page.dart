import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
                child: Text(
                  'Reminders',
                  style: GoogleFonts.baiJamjuree(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              
    );
  }
}
