class TransactionModel {
  String id;
  double amount;
  String category;
  String type;
  DateTime date;
  String note;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'category': category,
    'type': type,
    'date': date.toIso8601String(),
    'note': note,
  };

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      category: map['category'],
      type: map['type'],
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }
}
