import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}


  List<DropdownMenuItem<String>> get incomeCategories {
    List<DropdownMenuItem<String>> incomeMenu = const [
      DropdownMenuItem(value: 'Salary', child: Text('Salary')),
      DropdownMenuItem(value: 'Business', child: Text('Business')),
      DropdownMenuItem(value: 'Freelance', child: Text('Freelance')),
      DropdownMenuItem(value: 'Interest', child: Text('Interest')),
      DropdownMenuItem(value: 'Stocks', child: Text('Stocks')),
      DropdownMenuItem(value: 'Commission', child: Text('Commission')),
      DropdownMenuItem(value: 'Extra', child: Text('Extra')),
    ];
    return incomeMenu;
  }

  List<DropdownMenuItem<String>> get expenseCategories {
    List<DropdownMenuItem<String>> expenseMenu = const [
      DropdownMenuItem(value: 'Food', child: Text('Food')),
      DropdownMenuItem(value: 'Transportation', child: Text('Transportation')),
      DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
      DropdownMenuItem(value: 'Education', child: Text('Education')),
      DropdownMenuItem(value: 'EMI', child: Text('EMI')),       
      DropdownMenuItem(value: 'Utilities', child: Text('Utilities')),
      DropdownMenuItem(value: 'Internet', child: Text('Internet')),
      DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
      DropdownMenuItem(value: 'Health Care', child: Text('Health Care')),
      DropdownMenuItem(value: 'Others', child: Text('Others')),
    ];
    return expenseMenu;
  }

class _AddScreenState extends State<AddScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  DateTime showDate = DateTime.now();
  String? categoryType;
  String? incomeOrExpense;

  @override
  initState() {
    incomeOrExpense = "Income";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transactions'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 110,
                  child: SvgPicture.asset('assets/addSvg.svg'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                            value: 'Income',
                            groupValue: incomeOrExpense,
                            onChanged: (value) {
                              setState(() {
                                incomeOrExpense = 'Income';
                                categoryType = null;
                              });
                            }),
                        const Text('Income'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: 'Expense',
                            groupValue: incomeOrExpense,
                            onChanged: (value) {
                              setState(() {
                                incomeOrExpense = 'Expense';
                                categoryType = null;
                              });
                            }),
                        const Text('Expense'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    label: Text('Amount'),
                    prefixIcon: Icon(Icons.attach_money),
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
                const SizedBox(
                  height: 7,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  value: categoryType,
                  hint: const Text('Category'),
                  items: incomeOrExpense == 'Income'
                      ? incomeCategories
                      : expenseCategories,
                  onChanged: (value) {
                    setState(() {
                      categoryType = value.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 7,
                ),
                SizedBox(
                  height: 58,
                  child: GestureDetector(
                    onTap: () async {
                      selectDate();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.9,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                            size: 23,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat.yMMMMd().format(showDate),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      label: Text('Note'),
                      prefixIcon: Icon(Icons.note_alt_outlined),
                      counterText: ''),
                  maxLength: 20,
                ),
                const SizedBox(
                  height: 7,
                ),
                ElevatedButton(
                  onPressed: () {
                    submission(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Submit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submission(BuildContext context) async {
    final incomeOrExpenseValue = incomeOrExpense.toString();
    final amount = amountController.text.isEmpty
        ? 0.0
        : double.parse(amountController.text);
    final categoryTypeName = categoryType.toString();
    final selectedDate = showDate;
    final note = noteController.text;
    if (
        amount == 0 ||
        amount.isNegative ||
        categoryType == null) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all the fields',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        incomeOrExpense: incomeOrExpenseValue,
        amount: amount,
        categoryTypeName: categoryTypeName,
        selectedDate: selectedDate,
        note: note,
      );
      TransactionDB.instance.addTransaction(transaction);
      Navigator.of(context).pop();
      TransactionDB.instance.refreshUi();
    }
  }

  Future<void> selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (selectedDate == null) {
      return;
    } else {
      setState(() {
        showDate = selectedDate;
      });
    }
  }
}
