// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/charts/all_chart.dart';
import 'package:my_wallet/screens/charts/expense_chart.dart';
import 'package:my_wallet/screens/charts/income_chart.dart';
import 'package:my_wallet/screens/settings_screen.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
     DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Charts'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: TransactionDB.instance.transactionListNotifier,
              builder: (BuildContext context,
                  List<TransactionModel> transactionList, Widget? _) {
                final data = transactionList;
                final incomeList = data
                    .where((element) => element.incomeOrExpense == 'Income')
                    .toList();
                final expenseList = data
                    .where((element) => element.incomeOrExpense == 'Expense')
                    .toList();
                return incomeList.isEmpty || expenseList.isEmpty
                    ? _noChartDataImage(context)
                    : Column(children: [
                        const SizedBox(height: 10),
                        ValueListenableBuilder(
                            valueListenable: darkThemePreference,
                            builder:
                                (BuildContext context, bool isDark, Widget? _) {
                                  Color setColor= isDark? Colors.grey.shade800:Colors.indigoAccent;
                              return TabBar(
                                unselectedLabelColor: setColor,
                                indicatorSize: TabBarIndicatorSize.label,
                                tabs: [
                                  Tab(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: setColor,
                                              width: 1.5)),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text("All",
                                            style: TextStyle(
                                                fontWeight:
                                                    FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: setColor,
                                              width: 1.5)),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text("Income",
                                            style: TextStyle(
                                                fontWeight:
                                                    FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: setColor,
                                              width: 1.5)),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text("Expense",
                                            style: TextStyle(
                                                fontWeight:
                                                    FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ],
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: setColor),
                              );
                            }),
                            const SizedBox(height: 15),
                        const Expanded(
                          child: TabBarView(children: [
                            AllChart(),
                            IncomeChart(),
                            ExpenseChart(),
                          ]),
                        ),
                      ]);
              }),
        ),
      ),
    );
  }
}

Widget _noChartDataImage(context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: SvgPicture.asset('assets/chartNoDataSvg.svg')),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'No enough transactions to run a chart. Add both income and expense transactions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
