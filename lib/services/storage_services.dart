import 'package:get_storage/get_storage.dart';
import '../model/transaction.dart';

class StorageService {

  final box = GetStorage();
  final String key = "transactions";

  /// SAVE DATA
  void saveTransactions(List<TransactionModel> list) {

    List data = list.map((e) => e.toMap()).toList();

    box.write(key, data);
  }

  /// LOAD DATA
  List<TransactionModel> loadTransactions() {

    final data = box.read(key) ?? [];

    return List<TransactionModel>.from(
      data.map((e) => TransactionModel.fromMap(e)),
    );
  }
}