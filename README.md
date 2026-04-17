# FinPal 💰

FinPal is a modern, intuitive personal finance companion app built with Flutter. It helps you take control of your financial life by tracking expenses, analyzing spending patterns, and managing your budget with a premium, user-friendly interface.

## 📲 Download

You can download the latest version of the FinPal APK from the releases page:

[![Download APK](https://img.shields.io/badge/Download-APK-success?style=for-the-badge&logo=android)](https://github.com/shubham24680/FinPal/releases/latest)

## 📸 Screenshots

<p align="center">
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/onboarding.png" width="200" alt="Onboarding" />
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/expense.png" width="200" alt="home" />
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/transaction.png" width="200" alt="Transactions" />
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/profile.png" width="200" alt="Profile" />
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/add_payment.png" width="200" alt="add_payment" />
</p>

## 🚀 Features

- **Smart Expense Tracking**: Quickly log income and expenses with categories and payment methods.
- **Visual Analytics**: Interactive pie charts and financial analysis to understand where your money goes.
- **Transaction History**: Detailed logs grouped by month and day for easy review.
- **Overspent Alerts**: Real-time validation that warns you when your spending exceeds your income.
- **Customizable Profiles**: Personalize your experience with custom avatars and profile details.
- **Smooth Onboarding**: A beautiful guided introduction to help you get started.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) - UI toolkit for building natively compiled applications.
- **State Management**: [Riverpod](https://riverpod.dev) - A reactive caching and state management framework.
- **Local Database**: [Hive](https://docs.hivedb.dev/) - Lightweight and blazing fast key-value database.
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router) - Declarative routing for Flutter.
- **UI Enhancements**: 
  - `flutter_screenutil` for responsive design.
  - `fl_chart` for beautiful data visualization.
  - `flutter_svg` for crisp vector graphics.

## 📂 Project Structure

```text
lib/
├── app/               # Core app config, routing (GoRouter), and initialization
├── core/              # Global components, themes, extensions, and utils
└── features/          # Feature-based modules
    ├── onboarding/    # Introduction flow
    ├── home/          # Main dashboard
    ├── add_payment/   # Income & Expense logging
    ├── profile/       # User profile management
    └── transaction/   # History and detailed logs
```

## 🏗️ Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/shubham24680/FinPal.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run code generation** (for Hive adapters):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the app**:
   ```bash
   flutter run
   ```

## 📋 Future Roadmap (Planning)

- [ ] **Multi-currency Support**: Handle transactions in different currencies with live conversion.
- [ ] **Data Export**: Export your financial data to CSV or PDF reports.
- [ ] **Subscriptions Tracking**: Manage recurring payments and get notified before they are due.
- [ ] **Budget Goals**: Set monthly savings targets and track progress.
- [ ] **Dark Mode**: Add support for sleek dark mode themes.
- [ ] **Cloud Sync**: Optional cloud backup and multi-device synchronization.

---

Made with ❤️ by [Shubham Patel](https://github.com/shubham24680)
