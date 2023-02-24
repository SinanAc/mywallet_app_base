import 'package:my_wallet/models/transaction_model.dart';

class ChartData {
  String? categoryTypeName;
  double? amount;

  ChartData({
    this.categoryTypeName,
    this.amount,
  });
}

List<ChartData> chartLogic(List<TransactionModel> transactionList) {
  double value;
  String category;
  List visited = [];
  List<ChartData> newChartData = [];

  for (var i = 0; i < transactionList.length; i++) {
    visited.add(0);
  }

  for (var i = 0; i < transactionList.length; i++) {
    value = transactionList[i].amount;
    category = transactionList[i].categoryTypeName;
    for (var j = i + 1; j < transactionList.length; j++) {
      if (transactionList[i].categoryTypeName ==
          transactionList[j].categoryTypeName) {
        value += transactionList[j].amount;
        visited[j] = -1;
      }
    }
    if (visited[i] != -1) {
      newChartData.add(ChartData(categoryTypeName: category, amount: value));
    }
  }
  return newChartData;
}

class AllChartData {
  String? incomeOrExpense;
  double? amount;

  AllChartData({
    this.incomeOrExpense,
    this.amount,
  });
}

List<AllChartData> allChartLogic(List<TransactionModel> transactionList) {
  double value = 0;
  String incomeExpense;
  List visited = [];
  List<AllChartData> newChartData = [];

  for (var i = 0; i < transactionList.length; i++) {
    visited.add(0);
  }

  for (var i = 0; i < transactionList.length; i++) {
    value = transactionList[i].amount;
    incomeExpense = transactionList[i].incomeOrExpense;
    for (var j = i + 1; j < transactionList.length; j++) {
      if (transactionList[i].incomeOrExpense ==
          transactionList[j].incomeOrExpense) {
        value += transactionList[j].amount;
        visited[j] = -1;
      }
    }

    if (visited[i] != -1) {
      newChartData.add(
        AllChartData(
          incomeOrExpense: incomeExpense,
          amount: value,
        ),
      );
    }
  }
  return newChartData;
}
