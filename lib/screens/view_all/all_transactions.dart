import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/search_screen.dart';
import 'package:my_wallet/widgets/transaction_list.dart';

class AllTransactionScreen extends StatelessWidget {
  const AllTransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    ValueListenableBuilder(
          valueListenable: TransactionDB.instance.transactionListNotifier,
          builder: (BuildContext context,List<TransactionModel>transactionList,Widget?_){
          return 
     Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                       SearchScreen(transactionList: transactionList),
                ),
              );
            },
          ),
        ],
      ),
      body:  SafeArea(
        child: TransactionDB
                    .instance.transactionListNotifier.value.isEmpty? 
                   Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: SvgPicture.asset('assets/homeNoData.svg')),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
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
                  ): 
           transactionListWidget(context,false),

      ),
    );
              }
          );
  }
}