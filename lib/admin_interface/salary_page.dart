import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'dart:math';


/* Status ng Salary:
  Kulang nalang ng actual data from the database to fill the dropdown menu and variable values.
  Also di pa pala nasasave yung values since no database rin, so wala pa yung code para don
  Okay na yung calculations pero kung may issues man, pamessage nalang ako sa gc.
  Kung may issues man sa Theme.of(context).colorScheme, siguro pag wala pang standardized na Color Scheme so palitan nalang
  Same goes sa TextScheme
*/

/* Note
If you're goind to add another variable that will be factored into the salaries of the staff, initiate the following:
*Name* InitialValue - Yung initial value ng variable, default is 0
*Name* Value - Yung value ng variable na ifafactor sa formula ng salary, default is InitialValue
*Name*TextField - dito ii-input yung desired value ng variable
*Name*Controller - para makita immediately yung changes sa value ng salary pag binabago yung text field. lagay niyo dito yung logic na need like if gaano lang limit ng input, etc.
*Name*Formatter - para may specific format kung decimal or what not yung variable
*Name* State - yung logic ng update kapag may napansing change si controller

kung may percentage man do the same but default value dapat is 100 para x1 value ng affected ng percentage

Have fun lmao
*/

//Inital Variable Values - Alter the value if meron na sa database
num TSPrintInitialValue = 0;
num TSXeroxInitialValue = 0;
num TSSuppliesInitialValue = 0;
num TSPartyInitialValue = 0;
num CAmountInitialValue = 0;
num DViolationsInitialValue = 0;
num DPhilHealthInitialValue = 0;
num DSSSInitialValue = 0;
num LDeductionInitialValue = 0;
num CAdvanceInitialValue = 0;

num TSPrintPercentageInitialValue = 100;
num TSXeroxPercentageInitialValue = 100;
num TSSuppliesPercentageInitialValue = 100;
num TSPartyPercentageInitialValue = 100;

//Variable Values
num TSPrintValue = TSPrintInitialValue;
num TSXeroxValue = TSXeroxInitialValue;
num TSSuppliesValue = TSSuppliesInitialValue;
num TSPartyValue = TSPartyInitialValue;
num CAmountValue = CAmountInitialValue;
num DViolationsValue = DViolationsInitialValue;
num DPhilHealthValue = DPhilHealthInitialValue;
num DSSSValue = DSSSInitialValue;
num LDeductionValue = LDeductionInitialValue;
num CAdvanceValue = CAdvanceInitialValue;

num TSPrintPercentageValue = TSPrintPercentageInitialValue;
num TSXeroxPercentageValue = TSXeroxPercentageInitialValue;
num TSSuppliesPercentageValue = TSSuppliesPercentageInitialValue;
num TSPartyPercentageValue = TSPartyPercentageInitialValue;

num SalaryComputed = 0;
num BasicPay = 0;
num TotalDeductions = 0;
String NRemindersValue = NRemindersController.text;
// End of Values

//DropDownValues
SelectedStaff? selectedStaff;
IsFullTimeStaff? staffBoolean;

//Controllers para sa mga TextField
final TSPrintController = TextEditingController(
  text: TSPrintInitialValue.toStringAsFixed(2),
);
final TSXeroxController = TextEditingController(
  text: TSXeroxInitialValue.toStringAsFixed(2),
);
final TSSuppliesController = TextEditingController(
  text: TSSuppliesInitialValue.toStringAsFixed(2),
);
final TSPartyController = TextEditingController(
  text: TSPartyInitialValue.toStringAsFixed(2),
);
final CAmountController = TextEditingController(
  text: CAmountInitialValue.toStringAsFixed(2),
);
final DViolationsController = TextEditingController(
  text: DViolationsInitialValue.toStringAsFixed(2),
);
final DPhilHealthController = TextEditingController(
  text: DPhilHealthInitialValue.toStringAsFixed(2),
);
final DSSSController = TextEditingController(
  text: DSSSInitialValue.toStringAsFixed(2),
);
final LDeductionController = TextEditingController(
  text: LDeductionInitialValue.toStringAsFixed(2),
);
final CAdvanceController = TextEditingController(
  text: CAdvanceInitialValue.toStringAsFixed(2),
);
final NRemindersController = TextEditingController(text: "");

final TSPrintPercentageController = TextEditingController(
  text: TSPrintPercentageInitialValue.toStringAsFixed(0),
);
final TSXeroxPercentageController = TextEditingController(
  text: TSXeroxPercentageInitialValue.toStringAsFixed(0),
);
final TSSuppliesPercentageController = TextEditingController(
  text: TSSuppliesPercentageInitialValue.toStringAsFixed(0),
);
final TSPartyPercentageController = TextEditingController(
  text: TSPartyPercentageInitialValue.toStringAsFixed(0),
);

// For the Dropdown Menus
final staffBooleanController = TextEditingController();
// End of Variable Controllers

//For Textboxes to Input Salary Data
CurrencyTextInputFormatter CurrencyFormatter = CurrencyTextInputFormatter(
  NumberFormat.decimalPatternDigits(decimalDigits: 2),
);

CurrencyTextInputFormatter PercentageFormatter = CurrencyTextInputFormatter(
  NumberFormat.decimalPatternDigits(decimalDigits: 0),
);

//DropdownMenu for Selecting Staff
typedef StaffEntry = DropdownMenuEntry<SelectedStaff>;

//DropdownCategories
enum SelectedStaff {
  name1('ABCD'),
  name2('EFGH');

  const SelectedStaff(this.label);
  final String label;

  //logic goes here//
  static final List<StaffEntry> entries = UnmodifiableListView<StaffEntry>(
    values.map<StaffEntry>(
      (SelectedStaff name) => StaffEntry(value: name, label: name.label),
    ),
  );
}

typedef StaffBool = DropdownMenuEntry<IsFullTimeStaff>;

//DropdownCategories
enum IsFullTimeStaff {
  yes('Full-time Staff'),
  no('Part-time Staff');

  const IsFullTimeStaff(this.label);
  final String label;

  //logic goes here//
  static final List<StaffBool> entries = UnmodifiableListView<StaffBool>(
    values.map<StaffBool>(
      (IsFullTimeStaff boolean) =>
          StaffBool(value: boolean, label: boolean.label),
    ),
  );
}

late TabController tabController;

//Actual Body
class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});
  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage>
    with SingleTickerProviderStateMixin {
  
  // ✅ ADMIN NAVIGATION
  void _navigateTo(String pageName) {
    String? routeName;
    switch (pageName) {
      case 'Staff Management':
        routeName = AppRouter.adminStaffManagement;
        break;
      case 'Overall Inventory':
        routeName = AppRouter.adminServices;
        break;
      case 'Services':
        routeName = AppRouter.adminServices;
        break;
      case 'Salary':
        routeName = AppRouter.adminServices;
        break;
      case 'Customized Orders':
        routeName = AppRouter.adminCustomOrders;
        break;
      case 'Schedule':
        routeName = AppRouter.adminSchedule;
        break;
      case 'Reports':
        routeName = AppRouter.adminreports;
        break;
      case 'Notifications':
        routeName = AppRouter.notifications;
        break;
    }
    if (routeName != null) {
      Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: routeName == AppRouter.notifications ? true : null,
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$pageName not connected yet.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ✅ ADMIN SIDEBAR ITEM (White active state, Dark text)
  Widget _buildSidebarItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? const Color(0xFF1A237E) : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? const Color(0xFF1A237E) : Colors.white,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Formula para macompute Salary
  void formula() {
    if (staffBoolean == IsFullTimeStaff.yes) {
      BasicPay =
          (TSPrintValue * TSPrintPercentageValue / 100) +
          (TSXeroxValue * TSXeroxPercentageValue / 100) +
          (TSSuppliesValue * TSSuppliesPercentageValue / 100) +
          (TSPartyValue * TSPartyPercentageValue / 100);

      TotalDeductions =
          (DViolationsValue + DPhilHealthValue + DSSSValue + LDeductionValue);

      SalaryComputed =
          (BasicPay + CAmountValue - TotalDeductions - CAdvanceValue);
    } else {
      BasicPay =
          (TSPrintValue * TSPrintPercentageValue / 100) +
          (TSXeroxValue * TSXeroxPercentageValue / 100) +
          (TSSuppliesValue * TSSuppliesPercentageValue / 100) +
          (TSPartyValue * TSPartyPercentageValue / 100);

      TotalDeductions = (DViolationsValue + LDeductionValue);

      SalaryComputed =
          (BasicPay + CAmountValue - TotalDeductions - CAdvanceValue);
    }
  }
  // End of Formula

  //Function to Reset the TextFields
  void resetTextFields() {
    setState(() {
      TSPrintValue = TSPrintInitialValue;
      TSXeroxValue = TSXeroxInitialValue;
      TSSuppliesValue = TSSuppliesInitialValue;
      TSPartyValue = TSPartyInitialValue;
      CAmountValue = CAmountInitialValue;
      DViolationsValue = DViolationsInitialValue;
      DPhilHealthValue = DPhilHealthInitialValue;
      DSSSValue = DSSSInitialValue;
      LDeductionValue = LDeductionInitialValue;
      CAdvanceValue = CAdvanceInitialValue;

      TSPrintPercentageValue = TSPrintPercentageInitialValue;
      TSXeroxPercentageValue = TSXeroxPercentageInitialValue;
      TSSuppliesPercentageValue = TSSuppliesPercentageInitialValue;
      TSPartyPercentageValue = TSPartyPercentageInitialValue;

      TSPrintController.text = TSPrintInitialValue.toStringAsFixed(2);
      TSXeroxController.text = TSXeroxInitialValue.toStringAsFixed(2);
      TSSuppliesController.text = TSSuppliesInitialValue.toStringAsFixed(2);
      TSPartyController.text = TSPartyInitialValue.toStringAsFixed(2);
      CAmountController.text = CAmountInitialValue.toStringAsFixed(2);
      DViolationsController.text = DViolationsInitialValue.toStringAsFixed(2);
      DPhilHealthController.text = DPhilHealthInitialValue.toStringAsFixed(2);
      DSSSController.text = DSSSInitialValue.toStringAsFixed(2);
      LDeductionController.text = LDeductionInitialValue.toStringAsFixed(2);
      CAdvanceController.text = CAdvanceInitialValue.toStringAsFixed(2);

      TSPrintPercentageController.text =
          TSPrintPercentageInitialValue.toStringAsFixed(0);
      TSXeroxPercentageController.text =
          TSXeroxPercentageInitialValue.toStringAsFixed(0);
      TSSuppliesPercentageController.text =
          TSSuppliesPercentageInitialValue.toStringAsFixed(0);
      TSPartyPercentageController.text =
          TSPartyPercentageInitialValue.toStringAsFixed(0);

      formula();
    });
  }
  // End of Function

  //Variable States
  void TSPrintState() {
    setState(() {
      final String TSPrintText = TSPrintController.text;
      TSPrintController.value = TSPrintController.value.copyWith(
        selection: TextSelection(
          baseOffset: TSPrintText.length,
          extentOffset: TSPrintText.length,
        ),
      );
      TSPrintValue = CurrencyFormatter.getUnformattedValue();
      if (TSPrintController.text == "") {
        TSPrintController.text = "0.00";
      } else if (TSPrintController.text ==
          TSPrintInitialValue.toStringAsFixed(2)) {
        TSPrintValue = TSPrintInitialValue;
      }
      formula();
    });
  }

  void TSXeroxState() {
    setState(() {
      final String TSXeroxText = TSXeroxController.text;
      TSXeroxController.value = TSXeroxController.value.copyWith(
        selection: TextSelection(
          baseOffset: TSXeroxText.length,
          extentOffset: TSXeroxText.length,
        ),
      );
      TSXeroxValue = CurrencyFormatter.getUnformattedValue();
      if (TSXeroxController.text == "") {
        TSXeroxController.text = "0.00";
      } else if (TSXeroxController.text ==
          TSXeroxInitialValue.toStringAsFixed(2)) {
        TSXeroxValue = TSXeroxInitialValue;
      }
      formula();
    });
  }

  void TSSuppliesState() {
    setState(() {
      final String TSSuppliesText = TSSuppliesController.text;
      TSSuppliesController.value = TSSuppliesController.value.copyWith(
        selection: TextSelection(
          baseOffset: TSSuppliesText.length,
          extentOffset: TSSuppliesText.length,
        ),
      );
      TSSuppliesValue = CurrencyFormatter.getUnformattedValue();
      if (TSSuppliesController.text == "") {
        TSSuppliesController.text = "0.00";
      } else if (TSSuppliesController.text ==
          TSSuppliesInitialValue.toStringAsFixed(2)) {
        TSSuppliesValue = TSSuppliesInitialValue;
      }
      formula();
    });
  }

  void TSPartyState() {
    setState(() {
      final String TSPartyText = TSPartyController.text;
      TSPartyController.value = TSPartyController.value.copyWith(
        selection: TextSelection(
          baseOffset: TSPartyText.length,
          extentOffset: TSPartyText.length,
        ),
      );
      TSPartyValue = CurrencyFormatter.getUnformattedValue();
      if (TSPartyController.text == "") {
        TSPartyController.text = "0.00";
      } else if (TSPartyController.text ==
          TSSuppliesInitialValue.toStringAsFixed(2)) {
        TSPartyValue = TSPartyInitialValue;
      }
      formula();
    });
  }

  void CAmountState() {
    setState(() {
      final String CAmountText = CAmountController.text;
      CAmountController.value = CAmountController.value.copyWith(
        selection: TextSelection(
          baseOffset: CAmountText.length,
          extentOffset: CAmountText.length,
        ),
      );
      CAmountValue = CurrencyFormatter.getUnformattedValue();
      if (CAmountController.text == "") {
        CAmountController.text = "0.00";
      } else if (CAmountController.text ==
          CAmountInitialValue.toStringAsFixed(2)) {
        CAmountValue = CAmountInitialValue;
      }
      formula();
    });
  }

  void DViolationsState() {
    setState(() {
      final String DViolationsText = DViolationsController.text;
      DViolationsController.value = DViolationsController.value.copyWith(
        selection: TextSelection(
          baseOffset: DViolationsText.length,
          extentOffset: DViolationsText.length,
        ),
      );
      DViolationsValue = CurrencyFormatter.getUnformattedValue();
      if (DViolationsController.text == "") {
        DViolationsController.text = "0.00";
      } else if (DViolationsController.text ==
          DViolationsInitialValue.toStringAsFixed(2)) {
        DViolationsValue = DViolationsInitialValue;
      }
      formula();
    });
  }

  void DPhilHealthState() {
    setState(() {
      final String DPhilHealthText = DPhilHealthController.text;
      DPhilHealthController.value = DPhilHealthController.value.copyWith(
        selection: TextSelection(
          baseOffset: DPhilHealthText.length,
          extentOffset: DPhilHealthText.length,
        ),
      );
      DPhilHealthValue = CurrencyFormatter.getUnformattedValue();
      if (DPhilHealthController.text == "") {
        DPhilHealthController.text = "0.00";
      } else if (DPhilHealthController.text ==
          DPhilHealthInitialValue.toStringAsFixed(2)) {
        DPhilHealthValue = DPhilHealthInitialValue;
      }
      formula();
    });
  }

  void DSSSState() {
    setState(() {
      final String DSSSText = DSSSController.text;
      DSSSController.value = DSSSController.value.copyWith(
        selection: TextSelection(
          baseOffset: DSSSText.length,
          extentOffset: DSSSText.length,
        ),
      );
      DSSSValue = CurrencyFormatter.getUnformattedValue();
      if (DSSSController.text == "") {
        DSSSController.text = "0.00";
      } else if (DSSSController.text == DSSSInitialValue.toStringAsFixed(2)) {
        DSSSValue = DSSSInitialValue;
      }
      formula();
    });
  }

  void LDeductionState() {
    setState(() {
      final String LDeductionText = LDeductionController.text;
      LDeductionController.value = LDeductionController.value.copyWith(
        selection: TextSelection(
          baseOffset: LDeductionText.length,
          extentOffset: LDeductionText.length,
        ),
      );
      LDeductionValue = CurrencyFormatter.getUnformattedValue();
      if (LDeductionController.text == "") {
        LDeductionController.text = "0.00";
      } else if (LDeductionController.text ==
          LDeductionInitialValue.toStringAsFixed(2)) {
        LDeductionValue = LDeductionInitialValue;
      }
      formula();
    });
  }

  void CAdvanceState() {
    setState(() {
      final String CAdvanceText = CAdvanceController.text;
      CAdvanceController.value = CAdvanceController.value.copyWith(
        selection: TextSelection(
          baseOffset: CAdvanceText.length,
          extentOffset: CAdvanceText.length,
        ),
      );
      CAdvanceValue = CurrencyFormatter.getUnformattedValue();
      if (CAdvanceController.text == "") {
        CAdvanceController.text = "0.00";
      } else if (CAdvanceController.text ==
          CAdvanceInitialValue.toStringAsFixed(2)) {
        CAdvanceValue = CAdvanceInitialValue;
      }
      formula();
    });
  }

  void TSPrintPercentageState() {
    setState(() {
      setState(() {
        final String TSPrintPercentageText = TSPrintPercentageController.text;
        TSPrintPercentageController.value = TSPrintPercentageController.value
            .copyWith(
              selection: TextSelection(
                baseOffset: TSPrintPercentageText.length,
                extentOffset: TSPrintPercentageText.length,
              ),
            );
        TSPrintPercentageValue = PercentageFormatter.getUnformattedValue();
        if (TSPrintPercentageController.text == "") {
          TSPrintPercentageController.text = "0";
        } else if (TSPrintPercentageController.text ==
            TSPrintPercentageInitialValue.toStringAsFixed(0)) {
          TSPrintPercentageValue = TSPrintPercentageInitialValue;
        } else if (TSPrintPercentageController.text.length > 3) {
          TSPrintPercentageController.text = "999";
          TSPrintPercentageValue = 999;
        }
        formula();
      });
    });
  }

  void TSXeroxPercentageState() {
    setState(() {
      setState(() {
        final String TSXeroxPercentageText = TSXeroxPercentageController.text;
        TSXeroxPercentageController.value = TSXeroxPercentageController.value
            .copyWith(
              selection: TextSelection(
                baseOffset: TSXeroxPercentageText.length,
                extentOffset: TSXeroxPercentageText.length,
              ),
            );
        TSXeroxPercentageValue = PercentageFormatter.getUnformattedValue();
        if (TSXeroxPercentageController.text == "") {
          TSXeroxPercentageController.text = "0";
        } else if (TSXeroxPercentageController.text ==
            TSXeroxPercentageInitialValue.toStringAsFixed(0)) {
          TSXeroxPercentageValue = TSXeroxPercentageInitialValue;
        } else if (TSXeroxPercentageController.text.length > 3) {
          TSXeroxPercentageController.text = "999";
          TSXeroxPercentageValue = 999;
        }
        formula();
      });
    });
  }

  void TSSuppliesPercentageState() {
    setState(() {
      setState(() {
        final String TSSuppliesPercentageText =
            TSSuppliesPercentageController.text;
        TSSuppliesPercentageController.value = TSSuppliesPercentageController
            .value
            .copyWith(
              selection: TextSelection(
                baseOffset: TSSuppliesPercentageText.length,
                extentOffset: TSSuppliesPercentageText.length,
              ),
            );
        TSSuppliesPercentageValue = PercentageFormatter.getUnformattedValue();
        if (TSSuppliesPercentageController.text == "") {
          TSSuppliesPercentageController.text = "0";
        } else if (TSSuppliesPercentageController.text ==
            TSSuppliesPercentageInitialValue.toStringAsFixed(0)) {
          TSSuppliesPercentageValue = TSSuppliesPercentageInitialValue;
        } else if (TSSuppliesPercentageController.text.length > 3) {
          TSSuppliesPercentageController.text = "999";
          TSSuppliesPercentageValue = 999;
        }
        formula();
      });
    });
  }

  void TSPartyPercentageState() {
    setState(() {
      setState(() {
        final String TSPartyPercentageText = TSPartyPercentageController.text;
        TSPartyPercentageController.value = TSPartyPercentageController.value
            .copyWith(
              selection: TextSelection(
                baseOffset: TSPartyPercentageText.length,
                extentOffset: TSPartyPercentageText.length,
              ),
            );
        TSPartyPercentageValue = PercentageFormatter.getUnformattedValue();
        if (TSPartyPercentageController.text == "") {
          TSPartyPercentageController.text = "0";
        } else if (TSPartyPercentageController.text ==
            TSPartyPercentageInitialValue.toStringAsFixed(0)) {
          TSPartyPercentageValue = TSPartyPercentageInitialValue;
        } else if (TSPartyPercentageController.text.length > 3) {
          TSPartyPercentageController.text = "999";
          TSPartyPercentageValue = 999;
        }
        formula();
      });
    });
  }
  //End of Variable States

  //Initialization
  @override
  void initState() {
    selectedStaff = SelectedStaff.name1;
    staffBoolean = IsFullTimeStaff.no;
    resetTextFields();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    // Pag nag-update yung textfield, iuupdate rin yung value
    //Para Nag-uupdate values every TextField Change

    //Total Sales for Print
    TSPrintController.addListener(() {
      TSPrintState();
    });

    //Total Sales for Photocopy/Xerox
    TSXeroxController.addListener(() {
      TSXeroxState();
    });

    //Total Sales for Supplies
    TSSuppliesController.addListener(() {
      TSSuppliesState();
    });

    //Total Sales for Party Needs
    TSPartyController.addListener(() {
      TSPartyState();
    });

    //Commission Amount
    CAmountController.addListener(() {
      CAmountState();
    });

    //Deductions sa Violations
    DViolationsController.addListener(() {
      DViolationsState();
    });

    DPhilHealthController.addListener(() {
      DPhilHealthState();
    });

    DSSSController.addListener(() {
      DSSSState();
    });

    //Late Deductions
    LDeductionController.addListener(() {
      LDeductionState();
    });

    //Cash Advance
    CAdvanceController.addListener(() {
      CAdvanceState();
    });

    NRemindersController.addListener(() {
      setState(() {
        NRemindersValue = NRemindersController.text;
      });
    });

    TSPrintPercentageController.addListener(() {
      TSPrintPercentageState();
    });

    TSXeroxPercentageController.addListener(() {
      TSXeroxPercentageState();
    });

    TSSuppliesPercentageController.addListener(() {
      TSSuppliesPercentageState();
    });

    TSPartyPercentageController.addListener(() {
      TSPartyPercentageState();
    });
    super.initState();
  }
  //End of Initialization

  //TextFields
  Widget _TSPrintTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: TSPrintController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                topRight: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            contentPadding: EdgeInsets.all(12),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],
          onTap: TSPrintState,
          onTapAlwaysCalled: true,

          textAlign: TextAlign.right,
        ),
        //Text(TSPrintValue.toString()),
      ],
    );
  }

  Widget _TSXeroxTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: TSXeroxController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                topRight: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(TSXeroxValue.toString()),
      ],
    );
  }

  Widget _TSSuppliesTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: TSSuppliesController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                topRight: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(TSSuppliesValue.toString()),
      ],
    );
  }

  @override
  Widget _TSPartyTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: TSPartyController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                topRight: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(TSPartyValue.toString()),
      ],
    );
  }

  @override
  Widget _CAmountTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: CAmountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(CAmountValue.toString()),
      ],
    );
  }

  @override
  Widget _DViolationsTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: DViolationsController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(DViolationsValue.toString()),
      ],
    );
  }

  @override
  Widget _DPhilHealthTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: DPhilHealthController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          enabled: true,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(DPhilHealthValue.toString()),
      ],
    );
  }

  Widget _DPhilHealthTextFieldDisabled(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: DPhilHealthController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixText: "-disabled",
            suffixStyle: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          enabled: false,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(DPhilHealthValue.toString()),
      ],
    );
  }

  @override
  Widget _DSSSTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: DSSSController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(DViolationsValue.toString()),
      ],
    );
  }

  @override
  Widget _DSSSTextFieldDisabled(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: DSSSController,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixText: "-disabled",
            suffixStyle: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.right,
        ),
        //Text(DViolationsValue.toString()),
      ],
    );
  }

  @override
  Widget _LDeductionsTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: LDeductionController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(LDeductionValue.toString()),
      ],
    );
  }

  @override
  Widget _CAdvanceTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: CAdvanceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
            prefixText: "₱",
            prefixStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),

          inputFormatters: <TextInputFormatter>[CurrencyFormatter],

          textAlign: TextAlign.right,
        ),
        //Text(CAdvanceValue.toString()),
      ],
    );
  }

  @override
  Widget _NRemindersTextField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: NRemindersController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(12),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onPrimary,
            isDense: true,
          ),
          maxLines: 4,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        //Text(NRemindersValue),
      ],
    );
  }

  @override
  Widget _TSPrintPercentageField(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          child: TextFormField(
            controller: TSPrintPercentageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              contentPadding: EdgeInsets.all(12),
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).colorScheme.onPrimary,
              isDense: true,
              suffixText: "%",
              suffixStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            inputFormatters: <TextInputFormatter>[PercentageFormatter],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLength: 3,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),

            textAlign: TextAlign.right,
          ),
        ),
        //Text(TSPrintPercentageValue.toString()),
      ],
    );
  }

  Widget _TSXeroxPercentageField(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          child: TextFormField(
            controller: TSXeroxPercentageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              contentPadding: EdgeInsets.all(12),
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).colorScheme.onPrimary,
              isDense: true,
              suffixText: "%",
              suffixStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            inputFormatters: <TextInputFormatter>[PercentageFormatter],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLength: 3,

            style: TextStyle(color: Theme.of(context).colorScheme.primary),

            textAlign: TextAlign.right,
          ),
        ),
        //Text(TSXeroxPercentageValue.toString()),
      ],
    );
  }

  Widget _TSSuppliesPercentageField(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          child: TextFormField(
            controller: TSSuppliesPercentageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              contentPadding: EdgeInsets.all(12),
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).colorScheme.onPrimary,
              isDense: true,
              suffixText: "%",
              suffixStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            inputFormatters: <TextInputFormatter>[PercentageFormatter],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLength: 3,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),

            textAlign: TextAlign.right,
          ),
        ),
        //Text(TSSuppliesPercentageValue.toString()),
      ],
    );
  }

  Widget _TSPartyPercentageField(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          child: TextFormField(
            controller: TSPartyPercentageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              contentPadding: EdgeInsets.all(12),
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).colorScheme.onPrimary,
              isDense: true,
              suffixText: "%",
              suffixStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            inputFormatters: <TextInputFormatter>[PercentageFormatter],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLength: 3,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),

            textAlign: TextAlign.right,
          ),
        ),
        //Text(TSPartyPercentageValue.toString()),
      ],
    );
  }
  //End of TextFields

  //Calculation Section
  Widget _CalculationSection(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          if (constraints.maxWidth > 900) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Earnings',
                      style: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).colorScheme.onPrimary, // Added color
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Total Sales for Printing',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: _TSPrintTextField(context),
                                        ),

                                        _TSPrintPercentageField(context),
                                      ],
                                    ),

                                    SizedBox(height: 16),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Total Sales for Photocopy/Xerox',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: _TSXeroxTextField(context),
                                        ),

                                        _TSXeroxPercentageField(context),
                                      ],
                                    ),

                                    SizedBox(height: 16),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Total Sales for School Supplies',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: _TSSuppliesTextField(context),
                                        ),

                                        _TSSuppliesPercentageField(context),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Total Sales for Party Needs',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: _TSPartyTextField(context),
                                        ),
                                        _TSPartyPercentageField(context),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Commission Amount',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    _CAmountTextField(context),
                                    SizedBox(height: 16),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Deductions from Violations',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    _DViolationsTextField(context),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Deductions from PhilHealth',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    if (staffBoolean == IsFullTimeStaff.yes)
                                      _DPhilHealthTextField(context),
                                    if (staffBoolean == IsFullTimeStaff.no)
                                      _DPhilHealthTextFieldDisabled(context),
                                    SizedBox(height: 16),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Deductions from SSS',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    if (staffBoolean == IsFullTimeStaff.yes)
                                      _DSSSTextField(context),
                                    if (staffBoolean == IsFullTimeStaff.no)
                                      _DSSSTextFieldDisabled(context),
                                    SizedBox(height: 16),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Late Deduction',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    _LDeductionsTextField(context),
                                    SizedBox(height: 2),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        '- ₱1.00 Per Minute',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Cash Advance',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    _CAdvanceTextField(context),
                                    SizedBox(height: 2),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Direct Deduction from Total',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Notes and Reminders',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    _NRemindersTextField(context),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Earnings',
                        style: TextStyle(
                          fontSize: 36,
                          color: Theme.of(context).colorScheme.onPrimary, // Added color
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    SizedBox(height: 16),
                    ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Wrap(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Total Sales for Printing',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: _TSPrintTextField(
                                                  context,
                                                ),
                                              ),

                                              _TSPrintPercentageField(context),
                                            ],
                                          ),

                                          SizedBox(height: 16),
                                        ],
                                      ),

                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Total Sales for Photocopy/Xerox',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: _TSXeroxTextField(
                                                  context,
                                                ),
                                              ),

                                              _TSXeroxPercentageField(context),
                                            ],
                                          ),

                                          SizedBox(height: 16),
                                        ],
                                      ),

                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Total Sales for School Supplies',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: _TSSuppliesTextField(
                                                  context,
                                                ),
                                              ),

                                              _TSSuppliesPercentageField(
                                                context,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Total Sales for Party Needs',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: _TSPartyTextField(
                                                  context,
                                                ),
                                              ),
                                              _TSPartyPercentageField(context),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                        ],
                                      ),

                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Commission Amount',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          _CAmountTextField(context),
                                          SizedBox(height: 16),
                                        ],
                                      ),

                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Deductions from Violations',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          _DViolationsTextField(context),
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Deductions from PhilHealth',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          if (staffBoolean ==
                                              IsFullTimeStaff.yes)
                                            _DPhilHealthTextField(context),
                                          if (staffBoolean ==
                                              IsFullTimeStaff.no)
                                            _DPhilHealthTextFieldDisabled(
                                              context,
                                            ),
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Deductions from SSS',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          if (staffBoolean ==
                                              IsFullTimeStaff.yes)
                                            _DSSSTextField(context),
                                          if (staffBoolean ==
                                              IsFullTimeStaff.no)
                                            _DSSSTextFieldDisabled(context),
                                          SizedBox(height: 16),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Wrap(
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Late Deduction',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  _LDeductionsTextField(
                                                    context,
                                                  ),
                                                  SizedBox(height: 2),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      '- ₱1.00 Per Minute',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),

                                              Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Cash Advance',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  _CAdvanceTextField(context),
                                                  SizedBox(height: 2),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Direct Deduction from Total',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Notes and Reminders',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  _NRemindersTextField(context),
                                                  SizedBox(height: 16),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  //Staff Section
  Widget _StaffSection(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: SizedBox(
        height: 176,
        child: Row(
          children: [
            SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        size: 64,
                        Icons.account_circle,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(width: 12),
                      Text(
                        selectedStaff!.label,
                        style: TextStyle(
                          fontSize: 32,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Column(
                          children: [
                            SizedBox(height: 24),
                            DropdownMenu<SelectedStaff>(
                              dropdownMenuEntries: SelectedStaff.entries,
                              expandedInsets: EdgeInsets.zero,
                              initialSelection: SelectedStaff.name1,
                              inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                filled: true,
                                fillColor: Theme.of(
                                  context,
                                ).colorScheme.secondary.withValues(alpha: 0.0),
                                isDense: true,
                              ),
                              onSelected: (SelectedStaff? name) {
                                setState(() {
                                  selectedStaff = name;
                                  formula();
                                });
                              },
                              selectOnly: true,
                              textAlign: TextAlign.left,
                              textStyle: TextStyle(
                                overflow: TextOverflow.visible,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Column(
                          children: [
                            SizedBox(height: 24),
                            DropdownMenu<IsFullTimeStaff>(
                              dropdownMenuEntries: IsFullTimeStaff.entries,
                              expandedInsets: EdgeInsets.zero,
                              initialSelection: IsFullTimeStaff.no,
                              inputDecorationTheme: InputDecorationTheme(
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                filled: true,
                                fillColor: Theme.of(
                                  context,
                                ).colorScheme.secondary.withValues(alpha: 0.0),
                              ),
                              onSelected: (IsFullTimeStaff? boolean) {
                                setState(() {
                                  staffBoolean = boolean;
                                  formula();
                                });
                              },
                              selectOnly: true,
                              textAlign: TextAlign.left,
                              textStyle: TextStyle(
                                overflow: TextOverflow.visible,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Salary Section

Widget _SalarySection(BuildContext context) {
  return Card(
    color: Theme.of(context).colorScheme.secondary,
    child: Container(
      padding: EdgeInsets.all(16), // Reduced from 24
      child: Wrap(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double textScaleFactor(
                  BuildContext context, {
                  double maxTextScaleFactor = 4,
                }) {
                  final width = constraints.maxWidth;
                  double val = (width / 1400) * maxTextScaleFactor;
                  return max(1, min(val, maxTextScaleFactor));
                }

                return Column(
                  children: [
                    SizedBox(height: 8), // Reduced from 12
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24), // Reduced from 32
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "Salary Computed",
                          textScaler: TextScaler.linear(
                            textScaleFactor(context),
                          ),
                          style: TextStyle(
                            fontSize: 24, // Reduced from 32
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Reduced from 24
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24), // Reduced from 32
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "₱ ${SalaryComputed.toStringAsFixed(2)}",
                          textScaler: TextScaler.linear(
                            textScaleFactor(context),
                          ),
                          style: TextStyle(
                            fontSize: 36, // Reduced from 48
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Reduced from 12
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 64), // Reduced from 80
                      child: Divider(height: 1),
                    ),
                    const SizedBox(height: 32), // Reduced from 48
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12), // Reduced from 16
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Basic Pay",
                                textScaler: TextScaler.linear(
                                  textScaleFactor(context),
                                ),
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 14
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(width: 12), // Reduced from 16
                              Expanded(flex: 1, child: Divider(height: 1)),
                              SizedBox(width: 12), // Reduced from 16
                              Text(
                                "₱ ${BasicPay.toStringAsFixed(2)}",
                                textScaler: TextScaler.linear(
                                  textScaleFactor(context),
                                ),
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 14
                                  color: const Color.fromARGB(
                                    255,
                                    0,
                                    255,
                                    30,
                                  ),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12), // Reduced from 16
                          Row(
                            children: [
                              Text(
                                "Commissions",
                                textScaler: TextScaler.linear(
                                  textScaleFactor(context),
                                ),
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 14
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(width: 12), // Reduced from 16
                              Expanded(flex: 1, child: Divider(height: 1)),
                              SizedBox(width: 12), // Reduced from 16
                              Text(
                                "₱ ${CAmountValue.toStringAsFixed(2)}",
                                textScaler: TextScaler.linear(
                                  textScaleFactor(context),
                                ),
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 14
                                  color: const Color.fromARGB(
                                    255,
                                    0,
                                    255,
                                    30,
                                  ),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12), // Reduced from 16
                          Row(
                            children: [
                              Text(
                                "Cash Advance",
                                textScaler: TextScaler.linear(
                                  textScaleFactor(context),
                                ),
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 14
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(width: 12), // Reduced from 16
                              Expanded(flex: 1, child: Divider(height: 1)),
                              SizedBox(width: 12), // Reduced from 16
                              Text(
                                "₱ ${CAdvanceValue.toStringAsFixed(2)}",
                                textScaler: TextScaler.linear(
                                  textScaleFactor(context),
                                ),
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 14
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12), // Reduced from 16
                          Row(
                            children: [
                              Text(
                                "Other Deductions",
                                textScaler: TextScaler.linear(
                                  textScaleFactor(context),
                                ),
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 14
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(width: 12), // Reduced from 16
                              Expanded(flex: 1, child: Divider(height: 1)),
                              SizedBox(width: 12), // Reduced from 16
                              Text(
                                "₱ ${TotalDeductions.toStringAsFixed(2)}",
                                textScaler: TextScaler.linear(
                                  textScaleFactor(context),
                                ),
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 14
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12), // Reduced from 16
                        ],
                      ),
                    ),
                    const SizedBox(height: 32), // Reduced from 48
                    SizedBox(
                      width: 200, // Reduced from 256
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStatePropertyAll<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                          padding: WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(
                              horizontal: 12, // Reduced from 16
                              vertical: 12, // Reduced from 16
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Colors.green,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Save',
                          style: GoogleFonts.baiJamjuree(
                            textStyle: const TextStyle(color: Colors.white),
                            fontWeight: FontWeight.bold,
                            fontSize: 24, // Reduced from 32
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12), // Reduced from 16
                    SizedBox(
                      width: 200, // Reduced from 256
                      child: ElevatedButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              'Confirmation',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge!.copyWith(),
                            ),
                            content: Text(
                              'Reset input to the initial value? This cannot be undone.',
                            ),
                            actions: <Widget>[
                              SizedBox(
                                width: 100, // Reduced from 120
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape:
                                        WidgetStatePropertyAll<
                                          RoundedRectangleBorder
                                        >(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                    padding:
                                        WidgetStatePropertyAll<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                            horizontal: 12, // Reduced from 16
                                            vertical: 12, // Reduced from 16
                                          ),
                                        ),
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                          Colors.green,
                                        ),
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontSize: 14), // Reduced from 16
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100, // Reduced from 120
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape:
                                        WidgetStatePropertyAll<
                                          RoundedRectangleBorder
                                        >(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                    padding:
                                        WidgetStatePropertyAll<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                            horizontal: 12, // Reduced from 16
                                            vertical: 12, // Reduced from 16
                                          ),
                                        ),
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                          Colors.red,
                                        ),
                                  ),
                                  onPressed: () => {
                                    Navigator.pop(context, 'OK'),
                                    resetTextFields(),
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Values have been reset.',
                                        ),
                                      ),
                                    ),
                                  },
                                  child: Text(
                                    'Reset All',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontSize: 14), // Reduced from 16
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              WidgetStatePropertyAll<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                          padding: WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(
                              horizontal: 12, // Reduced from 16
                              vertical: 12, // Reduced from 16
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Colors.red,
                          ),
                        ),
                        child: Text(
                          'Reset All',
                          style: GoogleFonts.baiJamjuree(
                            textStyle: const TextStyle(color: Colors.white),
                            fontWeight: FontWeight.bold,
                            fontSize: 24, // Reduced from 32
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Reduced from 16
                  ],
                );
              },
            ),
          ),
        ],
      ),
    )
    );
  }

  //Page Body for WideScreen
  Widget _salary_Page_Wide(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                spacing: 12,
                children: [
                  _StaffSection(context),
                  Expanded(child: _CalculationSection(context)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [Expanded(child: _SalarySection(context))],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
  //Page Body for ThinScreen
 Widget _salary_Page_Thin(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          spacing: 0,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 360,
                child: Expanded(
                  child: TabBar(
                    controller: tabController,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    indicatorColor: Colors.orange,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(
                        context,
                      ).colorScheme.primary,
                    ),
                    unselectedLabelStyle: TextStyle(fontSize: 20),
                    overlayColor: WidgetStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                    tabs: <Widget>[
                      Tab(text: "Overview"),
                      Tab(text: 'Calculations'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  Column(
                    children: [
                      _StaffSection(context),
                      Expanded(child: _SalarySection(context)),
                    ],
                  ),
                  Column(
                    children: [
                      Expanded(child: _CalculationSection(context)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
  //Actual Builder
  @override
Widget build(BuildContext context) {
  //Adjust niyo 'to for resolution
  return Scaffold(
    backgroundColor: const Color(0xFF9FA8DA), // ✅ Admin background
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9FA8DA), Color(0xFFFFFFFF)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ✅ ADMIN SIDEBAR
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              left: 20.0,
            ),
            child: Container(
              width: 240,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF5B6388), Color(0xFF3E4563)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/logo.png',
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Cam2print System',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildSidebarItem(
                    Icons.people,
                    "Staff Management",
                    () => _navigateTo('Staff Management'),
                  ),
                  _buildSidebarItem(
                    Icons.inventory_2,
                    "Overall Inventory",
                    () => _navigateTo('Overall Inventory'),
                  ),
                  _buildSidebarItem(
                    Icons.settings,
                    "Services",
                    () => _navigateTo('Services'),
                  ),
                  _buildSidebarItem(
                    Icons.attach_money,
                    "Salary",
                    () => _navigateTo('Salary'),
                    isActive: true,
                  ),
                  _buildSidebarItem(
                    Icons.shopping_cart,
                    "Customized Orders",
                    () => _navigateTo('Customized Orders'),
                  ),
                  _buildSidebarItem(
                    Icons.calendar_today,
                    "Schedule",
                    () => _navigateTo('Schedule'),
                  ),
                  _buildSidebarItem(
                    Icons.error_outline,
                    "Reports",
                    () => _navigateTo('Reports'),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          AppRouter.login,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white70,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ MAIN CONTENT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20), // Reduced from 25
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Admin Header Style
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12, // Reduced from 15
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Saturday/ January 31, 2026",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _navigateTo('Notifications'),
                              child: const Icon(
                                Icons.notifications_none,
                                color: Color(0xFF1A237E),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 26,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jane",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                Text(
                                  "Admin",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16), // Reduced from 20
                  // ✅ YOUR ORIGINAL SALARY CONTENT (Preserved)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        if (constraints.maxWidth > 900) {
                          return _salary_Page_Wide(context);
                        } else {
                          return _salary_Page_Thin(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}