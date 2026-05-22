import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/transaction.dart';
import '../providers/transaction_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTimeRange? selectedRange;

  /// FILTERED TRANSACTIONS
  List<TransactionModel> getFilteredTransactions(
      List<TransactionModel> transactions,
      ) {
    if (selectedRange == null) {
      return transactions;
    }

    return transactions.where((t) {
      return t.date.isAfter(
        selectedRange!.start.subtract(const Duration(days: 1)),
      ) &&
          t.date.isBefore(selectedRange!.end.add(const Duration(days: 1)));
    }).toList();
  }

  /// PICK DATE RANGE
  Future<void> pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      initialDateRange: selectedRange,
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    final transactions = getFilteredTransactions(provider.transactions);

    /// CATEGORY EXPENSE DATA
    Map<String, double> categoryData = {};

    for (var t in transactions) {
      if (t.type == 'expense') {
        categoryData[t.category] = (categoryData[t.category] ?? 0) + t.amount;
      }
    }

    /// MONTHLY TREND DATA
    Map<String, double> monthlyData = {};

    for (var t in transactions) {
      final month = DateFormat('MMM').format(t.date);

      if (t.type == 'expense') {
        monthlyData[month] = (monthlyData[month] ?? 0) + t.amount;
      }
    }

    final totalExpense = categoryData.values.fold(
      0.0,
          (sum, item) => sum + item,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Analytics"),

        actions: [
          IconButton(
            onPressed: pickDateRange,
            icon: const Icon(Icons.date_range),
          ),
        ],
      ),

      body: transactions.isEmpty
          ? const Center(
        child: Text(
          "No transactions found",
          style: TextStyle(fontSize: 16),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DATE FILTER CARD
            if (selectedRange != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_alt),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "${DateFormat.yMMMd().format(selectedRange!.start)}"
                            " → "
                            "${DateFormat.yMMMd().format(selectedRange!.end)}",
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRange = null;
                        });
                      },
                      child: const Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
              ),

            /// SUMMARY CARDS
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: "Income",
                    value: provider.totalIncome,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _summaryCard(
                    title: "Expense",
                    value: provider.totalExpense,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// PIE CHART TITLE
            const Text(
              "Category Spending",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            /// PIE CHART CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 260,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 55,
                        sections: generatePieSections(
                          categoryData,
                          totalExpense,
                        ),
                      ),
                      swapAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// LEGENDS
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: categoryData.entries.map((e) {
                      final index = categoryData.keys.toList().indexOf(
                        e.key,
                      );

                      final color =
                      chartColors[index % chartColors.length];

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Text(e.key),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// BAR CHART TITLE
            const Text(
              "Monthly Expenses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            /// BAR CHART
            Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),

                  gridData: FlGridData(show: true),

                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final months = monthlyData.keys.toList();

                          if (value.toInt() >= months.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(months[value.toInt()]),
                          );
                        },
                      ),
                    ),
                  ),

                  barGroups: monthlyData.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.value,
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.deepPurple,
                        ),
                      ],
                    );
                  })
                      .toList(),
                ),

                swapAnimationDuration: const Duration(milliseconds: 700),
              ),
            ),

            const SizedBox(height: 24),

            /// LINE CHART TITLE
            const Text(
              "Expense Trend",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            /// LINE CHART
            Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),

                  gridData: FlGridData(show: true),

                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final months = monthlyData.keys.toList();

                          if (value.toInt() >= months.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(months[value.toInt()]),
                          );
                        },
                      ),
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,

                      spots: monthlyData.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          e.value.value,
                        );
                      })
                          .toList(),

                      barWidth: 4,

                      color: Colors.deepPurple,

                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.deepPurple.withOpacity(0.2),
                      ),

                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SUMMARY CARD
  Widget _summaryCard({
    required String title,
    required double value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 10),

          Text(
            "Rs ${value.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// PIE CHART DATA
  List<PieChartSectionData> generatePieSections(
      Map<String, double> data,
      double total,
      ) {
    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;

      final item = entry.value;

      final percentage = ((item.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: item.value,

        title: "$percentage%",

        radius: 90,

        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),

        color: chartColors[index % chartColors.length],
      );
    }).toList();
  }

  /// CHART COLORS
  final List<Color> chartColors = [
    Colors.deepPurple,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.amber,
  ];
}
