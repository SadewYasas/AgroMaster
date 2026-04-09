# AgroMaster - Product Requirements Document (PRD)

## Overview

**App Name:** AgroMaster
**Platform:** iOS (SwiftUI, Xcode)
**Purpose:** AI-powered plant health and farming companion app. Users can scan plants to detect diseases, get care tips, set reminders, and find nearby agricultural support centers.
**Target:** iOS 17+, iPhone

**Figma Design:**
https://www.figma.com/design/yNsYe8uqY7FGCZ1CSEXPqR/Untitled?node-id=0-1&t=f57lmZRslUIWg4Mn-1

---

## Tech Stack

- **UI Framework:** SwiftUI
- **Language:** Swift
- **Backend:** Firebase (Authentication + Firestore)
- **Local Storage:** Core Data
- **ML:** Core ML + VisionKit
- **Maps:** MapKit
- **Calendar:** EventKit
- **Auth:** Firebase Auth + LocalAuthentication (Face ID / Touch ID)
- **Notifications:** UNUserNotificationCenter

---

## Design System

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| Primary Green | `#0D631B` | Buttons, links, accents |
| Secondary Green | `#2E7D32` | Gradients, hero cards |
| Background | `#FBF9F8` | App background |
| Surface Light | `#F5F3F3` | Card backgrounds |
| Surface Medium | `#EAE8E7` | Input fields, secondary cards |
| Surface Dark | `#E4E2E1` | Tertiary cards |
| Text Primary | `#1B1C1C` | Headings, body text |
| Text Secondary | `#40493D` | Descriptions, subtitles |
| Accent Brown | `#79564B` | Labels, metadata text |
| Alert Red | `#BA1A1A` | Warnings, action required |
| Coral | `#FED0C1` | Insight card background |
| Light Green Tint | `#CBFFC2` | Hero card text |
| White | `#FFFFFF` | Card backgrounds, buttons |

### Typography

| Style | Font | Weight | Size |
|-------|------|--------|------|
| Heading 1 | Manrope | ExtraBold (800) | 36-48px |
| Heading 2 | Manrope | Bold (700) | 24-30px |
| Heading 3 | Manrope | Bold (700) | 20px |
| Heading 4 | Manrope | Bold (700) | 18px |
| Body | Inter | Regular (400) | 16px |
| Body Small | Inter | Regular (400) | 14px |
| Label | Inter | SemiBold (600) | 12px, uppercase, tracked |
| Caption | Inter | Medium (500) | 12px |
| Button | Inter | SemiBold (600) | 16px |

### Corner Radius

| Element | Radius |
|---------|--------|
| Cards (large) | 32px |
| Cards (medium) | 24px |
| Buttons | 12px (rect), 9999px (pill) |
| Inputs | 16px |
| Icon containers | 12px |
| Avatar badges | 9999px (circle) |

### Spacing

- Page horizontal padding: 24-30px
- Card internal padding: 24-32px
- Section gap: 24-32px
- Element gap within cards: 8-16px

---

## App Flow

```
Launch
  |
  v
Onboarding (4 pages, shown once)
  |
  v
Login / Register
  |-- Email + Password
  |-- Face ID / Touch ID
  |-- Sign Up flow
  |
  v
Navigation Page (landing with animation, post-auth)
  |
  v
Main Tab View (5 tabs)
  |-- Tab 1: Dashboard (Home)
  |-- Tab 2: Plant Care Tips
  |-- Tab 3: Scan (center, prominent)
  |-- Tab 4: History
  |-- Tab 5: Settings / Profile
```

---

## Screens and Features

### Screen 1: Onboarding (4 pages)

**Figma Nodes:** `60:376` (Welcome), `60:508` (AI Scan), `60:576` (Tips/Notifications), + 1 more

**UI Elements:**
- Full-bleed hero image with gradient overlay
- Brand logo "AGROMASTER" top-left (green, uppercase, tracked)
- Large heading (Manrope ExtraBold 48px)
- Description paragraph
- Progress indicator (4 dots: active = elongated green pill, inactive = small gray circle)
- "Continue" button (green gradient, rounded 12px)
- "Skip" text button below
- Glassmorphism AI status tag (frosted glass card with health percentage) on page 1

**Behavior:**
- Swipeable pages or button-driven navigation
- Skip goes directly to Login
- Only shown on first launch (UserDefaults flag)
- Progress dots update per page

**Page Content:**
1. Welcome: Monstera leaf hero, "Smarter Farming." heading, description about AI companion
2. AI Scan: Plant scanning visualization with recognition tags, "AI-powered scanning" heading
3. Tips & Notifications: Tip card + notification preview, "Stay informed" heading
4. Final: Get started CTA

---

### Screen 2: Login

**Figma Node:** `60:700`

**UI Elements:**
- App logo (plant icon in white rounded container, shadow)
- "AgroMaster" title (Manrope ExtraBold 36px, green)
- "PRECISION AGRICULTURE MANAGEMENT" subtitle (Inter Medium 14px, brown, uppercase tracked)
- Input group with rounded container (`#EAE8E7`):
  - Email field with uppercase label "EMAIL ADDRESS"
  - Password field with uppercase label "PASSWORD" and eye toggle icon
  - Divider between fields
- "Sign In" button (green gradient, full width)
- "Login with Face ID" button (outlined, with Face ID icon)
- "Forgot Password?" link (brown)
- "Don't have an account? Sign up" footer

**Face ID Modal (overlay):**
- Frosted glass container (backdrop blur, rounded 48px)
- Face ID glyph with scanning dot indicator
- "Face ID" title
- "Sign in to AgroMaster using Face ID" description
- "Cancel" button

**Implementation:**
- Firebase Auth for email/password
- `LocalAuthentication` framework for Face ID/Touch ID
- Keychain storage for biometric-linked credentials
- Form validation (email format, password length)
- Error states with inline messages

---

### Screen 3: Registration

**Implementation (no explicit Figma, follow login style):**
- Name, username, email, password fields
- Same input styling as Login
- Firebase Auth createUser + Firestore user document
- Username uniqueness check
- Redirect to Login on success

---

### Screen 4: Navigation / Landing Page

**Purpose:** Transition screen after authentication, before entering the main app

**UI Elements:**
- Animated welcome message with user's name
- App branding
- Smooth transition animation into MainTabView
- Brief loading state while fetching user data

---

### Screen 5: Dashboard (Home Tab)

**Figma Node:** `4:980`

**Layout:** Vertical scroll with bento-style cards

**UI Elements (top to bottom):**

1. **Header Area:**
   - User avatar (top-right, 39px circular)
   - "Welcome back to your Digital Greenhouse." (Manrope ExtraBold 36px, "Digital Greenhouse." in green)
   - "Good Morning, [Name]" greeting (Inter Medium 14px, brown)

2. **Scan Plant Card (Hero - Large Bento):**
   - Green background (`#2E7D32`) with plant image overlay (40% opacity)
   - Frosted glass icon container (top-left)
   - "Scan Plant" heading (Manrope Bold 30px, light green `#CBFFC2`)
   - Description text (Inter Medium 16px, light green 80% opacity)
   - "Launch Camera" pill button (white bg, green text, shadow)
   - Taps to Scan tab

3. **View History Card (White):**
   - Gray icon container with clock icon
   - "View History" heading
   - "Track the progress of your previous scans and reports."
   - "12 Reports >" link (green, semibold)
   - Taps to History tab

4. **Plant Care Tips Card (Gray `#E4E2E1`):**
   - White icon container with leaf icon
   - "Care Tips" heading
   - "Seasonal advice tailored to your local crop variety."
   - Overlapping avatar badges at bottom
   - Taps to Tips tab

5. **Reminders Card (Light gray `#F5F3F3`):**
   - Red dot + "ACTION REQUIRED" label (red, uppercase, tracked)
   - "Watering Schedule" heading (Manrope Bold 24px)
   - Description about which plants need water
   - White stat card with "02" large number + "Active Alerts" label
   - Taps to Reminders settings

6. **Nearby Support Card (Gray `#EAE8E7`):**
   - Dark icon container with pin icon
   - "Nearby Support" heading
   - "Connect with local agronomists and supply stores."
   - Frosted pill showing "3 Experts Nearby" with pin icon
   - Taps to Nearby tab

7. **Insight of the Day Card (Coral `#FED0C1`):**
   - "INSIGHT OF THE DAY" label (brown, uppercase, tracked)
   - Large quote text (Manrope Bold 30px, brown)
   - Description paragraph
   - "Read Full Article" pill button (brown bg, white text)
   - Large plant image below text section

---

### Screen 6: Plant Care Tips

**Figma Node:** `20:1396`

**UI Elements:**
- Back arrow + avatar (header)
- "PLANT HEALTH INSIGHTS" label
- "Cultivating Resilience" large heading
- Description paragraph

**Bento Grid Tips:**
1. **Featured Tip Card:** Image with gradient overlay, category tags ("Spring", "Organic"), heading + description overlay
2. **Secondary Tip Cards (2x):** Icon, heading, description, "Read more >" link
3. **Seasonal Maintenance Section:**
   - "Seasonal" heading with "See all" link
   - Season cards (Spring, Summer, Autumn) each with:
     - Seasonal garden image
     - Season name heading
     - 3 checklist items with checkmark icons

---

### Screen 7: AI Scan

**Figma Node:** `20:1855`

**UI Elements:**
- Back arrow + avatar (header)
- "AI DIAGNOSTICS" label
- "Scan your crops" heading
- Large image upload/preview area with:
  - Camera icon (centered, with shadow)
  - "Upload or take a photo" heading
  - "Position the affected leaf area in clear, natural lighting" description
  - "Select Photo" button (green gradient)
- "Try with sample image" link
- "Analyze" button (dark, full width)
- Floating scan button (green circle with camera icon, bottom-right)

**Scanning Tips Card:**
- Lightbulb icon + "Scanning Tips" heading
- 3 numbered tips:
  1. "Ensure the leaf is well-lit but avoid direct harsh sunlight glare."
  2. Tip about centering the affected area
  3. Tip about multiple angles

**Sample Preview Images:**
- 2 sample plant images with dark overlays

**Implementation:**
- `AVCaptureSession` for camera capture OR `UIImagePickerController`
- `VNDocumentCameraViewController` from VisionKit for guided scanning
- Core ML model integration for plant disease classification
- Image preprocessing before ML inference
- Loading state during analysis

---

### Screen 8: Scan Result Detail

**Figma Node:** `21:2474`

**UI Elements:**
- Back arrow (header)
- Full-width scanned image with AI overlay:
  - Glassmorphism tag showing "Analyzing Complete" with green dot
  - Semi-transparent green overlay on plant

**Diagnosis Section:**
- "Overall Plant Condition" label + percentage ("73.6%")
- Custom health meter (gradient bar: green to red)
- AI diagnosis text: disease identification explanation

**Treatment Section (dark card, rounded 32px):**
- Shield icon + "Recommended Treatment Plan" heading (2 lines)
- 4 recommendation cards, each with:
  - Green dot indicator
  - Category label (e.g., "Chemical Control", "Pruning", "Soil Health", "Follow-Up Scan")
  - Detailed description paragraph

**Implementation:**
- Core ML model output parsing
- Health score calculation
- Treatment recommendations (can be hardcoded or ML-generated)
- Save results to Core Data
- Option to set reminder for follow-up scan (EventKit)

---

### Screen 9: Scan History

**Figma Node:** `20:2182`

**UI Elements:**

**Stats Overview (top section):**
- Total scans card with plant graphic:
  - "Plant Scans Completed" label
  - Large stat number (Manrope Bold 40px)
  - Category filter pills ("Vegetable", "Fruit")
- Diagnosis accuracy bar chart + "99.2%" stat

**Search & Filter:**
- Search input with magnifying glass icon ("Search plant or disease...")
- Filter button (hamburger-style icon)

**Scan Cards (grouped by date):**
- Date separator with horizontal lines ("Today, April 2025" / "March 20, 2025")
- Each scan card contains:
  - Plant image (top, full width within card, rounded)
  - Plant name heading (Manrope Bold)
  - Date + time with clock icon
  - Category tags (e.g., "Early Blight", "Tomato")
  - Status badge (e.g., "Treatment in Progress")
  - Tap to view Scan Result Detail

**Implementation:**
- Core Data fetch with NSFetchedResultsController or @FetchRequest
- Search filtering by plant name or disease
- Date-grouped sections
- Pull to refresh

---

### Screen 10: Nearby Support Centers

**Figma Node:** `22:2647`

**UI Elements:**

**Map Section (top half):**
- MapKit map view with custom pin markers
- Map overlay controls (zoom in/out buttons, top-right)
- Pin markers with labels (e.g., "GreenLeaf Agro Center", "FarmCare Hub")

**Search & Filter Bar:**
- Frosted glass container with shadow
- Search input ("Search for centers or nurseries...")
- "Filter" button with funnel icon

**Results Section:**
- "AGRICULTURAL SUPPORT" label
- "Nearby Support" heading
- Distance filter tag ("Within 5 km" with pin icon)

**Center Cards:**
- Each card contains:
  - Circular icon container (plant/store icon)
  - Distance badge ("1.2 km")
  - Center name (Heading 3)
  - Description (3 lines)
  - Category tags (e.g., "Retail", "Pest Management")
  - Divider
  - "Directions" link (with arrow icon)
  - "Get Details" button (green, rounded, shadow)

**Informational Banner (bottom):**
- Decorative circular shape
- Heading about partnership program
- Description
- CTA button

**Implementation:**
- `CLLocationManager` for user location
- `MKMapView` with custom annotations
- Hardcoded or Firestore-sourced center data
- MapKit directions integration
- Search filtering by name/type

---

### Screen 11: Reminder Settings

**Figma Node:** `23:3309`

**UI Elements:**

**Header:**
- Back arrow + avatar
- "SETTINGS" label
- "Reminder Settings" heading (Manrope ExtraBold 36px)
- Description paragraph about notification configuration

**Master Toggle Card:**
- Plant icon in green circle
- "Smart Alerts" heading
- Description
- Custom iOS-style toggle switch (green track)

**Frequency Selection Section:**
- "Frequency options" heading
- Two option cards (Daily / Weekly), each with:
  - Calendar icon
  - Radio button indicator (filled circle for selected)
  - Frequency label
  - Description

**Detail Section:**
- Calendar icon
- "Timing" heading
- Description about notification timing
- "View calendar >" link

**Preferred Time Section:**
- "Preferred Time" heading
- Description
- Time picker row with dropdown arrow

**Implementation:**
- UserDefaults for toggle state and frequency
- `UNUserNotificationCenter` for scheduling local notifications
- EventKit for calendar reminder creation
- Custom time picker

---

### Screen 12: Bottom Navigation Bar

**Figma Node:** `22:2701`

**5 Tabs:**
1. Home (house icon) - Dashboard
2. Tips (leaf/document icon) - Plant Care Tips
3. Scan (camera icon) - AI Scan (center, potentially prominent)
4. History (clock icon) - Scan History
5. Settings (gear/sliders icon) - Profile/Settings

**Styling:**
- Active tab: green icon + text
- Inactive tab: gray icon + text
- Safe area bottom padding

---

## Feature Matrix

### MVP Features (8 Required)

| # | Feature | Screen(s) | iOS Frameworks |
|---|---------|-----------|----------------|
| F1 | Auth + Face ID/Touch ID | Login, Register | Firebase Auth, LocalAuthentication |
| F2 | Push Notifications + Core Data | Throughout app | UNUserNotificationCenter, Core Data |
| F3 | Profile / Settings | Reminder Settings | UserDefaults, UNNotification |
| F4 | Dashboard + Landing + Onboarding | Onboarding, Navigation, Dashboard | SwiftUI TabView, PageTabViewStyle |
| F5 | Analysis History | Scan History | Core Data, @FetchRequest |
| F6 | Plant Care Tips | Care Tips page | Static/Firestore content |
| F7 | Reminders | Dashboard card + Settings | UNNotification, EventKit |
| F8 | Nearby Support Centers | Nearby Support | MapKit, CoreLocation |

### Advanced Features (2 Required)

| # | Feature | Screen(s) | iOS Frameworks |
|---|---------|-----------|----------------|
| A1 | VisionKit + Core ML | AI Scan, Scan Result | VisionKit, CoreML, Vision |
| A2 | EventKit | Reminders, Scan Results | EventKit |

---

## Data Models

### Core Data Entities

**ScanResult**
```
- id: UUID
- plantName: String
- diseaseName: String?
- healthScore: Double
- imagePath: String
- scanDate: Date
- treatmentNotes: String?
- category: String (vegetable, fruit, etc.)
- status: String (healthy, treatment_in_progress, critical)
```

**Reminder**
```
- id: UUID
- title: String
- body: String
- frequency: String (daily, weekly)
- preferredTime: Date
- isEnabled: Bool
- linkedScanId: UUID?
- createdAt: Date
```

### Firestore Collections

**users**
```
- name: String
- username: String
- email: String
- area: String
- createdAt: Timestamp
```

**supportCenters** (optional, can be hardcoded)
```
- name: String
- description: String
- latitude: Double
- longitude: Double
- distance: String
- categories: [String]
- phone: String?
```

---

## Project Structure

```
AgroMaster/
├── AgroMasterApp.swift                    # App entry point
├── ContentView.swift                      # Auth state routing
├── Persistence.swift                      # Core Data stack
│
├── Models/
│   ├── AuthViewModel.swift                # Firebase auth logic
│   ├── BiometricAuthViewModel.swift       # Face ID / Touch ID
│   ├── KeychainManager.swift              # Secure credential storage
│   └── User/
│       └── UserModel.swift                # User data model
│
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift           # 4-page onboarding flow
│   │
│   ├── Login/
│   │   ├── LoginView.swift                # Login screen UI
│   │   └── LoginViewModel.swift           # Login logic
│   │
│   ├── Register/
│   │   ├── RegisterView.swift             # Registration screen UI
│   │   └── RegisterViewModel.swift        # Registration logic
│   │
│   ├── Navigation/
│   │   └── LandingView.swift              # Post-auth landing/transition
│   │
│   ├── MainTabView/
│   │   └── MainTabView.swift              # Tab bar container (5 tabs)
│   │
│   ├── Dashboard/
│   │   └── DashboardView.swift            # Home screen with bento cards
│   │
│   ├── PlantScanner/
│   │   ├── ScanView.swift                 # Camera / upload UI
│   │   ├── CameraViewModel.swift          # Camera session management
│   │   ├── ScanResultView.swift           # AI analysis results
│   │   └── CameraPreview.swift            # Camera preview wrapper
│   │
│   ├── History/
│   │   └── HistoryView.swift              # Scan history with search
│   │
│   ├── CareTips/
│   │   └── CareTipsView.swift             # Plant care tips page
│   │
│   ├── Reminders/
│   │   └── ReminderSettingsView.swift      # Reminder configuration
│   │
│   ├── NearbySupport/
│   │   ├── NearbySupportView.swift         # Map + center list
│   │   ├── SupportCenterDetailView.swift   # Center detail card
│   │   └── LocationViewModel.swift         # Location + map logic
│   │
│   └── Common/
│       ├── NotificationDelegate.swift      # Push notification handling
│       ├── FormValidator.swift             # Input validation utilities
│       └── Components/                     # Reusable UI components
│           ├── BentoCard.swift
│           ├── GradientButton.swift
│           └── CustomToggle.swift
│
├── CoreData/
│   └── AgroMaster.xcdatamodeld            # Core Data schema
│
├── ML/
│   └── PlantDiseaseClassifier.mlmodel     # Core ML model file
│
├── Assets.xcassets/                        # App icons, colors, images
│
├── GoogleService-Info.plist               # Firebase config
│
└── Tests/
    ├── AgroMasterTests/
    │   ├── AuthViewModelTests.swift
    │   ├── FormValidatorTests.swift
    │   ├── LoginViewModelTests.swift
    │   ├── LocationViewModelTests.swift
    │   ├── CameraViewModelTests.swift
    │   └── ScanResultTests.swift
    │
    └── AgroMasterUITests/
        ├── LoginViewUITests.swift
        └── OnboardingUITests.swift
```

---

## Implementation Priority

### Phase 1: Foundation
1. Xcode project setup with SwiftUI
2. Firebase integration (Auth + Firestore)
3. Core Data stack setup
4. Color/typography constants
5. App entry point with auth state routing

### Phase 2: Auth Flow
1. Login screen (email/password)
2. Registration screen
3. Face ID / Touch ID integration
4. Keychain credential storage
5. Onboarding flow (4 pages)
6. Post-auth navigation/landing page

### Phase 3: Main Navigation
1. MainTabView with 5 tabs
2. Dashboard screen with all bento cards
3. Bottom navigation bar styling

### Phase 4: Core Features
1. AI Scan view (camera + upload)
2. Core ML model integration (VisionKit + Core ML)
3. Scan Result detail view
4. Scan History with Core Data persistence
5. Plant Care Tips page

### Phase 5: Supporting Features
1. Nearby Support Centers (MapKit)
2. Reminder Settings (notifications + EventKit)
3. Push notification setup
4. Profile / Settings

### Phase 6: Polish
1. Unit tests (minimum coverage for key ViewModels)
2. Accessibility (VoiceOver labels, Dynamic Type)
3. Error states and loading indicators
4. Animations and transitions

---

## Unit Tests Required

Minimum test coverage for these components:

1. **AuthViewModel** - sign in, sign up, sign out, validation
2. **FormValidator** - email validation, password rules, username rules
3. **LoginViewModel** - form state, error handling
4. **LocationViewModel** - location permissions, distance calculation
5. **CameraViewModel** - camera permissions, image capture state
6. **ScanResult parsing** - ML output to display model conversion

---

## Accessibility Requirements

- VoiceOver labels on all interactive elements
- Dynamic Type support for text
- Sufficient color contrast (especially on green buttons)
- Haptic feedback on key interactions
- Reduced motion alternatives for animations
- Accessibility identifiers on key views for UI testing

---

## Notes for Development

1. **Core ML Model:** If a real plant disease `.mlmodel` is not available, create a mock classifier that returns random/hardcoded results for demo purposes. The architecture should be ready for a real model swap.

2. **Nearby Centers Data:** Can be hardcoded initially with Sri Lankan locations (Colombo area nurseries/agricultural centers) since this is for demo.

3. **Firebase Setup:** Need `GoogleService-Info.plist` configured. Auth rules should allow read/write for authenticated users.

4. **EventKit Permissions:** Request calendar access only when user interacts with reminder features, not on launch.

5. **Navigation Page:** This is a brief animated transition screen after login, before showing the tab view. Can be a simple branded splash with user greeting that auto-navigates after 1-2 seconds.

6. **Architecture Patterns:** Follow MVVM throughout. Key patterns:
   - `@StateObject` for ViewModels
   - Separate ViewModel files per feature
   - `AuthViewModel` as environment object
   - Firebase auth listener pattern
   - Accessibility identifiers on views

7. **Image Assets:** Use SF Symbols for icons where possible. Custom images for onboarding hero sections and sample plant photos.