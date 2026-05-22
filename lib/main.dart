import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/splash_screen.dart';
import 'providers/transaction_provider.dart';
import 'providers/category_provider.dart';
import 'providers/setting_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyAppWrapper());
}

/// 🔥 WRAPPER (IMPORTANT)
class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// 🧠 ALL PROVIDERS
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()..loadTransactions(),
        ),

        ChangeNotifierProvider(create: (_) => CategoryProvider()),

        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],

      /// 🎯 SETTINGS CONTROL (DARK MODE)
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Expense Tracker',

            /// 🌗 DARK MODE SWITCH
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            /// ☀️ LIGHT THEME
            theme: ThemeData(
              primaryColor: const Color(0xFF534AB7),
              scaffoldBackgroundColor: const Color(0xFFF8F7FF),
              colorScheme: const ColorScheme.light(primary: Color(0xFF534AB7)),
            ),

            /// 🌙 DARK THEME
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: const Color(0xFF534AB7),
            ),

            /// 🏠 START SCREEN
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
