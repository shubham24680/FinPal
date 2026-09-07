# Play Store listing assets

Build inputs for the Play Console listing. Nothing in this folder is bundled
into the app — it is not listed under `flutter.assets` in `pubspec.yaml`.

| File | Purpose | Status |
| --- | --- | --- |
| `play_icon_512.png` | Store icon, 512x512, full-bleed | Ready |
| `feature_graphic_1024x500.png` | Feature graphic | Ready |
| `privacy-policy-amendment.html` | Camera/photos clause for the hosted policy | Needs publishing |
| `screenshots/01_onboarding.png` … `06_home_dark.png` | Phone screenshots, 1080x2400 | Ready |

The icon is composited from the same art as the launcher icon
(`tool/icon/`), so the listing matches what users see after install. Play
applies its own corner rounding, which is why the source is a full square.

## Screenshots

Captured from the signed release APK on an Android 16 (API 36) emulator.
All six are 1080x2400 (Play requires 1080px+ on the short side). Do not use
the older `assets/res/*.png` shots — those include a copyrighted avatar and
cut features.

| File | Screen |
| --- | --- |
| `screenshots/01_onboarding.png` | Intro |
| `screenshots/02_home.png` | Home with income logged |
| `screenshots/03_transactions.png` | Transaction list |
| `screenshots/04_analysis.png` | Analysis charts |
| `screenshots/05_settings.png` | Settings |
| `screenshots/06_home_dark.png` | Dark theme + hidden balance |

## Listing copy

**App name** (30 max) — 23 characters:

```
FinPal: Expense Tracker
```

**Short description** (80 max) — 75 characters:

```
Offline expense tracker. No account, no ads, and no data leaves your phone.
```

**Full description** (4000 max):

```
FinPal is a personal finance tracker that keeps your money data where it
belongs — on your phone.

No sign-up. No cloud account. No ads. No analytics. FinPal ships with zero
network permissions, so your records physically cannot leave your device.

WHAT YOU CAN DO

• Log income and expenses in seconds
• Organise spending with categories and payment methods you control
• Attach a receipt photo to any transaction
• See where your money goes with clear monthly charts
• Drill into any category to review its transactions
• Filter your history by month and by income or expense
• Pick your own currency
• Hide your balance when you are in public
• Switch between light and dark themes

PRIVATE BY DESIGN

Most finance apps ask you to hand over bank credentials or create an account.
FinPal does neither. Everything you enter is stored locally using on-device
storage, and the app declares no internet permission at all. Clearing the app's
data or uninstalling removes your records from the device.

Receipt photos and profile pictures are copied into FinPal's own private
storage so they stay put, and they are deleted when you remove the transaction
or clear your data.

BUILT TO STAY OUT OF THE WAY

FinPal is deliberately small and quiet. No notifications begging you to come
back, no upsells, no subscription. Open it, record what you spent, get on with
your day.

Questions or feedback? Reach us at seven.dev987@gmail.com
```

## Play Console answers

**Data safety** — no data collected and no data shared. Everything is stored
on-device and the release manifest declares no permissions. Photos and profile
details are user-entered and stay local, so they are not "collected" in Play's
sense. Note the camera/photo access in the policy (see the amendment file).

**Content rating** — no violence, no user-generated content sharing, no
in-app purchases, no ads. Expect "Everyone".

**Other declarations**

- Category: Finance
- Ads: none
- News app: no
- Target audience: 13+
- The personal-loan declaration does not apply to a local expense tracker
- Privacy policy URL: https://shubham24680.github.io/policy/finpal-privacy-policy.html

## Play Console setup (account work)

This cannot be done from the repo. Do it in this order:

1. Publish `privacy-policy-amendment.html` into the hosted policy and bump
   the "Last updated" date.
2. Open [Play Console](https://play.google.com/console), finish identity
   verification, and pay the $25 registration fee if that is still pending.
3. Create the app: name `FinPal: Expense Tracker`, default language English,
   app type App, free, category Finance.
4. First upload: `build/app/outputs/bundle/release/app-release.aab`.
   Enable Play App Signing when prompted (keep `~/finpal-upload.jks` — that
   is the upload key; Google holds the app-signing key).
5. Fill Data safety: no data collected, no data shared, no encryption in
   transit (nothing is sent). Photos and profile details are stored only on
   the device. Point the policy URL at the page from step 1.
6. Content rating questionnaire — expect Everyone. Ads: no. News: no.
   Target audience 13+. The personal-loan declaration does not apply.
7. Store listing: paste the copy above, upload `play_icon_512.png`,
   `feature_graphic_1024x500.png`, and at least two of the phone screenshots.
8. Create a closed testing track, add at least 12 testers, and start the
   test the same day. Production access for a personal account requires
   those testers to stay opted in for 14 continuous days. This is the
   longest lead time in the release.
