# expense_tracer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference. Expense Tracer Personal Expense Tracker
A professional, feature-rich personal finance tracker built with Flutter. Track your income and expenses, visualize spending patterns, manage categories, and stay on top of your finances all stored locally on your device with no internet required.
 App Overview
Expense Tracer is a clean and intuitive mobile application designed to help users manage their personal finances effectively. It provides real-time balance tracking, detailed analytics through interactive charts, category-based expense management, and persistent local storage all wrapped in a modern, professional UI.
Core Features
Transaction Management
•	Add, edit, and delete income or expense transactions
•	Each transaction includes: amount, category, type (income/expense), date, time, and note
•	Swipe right to edit and left to delete transactions directly from the list
•	Future date and time entry is blocked  only current or past datetime is allowed
•	All transactions are automatically sorted by date, newest first
•	Confirmation dialog appears before any deletion to prevent accidental loss
Analytics & Insights
•	Pie Chart Visualizes category-wise expense distribution with percentage labels
•	Bar Chart  Displays monthly expenses grouped by month with gradient-styled bars
•	Line Chart  Shows expense trend over time with a smooth curve and area fill
•	Date Range Filter  Filter all charts and data by a custom date range
•	Summary Cards  Displays total income and total expense side by side
Monthly Summary
•	Balance card with gradient showing current balance, total income, and total expense
•	Category-wise expense breakdown with linear progress bars
•	Each category shows its percentage of total expenses
•	Recent 5 transactions shown for quick reference
Category Management
•	4 built-in default categories (Food, Travel, Bills, Shopping) locked and protected from deletion
•	Create unlimited custom categories with: 
o	A custom name
o	An emoji icon selected from a visual picker (16 options)
o	A color selected from a color picker (8 options)
•	Edit or delete any custom category at any time
•	All categories persist across app restarts via local storage
Preferences & Settings
•	Currency selector: PKR, USD, EUR
•	Dark mode toggle switches the entire app theme instantly
•	Language setting  currently English (designed to be extendable)
•	Clear all data  removes all transactions with a confirmation step
•	Direct navigation to the Category Manager from Settings
 UI & Design
•	Professional Indigo/Violet color scheme with clean white cards
•	Smooth animated transitions on the Launch Screen (fade + slide)
•	Animated toggle button for switching between Expense and Income
•	Animated icon and color pickers in the Category Form
•	Meaningful empty states with icons on every screen
•	Floating snack bars with rounded corners for errors and success messages
•	Consistent border radius, spacing, and typography throughout the app
Key Packages & Libraries
Package	Purpose
flutter	Core cross-platform UI framework
provider	State management using ChangeNotifier pattern
get_storage	Lightweight synchronous local key-value storage
fl_chart	Interactive Pie, Bar, and Line charts
intl	Date and time formatting (DateFormat, TimeOfDay)
uuid	Generates unique IDs (v4) for each transaction
pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  get_storage: ^2.1.1
  fl_chart: ^0.68.0
  intl: ^0.19.0
  uuid: ^4.3.3
          │
          
 Planned Future Enhancements
•	Budget limits per category with overspending alerts
•	Export transactions to CSV or PDF format
•	Recurring transactions (daily, weekly, monthly)
•	Support for multiple wallets or accounts
•	Cloud sync and backup via Firebase
•	Biometric app lock (fingerprint or Face ID)
•	Home screen widget displaying current balance
•	Multi-language support (Urdu, Arabic, and others)
•	Push notifications and spending reminders
________________________________________
 Testing Checklist
•	Add an income transaction and verify balance increases
•	Add an expense transaction and verify balance decreases
•	Edit an existing transaction and confirm changes are saved
•	Delete a transaction via swipe and confirm it is removed
•	Enter a future time and confirm it is rejected
•	Add a custom category and verify it appears in the dropdown
•	Delete a custom category and confirm it is removed
•	Toggle dark mode and confirm theme changes across all screens
•	Change currency and confirm it is reflected in the UI
•	Clear all data and confirm the app shows empty states

"Smart Money Management."
Expense Tracer v1.0.0 — Built for educational and personal use.

