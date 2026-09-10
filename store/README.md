# Play Store listing assets

Build inputs for the Play Console listing. Nothing in this folder is bundled
into the app — it is not listed under `flutter.assets` in `pubspec.yaml`.

| File | Purpose | Status |
| --- | --- | --- |
| `play_icon_512.png` | Store icon, 512x512, full-bleed | Ready |
| `feature_graphic_1024x500.png` | Feature graphic | Ready |
| `../docs/finpal-privacy-policy.html` | Hosted Privacy Policy (plain legal page) | Live — re-publish after edits |
| `../docs/finpal-terms-and-conditions.html` | Hosted Terms and Conditions | Live — re-publish after edits |
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

No sign-up. No cloud account. No ads. No analysis. FinPal ships with zero
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
on-device, and the release manifest declares no `INTERNET` permission, so nothing
can be transmitted. Photos and profile details are user-entered and stay local,
so they are not "collected" in Play's sense.

**Permissions** — the release manifest is not permission-free. It declares
`CAMERA`, `READ_MEDIA_IMAGES`, and `READ_EXTERNAL_STORAGE` (`maxSdkVersion="32"`),
all requested at tap time for receipt photos and the profile picture. Do not tell
Play the app has zero permissions. `READ_MEDIA_IMAGES` is a sensitive permission,
so expect the Photo and Video Permissions declaration in App content — the
justification is one-off image attachment chosen by the user, with no gallery
scanning and no upload. If Play pushes back, the fallback is to drop
`READ_MEDIA_IMAGES` and rely on the Android photo picker, which needs no
permission.

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

1. Copy `docs/finpal-privacy-policy.html` and
   `docs/finpal-terms-and-conditions.html` to your GitHub Pages policy site
   (same URLs the app already opens). Both URLs are already live, so this step
   is a re-publish whenever the local copies change — the hosted page is what
   Play reviews, not the one in this repo.
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
6. App content: complete the Photo and Video Permissions declaration for
   `READ_MEDIA_IMAGES` (see Permissions above). Do not skip this — it is the
   most likely cause of a rejection.
7. Content rating questionnaire — expect Everyone. Ads: no. News: no.
   Target audience 13+. The personal-loan declaration does not apply.
8. Store listing: paste the copy above, upload `play_icon_512.png`,
   `feature_graphic_1024x500.png`, and at least two of the phone screenshots.
9. Create a closed testing track, add at least 12 testers, and start the
   test the same day. Production access for a personal account requires
   those testers to stay opted in for 14 continuous days. This is the
   longest lead time in the release.
