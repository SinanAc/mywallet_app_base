import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/settings_screen.dart';
import 'package:my_wallet/widgets/transaction_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  getSharedPrefName() async {
    final SharedPreferences pref;
    pref = await SharedPreferences.getInstance();
    userName = pref.getString('name').toString();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Wallet'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: TransactionDB.instance.transactionListNotifier,
              builder: (BuildContext context,
                  List<TransactionModel> transactionList, Widget? _) {
                double incomeTotal = 0;
                double expenseTotal = 0;
                for (int i = 0; i < transactionList.length; i++) {
                  transactionList[i].incomeOrExpense == 'Income'
                      ? incomeTotal += transactionList[i].amount
                      : expenseTotal += transactionList[i].amount;
                }
                double totalBalance = incomeTotal - expenseTotal;
                totalBalance < 0 ? totalBalance = 0 : totalBalance;
                return transactionList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child:
                                    SvgPicture.asset('assets/homeNoData.svg')),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            const Text(
                              'No transaction data to display \nStart adding now',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: ValueListenableBuilder(
                                valueListenable: darkThemePreference,
                                builder: (BuildContext context, bool isDark,
                                    Widget? _) {
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
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Hai',
                                                      style: TextStyle(
                                                        color: Colors.amber,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  Text(userName,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold))
                                                ],
                                              ),
                                              SvgPicture.asset(
                                                'assets/masterCardLogo.svg',
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          const Text('Your Total Balance is',
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
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Recent Transactions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(child: transactionListWidget(context, true)),
                        ],
                      );
              }),
        ));
  }
}
