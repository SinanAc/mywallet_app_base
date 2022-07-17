// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/settings_screen.dart';
import 'package:my_wallet/widgets/transaction_list.dart';

class CustomTransactionScreen extends StatelessWidget {
  String hintText;
  DateTime customSelected;
  DateTime customSelectedLastDate;
  CustomTransactionScreen(
      {Key? key,
      required this.hintText,
      required this.customSelected,
      required this.customSelectedLastDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hintText == 'Income'
            ? 'Income'
            : hintText == 'Expense'
                ? 'Expense'
                : hintText == 'Today'
                    ? 'Today'
                    : hintText == 'Last Week'
                        ? 'Last Week'
                        : hintText == 'Last Month'
                            ? 'Last Month'
                            : hintText == 'Custom Date'
                                ? DateFormat.yMMMd().format(customSelected)
                                : hintText == 'Custom Month'
                                    ? DateFormat.yMMMM().format(customSelected)
                                    : hintText == 'Custom Period'
                                        ? '${DateFormat.MMMd().format(customSelected)} - ${DateFormat.MMMd().format(customSelectedLastDate)}'
                                        : ''),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: TransactionDB.instance.transactionListNotifier,
            builder: (BuildContext context,
                List<TransactionModel> transactionList, Widget? _) {
              final data = transactionList;
              double customMonthIncome = 0;
              double customMonthExpense = 0;
              final customMonthData = data
                  .where((element) =>
                      DateFormat.yMMMM().format(element.selectedDate) ==
                      DateFormat.yMMMM().format(customSelected))
                  .toList();
              for (int i = 0; i < customMonthData.length; i++) {
                customMonthData[i].incomeOrExpense == 'Income'
                    ? customMonthIncome += customMonthData[i].amount
                    : customMonthExpense += customMonthData[i].amount;
              }
              return hintText == 'Income' && data.where((element) => element.incomeOrExpense == 'Income').toList().isEmpty ||
                      hintText == 'Expense' &&
                          data
                              .where((element) =>
                                  element.incomeOrExpense == 'Expense')
                              .toList()
                              .isEmpty ||
                      hintText == 'Today' &&
                          data
                              .where((element) =>
                                  DateFormat.yMMMMd().format(element.selectedDate) ==
                                  DateFormat.yMMMMd().format(DateTime.now()))
                              .toList()
                              .isEmpty ||
                      hintText == 'Last Week' &&
                          data
                              .where((element) => element.selectedDate.isAfter(DateTime.now()
                                  .subtract(const Duration(days: 7))))
                              .toList()
                              .isEmpty ||
                      hintText == 'Last Month' &&
                          data
                              .where((element) => element.selectedDate.isAfter(
                                  DateTime.now()
                                      .subtract(const Duration(days: 30))))
                              .toList()
                              .isEmpty ||
                      hintText == 'Custom Date' &&
                          data
                              .where((element) => DateFormat.yMMMMd().format(element.selectedDate) == DateFormat.yMMMMd().format(customSelected))
                              .toList()
                              .isEmpty ||
                      hintText == 'Custom Month' && customMonthData.isEmpty ||
                      hintText == 'Custom Period' && data.where((element) => element.selectedDate.isAfter(customSelected.subtract(const Duration(days: 1)))).toList().isEmpty ||
                      data.where((element) => element.selectedDate.isBefore(customSelectedLastDate.add(const Duration(days: 1)))).toList().isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: SvgPicture.asset('assets/homeNoData.svg')),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Text(
                            hintText == 'Income'
                                ? 'No Income transactions to display \nStart adding now'
                                : hintText == 'Expense'
                                    ? 'No Expense transactions to display \nStart adding now'
                                    : hintText == 'Today'
                                        ? 'No transactions today \nStart adding now'
                                        : hintText == 'Last Week'
                                            ? 'No transactions in last week \nStart adding now'
                                            : hintText == 'Last Month'
                                                ? 'No transactions in last month \nStart adding now'
                                                : hintText == 'Custom Date'
                                                    ? 'No transactions on selected date'
                                                    : hintText == 'Custom Month'
                                                        ? 'No transactions on selected month'
                                                        : 'No Transactions on selected period',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          )
                        ],
                      ),
                    )
                  : hintText == 'Income'
                      ? incomeTransactionListWidget(context)
                      : hintText == 'Expense'
                          ? expenseTransactionListWidget(context)
                          : hintText == 'Today'
                              ? todayTransactionListWidget(context)
                              : hintText == 'Last Week'
                                  ? lastWeekTransactionListWidget(context)
                                  : hintText == 'Last Month'
                                      ? lastMonthTransactionListWidget(context)
                                      : hintText == 'Custom Date'
                                          ? customDateTransactionListWidget(context, customSelected)
                                          : hintText == 'Custom Month'
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                        7,
                                                      ),
                                                      child:
                                                          ValueListenableBuilder(
                                                              valueListenable:
                                                                  darkThemePreference,
                                                              builder:
                                                                  (BuildContext
                                                                          context,
                                                                      bool
                                                                          isDark,
                                                                      Widget?
                                                                          _) {
                                                                return Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        isDark
                                                                            ? const Color.fromARGB(
                                                                                255,
                                                                                14,
                                                                                14,
                                                                                89)
                                                                            : Colors.indigo,
                                                                        isDark
                                                                            ? const Color.fromARGB(
                                                                                255,
                                                                                22,
                                                                                22,
                                                                                22)
                                                                            : Colors.black87,
                                                                      ],
                                                                      begin: Alignment
                                                                          .topCenter,
                                                                      end: Alignment
                                                                          .bottomCenter,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.all(
                                                                        MediaQuery.of(context).size.aspectRatio *
                                                                            40),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const Text('Income',
                                                                                style: TextStyle(
                                                                                  color: Colors.amber,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            Text('₹ $customMonthIncome',
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            const Text('Expense',
                                                                                style: TextStyle(
                                                                                  color: Colors.amber,
                                                                                  fontWeight: FontWeight.bold,
                                                                                )),
                                                                            Text('₹ $customMonthExpense',
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                    ),
                                                    Expanded(
                                                        child:
                                                            customMonthTransactionListWidget(
                                                                context,
                                                                customSelected)),
                                                  ],
                                                )
                                              : hintText == 'Custom Period'
                                                  ? customPeriodTransactionListWidget(context, customSelected, customSelectedLastDate)
                                                  : const SizedBox();
            }),
      ),
    );
  }
}
