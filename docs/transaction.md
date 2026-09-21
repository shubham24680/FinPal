# Transaction — Data Flow

> Keep this file updated when models, services, or providers change.

## Overview

Owns payment CRUD and transaction queries. Persists `PaymentModel` in Hive. Depends on **settings** (`OptionModel` / `OptionServices`) for category and payment-method resolution.

```
UI (screens/widgets)
  → PaymentProvider / TransactionNotifier
    → TransactionService
      → HiveService<PaymentModel> (payment box)
```

---

## Models

### `PaymentModel` (Hive typeId: 5)

| Field | Type | Notes |
|-------|------|--------|
| `id` | `String` | UUID v7 if empty |
| `paymentType` | `String` | `TransactionType.income.id` / `expense.id` |
| `amount` | `double` | |
| `date` | `DateTime` | defaults to now |
| `categoryId` | `String` | defaults to `OptionsConstant.otherCategory.id` |
| `paymentMethodId` | `String` | defaults to `OptionsConstant.otherCategory.id` |
| `notes` | `String` | default `""` |
| `createdAt` | `DateTime` | |
| `updatedAt` | `DateTime` | |
| `receiptPath` | `String` | local file path; default `""` |

Methods: `copyWith(...)`.

### `TransactionHelperModel` (UI helper, not persisted)

| Field | Type |
|-------|------|
| `icon` | `String` |
| `label` | `String` |
| `value` | `String` |
| `valueColor` | `Color?` |

### `PaymentState` (form state in `payment_provider.dart`)

| Field | Type | Notes |
|-------|------|--------|
| `id` | `String?` | null = new payment |
| `type` | `TransactionType` | |
| `initialAmount` | `double` | signed delta when editing |
| `amount` | `String` | formatted input |
| `date` | `String` | formatted date-time |
| `category` | `OptionModel?` | |
| `paymentMethod` | `OptionModel?` | |
| `buttonState` | `ButtonState` | |
| `overspent` | `String` | |
| `notes` | `String` | |
| `receiptPath` | `String` | |
| `createdAt` | `DateTime?` | |
| `toastType` / `toastMessage` | toast feedback | |
| `helperText` / `helperTextColor` | balance preview | |

---

## Enums / constants

### `TransactionType`

| Value | `id` | Linked `OptionType` |
|-------|------|---------------------|
| `income` | `"income"` | `OptionType.income` |
| `expense` | `"expense"` | `OptionType.expense` |

### `ReceiptUtils`

| Method | Returns | Purpose |
|--------|---------|---------|
| `validateReceipt(path)` | `String?` | null if OK; else error message (exists, extension, size ≤ 5MB) |
| `fileName(path)` | `String` | last path segment |

---

## Services

### `TransactionService`

Storage: `HiveService<PaymentModel>` + in-memory `_cache`, `_totalIncome`, `_totalExpense`.

#### CRUD

| Method | Signature | Behavior |
|--------|-----------|----------|
| `save` | `(PaymentModel) → Future<void>` | upsert by id; clears cache |
| `saveAll` | `(List<PaymentModel>) → Future<void>` | batch upsert; clears cache |
| `delete` | `(String id) → Future<void>` | remove + discard receipt file |
| `clearData` | `() → Future<void>` | wipe box + all receipts |
| `clearCache` | `() → void` | reset cache + totals |

#### Getters / queries

| Method | Returns | Behavior |
|--------|---------|----------|
| `payments` | `List<PaymentModel>` | cached `getAllData()` |
| `getPayment(id)` | `PaymentModel?` | by id |
| `totalIncome` | `double` | sum of income payments |
| `totalExpense` | `double` | sum of expense payments |
| `availableBalance` | `double` | income − expense |
| `incomeTransactions` | `List<PaymentModel>` | filter by income type |
| `expenseTransactions` | `List<PaymentModel>` | filter by expense type |
| `getRecentTransactions({limit})` | `List<PaymentModel>` | newest first, default limit 5 |
| `getMonthlyTransactions(month)` | `List<List<PaymentModel>>` | days in month, newest day first |
| `getTransactionsByDate(date)` | `List<PaymentModel>` | same day |
| `filterTransactions(groups, typeFilter)` | `List<List<PaymentModel>>` | filter day groups by type |
| `transactionByCategories(options)` | category + payments rows | sorted by payment count desc |
| `transactionByCategory(option)` | `List<PaymentModel>` | by `categoryId` |
| `paymentsInRange(start, end)` | `List<PaymentModel>` | inclusive date range |
| `totalIncomeInRange(start, end)` | `double` | |
| `totalExpenseInRange(start, end)` | `double` | |
| `expensesByCategoryInRange(...)` | category / amount / count | expense only, amount desc |
| `expensesByMethodInRange(...)` | method / amount / count | expense only, amount desc |
| `expenseTrendInRange(...)` | date / amount points | daily or monthly (`byMonth`) |

---

## Providers

| Provider | Type | Role |
|----------|------|------|
| `paymentBoxProvider` | `Provider<Box<PaymentModel>>` | Hive box (overridden at app start) |
| `transactionProvider` | `AsyncNotifierProvider → TransactionService` | service lifecycle + save/delete/clear |
| `selectedDateProvider` | `StateProvider<DateTime>` | calendar / list day |
| `transactionTypeFilterProvider` | `StateProvider<TransactionType?>` | income/expense filter |
| `transactionAppbarProvider` | `StateProvider.family<bool, String>` | app bar UI flag |
| `selectedTransactionProvider` | `StateProvider<PaymentModel?>` | payment being edited |
| `paymentProvider` | `StateNotifierProvider → PaymentState` | add/edit form |

### `PaymentProvider` methods

| Method | Purpose |
|--------|---------|
| `set(...)` | update form fields; validates receipt |
| `onChange()` | enable/disable save button |
| `checkSpent()` | helper text vs available balance |
| `save()` | builds `PaymentModel` → `transactionProvider.save` |
| `clearToast()` / `_showError` | toast handling |

---

## Data flow

### Create / update payment

```
EditTransactionScreen
  → paymentProvider.set(...) / save()
    → PaymentModel(categoryId, paymentMethodId from OptionModel)
      → TransactionNotifier.save
        → TransactionService.save → Hive
```

### Read transactions (list / home / analysis)

```
transactionProvider (TransactionService)
  → payments / getMonthlyTransactions / paymentsInRange / …
    → UI or AnalysisCalculator
```

### Cross-feature

| From | To | What |
|------|----|------|
| settings `OptionServices` | payment form | `findById` for category / method |
| settings `OptionModel.id` | `PaymentModel.categoryId` / `paymentMethodId` | FK-like refs |
| transaction `payments` | analysis / home | raw payment list for aggregations |

---

## Key files

| Path | Role |
|------|------|
| `data/models/payment_model.dart` | persisted model |
| `data/models/transaction_helper_model.dart` | UI row helper |
| `data/services/transaction_service.dart` | CRUD + queries |
| `data/receipt_utils.dart` | receipt validation |
| `data/notifiers/transaction_provider.dart` | service notifier |
| `data/notifiers/payment_provider.dart` | form state |
| `presentation/screens/*` | UI |
