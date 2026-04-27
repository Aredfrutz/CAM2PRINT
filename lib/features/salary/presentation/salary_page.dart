import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';

typedef CategoryEntry = DropdownMenuEntry<CategoryLabel>;

enum CategoryLabel {
  schoolSupplies('School Supplies'),
  partyNeeds('Party Needs');

  const CategoryLabel(this.label);
  final String label;

  //logic goes here//
  static final List<CategoryEntry> entries =
      UnmodifiableListView<CategoryEntry>(
        values.map<CategoryEntry>(
          (CategoryLabel category) =>
              CategoryEntry(value: category, label: category.label),
        ),
      );
}

class SalaryPage extends StatelessWidget {
  const SalaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary',
          style: GoogleFonts.baiJamjuree(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: <Widget>[
                    Card(
                      color: Theme.of(context).colorScheme.secondary,
                      child: SizedBox(
                        height: 160,
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            SizedBox(width: 12),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        size: 64,
                                        Icons.account_circle,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "John Doe",
                                        style: TextStyle(
                                          fontSize: 32,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: DropdownMenu<CategoryLabel>(
                                          width: 480,
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide()),
                                                filled: true,
                                                fillColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.0)
                                              ),
                                          textAlign: TextAlign.left,
                                          textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                          initialSelection:
                                              CategoryLabel.schoolSupplies,
                                          dropdownMenuEntries:
                                              CategoryLabel.entries,
                                        ),
                                      ),
                                      SizedBox(width: 32),
                                      Text(
                                        "Software Engineer",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                      ),
                                      Text(
                                        "\$100,000",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Card(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Column(
                          children: [
                            ListTile(title: Text('Type')),
                            ListTile(title: Text('Date')),
                            ListTile(title: Text('Amount')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(child: _SalarySection(title: 'Cash Advance')),
              SizedBox(width: 12),
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
      color: Color(0xff7a94a8),
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
