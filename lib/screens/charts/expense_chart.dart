// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/charts/all_chart.dart';
import 'package:my_wallet/screens/charts/chart_functions.dart';
import 'package:my_wallet/screens/settings_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseChart extends StatefulWidget {
  const ExpenseChart({Key? key}) : super(key: key);

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  String chartCategoryType = 'Last 30 days';
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext context, List<TransactionModel> transactionList,
            Widget? _) {
          final data = transactionList;
          final expenseList = data
              .where((element) => element.incomeOrExpense == 'Expense')
              .toList();
          final lastMonthExpenseList = expenseList
              .where((element) => element.selectedDate
                  .isAfter(DateTime.now().subtract(const Duration(days: 31))))
              .toList();
          final hundredDaysExpenseList = expenseList
              .where((element) => element.selectedDate
                  .isAfter(DateTime.now().subtract(const Duration(days: 101))))
              .toList();
          final List<ChartData> incomeTransactionList = chartLogic(expenseList);
          final List<ChartData> lastMonthExpenseTransactionList =
              chartLogic(lastMonthExpenseList);
          final List<ChartData> hundredDaysExpenseTransactionList =
              chartLogic(hundredDaysExpenseList);
          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  value: chartCategoryType,
                  items: chartCategories,
                  onChanged: (value) {
                    setState(() {
                      chartCategoryType = value.toString();
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    _selectPeriod(context, expenseList);
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                  color: Colors.blue,
                )
              ],
            ),
            Expanded(
              child: chartCategoryType == 'All'
                  ? _expenseDataChart(incomeTransactionList)
                  : chartCategoryType == 'Last 30 days' &&
                          lastMonthExpenseList.isNotEmpty
                      ? _expenseDataChart(lastMonthExpenseTransactionList)
                      : chartCategoryType == 'Last 30 days' &&
                              lastMonthExpenseList.isEmpty
                          ? const Expanded(
                              child: Center(
                                  child: Text(
                              'No data available !!',
                              style: TextStyle(color: Colors.red),
                            )))
                          : chartCategoryType == 'Last 100 days' &&
                                  hundredDaysExpenseList.isNotEmpty
                              ? _expenseDataChart(
                                  hundredDaysExpenseTransactionList)
                              : chartCategoryType == 'Last 100 days' &&
                                      hundredDaysExpenseList.isEmpty
                                  ? const Expanded(
                                      child: Center(
                                          child: Text(
                                      'No data available !!',
                                      style: TextStyle(color: Colors.red),
                                    )))
                                  : const SizedBox(),
            )
          ]);
        });
  }

  Widget _expenseDataChart(List<ChartData> transactionList,
      {bool isCustom = false}) {
    final List<ChartData> chartData = transactionList;
    return Center(
        child: SfCircularChart(
      legend: Legend(
        isVisible: true,
        position: isCustom ? LegendPosition.bottom : LegendPosition.right,
        isResponsive: true,
      ),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          xValueMapper: (ChartData data, _) => data.categoryTypeName,
          yValueMapper: (ChartData data, _) => data.amount,
          selectionBehavior: SelectionBehavior(enable: true),
        )
      ],
    ));
  }

  Future<void> _selectPeriod(BuildContext context, List<TransactionModel> data) async {
    final customSelectedFirstDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 1)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
      helpText: 'SELECT FIRST DATE',
    );
    if (customSelectedFirstDate == null) {
      return;
    } else {
      final customSelectedLastDate = await showDatePicker(
        context: context,
        initialDate: customSelectedFirstDate.add(const Duration(days: 1)),
        firstDate: customSelectedFirstDate.add(const Duration(days: 1)),
        lastDate: DateTime.now(),
        helpText: 'SELECT LAST DATE',
      );
      if (customSelectedLastDate == null) {
        return;
      } else {
        final List<TransactionModel> customPeriodListGenerate = [];
        customPeriodListGenerate.clear();
        for (var element in data) {
          if (element.selectedDate.isAfter(
                  customSelectedFirstDate.subtract(const Duration(days: 1))) &&
              element.selectedDate.isBefore(
                  customSelectedLastDate.add(const Duration(days: 1)))) {
            customPeriodListGenerate.add(element);
          }
        }
        final List<ChartData> customPeriodList =
            chartLogic(customPeriodListGenerate);

        _showBottomSheet(context, customPeriodList,
            '${DateFormat.MMMd().format(customSelectedFirstDate)} - ${DateFormat.MMMd().format(customSelectedLastDate)}');
      }
    }
  }

  Future<dynamic> _showBottomSheet(
      BuildContext context, List<ChartData> customPeriodList, String heading)async {
        return
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return
          ValueListenableBuilder(
        valueListenable: darkThemePreference,
        builder: (BuildContext context, bool isDark, Widget?_){
          return
           Container(
            decoration:  BoxDecoration(
              color: isDark? Colors.grey[800]: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(heading,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
                customPeriodList.isNotEmpty
                    ? _expenseDataChart(customPeriodList, isCustom: true)
                    : const Center(
                        child: Text('No data available on selected period !!',
                            textAlign: TextAlign.center),
                      ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          );});
        });
  }
}
