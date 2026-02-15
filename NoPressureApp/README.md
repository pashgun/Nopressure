# No Pressure Flashcards

Anti-burnout flashcard app with AI-powered card creation and FSRS spaced repetition.

## Features

✨ **Onboarding Flow**
- Welcome screen
- How It Works (3 feature pages)
- Personalization (goal, daily time, interests)

🏠 **Home Screen**
- Today's Goal tracker with progress ring
- Due cards section
- Quick "Start Learning" button
- Sample decks (Spanish + Swift Basics)

📚 **Library**
- Grid view of all decks
- Search and filters (All/Recent/Favorites)
- Deck cards with progress indicators

➕ **Create**
- AI import options (Camera/PDF/Text)
- Manual card creation (coming soon)

🎴 **Study Session**
- Flip card animation (tap to reveal)
- FSRS-powered spaced repetition
- 4 rating options: Again/Hard/Good/Easy
- Session complete celebration

🔍 **Explore**
- Browse categories (Languages, Science, Math, etc.)
- Featured decks (coming soon)

## Tech Stack

- **UI:** SwiftUI
- **Data:** SwiftData (iOS 17+)
- **Algorithm:** FSRS v5.0.0 (scientifically optimal spacing)
- **Design:** Liquid Glass design system
- **Build:** XcodeGen

## Quick Start

**On Mac with Xcode:**

```bash
cd NoPressureApp
./build_and_run.sh
```

The script will:
1. ✅ Check/install xcodegen
2. ✅ Generate Xcode project
3. ✅ Download FSRS dependency
4. ✅ Build app
5. ✅ Launch iOS Simulator
6. ✅ Install and run No Pressure Flashcards

**First run:** ~5 minutes
**Subsequent runs:** ~2 minutes

## Manual Build

If you prefer Xcode GUI:

```bash
# Generate project
xcodegen generate

# Open in Xcode
open NoPressureApp.xcodeproj
```

Then press Cmd+R to build and run.

## Project Structure

```
NoPressureApp/
├── NoPressureApp/
│   ├── NoPressureApp.swift      # Main app with SwiftData setup
│   ├── ContentView.swift         # Onboarding vs Main app logic
│   ├── Components/
│   │   ├── LiquidGlass.swift     # Design system modifiers
│   │   └── MeshBackground.swift  # Gradient background
│   ├── Models/
│   │   ├── User.swift
│   │   ├── Deck.swift
│   │   ├── Flashcard.swift
│   │   └── FSRSData.swift
│   ├── Services/
│   │   └── FSRSService.swift     # Spaced repetition logic
│   ├── Views/
│   │   ├── Onboarding/          # Welcome, How It Works, Personalization
│   │   ├── Home/                 # Dashboard
│   │   ├── Create/               # AI import options
│   │   ├── Library/              # Deck grid
│   │   ├── Explore/              # Categories
│   │   ├── Study/                # Flashcard session
│   │   └── MainTabView.swift     # Tab bar navigation
│   ├── Extensions/
│   │   └── Color+Hex.swift
│   └── Info.plist
├── Package.swift                  # FSRS dependency
├── project.yml                    # XcodeGen config
├── build_and_run.sh              # Automation script
└── README.md

## Design System

### Colors

```swift
// Backgrounds
Color.black                    // True black
Color(hex: "#1C1C1E")         // Dark gray

// Accents
Color(hex: "#BF5AF2")         // Purple (primary)
Color(hex: "#0A84FF")         // Blue
Color(hex: "#FF375F")         // Pink/Red
Color(hex: "#30D158")         // Green
Color(hex: "#FF9F0A")         // Orange

// Text
Color.white                    // Primary text
Color(hex: "#8E8E93")         // Secondary text
Color(hex: "#636366")         // Tertiary text
```

### Liquid Glass Effects

```swift
// Glass Card (large containers)
.glassCard()

// Liquid Button (with shine)
.liquidButton()

// Liquid Glass (general)
.liquidGlass(cornerRadius: 24)
```

### Mesh Background

Gradient background with blurred colored circles (purple, blue, pink).

## Sample Data

App includes 2 sample decks:

**Spanish Basics** (6 cards)
- Hello → Hola
- Goodbye → Adiós
- Thank you → Gracias
- ...

**Swift Basics** (4 cards)
- What is a variable? → A container for storing data values
- What is a constant? → An immutable value...
- ...

## Requirements

- macOS with Xcode 15.0+
- iOS 17.0+ Simulator
- Homebrew (for xcodegen)

## Troubleshooting

**"xcodegen: command not found"**
```bash
brew install xcodegen
```

**"No such simulator"**
- Open Xcode → Window → Devices and Simulators
- Add an iPhone simulator

**Build errors**
```bash
# Clean and rebuild
rm -rf ~/Library/Developer/Xcode/DerivedData/NoPressureApp-*
./build_and_run.sh
```

## Next Steps

- [ ] AI card generation (camera/PDF/text)
- [ ] Manual card creation flow
- [ ] CloudKit sync
- [ ] Widgets
- [ ] Dark/Light theme toggle
- [ ] Export/Import decks

## License

MIT

---

**Made with ❤️ using SwiftUI + FSRS**
