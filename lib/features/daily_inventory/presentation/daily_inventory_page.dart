import 'package:flutter/material.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Inventory',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: TextField(decoration: InputDecoration(labelText: 'Shop')),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Filter'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(items[index]),
                trailing: const SizedBox(
                  width: 220,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Packs'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Pieces'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
