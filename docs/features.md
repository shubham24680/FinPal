# Features — Data Flow Index

Living docs for models, services, and data flow. Update the matching feature file whenever you add/change a model field, service method, or provider.

| Feature | Doc | Owns persistence? |
|---------|-----|-------------------|
| [transaction](transaction/DATA_FLOW.md) | payments CRUD + queries | Hive `PaymentModel` |
| [settings](settings/DATA_FLOW.md) | settings, profile, options (`byType`, sort, …) | Hive Settings / Profile / Option |
| [analysis](analysis/DATA_FLOW.md) | aggregations, trends, breakdowns | none (computes from payments + options) |
| [home](home/DATA_FLOW.md) | nav shell + dashboard | none (reads other features) |
| [onboarding](onboarding/DATA_FLOW.md) | first-run seed | writes via settings/profile |

## App-wide flow (simplified)

```
Onboarding (first visit)
  → seed Options + Profile + Settings.isFirstVisit=false
      ↓
Home / Transaction / Analysis / Settings
  → PaymentModel  ←→  OptionModel (categoryId, paymentMethodId)
  → AnalysisCalculator(payments, options) → charts
  → Settings (currency, theme, hide balance) → all UI
```

## How to maintain

When you change code under `lib/features/<name>/`:

1. Open `lib/features/<name>/DATA_FLOW.md`
2. Update **Models** (fields), **Services** (methods), **Providers**, and **Data flow**
3. If another feature now depends on the change, note it under **Cross-feature**
