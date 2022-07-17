// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_wallet/models/transaction_model.dart';
import 'package:my_wallet/screens/splash_screen.dart';
import 'package:my_wallet/widgets/dark_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const transactionDbName = 'transaction_db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel value);
  Future<void> updateTransaction({required data, required id});
  Future<List<TransactionModel>> getAllTransaction();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel value) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    transactionDB.put(value.id, value);
    refreshUi();
  }

  @override
  Future<List<TransactionModel>> getAllTransaction() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    return transactionDB.values.toList();
  }

  Future<void> refreshUi() async {
    final transactionList = await getAllTransaction();
    transactionList.sort((a, b) => b.selectedDate.compareTo(a.selectedDate));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(transactionList);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> updateTransaction({required data, required id}) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    transactionDB.put(id, data);
    refreshUi();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.delete(id);
    refreshUi();
  }
}



Future<void> appReset(ctx) async {
  final themeChange = Provider.of<DarkThemeProvider>(ctx,listen: false);
  themeChange.darkTheme=false;
  final transactionDB = await Hive.openBox<TransactionModel>(transactionDbName);
  transactionDB.clear();
  final pref= await SharedPreferences.getInstance();
  pref.clear();
  Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const SplashScreen()),
      (route) => false);
}

