// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/widgets/transaction_list.dart';


String searchValue='';
class SearchScreen extends StatelessWidget {
  List<TransactionModel> transactionList;
  SearchScreen({Key? key,required this.transactionList}) : super(key: key);

  bool initSearching = true;
  List<TransactionModel> results = [];
  runFilter(enteredKeyword) {
    initSearching = false;
    if (enteredKeyword.isEmpty) {
      results = transactionList;
    } else {
      results = transactionList
              .where((element) => element.categoryTypeName
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList() +
          transactionList
              .where((element) => element.amount
                  .toString()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
    }
    TransactionDB.instance.transactionListNotifier.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: TransactionDB.instance.transactionListNotifier,
              builder: (BuildContext context,
                  List<TransactionModel> transactionList, Widget? _) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        onChanged: (value) {
                          searchValue = value;
                          runFilter(searchValue);
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Search',
                            hintText: 'Search by category or amount',
                            counterText: '',
                            suffixIcon: Icon(Icons.search)),
                        maxLength: 20,
                      ),
                    ),
                    Expanded(
                        child: results.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  final data = results[index];
                                  return displayCard(context, data,
                                      isCustom: true,isSearch: true);
                                })
                            : initSearching
                                ? ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    itemCount: transactionList.length,
                                    itemBuilder: (context, index) {
                                      final data = transactionList[index];
                                      return displayCard(context, data,
                                          isCustom: true,isSearch: true);
                                    })
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.22,
                                            child: SvgPicture.asset(
                                                'assets/noSearchResults.svg')),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        const Text(
                                          'No results found',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              ),
                                        )
                                      ],
                                    ),
                                  )),
                  ],
                );
              })),
    );
  }
}
