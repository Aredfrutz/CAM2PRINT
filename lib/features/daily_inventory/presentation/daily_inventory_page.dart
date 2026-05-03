import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DailyInventoryPage extends StatelessWidget {
  const DailyInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      'SBP Printing',
      'LBP Printing',
      'A4 Printing',
      'Sticker',
      'Calling Card',
    ];

    return  Expanded(
                child: Text(
                  'Daily Inventory',
                  style: GoogleFonts.baiJamjuree(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
  }
}
