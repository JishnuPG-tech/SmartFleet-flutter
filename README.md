# SmartFleet (സ്മാർട്ട്ഫ്ലീറ്റ്) - Flutter Android Client

> **Enterprise Commercial Logistics, Dispatch & Fleet Operations Platform**  
> Senior-friendly, high-contrast Flutter Android application designed for heavy commercial fleet operations across Kerala and South India.

[![GitHub Release](https://img.shields.io/github/v/release/JishnuPG-tech/SmartFleet-flutter?style=flat-square&color=0B6B3A)](https://github.com/JishnuPG-tech/SmartFleet-flutter/releases)
[![Backend Repository](https://img.shields.io/badge/Backend-SmartFleet--Backend-blue?style=flat-square)](https://github.com/JishnuPG-tech/SmartFleet-Backend)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.x%20%7C%20Dart%203.x-02569B?style=flat-square)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20(ARM64%2C%20ARMv7%2C%20x86__64)-3DDC84?style=flat-square)](https://android.com)

---

## Direct APK Downloads

| Release | Version | Build | Architecture | Download Link | SHA-256 Checksum |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Latest Production** | `v2.6.1` | `8` | Universal ARM64/ARMv7 | [Download APK (GitHub Release)](https://github.com/JishnuPG-tech/SmartFleet-flutter/releases/download/v2.6.1/SmartFleet-v2.6.1-release.apk) | `4d0dc6618dc3a4c98d3421a5bbc1a9201a9c2974895706cb89b10220b5c03254` |
| **In-Repo Mirror** | `v2.6.1` | `8` | Universal Android | [View in Repository](./apk/SmartFleet-v2.6.1-release.apk) | `4d0dc6618dc3a4c98d3421a5bbc1a9201a9c2974895706cb89b10220b5c03254` |

---

## Key Features

### Driver Experience & Cockpit
- **Single Active Task Focus**: Displays only current active assignment, route corridor, destination hub, and required tonnage.
- **Turn-by-Turn Navigation**: One-tap native Google Maps launcher with automatic highway routing across NH 66, NH 766, and NH 544.
- **Instant Emergency Actions**: Dedicated stacked >= 56dp high-contrast buttons for **"Call Office"** and **"Help / Breakdown"**.
- **Delivery Proof Flow (POD)**:
  - 4-digit security PIN verification.
  - Parcel photo capture with preview.
  - Interactive touch signature pad.
- **Real-Time Earnings & Bata**: Transparent breakdown of base pay, trip bata, allowances, and payout status.
- **Bilingual Interface**: Full localization support for **Malayalam** and **English**.

### Fleet Admin & Dispatch Operations
- **Interactive Fleet Tracking Map**: OpenStreetMap integration with dark midnight contrast, dynamic truck markers, and zero watermark crutches.
- **Dynamic Fleet Registration**: Add commercial heavy haulers on the fly with automatic backend database synchronization.
- **Instant Dispatch**: Assign consignments to onboarded drivers with live WebSocket broadcasts.
- **Active Trip Monitoring**: Track progress, milestone completion, and driver telemetry in real time.
- **Driver Directory**: View licenses, experience, assigned trucks, and one-tap emergency call shortcuts.

---

## Architecture & Repositories

- **Mobile Client**: [JishnuPG-tech/SmartFleet-flutter](https://github.com/JishnuPG-tech/SmartFleet-flutter)
- **FastAPI Backend Server**: [JishnuPG-tech/SmartFleet-Backend](https://github.com/JishnuPG-tech/SmartFleet-Backend)
- **Live Cloud API Endpoint**: `https://jishnupg-opencode-cli.hf.space/preview/8000/api/v1`

---

## Project Structure

```
SmartFleet-flutter/
├── android/               # Native Android configuration, ProGuard, & manifest
├── apk/                   # Pre-compiled production APK binaries & SHA256 checksums
│   ├── SHA256SUMS.txt
│   ├── SmartFleet-latest.apk
│   └── SmartFleet-v2.6.1-release.apk*├── assets/                # Offline TTF fonts (Noto Sans Malayalam) & icons
├── lib/
│   ├── core/
│   │   ├── data/          # Repository, API client, & immutable models
│   │   ├── design/        # Tokens, enterprise theme, & reusable components
│   │   ├── maps/          # Leaflet / OpenStreetMap integration
│   │   └── services/      # In-app OTA updater & file provider services
│   ├── l10n/              # ARB localization files (English & Malayalam)
│   ├── screens/
│   │   ├── admin/         # Dispatch, fleet management, & analytics tabs
│   │   ├── auth/          # Onboarding, driver login, & role selection
│   │   └── driver/        # Driver cockpit, trip navigation, & POD flow
│   └── main.dart          # Application entrypoint & theme initialization
├── test/                  # 64+ automated unit and integration tests
├── pubspec.yaml           # Dependencies, assets, & version definition
└── README.md
```

---

## Build & Installation

### Prerequisites
- Flutter SDK >= 3.20.0
- Android SDK 34+
- Java JDK 17

### Local Compilation
```bash
# Clone the repository
git clone https://github.com/JishnuPG-tech/SmartFleet-flutter.git
cd SmartFleet-flutter

# Get dependencies
flutter pub get

# Run tests
flutter test

# Compile production release APK
flutter build apk --release --target-platform android-arm64
```

---

## License

Proprietary © SmartFleet Logistics Kerala. All rights reserved.
