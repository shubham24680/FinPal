# Onboarding — Data Flow

> Keep this file updated when models, services, or providers change.

## Overview

First-run flow: splash → intro/onboarding pages → personal details. Seeds default categories/methods and marks `isFirstVisit = false`. No Hive models owned here; writes through **settings** and **profile** notifiers.

```
SplashScreen
  → settings.isFirstVisit?
      true  → Onboarding / Intro → PersonalDetails
      false → Home (ScreensWithNavbar)

PersonalDetails
  → profileProvider.onSubmit(setDefaultData: true)
      → profileNotifier.save
      → onboardingProvider.setupDefaultData
```

---

## Models

### `OnboardingState` (UI only)

| Field | Type | Notes |
|-------|------|--------|
| `pageController` | `PageController` | intro pager |
| `currentIndex` | `int` | active page |
| `buttonState` | `ButtonState` | next / loading |

No persisted models in this feature.

---

## Services

None local. Orchestrates:

| Call | Target |
|------|--------|
| `optionNotifer.saveAllOptions(OptionsConstant.allOptions)` | settings `OptionServices` |
| `settingsNotifier.save(isFirstVisit: false)` | settings Hive |
| `profileNotifier.save(...)` | via `profileProvider.onSubmit` |

---

## Providers

| Provider | Type | Role |
|----------|------|------|
| `onboardingProvider` | `StateNotifierProvider → OnboardingState` | pager + default seed |

### `OnboardingNotifer` methods

| Method | Behavior |
|--------|----------|
| `next()` | disable button briefly; animate to next page |
| `setupDefaultData()` | wait for options ready → `saveAllOptions(allOptions)` → delay → `isFirstVisit: false` |

---

## Data flow

### First launch

```
Splash
  → settingsNotifier → isFirstVisit == true
    → OnboardingScreen / IntroScreen (pageController via onboardingProvider)
      → PersonalDetailsScreen
        → profileProvider fields (name, dob, gender, income, image)
        → onSubmit(setDefaultData: true)
            → ProfileModel saved (key: user)
            → OptionsConstant.allOptions → OptionServices.saveAll
            → SettingsModel.isFirstVisit = false
        → navigate to home
```

### Returning user

```
Splash → isFirstVisit == false → ScreensWithNavbar / Home
```

### Cross-feature

| Feature | Role in onboarding |
|---------|-------------------|
| **settings** | first-visit flag, seed options, currency defaults |
| **settings/profile** | personal details form + Hive profile |
| **home** | destination after setup |

---

## Key files

| Path | Role |
|------|------|
| `data/notifiers/onboarding_provider.dart` | state + `setupDefaultData` |
| `data/constants/onboarding_constants.dart` | copy / assets |
| `presentation/screens/splash_screen.dart` | route gate |
| `presentation/screens/intro_screen.dart` | intro |
| `presentation/screens/onboarding_screen.dart` | pager |
| `presentation/screens/personal_details_screen.dart` | profile capture |
| `presentation/widgets/helper_widgets.dart` | shared UI |
