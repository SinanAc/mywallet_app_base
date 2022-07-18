import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/add_screen.dart';

class EditScreen extends StatefulWidget {
  final TransactionModel data;
  const EditScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  DateTime showDate = DateTime.now();
  String? categoryType;
  String? incomeOrExpense;

  @override
  initState() {
    amountController.text = widget.data.amount.toString();
    noteController.text = widget.data.note;
    categoryType = widget.data.categoryTypeName;
    showDate = widget.data.selectedDate;
    incomeOrExpense = widget.data.incomeOrExpense;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details'),
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
                  height: 120,
                  child: SvgPicture.asset('assets/editSvg.svg'),
                ),
                const SizedBox(
                  height: 15,
                ),
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  value: categoryType,
                  items: incomeOrExpense == 'Income'
                      ? incomeCategories
                      : expenseCategories,
                  hint: const Text('Category'),
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
                  height: 60,
                  child: GestureDetector(
                    onTap: () async {
                      _selectDate();
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
                      counterText: '',
                    ),
                    maxLength: 20
                    ),
                const SizedBox(
                  height: 7,
                ),
                ElevatedButton(
                  onPressed: () {
                    _updation(context, widget.data.id!);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Update',
                                        style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updation(BuildContext context, String id) {
    final incomeOrExpenseValue = incomeOrExpense.toString();
    final amount = amountController.text.isEmpty
        ? 0.0
        : double.parse(amountController.text);
    final categoryTypeName = categoryType.toString();
    final selectedDateNew = showDate;
    final note = noteController.text;

    if (amount == 0 || amount.isNegative) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all the fields',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      final transaction = TransactionModel(
        id: widget.data.id,
        incomeOrExpense: incomeOrExpenseValue,
        amount: amount,
        categoryTypeName: categoryTypeName,
        selectedDate: selectedDateNew,
        note: note,
      );
      TransactionDB.instance.updateTransaction(data: transaction, id: id);
      Navigator.of(context).pop();
      if(amount!=widget.data.amount || categoryTypeName!=widget.data.categoryTypeName || selectedDateNew!=widget.data.selectedDate || note!=widget.data.note){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Successfully Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
    backgroundColor:  Colors.grey,
     behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      }
    }
  }

  Future<void> _selectDate() async {
    final selectedDateNow = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (selectedDateNow == null) {
      return;
    } else {
      setState(() {
        showDate = selectedDateNow;
      });
    }
  }
}
