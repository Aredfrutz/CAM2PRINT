import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

final DateTime date = DateTime.now();

//configurations for the category dropdown list//

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

class OverallInventoryPage extends StatelessWidget {
  const OverallInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            children: <Widget>[
              //Title
              SizedBox(width: 12),
              Expanded(
                child: Align(
                  child: Row(
                    children: [
                      Text(
                        'Overall Inventory /',
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      DropdownMenu<CategoryLabel>(
                        width: 336,
                        enableSearch: false,
                        selectOnly: true,
                        trailingIcon:  Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary, size: 32),
                        inputDecorationTheme: InputDecorationTheme(
                          
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: false,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 1.0),
                        ),
                        textAlign: TextAlign.left,
                        textStyle: GoogleFonts.baiJamjuree(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        initialSelection: CategoryLabel.schoolSupplies,
                        dropdownMenuEntries: CategoryLabel.entries,
                      ),
                    ],
                  ),
                ),
              ),
              //Categories
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Category: ",
                  style: GoogleFonts.baiJamjuree(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: DropdownMenu<CategoryLabel>(
                  width: 256,
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 1.0),
                  ),
                  selectOnly: true,
                  textAlign: TextAlign.left,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  initialSelection: CategoryLabel.schoolSupplies,
                  dropdownMenuEntries: CategoryLabel.entries,
                ),
              ),

              SizedBox(width: 12),
              SizedBox(
                width: 48,
                height: 48,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0.0,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    tooltip: 'Add Item',
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('This is a snackassbar')),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Expanded(
            child: Row(
              children: const [
                Expanded(child: _SchoolSupplies(title: 'School Supplies')),
                SizedBox(width: 12),
                /* Expanded(child: _PartyNeeds(title: 'Party Needs')), */
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SchoolSupplies extends StatelessWidget {
  const _SchoolSupplies({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.baiJamjuree(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    DateFormat('MMMM d, y').format(DateTime.now()),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.baiJamjuree(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: FixedColumnWidth(160),
                2: FixedColumnWidth(160),
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Color(0xff2A2A2A),
                  width: 0.5,
                ),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Item",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Price",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Quantity",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                TableRow(
                  children: <Widget>[
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Item",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Price",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Quantity",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                TableRow(
                  children: <Widget>[
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Item",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Price",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Quantity",
                          style: GoogleFonts.baiJamjuree(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
class _PartyNeeds extends StatelessWidget {
  const _PartyNeeds({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return  Visibility(
      visible: true,
      child: Expanded(child: Card(
      color: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(200),
              1: FlexColumnWidth(),
              2: FixedColumnWidth(128),
            },

            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                decoration: BoxDecoration(
                  color: Color(0xff4a5f7f),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0),
                  ),
                ),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: GoogleFonts.baiJamjuree(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('MMMM d, y').format(DateTime.now()),
                      style: GoogleFonts.baiJamjuree(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: FixedColumnWidth(160),
                2: FixedColumnWidth(128),
              },

              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Text(
                        "Black Pencil",
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "12.00",
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "121",
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            indent: 32,
            endIndent: 32,
            color: Theme.of(context).colorScheme.primary,
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: FixedColumnWidth(160),
                2: FixedColumnWidth(128),
              },

              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Text(
                        "Item",
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Price",
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Quantity",
                        style: GoogleFonts.baiJamjuree(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            indent: 32,
            endIndent: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      ),
      ),
    );
  }
}
*/
