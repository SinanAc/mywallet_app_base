// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/data_base/db_functions.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/edit_screen.dart';
import 'package:my_wallet/screens/search_screen.dart';

@override
Widget transactionListWidget(BuildContext context, bool? isHomeScreen) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return displayCard(context, data);
          },
          itemCount: isHomeScreen == true
              ? newTransactionList.length < 5
                  ? newTransactionList.length
                  : 5
              : newTransactionList.length,
        );
      },
    ),
  );
}

@override
Widget incomeTransactionListWidget(BuildContext context) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return data.incomeOrExpense == 'Income'
                ? displayCard(context, data)
                : const SizedBox();
          },
          itemCount: newTransactionList.length,
        );
      },
    ),
  );
}

@override
Widget expenseTransactionListWidget(BuildContext context) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return data.incomeOrExpense == 'Expense'
                ? displayCard(context, data)
                : const SizedBox();
          },
          itemCount: newTransactionList.length,
        );
      },
    ),
  );
}

@override
Widget todayTransactionListWidget(BuildContext context) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return DateFormat.MMMMd().format(data.selectedDate) ==
                    DateFormat.MMMMd().format(DateTime.now())
                ? displayCard(context, data)
                : const SizedBox();
          },
          itemCount: newTransactionList.length,
        );
      },
    ),
  );
}

@override
Widget lastWeekTransactionListWidget(
  BuildContext context,
) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return data.selectedDate
                    .isAfter(DateTime.now().subtract(const Duration(days: 7)))
                ? displayCard(context, data)
                : const SizedBox();
          },
          itemCount: newTransactionList.length,
        );
      },
    ),
  );
}

@override
Widget lastMonthTransactionListWidget(BuildContext context) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return data.selectedDate
                    .isAfter(DateTime.now().subtract(const Duration(days: 30)))
                ? displayCard(context, data)
                : const SizedBox();
          },
          itemCount: newTransactionList.length,
        );
      },
    ),
  );
}

@override
Widget customDateTransactionListWidget(
    BuildContext context, DateTime customDate) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return DateFormat.yMMMMd().format(data.selectedDate) ==
                    DateFormat.yMMMMd().format(customDate)
                ? displayCard(context, data, isCustom: true)
                : const SizedBox();
          },
          itemCount: newTransactionList.length,
        );
      },
    ),
  );
}

@override
Widget customMonthTransactionListWidget(
    BuildContext context, DateTime customMonth) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return DateFormat.yMMMM().format(data.selectedDate) ==
                    DateFormat.yMMMM().format(customMonth)
                ? displayCard(context, data, isCustom: true)
                : const SizedBox();
          },
          itemCount: newTransactionList.length,
        );
      },
    ),
  );
}

@override
Widget customPeriodTransactionListWidget(BuildContext context,
    DateTime customSelectedFirstDate, DateTime customSelectedLastDate) {
  TransactionDB.instance.refreshUi();
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newTransactionList,
          Widget? _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (ctx, index) {
            final data = newTransactionList[index];
            return data.selectedDate.isAfter(customSelectedFirstDate
                        .subtract(const Duration(days: 1))) &&
                    data.selectedDate.isBefore(
                        customSelectedLastDate.add(const Duration(days: 1)))
                ? displayCard(context, data, isCustom: true)
                : const SizedBox();
          },
          itemCount: newTransactionList.length,
        );
      },
    ),
  );
}

/*transaction displaying card*/
Widget displayCard(BuildContext context, TransactionModel data,
    {bool isCustom = false, bool isSearch = false}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.02,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      leading: CircleAvatar(
        radius: MediaQuery.of(context).size.height * 0.05,
        backgroundColor:
            data.incomeOrExpense == 'Income' ? Colors.green : Colors.red,
        child: data.incomeOrExpense == 'Income'
            ? const Icon(
                Icons.trending_up_outlined,
                color: Colors.white,
              )
            : const Icon(
                Icons.trending_down_outlined,
                color: Colors.white,
              ),
      ),
      title: Text(
        data.categoryTypeName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        DateFormat.MMMMd().format(data.selectedDate),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '₹ ${data.amount}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            child: Text(
              data.note,
              style: const TextStyle(),
            ),
          ),
        ],
      ),
      onTap: () {
        isCustom
            ? null
            : Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditScreen(data: data)));
      },
      onLongPress: () {
        deleteVerification(
          context,
          data.id!,
          isSearch: isSearch,
        );
      },
    ),
  );
}

/*Function for Delete Verification*/
Future<dynamic> deleteVerification(
  BuildContext context,
  String id, {
  bool isSearch = false,
}) async {
  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text(
          'Delete !!',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
            'This transaction will be deleted permanently. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              TransactionDB.instance.deleteTransaction(id);
              Navigator.of(ctx).pop();
              isSearch
                  ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SearchScreen(
                          transactionList: TransactionDB
                              .instance.transactionListNotifier.value)))
                  : null;
            },
            child: const Text('Delete',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
