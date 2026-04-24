import 'package:flutter/material.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reminder', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: 'Search reminder'),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: const [
              ListTile(title: Text('Payment Reminder')),
              ListTile(title: Text('Production Due Today')),
              ListTile(title: Text('Order Pick-up Reminder')),
            ],
          ),
        ),
      ],
    );
  }
}
