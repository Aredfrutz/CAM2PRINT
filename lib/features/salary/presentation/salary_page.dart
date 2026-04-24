import 'package:flutter/material.dart';

class SalaryPage extends StatelessWidget {
  const SalaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Salary', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            children: const [
              Expanded(child: _SalarySection(title: 'Additional')),
              SizedBox(width: 12),
              Expanded(child: _SalarySection(title: 'Cash Advance')),
              SizedBox(width: 12),
              Expanded(child: _SalarySection(title: 'Deduction')),
            ],
          ),
        ),
      ],
    );
  }
}

class _SalarySection extends StatelessWidget {
  const _SalarySection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(title: Text(title)),
          const Divider(height: 1),
          const Expanded(
            child: Column(
              children: [
                ListTile(title: Text('Type')),
                ListTile(title: Text('Date')),
                ListTile(title: Text('Amount')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
