# FinPal 💰

FinPal is a modern, intuitive personal finance companion built with Flutter. Track income and expenses, visualize spending, review transaction history, and get AI-powered financial guidance — all with a clean, premium interface.

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.7+-0175C2?style=flat-square&logo=dart&logoColor=white" alt="Dart"></a>
  <a href="https://riverpod.dev"><img src="https://img.shields.io/badge/Riverpod-2.x-00A4A6?style=flat-square" alt="Riverpod"></a>
  <a href="https://github.com/shubham24680/FinPal/releases/latest"><img src="https://img.shields.io/github/v/release/shubham24680/FinPal?style=flat-square&label=Release" alt="Release"></a>
</p>

---

## Table of Contents

- [Download](#-download)
- [Screenshots](#-screenshots)
- [Features](#-features)
- [Privacy & Data](#-privacy--data)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Legal](#-legal)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)

---

## 📲 Download

Download the latest Android APK from the releases page:

[![Download APK](https://img.shields.io/badge/Download-APK-success?style=for-the-badge&logo=android)](https://github.com/shubham24680/FinPal/releases/latest)

> FinPal currently targets **Android**. iOS, macOS, and web project folders are included for future support.

---

## 📸 Screenshots

<p align="center">
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/onboarding.png" width="200" alt="Onboarding" />
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/expense.png" width="200" alt="Dashboard" />
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/transaction.png" width="200" alt="Transactions" />
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/profile.png" width="200" alt="Profile" />
  <img src="https://github.com/shubham24680/FinPal/blob/main/assets/res/add_payment.png" width="200" alt="Add Payment" />
</p>

---

## 🚀 Features

### Core Finance
- **Income & Expense Tracking** — Log transactions with amount, date, category, payment method, and optional notes.
- **Visual Analytics** — Interactive pie charts and balance cards to understand spending at a glance.
- **Transaction History** — Browse records grouped by month and day with date filtering.
- **Transaction Overview** — Drill into grouped transactions for a detailed breakdown.
- **Overspent Alerts** — Real-time validation warns you when expenses exceed income.
- **Swipe Actions** — Swipe transactions to edit or delete them quickly.

### Personalization
- **Custom Categories** — Manage your own income and expense categories.
- **Payment Methods** — Add and organize payment methods (UPI, cash, cards, etc.).
- **Profile** — Set a display name and choose from built-in avatars.
- **Smooth Onboarding** — Guided first-run experience with loading states for a polished setup flow.

---

## 🔒 Privacy & Data

FinPal is designed with a **local-first** approach:

| Data | Storage |
|------|---------|
| Profile, transactions, categories, payment methods | On-device (Hive) |
| Receipt images & avatars | On-device (app storage) |

- No account or sign-up required
- No data leaves your device
- No bank login or credential collection
- Uninstalling the app removes locally stored data from your device

See the hosted [Privacy Policy](https://shubham24680.github.io/policy/finpal-privacy-policy.html) and [Terms & Conditions](https://shubham24680.github.io/policy/finpal-terms-and-conditions.html) for full details. Source copies live in the `docs/` folder.

---

## 🛠️ Tech Stack

| Layer | Tools |
|-------|-------|
| **Framework** | [Flutter](https://flutter.dev) |
| **State Management** | [Riverpod](https://riverpod.dev) |
| **Local Database** | [Hive](https://docs.hivedb.dev/) |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) |
| **Charts** | [fl_chart](https://pub.dev/packages/fl_chart) |
| **UI** | `flutter_screenutil`, `flutter_svg`, `flutter_native_splash`, `shimmer` |
| **Other** | `image_picker`, `path_provider`, `url_launcher`, `uuid`, `intl`, `package_info_plus` |

---

## 📂 Project Structure

```text
lib/
├── app/                    # App bootstrap, theme, routing (GoRouter)
├── core/
│   ├── customs/            # Reusable UI components (buttons, typography, etc.)
│   ├── local_storage/      # Hive local database
│   └── utils/              # Colors, widgets, constants
└── features/               # Feature-first modules
    ├── onboarding/         # Splash, introduction, personal details
    ├── home/               # Shell, bottom navigation
    ├── expense/            # Dashboard, balance card, category charts
    ├── add_payment/        # Add / edit income & expense
    ├── transaction/        # History, swipe actions, overview
    └── profile/            # Profile, categories, payment methods, legal links

docs/
├── finpal-privacy-policy.html
└── finpal-terms-and-conditions.html
```

---

## 🏗️ Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x)
- Dart `^3.7.2`
- Android Studio / VS Code with Flutter extensions
- A physical device or emulator running Android 7.0 (API 24) or newer

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/shubham24680/FinPal.git
   cd FinPal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build APK

```bash
flutter build apk --release
```

The output APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📄 Legal

Legal pages are available in the `docs/` folder and are hosted on GitHub Pages:

- [Privacy Policy](https://shubham24680.github.io/policy/finpal-privacy-policy.html)
- [Terms & Conditions](https://shubham24680.github.io/policy/finpal-terms-and-conditions.html)

In-app links in Profile point to these URLs via `lib/features/profile/profile_constants.dart`.

---

## 📋 Roadmap

- [ ] **Passcode & App Lock** — 6-digit passcode with lock screen on launch.
- [ ] **Biometric Authentication** — Fingerprint unlock on the lock screen (with passcode fallback).
- [ ] **FinPal AI** — Chat-based finance assistant for budgeting tips and spending insights.
- [ ] **Multi-currency Support** — Handle transactions in different currencies with live conversion.
- [ ] **Data Export** — Export financial data to CSV or PDF reports.
- [ ] **Subscriptions Tracking** — Manage recurring payments and get notified before they are due.
- [ ] **Budget Goals** — Set monthly savings targets and track progress.
- [ ] **Dark Mode** — Full dark theme support across the app.
- [ ] **Cloud Sync** — Optional cloud backup and multi-device synchronization.
- [ ] **iOS Release** — App Store build and distribution.

---

## 🤝 Contributing

Contributions are welcome! To get started:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Open a pull request against `main`

Please keep changes focused and follow the existing feature-based folder structure.

---

Made with ❤️ by [Shubham Patel](https://github.com/shubham24680)
