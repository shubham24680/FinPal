# Analysis — Data Flow

> Keep this file updated when models, services, or providers change.

## Overview

Pure computation over **transaction** payments + **settings** options. No Hive persistence. Builds period summaries, trends, and category/method breakdowns for charts and detail screens.

```
UI (AnalysisScreen / Listing / Detail)
  → analysis providers (period, month, selected category)
    → AnalysisCalculator.* (static)
      ← TransactionService.payments
      ← OptionServices (expense categories, payment methods)
```

---

## Models

### `AnalysisModel` (not persisted)

| Field | Type | Default |
|-------|------|---------|
| `id` | `String` | required |
| `title` | `String` | required |
| `amount` | `double` | `0` |
| `count` | `int` | `0` |
| `percentage` | `double` | `0` |
| `color` | `ColorSet` | `primary` |
| `icon` | `String?` | |

Methods: `copyWith(...)`.

### `PeriodAnalysis`

| Field | Type | Default |
|-------|------|---------|
| `period` | `AnalysisPeriod` | `thisMonth` |
| `income` | `double` | `0` |
| `expense` | `double` | `0` |
| `available` | `double` | `0` |
| `analysisPie` | `List<AnalysisModel>` | earned / spent / remaining |
| `expenseTrend` | `List<AnalysisModel>` | |
| `incomeTrend` | `List<AnalysisModel>` | |
| `categories` | `List<AnalysisModel>` | expense by category |
| `methods` | `List<AnalysisModel>` | expense by payment method |

### `CategoryMonthAnalysis`

| Field | Type | Notes |
|-------|------|--------|
| `summary` | `AnalysisModel` | category total + % of month expense |
| `monthExpenseTotal` | `double` | all expenses in month |
| `trend` | `List<AnalysisModel>` | daily spend for that category |
| `methods` | `List<AnalysisModel>` | methods used in that category |
| `range` | `DateTimeRange` | month start → end |

---

## Enums / services

### `AnalysisPeriod`

| Value | Label | `range` |
|-------|-------|---------|
| `thisWeek` | This week | Mon–Sun of current week |
| `thisMonth` | This month | startOfMonth → endOfMonth |
| `lastMonth` | Last month | previous calendar month |
| `thisYear` | This year | Jan 1 → Dec 31 |

Also: `anchorDate`, `previousRange` (comparison window).

### `AnalysisCalculator` (all static)

| Method | Inputs | Returns / purpose |
|--------|--------|-------------------|
| `getCategories` | payments, allCategories, `{limit, onlyWithSpend, month}` | top expense categories (default limit 4); unknown ids → Other |
| `categoryMonthAnalysis` | categoryId, month, payments, category, methods, knownCategories | `CategoryMonthAnalysis` |
| `compute` | period, payments, expenseCategories, paymentMethods, currency, fallbacks, `{month}` | full `PeriodAnalysis` for a month range |
| `getAnalysis` | income, expense, available | pie cards (earned / spent / remaining or Overspent) |
| `getTrend` | payments, period, range | day or month buckets as `AnalysisModel` list |
| `categoryBreakdown` | payments, categories, totalAmount, `{fallback}` | group by `categoryId` |
| `methodBreakdown` | payments, methods, total, `{fallback}` | group by `paymentMethodId` |
| `inRange` | date, range | inclusive date check |
| `sumByType` | payments, `TransactionType` | sum amounts for type |
| `breakdownPayments` | byId map, options, totalAmount, `{fallback}` | shared row builder + % + sort desc |
| `matchesCategory` | paymentCategoryId, categoryId, knownCategories | public match after resolving Other |
| `_resolvedOptionId` | optionId, knownIds | empty/unknown → Other |
| `_matchesResolvedOption` | … | private equality after resolve |

**Note:** `compute` currently builds range from `(month ?? now).startOfMonth` → `endOfMonth` (period.range is commented out).

---

## Providers

| Provider | Type | Role |
|----------|------|------|
| `analysisPeriodProvider` | `StateProvider<AnalysisPeriod>` | selected period chip |
| `hideBalanceProvider` | `StateProvider<bool>` | UI hide amounts |
| `selectedCategoryIdProvider` | `StateProvider<String?>` | detail screen target |
| `categoriesMonthProvider` | `StateProvider<DateTime>` | month for category listing |

### Navigation helpers

| Function | Behavior |
|----------|----------|
| `openCategoriesList(ref, context)` | set month = now → push categories route |
| `openCategoryDetail(ref, context, categoryId)` | set selected id → push detail route |

---

## Data flow

### Main analysis screen

```
AnalysisScreen
  → watch transactionProvider.payments
  → watch optionNotifer (expenseCategories, paymentMethods)
  → watch analysisPeriodProvider / month
  → AnalysisCalculator.compute(...)
      → PeriodAnalysis
        → analysisPie / trends / categories / methods widgets
```

### Category listing (home or analysis)

```
payments + expense options
  → AnalysisCalculator.getCategories(..., month:, limit:, onlyWithSpend:)
    → CategoriesCard / ListingScreen
```

### Category detail

```
selectedCategoryIdProvider + categoriesMonthProvider
  → AnalysisCalculator.categoryMonthAnalysis(...)
    → summary, trend, methods
```

### Cross-feature inputs

| Source feature | Data |
|----------------|------|
| **transaction** | `List<PaymentModel>` |
| **settings** | expense `OptionModel`s, payment method `OptionModel`s, currency for display |
| **home** | may call `getCategories` for preview cards |

---

## Key files

| Path | Role |
|------|------|
| `data/models/analysis_model.dart` | AnalysisModel, PeriodAnalysis, CategoryMonthAnalysis |
| `data/services/analysis_calculator.dart` | all aggregations |
| `data/services/analysis_period.dart` | period enum + ranges |
| `data/notifiers/analysis_provider.dart` | UI state + navigation |
| `constants/constants.dart` | AnalysisConstants (pie templates) |
| `presentation/screens/*` | analysis / listing / detail |
| `presentation/widgets/*` | cards, chart, chips, breakdown |
