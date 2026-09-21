# Settings — Data Flow

> Keep this file updated when models, services, or providers change.

## Overview

Owns app preferences, user profile, and options (income/expense categories + payment methods). Other features resolve category/method names and currency through this layer.

```
UI
  → OptionProvider / ProfileProvider / SettingsNotifier
    → OptionServices | HiveService<ProfileModel> | HiveService<SettingsModel>
      → Hive boxes (options / profile / settings)
```

---

## Models

### `SettingsModel` (Hive typeId: 0) — key: `"settings"`

| Field | Type | Default |
|-------|------|---------|
| `id` | `String` | UUID |
| `isFirstVisit` | `bool` | `true` |
| `isFingerprintEnabled` | `bool` | `false` |
| `isPasscodeEnabled` | `bool` | `false` |
| `currencyCode` | `String` | `'INR'` |
| `currencySymbol` | `String` | `'₹'` |
| `languageCode` | `String` | `'en'` |
| `themeMode` | `String` | `'system'` |
| `hideBalanceOnHome` | `bool` | `false` |
| `dailyReminderEnabled` | `bool` | `false` |
| `dailyReminderTime` | `DateTime?` | |
| `monthlyBudget` | `double` | `0` |
| `aiInsightsEnabled` | `bool` | `false` |

Methods: `copyWith(...)`.

### `SettingsContentModel` (UI tile config, not persisted)

| Field | Type |
|-------|------|
| `id`, `title`, `subtitle`, `actionText` | `String` |
| `icon` | `String` |
| `iconColor`, `iconBgColor`, `iconBgDarkColor?` | `Color` |
| `actionType` | `ActionType` |
| `path` | `String` |
| `value` | `bool` |

### `ActionType`

`none` | `toggle` | `navigate` | `launchUrl` | `bottomSheet` | `dialog`

### `ProfileModel` (Hive typeId: 1) — key: `"user"`

| Field | Type | Default |
|-------|------|---------|
| `id` | `String` | UUID v4 |
| `profileImage` | `String` | `""` |
| `name` | `String` | `""` |
| `dob` | `String` | `""` |
| `gender` | `String` | `""` |
| `email` | `String` | `""` |
| `phone` | `String` | `""` |
| `monthlyIncome` | `double?` | |
| `createdAt` | `DateTime?` | now |

Methods: `copyWith(...)` (supports `clearMonthlyIncome`).

### `ProfileContentModel` (progress step UI)

| Field | Type |
|-------|------|
| `id`, `title`, `icon`, `value` | `String` |
| `color` | `ColorSet` |
| `isCompleted` | `bool` |

### `OptionModel` (Hive typeId: 2)

| Field | Type | Default |
|-------|------|---------|
| `id` | `String` | UUID v4 if empty |
| `type` | `String` | `OptionType.*.id` |
| `name` | `String` | |
| `icon` | `String` | `""` |
| `color` | `String` | color set name |
| `isMandatory` | `bool` | `false` |

Methods: `copyWith(...)`.

### Form states

**`OptionState`**: `id?`, `icon`, `name`, `color`, `type?`, `buttonState`, `toastType`, `message`

**`ProfileState`**: `profileImage`, `name`, `dob`, `gender`, `monthlyIncome?`, `buttonState`

---

## Enums / constants

### `OptionType`

| Value | `id` | UI name |
|-------|------|---------|
| `income` | `"income_category"` | Income Category |
| `expense` | `"expense_category"` | Expense Category |
| `paymentMethod` | `"payment_method"` | Payment Method |

### `SortType`

`ascending` | `descending`

### `OptionsConstant`

- `otherCategory` — fallback option (`id: "other_category"`)
- `allOptions` — seeded defaults (used by onboarding)

---

## Services

### `OptionServices`

Storage: `HiveService<OptionModel>` + `_cache`.

#### CRUD

| Method | Signature | Behavior |
|--------|-----------|----------|
| `save` | `(OptionModel) → Future<void>` | upsert; clear cache |
| `saveAll` | `(List<OptionModel>) → Future<void>` | batch upsert |
| `delete` | `(String id) → Future<void>` | remove by id |
| `clearData` | `() → Future<void>` | wipe all options |
| `clearCache` | `() → void` | |

#### Getters

| Getter | Returns |
|--------|---------|
| `categories` | all options (cached) |
| `incomeCategories` | `byType(OptionType.income.id)` |
| `expenseCategories` | `byType(OptionType.expense.id)` |
| `paymentMethods` | `byType(OptionType.paymentMethod.id)` |

#### Filters / lookup

| Method | Signature | Behavior |
|--------|-----------|----------|
| `findById` | `(String id) → OptionModel` | Hive get or `otherCategory` |
| `findByName` | `(name, type) → OptionModel` | or `otherCategory` |
| `findByNameOrNull` | `(name, type, {excludeId}) → OptionModel?` | case-insensitive name match |
| `existsByName` | `(name, type, {excludeId}) → bool` | duplicate check |
| `byType` | `(type, {excludeId}) → List<OptionModel>` | filter by `OptionModel.type` |
| `byTypeSorted` | `(type, {sortType, isMandatory}) → List` | name sort; optional mandatory-first; asc/desc |

### `ProfileProgress`

Wraps `List<ProfileContentModel> steps`.

| Getter | Meaning |
|--------|---------|
| `current` | index of first incomplete step |
| `completed` / `total` | counts |
| `fraction` / `percent` | progress |
| `isComplete` | all steps done |

### Currency helpers (`currency_format_extension.dart`)

On `Ref` / `WidgetRef`: `formatCurrency`, `formatSignedCurrency`, `formatCurrencyInput`, `formatAmountForInput`, `parseCurrency`, etc. — all read `currencyProvider` from settings.

---

## Providers

| Provider | Type | Role |
|----------|------|------|
| `settingsBoxProvider` | `Box<SettingsModel>` | Hive box override |
| `settingsNotifier` | `AsyncNotifier → SettingsModel` | load/save settings |
| `themeProvider` | `Provider<ThemeMode>` | derived from settings |
| `currencyProvider` | `Provider<CurrencyContants>` | derived from settings |
| `appVersionProvider` | `FutureProvider<String>` | package version |
| `toggleProvider` | `Provider.family<bool, String>` | e.g. `hide_balance` |
| `profileBoxProvider` | `Box<ProfileModel>` | |
| `profileNotifier` | `AsyncNotifier → ProfileModel` | persist profile (`key: user`) |
| `profileProvider` | `StateNotifier → ProfileState` | edit form |
| `optionBoxProvider` | `Box<OptionModel>` | |
| `optionNotifer` | `AsyncNotifier → OptionServices` | service lifecycle |
| `optionProvider` | `StateNotifier → OptionState` | add/edit option form |
| `selectedOptionProvider` | `StateProvider<OptionModel?>` | option being edited |

### Notable notifier methods

**`SettingsNotifier.save(...)`** — partial update of settings fields.

**`ProfileNotifier`**: `save(...)`, `clearData()` (discards old avatar after successful save).

**`ProfileProvider`**: `setName/Dob/Gender/MonthlyIncome/ProfileImage`, `onSubmit({skipValidation, setDefaultData})` — can call onboarding `setupDefaultData`.

**`OptionNotifier`**: `saveOption`, `saveAllOptions`, `deleteOption`, `clearData`.

**`OptionProvider`**: `set`, `onChange`, `save` (duplicate name check via `existsByName`), `resetToast`.

---

## Data flow

### Options list (income / expense / methods)

```
OptionsScreen
  → optionNotifer → OptionServices
    → byTypeSorted(OptionType.income.id, sortType: ascending)
    → byTypeSorted(OptionType.expense.id, …)
    → byTypeSorted(OptionType.paymentMethod.id, …)
```

### Save option

```
EditOptionScreen → optionProvider.save()
  → existsByName → OptionModel → optionNotifer.saveOption → Hive
```

### Profile + first-run defaults

```
PersonalDetails / EditProfile
  → profileProvider.onSubmit(setDefaultData: true?)
    → profileNotifier.save
    → onboardingProvider.setupDefaultData
      → optionNotifer.saveAllOptions(OptionsConstant.allOptions)
      → settingsNotifier.save(isFirstVisit: false)
```

### Cross-feature

| Consumer | Uses |
|----------|------|
| **transaction** | `findById`, category/method lists, currency format |
| **analysis** | expense categories, payment methods for breakdowns |
| **home** | categories for cards; `hideBalanceOnHome` |
| **onboarding** | seeds options + clears first visit |

---

## Key files

| Path | Role |
|------|------|
| `data/models/settings_model.dart` | settings + SettingsContentModel |
| `data/models/profile_model.dart` | profile |
| `data/models/profile_helper_model.dart` | progress steps |
| `data/models/option_model.dart` | categories / methods |
| `data/services/option_services.dart` | option CRUD + byType / sort |
| `data/services/profile_services.dart` | ProfileProgress |
| `data/notifiers/settings_notifier.dart` | settings + theme/currency |
| `data/notifiers/profile_provider.dart` | profile |
| `data/notifiers/options_provider.dart` | options |
| `data/extensions/currency_format_extension.dart` | formatting |
| `data/constants/option_constants.dart` | OptionType + defaults |
