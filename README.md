
https://github.com/user-attachments/assets/0c66e093-73dd-4813-89b1-6aa8e5daab09
# ÖZINŞE — iOS Streaming App Client

A modern, full-featured iOS movie and series streaming client built 100% programmatically using **UIKit** and **SnapKit**. The application features dynamic content presentation, video streaming playback, dynamic search and categorization, dark/light mode toggling, runtime multi-language localization, and account authentication flows.

---

## 🎥 App Showcase

<p align="center">
  <video width="320" controls autoplay loop muted src="https://github.com/user-attachments/assets/bff1057e-a43f-4a71-ae03-6bae317c5a8b"></video>
</p>

---

## 🛠 Key Features

- **🎬 Home & Media Discovery:**
  - Horizontal & vertical content carousels showcasing popular TV series, cartoons, and movies (*ÖZINŞE-де танымал*, *Телехикаялар*, etc.).
  - Detailed media view screens featuring series metadata, episode selection lists, cast/crew details, and screenshots.
  - Native video player integration for watching episodes directly within the app.

- **🔍 Search & Category Filtering:**
  - Interactive category tag grid allowing instant filtering across genres (Sitcoms, Anime, Cartoons, Documentaries, Reality TV).
  - Search field auto-filtering for quick title lookups.

- **📌 Favorites Management:**
  - Add or remove series and movies to personal favorites list with instant UI synchronization.

- **🌙 Theme Switching (Light & Dark Mode):**
  - Seamless toggle between Dark and Light mode themes in real-time across all main controllers.

- **👤 Profile, Security & Account Management (`ProfileViewController`):**
  - Personal details view and secure password changing workflow (`ChangePasswordViewController`).
  - Interactive notification and appearance switches.
  - Custom sheet presentation modal (`LanguageViewController`) supporting dynamic runtime switching across Kazakh, English, and Russian.
  - Animated blur overlay (`UIVisualEffectView`) for modal dialogs.
  - Confirmation alert dialog for user logout with root view controller transition.

- **👋 Onboarding & Authentication Flow:**
  - Multi-page carousel onboarding experience with image hero banners, page control indicators, and step navigation.
  - Programmatic Sign In and Sign Up (Registration) screens with custom input styling, secure text entry toggles, and validation.

---

## 🚀 Tech Stack & Architecture

- **Language:** Swift 5+
- **UI Framework:** UIKit (100% Programmatic UI, zero Storyboards / XIBs)
- **Auto Layout:** SnapKit DSL
- **Navigation:** Custom `UITabBarController` & `UINavigationController` with standard bar appearances
- **Data Persistence & State:** `UserDefaults` (Language preferences, authentication state, theme selections)
- **Networking & Media:** Async API fetching & embedded Video Player support

---

## 📌 Status & Roadmap

- [x] Programmatic Tab Bar and Navigation architecture
- [x] Multi-step Onboarding carousel & Authentication screens (Sign In / Registration)
- [x] Home catalog carousels and detail view controller implementation
- [x] Embedded video player integration for episode streaming
- [x] Interactive Category filtering and Search view
- [x] Favorites bookmarking flow and real-time list management
- [x] Complete Profile management & Password update screens
- [x] Light & Dark Mode theme switching system
- [x] Dynamic multi-language localization (Kazakh, English, Russian) via `UISheetPresentationController`
- [x] Logout handling with root view controller reset transitions
- [ ] Code refactoring and bug polish pass
