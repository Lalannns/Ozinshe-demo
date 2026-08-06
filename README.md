# Ozinshe App

A modern iOS streaming app client built 100% programmatically with UIKit and SnapKit, focused on delivering a clean user interface, localized experience, and smooth modal interactions.

---

## 📸 Screenshots

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-04 at 20 08 26" src="https://github.com/user-attachments/assets/1e36d5a9-ed0e-49b6-babe-dd9c5fcb856e" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-04 at 20 08 30" src="https://github.com/user-attachments/assets/cb23e226-149d-4609-881c-6b0d4f9eda0a" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-04 at 20 08 35" src="https://github.com/user-attachments/assets/50fafaaa-be4b-4aac-ab83-5a62a9bb95dc" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-04 at 20 08 39" src="https://github.com/user-attachments/assets/c1dcadd8-0673-4d06-8c8c-8ea8a5bc92c5" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-08-04 at 20 15 55" src="https://github.com/user-attachments/assets/61335ce4-a764-413f-b521-36e6ece0f340" />


---

## 🛠 Key Features

* **Profile & Settings Management (`ProfileViewController`):**
* Fully programmatic UI built with **SnapKit** (zero Storyboards/XIBs).


* Custom `ImageSwitch` components for notifications and theme settings.


* Animated background blur overlay (`UIVisualEffectView`) during modal presentations.


* Integrated logout flow via `UIAlertController` sheet with root view controller replacement transition.




* **Language Selection Modal (`LanguageViewController`):**
* Custom `UISheetPresentationController` modal with custom detents and corner radiuses.


* Delegate pattern (`LanguageViewControllerDelegate`) for real-time localized UI updates without view reloading.


* Persistent language preferences managed through `UserDefaults`.




* **Navigation & Tab Bar (`TabBarViewController`):**
* Multi-tab navigation architecture managing Home, Search, Favorites, and Profile sections.


* Custom `UINavigationBarAppearance` styling with standardized back/action bar items.




* **Localization (`Localizable.strings`):**
* Multi-language support (English, Kazakh, Russian) with dynamic runtime switching.





---

## 🚀 Tech Stack & Architecture

* **Language:** Swift 5+
* **UI Framework:** UIKit (100% Programmatic)


* **Auto Layout:** SnapKit DSL


* **Architecture:** MVC (Refactor to MVVM planned)
* **Data Persistence:** `UserDefaults`


---

## 📌 Roadmap & Progress

* [x] Programmatic Tab Bar and Navigation infrastructure


* [x] Complete Profile UI with SnapKit layout constraints


* [x] Custom sheet modal presentation & blur effect integration


* [x] Dynamic multi-language localization & `UserDefaults` persistence


* [x] Logout alert and root controller transition handling


* [ ] Connect profile user data to backend API / Firebase
* [ ] Implement full Dark Mode theme switching logic
* [ ] Refactor Profile controller to MVVM architecture
