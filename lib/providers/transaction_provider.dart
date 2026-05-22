import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction.dart';
import '../services/storage_services.dart';

class TransactionProvider extends ChangeNotifier {
  final StorageService storage = StorageService();

  final uuid = const Uuid();

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  TransactionProvider() {
    loadTransactions();
  }

  void loadTransactions() {
    _transactions = storage.loadTransactions();

    _transactions.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
  }

  void addTransaction({
    required double amount,
    required String category,
    required String type,
    required DateTime date,
    required String note,
  }) {
    final transaction = TransactionModel(
      id: uuid.v4(),
      amount: amount,
      category: category,
      type: type,
      date: date,
      note: note,
    );

    _transactions.add(transaction);

    storage.saveTransactions(_transactions);

    loadTransactions();
  }

  void updateTransaction(TransactionModel updated) {
    final index = _transactions.indexWhere((e) => e.id == updated.id);

    if (index != -1) {
      _transactions[index] = updated;

      storage.saveTransactions(_transactions);

      loadTransactions();
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((e) => e.id == id);

    storage.saveTransactions(_transactions);

    notifyListeners();
  }

  void clearAll() {
    _transactions.clear();

    storage.saveTransactions([]);

    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((e) => e.type == 'income')
      .fold(0, (sum, item) => sum + item.amount);

  double get totalExpense => _transactions
      .where((e) => e.type == 'expense')
      .fold(0, (sum, item) => sum + item.amount);

  double get balance => totalIncome - totalExpense;
}
