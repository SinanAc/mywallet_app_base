// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/charts/chart_functions.dart';
import 'package:my_wallet/screens/settings_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AllChart extends StatefulWidget {
  const AllChart({Key? key}) : super(key: key);
  @override
  State<AllChart> createState() => _AllChartState();
}

class _AllChartState extends State<AllChart> {
  String chartCategoryType = 'Last 30 days';
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext context, List<TransactionModel> transactionList,
            Widget? _) {
          final data = transactionList;
          final lastMonthList = data
              .where((element) => element.selectedDate
                  .isAfter(DateTime.now().subtract(const Duration(days: 31))))
              .toList();
          final hundredDaysList = data
              .where((element) => element.selectedDate
                  .isAfter(DateTime.now().subtract(const Duration(days: 101))))
              .toList();
          final List<AllChartData> allTransactionList =
              allChartLogic(transactionList);
          final List<AllChartData> lastMonthTransactionList =
              allChartLogic(lastMonthList);
          final List<AllChartData> hundredDaysTransactionList =
              allChartLogic(hundredDaysList);
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
                      _selectPeriod(context, data);
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    color: Colors.blue)
              ],
            ),
            Expanded(
              child: chartCategoryType == 'All'
                  ? _dataChart(allTransactionList)
                  : chartCategoryType == 'Last 30 days' &&
                          lastMonthList.isNotEmpty
                      ? _dataChart(lastMonthTransactionList)
                      : chartCategoryType == 'Last 30 days' &&
                              lastMonthList.isEmpty
                          ? const Expanded(
                              child: Center(child: Text('No data available')))
                          : chartCategoryType == 'Last 100 days' &&
                                  hundredDaysList.isNotEmpty
                              ? _dataChart(hundredDaysTransactionList)
                              : chartCategoryType == 'Last 100 days' &&
                                      hundredDaysList.isEmpty
                                  ? const Expanded(
                                      child: Center(
                                          child: Text('No data available')))
                                  : const SizedBox(),
            )
          ]);
        });
  }

  Widget _dataChart(List<AllChartData> transactionList,
      {bool isCustom = false}) {
    final List<AllChartData> chartData = transactionList;
    return Center(
        child: SfCircularChart(
      legend: Legend(
        isVisible: true,
        position: isCustom ? LegendPosition.bottom : LegendPosition.right,
        isResponsive: true,
      ),
      series: <CircularSeries>[
        PieSeries<AllChartData, String>(
          dataSource: chartData,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          xValueMapper: (AllChartData data, _) => data.incomeOrExpense,
          yValueMapper: (AllChartData data, _) => data.amount,
          selectionBehavior: SelectionBehavior(enable: true),
        )
      ],
    ));
  }

  _selectPeriod(BuildContext context, List<TransactionModel> data) async {
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
        final List<AllChartData> customPeriodList = allChartLogic(customPeriodListGenerate);
        _showBottomSheet(context, customPeriodList,
            '${DateFormat.MMMd().format(customSelectedFirstDate)} - ${DateFormat.MMMd().format(customSelectedLastDate)}');
      }
    }
  }

  _showBottomSheet(BuildContext context, List<AllChartData> customPeriodList,
      String heading) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ValueListenableBuilder(
              valueListenable: darkThemePreference,
              builder: (BuildContext context, bool isDark, Widget? _) {
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.white,
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
                      Text(
                        heading,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      customPeriodList.isNotEmpty
                          ? _dataChart(customPeriodList, isCustom: true)
                          : const Center(
                              child: Text(
                                  'No data available on selected period !!',
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
                );
              });
        });
  }
}

List<DropdownMenuItem<String>> get chartCategories {
  List<DropdownMenuItem<String>> chartMenu = const [
     DropdownMenuItem(value: 'Last 30 days', child: Text('Last 30 days')),
     DropdownMenuItem(value: 'Last 100 days', child: Text('Last 100 days')),
     DropdownMenuItem(value: 'All', child: Text('All')),
  ];
  return chartMenu;
}
