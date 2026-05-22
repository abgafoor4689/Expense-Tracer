import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class MonthlySummaryScreen extends StatelessWidget {
  const MonthlySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    /// CATEGORY TOTALS
    Map<String, double> categoryTotals = {};

    for (var t in provider.transactions) {
      if (t.type == "expense") {
        categoryTotals[t.category] =
            (categoryTotals[t.category] ?? 0) + t.amount;
      }
    }

    final transactions = provider.transactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Monthly Summary"),
      ),

      body: transactions.isEmpty
          ? _emptyState()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// BALANCE CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B4DCC), Color(0xFF7B61FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.2),

                    blurRadius: 10,

                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Current Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Rs ${provider.balance.toStringAsFixed(0)}",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _summaryItem(
                          title: "Income",
                          amount: provider.totalIncome,

                          color: Colors.greenAccent,

                          icon: Icons.arrow_downward,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: _summaryItem(
                          title: "Expense",
                          amount: provider.totalExpense,

                          color: Colors.redAccent,

                          icon: Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// SECTION TITLE
            const Text(
              "Expense Breakdown",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            /// CATEGORY LIST
            ...categoryTotals.entries.map((e) {
              final percent = provider.totalExpense == 0
                  ? 0
                  : (e.value / provider.totalExpense) * 100;

              return Card(
                elevation: 2,

                margin: const EdgeInsets.only(bottom: 14),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.red.withOpacity(0.12),

                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.red,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [
                                Text(
                                  e.key,

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,

                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "${percent.toStringAsFixed(1)}% of expenses",

                                  style: TextStyle(
                                    color: Colors.grey.shade600,

                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            "Rs ${e.value.toStringAsFixed(0)}",

                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// PROGRESS BAR
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: LinearProgressIndicator(
                          value: percent / 100,

                          minHeight: 8,

                          backgroundColor: Colors.grey.shade200,

                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF5B4DCC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            /// RECENT ACTIVITY
            const Text(
              "Recent Activity",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            ...transactions.take(5).map((t) {
              final isExpense = t.type == "expense";

              return Card(
                elevation: 2,

                margin: const EdgeInsets.only(bottom: 12),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),

                  leading: CircleAvatar(
                    backgroundColor: isExpense
                        ? Colors.red.withOpacity(0.12)
                        : Colors.green.withOpacity(0.12),

                    child: Icon(
                      isExpense
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,

                      color: isExpense ? Colors.red : Colors.green,
                    ),
                  ),

                  title: Text(
                    t.category,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      if (t.note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(t.note),
                        ),

                      const SizedBox(height: 4),

                      Text(
                        DateFormat.yMMMd().add_jm().format(t.date),

                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  trailing: Text(
                    "${isExpense ? "-" : "+"} Rs ${t.amount.toStringAsFixed(0)}",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,

                      fontSize: 16,

                      color: isExpense ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// EMPTY STATE
  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.pie_chart_outline, size: 90, color: Colors.grey),

          SizedBox(height: 16),

          Text(
            "No Summary Available",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 8),

          Text(
            "Add transactions to see monthly insights",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// SUMMARY ITEM
  Widget _summaryItem({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),

            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  "Rs ${amount.toStringAsFixed(0)}",

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,

                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
