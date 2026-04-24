import 'package:flutter/material.dart';

class OverallInventoryPage extends StatelessWidget {
  const OverallInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Inventory',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: 'Search Item / Category'),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: const [
              ListTile(
                title: Text('Black Panda'),
                subtitle: Text('2 packs, 50 pieces'),
              ),
              ListTile(
                title: Text('Marker'),
                subtitle: Text('1 pack, 20 pieces'),
              ),
              ListTile(
                title: Text('Yellow Balloon'),
                subtitle: Text('0 pack, 180 pieces'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
