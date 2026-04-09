# AgroMaster

An AI-powered plant health and farming companion for iOS. Scan crops to detect diseases, get tailored care tips, schedule reminders, and find nearby agricultural support centers — all from your iPhone.

> Built with SwiftUI, Firebase, and Core ML for iOS 17+.

---

## Features

- **Onboarding flow** — 4-page intro with custom indicators
- **Authentication** — Email/password sign-in and registration via Firebase Auth, with Face ID / Touch ID quick login
- **Dashboard** — Bento-style home with greeting, quick actions, reminders, and insights
- **Plant scanner** — Pick or capture an image of a leaf, run AI analysis, and view a diagnosis with recommended treatments
- **Scan history** — Date-grouped scan log with status filters and search
- **Care tips** — Curated articles, secondary tip cards, and a seasonal maintenance checklist
- **Nearby support** — Map of nearby agricultural centers with directions and contact details
- **Reminders** — Configurable daily/weekly local notifications for watering, treatments, and seasonal tasks
- **Settings** — Profile, preferences, app info, and sign-out

---

## Tech Stack

| Area | Technology |
|---|---|
| UI | SwiftUI |
| Language | Swift 5.9+ |
| Architecture | MVVM |
| Auth | Firebase Auth + LocalAuthentication (Face ID / Touch ID) |
| Database | Firebase Firestore (cloud) + Core Data (local) |
| ML | Core ML + VisionKit |
| Maps | MapKit + CoreLocation |
| Notifications | UNUserNotificationCenter |
| Credentials | Keychain Services |
| Fonts | Manrope + Inter (variable fonts) |

**Minimum target:** iOS 17.0

---

## Project Structure

```
AgroMaster/
├── AgroMaster PRD.md              Product requirements document
├── AgroMaster.xcodeproj/          Xcode project file
├── AgroMaster/                    App source
│   ├── AgroMasterApp.swift        @main entry point
│   ├── ContentView.swift          Root router (onboarding / auth / main)
│   ├── Persistence.swift          Core Data stack
│   ├── Info.plist
│   ├── AgroMaster.entitlements
│   ├── GoogleService-Info.plist   Firebase config (placeholder — see Setup)
│   ├── Assets.xcassets/           App icons, accent colors
│   ├── Fonts/                     Manrope + Inter variable fonts
│   ├── CoreData/                  Core Data model
│   ├── Extensions/                Color, Font, AnyTransition extensions
│   ├── Models/                    Data models and shared ViewModels
│   │   ├── User/UserModel.swift
│   │   ├── AuthViewModel.swift
│   │   ├── BiometricAuthViewModel.swift
│   │   └── KeychainManager.swift
│   └── Views/                     All SwiftUI views, grouped by feature
│       ├── Onboarding/
│       ├── Login/
│       ├── Register/
│       ├── Navigation/            Landing transition screen
│       ├── MainTabView/
│       ├── Dashboard/
│       ├── PlantScanner/
│       ├── History/
│       ├── CareTips/
│       ├── NearbySupport/
│       ├── Reminders/
│       ├── Settings/
│       └── Common/                Shared validators, components, delegates
├── AgroMasterTests/               Unit tests (80 tests across 6 files)
└── AgroMasterUITests/              UI test target (Xcode-generated stubs)
```

### Architecture

The app follows **MVVM**:
- **Models** are plain Swift structs (`UserModel`) and ViewModels (`AuthViewModel`, `LoginViewModel`, etc.)
- **Views** are SwiftUI views that observe their ViewModel via `@StateObject` (local) or `@EnvironmentObject` (shared)
- **Shared state** like the authenticated user is injected at the app root and propagated via environment
- **Persistence** is split: Firebase Firestore for user data, Core Data for local cache, Keychain for credentials

---

## Setup

### Requirements

- macOS with Xcode 16+
- iOS 17+ device or simulator
- A Firebase project (free tier is fine)
- Apple Developer account (only required to run on a physical device)

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/AgroMaster.git
cd AgroMaster
```

### 2. Set up Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project
2. Add an iOS app with the bundle ID `com.agromaster.AgroMaster` (or whatever you set in Xcode)
3. Download `GoogleService-Info.plist` from the Firebase console
4. Replace the placeholder file at `AgroMaster/GoogleService-Info.plist` with the downloaded one
5. In the Firebase console, enable:
   - **Authentication → Sign-in method → Email/Password**
   - **Firestore Database** (start in test mode for development)

### 3. Add the Firebase SDK

Open `AgroMaster.xcodeproj` in Xcode, then:

1. **File → Add Package Dependencies...**
2. Paste: `https://github.com/firebase/firebase-ios-sdk`
3. Select the following products:
   - `FirebaseAuth`
   - `FirebaseFirestore`
   - `FirebaseFirestoreCombine-Community`
4. Click **Add Package**

### 4. Build and run

Select an iPhone simulator (or your device) and press `⌘R`. The app should launch into the onboarding flow.

> **Tip:** to test Face ID in the simulator, go to **Features → Face ID → Enrolled**, then trigger a Face ID prompt and use **Features → Face ID → Matching Face**.

---

## Testing

The project includes **80 unit tests** covering form validation, view model state, and data models.

Run tests in Xcode with `⌘U`, or from the command line:

```bash
xcodebuild test \
  -project AgroMaster.xcodeproj \
  -scheme AgroMaster \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

Test coverage:

| Suite | Tests | What it covers |
|---|---|---|
| `FormValidatorTests` | 28 | Email, password, username, name validation |
| `LoginViewModelTests` | 12 | Login form state and validation |
| `CameraViewModelTests` | 10 | Image loading, reset, mock analysis |
| `LocationViewModelTests` | 14 | Center filtering, distance, region |
| `ScanResultTests` | 11 | Scan result data model integrity |
| `AuthViewModelTests` | 5 | Non-Firebase auth state logic |

---

## Design System

The app implements a complete design system in code rather than asset catalogs for compile-time safety. See:

- [Color tokens](AgroMaster/Extensions/Color+AgroMaster.swift) — 13 named colors
- [Typography](AgroMaster/Extensions/Font+AgroMaster.swift) — Manrope (headings) + Inter (body)
- [Transitions](AgroMaster/Extensions/AnyTransition+AgroMaster.swift) — Slide and fade-scale animations

Full design specs are in [AgroMaster PRD.md](AgroMaster%20PRD.md).

---

## Roadmap

The PRD defines six implementation phases, all currently complete:

- [x] **Phase 1** — Foundation: design system, Core Data, persistence, app shell
- [x] **Phase 2** — Auth flow: onboarding, login, registration, biometric auth, landing
- [x] **Phase 3** — Dashboard and main navigation
- [x] **Phase 4** — Plant scanner, scan results, history, care tips
- [x] **Phase 5** — Nearby support, reminders, settings
- [x] **Phase 6** — Unit tests and accessibility

Future enhancements could include:
- Real Core ML disease classification model (currently uses a mock disease database)
- Apple Sign-In and Google Sign-In
- iCloud sync for scan history
- iPad and Apple Watch companion apps

---

## License

This project is for educational and demonstration purposes.
