import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/setting_provider.dart';
import '../providers/transaction_provider.dart';
import 'categories_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FF),

          appBar: AppBar(
            backgroundColor: const Color(0xFF534AB7),
            centerTitle: true,
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 👤 PROFILE CARD
                _settingsCard(
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF534AB7),
                        child: Text(
                          "PKR",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Ayesha Perveen",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Personal account",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ⚙️ PREFERENCES
                _sectionLabel("PREFERENCES"),

                _settingsCard(
                  child: Column(
                    children: [
                      /// 💱 Currency
                      _settingsRow(
                        icon: '💱',
                        label: 'Currency',
                        trailing: DropdownButton<String>(
                          value: provider.currency,
                          underline: const SizedBox(),
                          items: ['PKR', 'USD', 'EUR']
                              .map(
                                (c) =>
                                DropdownMenuItem(value: c, child: Text(c)),
                          )
                              .toList(),
                          onChanged: (val) => provider.setCurrency(val!),
                        ),
                      ),

                      _divider(),

                      /// 🌙 Dark Mode
                      _settingsRow(
                        icon: '🌙',
                        label: 'Dark mode',
                        trailing: Switch(
                          value: provider.isDarkMode,
                          activeThumbColor: const Color(0xFF534AB7),
                          onChanged: (_) => provider.toggleDarkMode(),
                        ),
                      ),

                      _divider(),

                      _settingsRow(
                        icon: '🌐',
                        label: 'Language',
                        trailing: const Text(
                          "English ›",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 📂 DATA
                _sectionLabel("DATA"),

                _settingsCard(
                  child: Column(
                    children: [
                      /// 📁 Categories
                      _settingsRow(
                        icon: Icons.category_outlined,
                        label: 'Categories',
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CategoriesScreen(),
                            ),
                          );
                        },
                      ),

                      _divider(),

                      /// 🗑 Clear Data
                      _settingsRow(
                        icon: Icons.delete_outline,
                        label: 'Clear all data',
                        labelColor: Colors.red,
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.red,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Clear all data"),
                              content: const Text(
                                "This will delete all transactions.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Provider.of<TransactionProvider>(
                                      context,
                                      listen: false,
                                    ).clearAll();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Data cleared"),
                                      ),
                                    );
                                  },
                                  child: const Text("Clear"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// FOOTER
                const Center(
                  child: Text(
                    "SpendWise v1.0.0",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= WIDGETS =================

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _settingsCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD3D1C7), width: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _settingsRow({
    required dynamic icon,
    required String label,
    required Widget trailing,
    VoidCallback? onTap,
    Color? labelColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            icon is String
                ? Text(icon, style: const TextStyle(fontSize: 18))
                : Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: labelColor ?? Colors.black),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 0.5, color: Color(0xFFD3D1C7));
  }
}
