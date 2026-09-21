# Home — Data Flow

> Keep this file updated when models, services, or providers change.

## Overview

Shell + dashboard UI. No Hive models of its own. Reads **transaction** totals/recent payments, **settings** options/currency/hide-balance, and **analysis** category helpers to render the home screen and bottom nav.

```
ScreensWithNavbar (nav index)
  → HomeScreen
      ← transactionProvider (balance, recent, categories)
      ← optionNotifer / settingsNotifier
      ← AnalysisCalculator.getCategories (optional)
```

---

## Models

### `NavModel` (UI only)

| Field | Type | Notes |
|-------|------|--------|
| `id` | `String` | tab id |
| `page` | `Widget` | tab body |
| `selectedIcon` | `String?` | |
| `unselectedIcon` | `String?` | |
| `title` | `String?` | |

Defined in `data/models/helper_model.dart`. Tab list typically lives in `home_constants.dart`.

---

## Services

None in this feature. Consumes:

| Feature | API used on home |
|---------|------------------|
| **transaction** | `availableBalance`, `totalIncome`, `totalExpense`, `getRecentTransactions`, payment lists |
| **settings** | `OptionServices` (categories), `hideBalanceOnHome`, currency format |
| **analysis** | `AnalysisCalculator.getCategories` for category spend cards |

---

## Providers

| Provider | Type | Role |
|----------|------|------|
| `navProvider` | `StateProvider<int>` | selected bottom-nav index |

---

## Data flow

### Bottom navigation

```
ScreensWithNavbar
  → watch navProvider
  → NavModel list → selected page (Home / Transactions / Analysis / Settings)
```

### Home dashboard

```
HomeScreen
  → transactionProvider.value
      → availableBalance / income / expense
      → getRecentTransactions()
  → settings: hideBalanceOnHome, currency formatting
  → optionNotifer + AnalysisCalculator.getCategories(...)
      → CategoriesCard
  → FAB → navigate to add transaction (clears selectedTransaction)
```

### Cross-feature

| Direction | What |
|-----------|------|
| home → transaction | open add/edit payment |
| home → analysis | open category list/detail helpers |
| home → settings | profile avatar / currency display |

---

## Key files

| Path | Role |
|------|------|
| `data/models/helper_model.dart` | `NavModel` |
| `data/notifiers/home_provider.dart` | `navProvider` |
| `data/constants/home_constants.dart` | nav / home constants |
| `presentation/screens/home_screen.dart` | dashboard |
| `presentation/screens/screens_with_navbar.dart` | shell |
| `presentation/widgets/categories_card.dart` | category preview |
| `presentation/widgets/animated_fab.dart` | add payment FAB |
