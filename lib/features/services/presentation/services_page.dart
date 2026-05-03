import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const tabs = [
      'Packages',
      'Souvenir',
      'Invitation',
      'Candle',
      'Ref Magnet',
      'T-Shirt',
      'Mug',
      'More',
    ];

    return  Expanded(
                child: Text(
                  'Schedule',
                  style: GoogleFonts.baiJamjuree(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              
    );
  }
}
