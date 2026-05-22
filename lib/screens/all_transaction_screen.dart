import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import 'add_edit_transaction_screen.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  String filter = "all";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    final filtered = provider.transactions.where((t) {
      final matchesFilter =
          filter == "all" ||
              (filter == "income" && t.type == "income") ||
              (filter == "expense" && t.type == "expense");

      final matchesSearch =
          t.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
              t.note.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text("All Transactions"),
      ),

      body: Column(
        children: [
          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search transactions...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// FILTER
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildChip("all"),
                _buildChip("income"),
                _buildChip("expense"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// LIST
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("No Transactions"))
                : ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 100,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final t = filtered[index];

                final isExpense = t.type == "expense";

                return _buildSwipeCard(context, t, isExpense, provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 SWIPE CARD
  Widget _buildSwipeCard(
      BuildContext context,
      dynamic t,
      bool isExpense,
      TransactionProvider provider,
      ) {
    return Dismissible(
      key: Key(t.id),

      direction: DismissDirection.horizontal,

      background: _editBackground(),

      secondaryBackground: _deleteBackground(),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _confirmDelete(context);
        }

        if (direction == DismissDirection.startToEnd) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTransactionScreen(transaction: t),
            ),
          );

          return false;
        }

        return false;
      },

      onDismissed: (_) {
        provider.deleteTransaction(t.id);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Transaction deleted")));
      },

      child: Card(
        elevation: 2,

        margin: const EdgeInsets.only(bottom: 14),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

        child: ListTile(
          contentPadding: const EdgeInsets.all(14),

          leading: CircleAvatar(
            radius: 26,

            backgroundColor: isExpense
                ? Colors.red.withOpacity(0.15)
                : Colors.green.withOpacity(0.15),

            child: Icon(
              isExpense ? Icons.arrow_upward : Icons.arrow_downward,
              color: isExpense ? Colors.red : Colors.green,
            ),
          ),

          /// TITLE + NOTE + DATE TIME
          title: Text(
            t.category,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (t.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(t.note),
                ),

              const SizedBox(height: 6),

              /// DATE + TIME
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 13,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    DateFormat.yMMMd().format(t.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(width: 10),

                  const Icon(Icons.access_time, size: 13, color: Colors.grey),

                  const SizedBox(width: 4),

                  Text(
                    DateFormat.jm().format(t.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          /// AMOUNT
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Text(
                "${isExpense ? "-" : "+"} Rs ${t.amount}",

                style: TextStyle(
                  color: isExpense ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                t.type.toUpperCase(),

                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isExpense ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🟢 EDIT BG
  Widget _editBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(18),
      ),

      alignment: Alignment.centerLeft,

      padding: const EdgeInsets.only(left: 20),

      child: const Icon(Icons.edit, color: Colors.white),
    );
  }

  /// 🔴 DELETE BG
  Widget _deleteBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(18),
      ),

      alignment: Alignment.centerRight,

      padding: const EdgeInsets.only(right: 20),

      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  /// DELETE CONFIRM
  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Transaction"),

          content: const Text(
            "Are you sure you want to delete this transaction?",
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () => Navigator.pop(context, true),

              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  /// FILTER CHIP
  Widget _buildChip(String value) {
    final isSelected = filter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: ChoiceChip(
        label: Text(value[0].toUpperCase() + value.substring(1)),

        selected: isSelected,

        selectedColor: const Color(0xFF5B4DCC),

        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),

        onSelected: (_) {
          setState(() {
            filter = value;
          });
        },
      ),
    );
  }
}
