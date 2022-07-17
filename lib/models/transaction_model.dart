import 'package:hive_flutter/hive_flutter.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String incomeOrExpense;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String categoryTypeName;

  @HiveField(4)
  final DateTime selectedDate;

  @HiveField(5)
  final String note;

  TransactionModel({
    this.id,
    required this.incomeOrExpense,
    required this.amount,
    required this.categoryTypeName,
    required this.selectedDate,
    required this.note,
  });
}
