// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/settings_screen.dart';
import 'package:my_wallet/screens/view_all/all_transactions.dart';
import 'package:my_wallet/screens/view_all/custom_trans.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  bool isAll = false;
  bool isLastMonth = true;
  bool isLastYear = false;

  @override
  initState() {
    isAll = false;
    isLastMonth = true;
    isLastYear = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
          valueListenable: TransactionDB.instance.transactionListNotifier,
          builder: (BuildContext context,
              List<TransactionModel> transactionList, Widget? _) {
            final data = transactionList;
            final lastMonthData = data
                .where((element) => element.selectedDate
                    .isAfter(DateTime.now().subtract(const Duration(days: 31))))
                .toList();
            final lastYearData = data
                .where((element) => element.selectedDate.isAfter(
                    DateTime.now().subtract(const Duration(days: 366))))
                .toList();
            double incomeTotal = 0;
            double expenseTotal = 0;
            double lastMonthIncome = 0;
            double lastMonthExpense = 0;
            double lastYearIncome = 0;
            double lastYearExpense = 0;

            for (int i = 0;
                i < data.length;
                i++) {
              data[i]
                          .incomeOrExpense ==
                      'Income'
                  ? incomeTotal += data[i].amount
                  : expenseTotal += data[i].amount;
            }

            for (int i = 0; i < lastMonthData.length; i++) {
              lastMonthData[i].incomeOrExpense == 'Income'
                  ? lastMonthIncome += lastMonthData[i].amount
                  : lastMonthExpense += lastMonthData[i].amount;
            }

            for (int i = 0; i < lastYearData.length; i++) {
              lastYearData[i].incomeOrExpense == 'Income'
                  ? lastYearIncome += lastYearData[i].amount
                  : lastYearExpense += lastYearData[i].amount;
            }

            double totalBalance = incomeTotal - expenseTotal;
            totalBalance < 0 ? totalBalance = 0 : totalBalance;
            return data.isEmpty
                ? noDataPicure(context)
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: darkThemePreference,
                            builder:
                                (BuildContext context, bool isDark, Widget? _) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      isDark
                                          ? const Color.fromARGB(
                                              255, 14, 14, 89)
                                          : Colors.indigo,
                                      isDark
                                          ? const Color.fromARGB(
                                              255, 22, 22, 22)
                                          : Colors.black87,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                    left: MediaQuery.of(context).size.height *
                                        0.02,
                                    right: MediaQuery.of(context).size.height *
                                        0.02,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text('Total Balance',
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text('₹ $totalBalance',
                                          style: TextStyle(
                                            fontSize: 17,
                                              color: totalBalance > 0
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              const Text('Total Income',
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(
                                                  isAll == true
                                                      ? '₹ $incomeTotal'
                                                      : isLastMonth == true
                                                          ? '₹ $lastMonthIncome'
                                                          : isLastYear == true
                                                              ? '₹ $lastYearIncome'
                                                              : '',
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const Text('Total Expense',
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(
                                                  isAll ? '₹ $expenseTotal'
                                                      : isLastMonth ? '₹ $lastMonthExpense'
                                                          : isLastYear? '₹ $lastYearExpense'
                                                              : '',
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ChoiceChip(
                                              label: const Text(
                                                'Last Month',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              selected: isLastMonth,
                                              selectedColor: Colors.blue,
                                              backgroundColor: Colors.grey[600],
                                              onSelected: (bool value) {
                                                setState(() {
                                                  isLastMonth = true;
                                                  isAll = false;
                                                  isLastYear = false;
                                                });
                                              },
                                            ),
                                            ChoiceChip(
                                              label: const Text(
                                                'Last Year',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              selected: isLastYear,
                                              selectedColor: Colors.blue,
                                              backgroundColor: Colors.grey[600],
                                              onSelected: (bool value) {
                                                setState(() {
                                                  isLastYear = true;
                                                  isAll = false;
                                                  isLastMonth = false;
                                                });
                                              },
                                            ),
                                            ChoiceChip(
                                              label: const Text(
                                                'All',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              selected: isAll,
                                              selectedColor: Colors.blue,
                                              backgroundColor: Colors.grey[600],
                                              onSelected: (bool value) {
                                                setState(() {
                                                  isAll = true;
                                                  isLastMonth = false;
                                                  isLastYear = false;
                                                });
                                              },
                                            ),
                                          ])
                                    ],
                                  ),
                                ),
                              );
                            }),
                        Expanded(
                          child: ListView(children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'All Transactions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  sortingButton(context, 'All',
                                      FontAwesomeIcons.scaleBalanced),
                                  sortingButton(context, 'Income',
                                      FontAwesomeIcons.sackDollar),
                                  sortingButton(context, 'Expense',
                                      FontAwesomeIcons.handsBubbles),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                sortingButton(context, 'Today',
                                    FontAwesomeIcons.calendarDay),
                                sortingButton(context, 'Last Week',
                                    FontAwesomeIcons.calendarWeek),
                                sortingButton(context, 'Last Month',
                                    FontAwesomeIcons.calendarDays),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8, top: 5),
                              child: Text('Custom',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                sortingButton(context, 'Date',
                                    FontAwesomeIcons.calendarCheck),
                                sortingButton(context, 'Month',
                                    FontAwesomeIcons.calendarPlus),
                                sortingButton(context, 'Period',
                                    FontAwesomeIcons.squarePen),
                              ],
                            )
                          ]),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }

  Widget sortingButton(
    BuildContext context,
    String text,
    IconData icon,
  ) {
    return GestureDetector(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Card(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: Colors.blue,
              size: MediaQuery.of(context).size.height * 0.035,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
            )
          ],
        )),
      ),
      onTap: () {
        text == 'All'
            ? Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AllTransactionScreen()))
            : text == 'Income'
                ? Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CustomTransactionScreen(
                          hintText: 'Income',
                          customSelected: DateTime.now(),
                          customSelectedLastDate: DateTime.now(),
                        )))
                : text == 'Expense'
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CustomTransactionScreen(
                              hintText: 'Expense',
                              customSelected: DateTime.now(),
                              customSelectedLastDate: DateTime.now(),
                            )))
                    : text == 'Today'
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomTransactionScreen(
                                  hintText: 'Today',
                                  customSelected: DateTime.now(),
                                  customSelectedLastDate: DateTime.now(),
                                )))
                        : text == 'Last Week'
                            ? Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CustomTransactionScreen(
                                      hintText: 'Last Week',
                                      customSelected: DateTime.now(),
                                      customSelectedLastDate: DateTime.now(),
                                    )))
                            : text == 'Last Month'
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CustomTransactionScreen(
                                          hintText: 'Last Month',
                                          customSelected: DateTime.now(),
                                          customSelectedLastDate:
                                              DateTime.now(),
                                        )))
                                : text == 'Date'
                                    ? selectDate()
                                    : text == 'Month'
                                        ? selectMonth(
                                            context: context, locale: 'en')
                                        : selectPeriod();
      },
    );
  }

  Widget noDataPicure(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: SvgPicture.asset('assets/viewAllNoData.svg')),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const Text(
            'No transaction data to display \nStart adding now',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }

  Future<void> selectDate() async {
    final customSelectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (customSelectedDate == null) {
      return;
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomTransactionScreen(
                hintText: 'Custom Date',
                customSelected: customSelectedDate,
                customSelectedLastDate: DateTime.now(),
              )));
    }
  }

  Future<void> selectMonth(
      {required BuildContext context, String? locale}) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final customSelectedMonth = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      locale: localeObj,
    );
    if (customSelectedMonth == null) {
      return;
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomTransactionScreen(
                hintText: 'Custom Month',
                customSelected: customSelectedMonth,
                customSelectedLastDate: DateTime.now(),
              )));
    }
  }

  Future<void> selectPeriod() async {
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
        initialDate: DateTime.now(),
        firstDate: customSelectedFirstDate.add(const Duration(days: 1)),
        lastDate: DateTime.now(),
        helpText: 'SELECT LAST DATE',
      );
      if (customSelectedLastDate == null) {
        return;
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CustomTransactionScreen(
                  hintText: 'Custom Period',
                  customSelected: customSelectedFirstDate,
                  customSelectedLastDate: customSelectedLastDate,
                )));
      }
    }
  }
}
