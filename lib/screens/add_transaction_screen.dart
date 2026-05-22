import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/category.dart';
import '../model/transaction.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String type = "expense";
  String? category;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool get isEdit => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    if (transaction != null) {
      /// EDIT MODE
      amountController.text = transaction.amount.toString();

      noteController.text = transaction.note;

      type = transaction.type;

      category = transaction.category;

      selectedDate = transaction.date;

      selectedTime = TimeOfDay(
        hour: transaction.date.hour,
        minute: transaction.date.minute,
      );
    } else {
      /// ADD MODE
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final categories = context.read<CategoryProvider>().categories;

        if (categories.isNotEmpty) {
          setState(() {
            category = categories.first.name;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  /// DATE PICKER
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// TIME PICKER (NO FUTURE TIME)
  Future<void> pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime == null) return;

    final now = DateTime.now();

    final isToday =
        selectedDate.year == now.year &&
            selectedDate.month == now.month &&
            selectedDate.day == now.day;

    if (isToday) {
      final pickedMinutes = pickedTime.hour * 60 + pickedTime.minute;

      final currentMinutes = now.hour * 60 + now.minute;

      if (pickedMinutes > currentMinutes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Future time not allowed"),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }
    }

    setState(() {
      selectedTime = pickedTime;
    });
  }

  /// ADD CATEGORY DIALOG
  void addCategoryDialog() {
    final controller = TextEditingController();

    String selectedIcon = "none";

    final icons = [
      "none",
      "🍔",
      "🚗",
      "🛒",
      "💼",
      "🎓",
      "🏥",
      "🎮",
      "🏠",
      "✈️",
      "💡",
      "📱",
    ];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: const Text("Add Category"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Category Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose Icon",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: icons.map((icon) {
                        final isSelected = selectedIcon == icon;

                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedIcon = icon;
                            });
                          },

                          child: Container(
                            width: 52,
                            height: 52,

                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF5B4DCC).withOpacity(0.15)
                                  : Colors.grey.shade100,

                              borderRadius: BorderRadius.circular(14),

                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF5B4DCC)
                                    : Colors.transparent,

                                width: 2,
                              ),
                            ),

                            child: Center(
                              child: icon == "none"
                                  ? const Icon(Icons.block, color: Colors.grey)
                                  : Text(
                                icon,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B4DCC),
                  ),

                  onPressed: () {
                    if (controller.text.trim().isEmpty) {
                      return;
                    }

                    final newCategory = CategoryModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),

                      name: controller.text.trim(),

                      icon: selectedIcon,

                      color: Colors.grey,

                      isDefault: false,
                    );

                    context.read<CategoryProvider>().addCategory(newCategory);

                    setState(() {
                      category = newCategory.name;
                    });

                    Navigator.pop(context);
                  },

                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// SAVE TRANSACTION
  void saveTransaction() {
    final amountText = amountController.text.trim();

    if (amountText.isEmpty) {
      _showError("Enter amount");
      return;
    }

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _showError("Invalid amount");
      return;
    }

    if (category == null) {
      _showError("Select category");
      return;
    }

    final now = DateTime.now();

    final isToday =
        selectedDate.year == now.year &&
            selectedDate.month == now.month &&
            selectedDate.day == now.day;

    if (isToday) {
      final selectedMinutes = selectedTime.hour * 60 + selectedTime.minute;

      final currentMinutes = now.hour * 60 + now.minute;

      if (selectedMinutes > currentMinutes) {
        _showError("Future time not allowed");
        return;
      }
    }

    final finalDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final provider = context.read<TransactionProvider>();

    if (isEdit) {
      provider.updateTransaction(
        TransactionModel(
          id: widget.transaction!.id,
          amount: amount,
          category: category!,
          type: type,
          date: finalDateTime,
          note: noteController.text.trim(),
        ),
      );
    } else {
      provider.addTransaction(
        amount: amount,
        category: category!,
        type: type,
        note: noteController.text.trim(),
        date: finalDateTime,
      );
    }

    Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(isEdit ? "Edit Transaction" : "Add Transaction"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              /// TYPE
              Container(
                padding: const EdgeInsets.all(4),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            type = "expense";
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),

                          decoration: BoxDecoration(
                            color: type == "expense"
                                ? Colors.red
                                : Colors.transparent,

                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: Text(
                            "Expense",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: type == "expense"
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            type = "income";
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),

                          decoration: BoxDecoration(
                            color: type == "income"
                                ? Colors.green
                                : Colors.transparent,

                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: Text(
                            "Income",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: type == "income"
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// AMOUNT
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                style: const TextStyle(fontSize: 24),

                decoration: InputDecoration(
                  hintText: "0.00",
                  prefixText: "Rs ",

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CATEGORY
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: category,
                    isExpanded: true,

                    items: [
                      ...categories.map(
                            (e) => DropdownMenuItem<String>(
                          value: e.name,

                          child: Row(
                            children: [
                              if (e.icon != "none")
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(e.icon),
                                ),

                              Text(e.name),
                            ],
                          ),
                        ),
                      ),

                      const DropdownMenuItem<String>(
                        value: "Others",
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 8),
                            Text("Add Category"),
                          ],
                        ),
                      ),
                    ],

                    onChanged: (value) {
                      if (value == "Others") {
                        addCategoryDialog();
                      } else {
                        setState(() {
                          category = value;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DATE + TIME
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: pickDate,

                      child: Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),

                            const SizedBox(width: 10),

                            Text(DateFormat.yMMMd().format(selectedDate)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: pickTime,

                      child: Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.access_time),

                            const SizedBox(width: 10),

                            Text(selectedTime.format(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// NOTE
              TextField(
                controller: noteController,
                maxLines: 4,

                decoration: InputDecoration(
                  hintText: "Add note...",

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B4DCC),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: saveTransaction,

                  child: Text(
                    isEdit ? "Update Transaction" : "Save Transaction",

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
