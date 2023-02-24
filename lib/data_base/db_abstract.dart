import 'package:my_wallet/models/transaction_model.dart';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel value);
  Future<void> updateTransaction({required data, required id});
  Future<List<TransactionModel>> getAllTransaction();
  Future<void> deleteTransaction(String id);
}