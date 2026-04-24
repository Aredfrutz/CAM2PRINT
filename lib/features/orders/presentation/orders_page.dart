import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('Orders', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text('Package Orders')),
            Chip(label: Text('Tarpaulin Orders')),
            Chip(label: Text('Invitation Orders')),
            Chip(label: Text('Souvenir Orders')),
          ],
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: 'Customer Name'),
        ),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(labelText: 'Event Date')),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(labelText: 'Theme/Design')),
        const SizedBox(height: 8),
        const TextField(
          maxLines: 3,
          decoration: InputDecoration(labelText: 'Additional Details'),
        ),
      ],
    );
  }
}
