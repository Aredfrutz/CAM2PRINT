import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Schedule', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const TextField(decoration: InputDecoration(labelText: 'Staff Name')),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(labelText: 'Start Time')),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(labelText: 'End Time')),
        const SizedBox(height: 12),
        const Expanded(
          child: Card(
            child: Center(
              child: Text('Shift and leave request list placeholder'),
            ),
          ),
        ),
      ],
    );
  }
}
