# SmartFleet (സ്മാർട്ട്ഫ്ലീറ്റ്)

> **Move Smart. Manage Better.**  
> A senior-friendly, high-contrast fleet operations and driver logistics application built with Flutter for Android.

---

## 🌟 Overview

SmartFleet is engineered specifically for truck drivers and fleet owners in Kerala. Unlike traditional enterprise logistics dashboards that crowd phone screens with dense data and desktop paradigms, SmartFleet is designed around a single benchmark:

> *"Can a 60-year-old driver wearing reading glasses, inside a truck cabin in direct sunlight, use this with zero explanation?"*

---

## 🚀 Key Features

### 🚚 Driver Experience
- **One Active Task Focus**: Eliminates cognitive overload by highlighting only the current active trip, next destination milestone, and essential ETA/distance.
- **Single-Tap Navigation**: One-touch "Show route in Google Maps" integration.
- **Physical Safety Actions**: Dedicated, unmissable stacked $\ge 56\text{dp}$ buttons for **"Call Office"** and **"Help / Breakdown"**.
- **Delivery Proof Flow**:
  - Secure 4-digit OTP verification.
  - Camera/gallery parcel photo proof with preview.
  - Interactive finger signature capture pad.
- **Earnings & Bata History**: Clear trip-by-trip breakdown of base fare, driver bata, deductions, and payout status.
- **Profile & Language Switch**: One-tap toggle between **മലയാളം** (Malayalam) and **English**.

### 🏢 Fleet Admin / Owner Experience
- **Morning/Evening Fleet Overview**: Time-derived Malayalam/English greetings with big KPI metric cards:
  - 🟢 **Active Trips**
  - ⚪ **Available Trucks**
  - 🔵 **Delivered Today**
- **Actionable Attention Alert**: Instant banner when delayed trips or breakdowns require immediate office dispatch.
- **Quick Trip Dispatch Form**:
  - 4 verified pickers: Driver selection, Truck registration, Route corridor, Cargo category & tonnage.
  - Explicit confirmation modal before dispatch.
- **Live Trips Directory**: Real-time progress indicators, search bar, and status filtering (`All`, `Running`, `Waiting`, `Done`).
- **Detailed Route Timeline**: Vertical milestone cards with driver contact shortcuts and WhatsApp trip sharing.
- **Truck & Driver Directories**: Complete roster with registration badges, license validity checks, and direct call shortcuts.

---

## 🎨 Accessibility & Design Tokens

Designed in accordance with strict WCAG AAA/AA sunlight readability standards:

| Token | Value | Rationale |
| :--- | :--- | :--- |
| **Canvas Background** | `#FFFFFF` | Maximum ambient contrast in bright sunlight |
| **Card Surface** | `#F4F5F3` | Subtle elevation without low-contrast shadows |
| **Primary Text** | `#111111` | Extreme readability ($\ge 18.88:1$ contrast ratio) |
| **Secondary Text** | `#3F4541` | High contrast secondary labels ($\ge 7.82:1$) |
| **Brand Accent** | `#0B6B3A` | Deep forest green for primary calls to action ($\ge 5.31:1$) |
| **Status Chips** | Dual Coding | Every status combines a distinct color, an icon, and a textual label |
| **Typography** | Noto Sans + Noto Sans Malayalam | 100% offline bundled TTF assets (no network font requests) |
| **Type Scale** | Large & Legible | Body $\ge 18\text{sp}$, Secondary $\ge 16\text{sp}$, Numbers $\ge 32\text{sp}$ |
| **Touch Targets** | $\ge 56\text{dp}$ Height | Minimum full-width touch areas for easy one-hand driving operation |

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (SDK $\ge 3.0$) / Dart
- **Architecture**: Domain-driven repository pattern with immutable models (`Trip`, `Driver`, `Truck`).
- **State Management**: Reactive state notification via persistent `LocalFleetRepository` backed by local JSON storage.
- **Localization**: Official Flutter `gen-l10n` (`intl`) with English (`app_en.arb`) and Malayalam (`app_ml.arb`).
- **Platform**: Android (`arm64-v8a`, `armeabi-v7a`, `x86_64`) targeting modern Android SDKs.

---

## 🧪 Testing & Verification

SmartFleet includes a comprehensive test suite of **64 automated tests** covering unit models, localization, multi-scale widget rendering, and end-to-end integration flows:

```bash
# Run all tests headlessly
flutter test --no-pub
```

### Layout Stability Guarantee
All UI screens are tested across:
- **Viewport**: Narrow 360dp width (standard budget Android devices).
- **Text Scale**: $1.0\times$ baseline and $1.5\times$ accessibility scale.
- **Localization**: English and Malayalam.
- **Result**: **0 RenderFlex overflows** across all 28 widget configurations.

---

## 📦 Building Release APKs

Build optimized release APKs split per CPU architecture:

```bash
flutter build apk --release --split-per-abi
```

Generated APKs:
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

---

## 📄 License

Proprietary © SmartFleet Logistics Kerala. All rights reserved.
