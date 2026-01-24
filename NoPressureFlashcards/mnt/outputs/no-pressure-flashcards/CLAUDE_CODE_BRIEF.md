# No Pressure Flashcards — iOS App Brief for Claude Code

## App Overview
**Name:** No Pressure Flashcards
**Platform:** iOS (SwiftUI, iOS 17+)
**Design Language:** iOS 26 Liquid Glass
**Core Concept:** Anti-burnout flashcard app with AI-powered card creation

## Key Differentiators
- **No guilt for missed days** — backlog forgiveness, no streaks pressure
- **AI card generation** — snap photo, upload PDF, paste text → instant flashcards
- **FSRS algorithm** — scientifically optimal spaced repetition
- **Daily caps** — prevents over-studying and burnout

---

## Design System

### Colors
```swift
// Backgrounds
let trueBlack = Color(hex: "#000000")
let darkGray = Color(hex: "#1C1C1E")

// Accent Colors
let accentPurple = Color(hex: "#BF5AF2")
let accentBlue = Color(hex: "#0A84FF")
let accentPink = Color(hex: "#FF375F")
let accentGreen = Color(hex: "#30D158")
let accentOrange = Color(hex: "#FF9F0A")

// Text
let textPrimary = Color.white
let textSecondary = Color(hex: "#8E8E93")
let textTertiary = Color(hex: "#636366")
```

### Liquid Glass Effect (SwiftUI)

**From Figma iOS 26 UI Kit - exact values:**

```swift
// MARK: - Glass Card (Large containers)
struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

// MARK: - Liquid Button (with shine effect)
struct LiquidButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(Color.white.opacity(0.01))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            // Inner glow effect
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .blur(radius: 1)
            )
    }
}

// MARK: - Liquid Glass (General purpose)
struct LiquidGlass: ViewModifier {
    var cornerRadius: CGFloat = 24
    var blurRadius: CGFloat = 15

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.05),
                        Color.white.opacity(0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}

extension View {
    func liquidGlass(cornerRadius: CGFloat = 24) -> some View {
        modifier(LiquidGlass(cornerRadius: cornerRadius))
    }

    func glassCard() -> some View {
        modifier(GlassCard())
    }

    func liquidButton() -> some View {
        modifier(LiquidButton())
    }
}
```

### Mesh Gradient Background
```swift
struct MeshBackground: View {
    var body: some View {
        ZStack {
            Color.black

            Circle()
                .fill(Color(hex: "#BF5AF2").opacity(0.4))
                .blur(radius: 100)
                .offset(x: -100, y: -200)

            Circle()
                .fill(Color(hex: "#0A84FF").opacity(0.3))
                .blur(radius: 100)
                .offset(x: 100, y: 200)

            Circle()
                .fill(Color(hex: "#FF375F").opacity(0.2))
                .blur(radius: 80)
                .offset(x: 0, y: 0)
        }
        .ignoresSafeArea()
    }
}
```

### Typography
```swift
// Title Large - 34pt Bold
.font(.system(size: 34, weight: .bold))

// Title 1 - 28pt Bold
.font(.system(size: 28, weight: .bold))

// Title 2 - 22pt Bold
.font(.system(size: 22, weight: .bold))

// Headline - 17pt Semibold
.font(.system(size: 17, weight: .semibold))

// Body - 17pt Regular
.font(.system(size: 17, weight: .regular))

// Subheadline - 15pt Regular
.font(.system(size: 15, weight: .regular))

// Caption - 12pt Regular
.font(.system(size: 12, weight: .regular))
```

---

## Screen Structure

### 1. Onboarding Flow (6 screens)

**1.1 Welcome**
- App logo + name
- Tagline: "Learn without the pressure"
- Floating animated cards in background
- "Get Started" button

**1.2 How It Works — Snap & Learn**
- Icon: Camera
- Title: "Snap & Learn"
- Description: AI creates flashcards from photos, PDFs, or text
- "Continue" button

**1.3 How It Works — No Guilt**
- Icon: Heart
- Title: "No Guilt, No Burnout"
- Description: Miss a day? No problem. No streaks, no pressure.
- "Continue" button

**1.4 How It Works — Smart Repetition**
- Icon: Brain
- Title: "Smart Repetition"
- Description: FSRS algorithm shows cards at optimal time
- "Continue" button

**1.5 Personalization — Goal**
- Title: "What's your goal?"
- Selection cards (single select):
  - 🎓 Ace my exams
  - 🗣️ Learn a language
  - 💼 Professional growth
  - 🧠 General knowledge

**1.6 Personalization — Time**
- Title: "How much time per day?"
- Selection cards:
  - ⚡ 5 min — Quick learner
  - ☕ 15 min — Steady pace
  - 📚 30 min — Dedicated
  - 🚀 60 min — Power user

**1.7 Personalization — Interests**
- Title: "What interests you?"
- Multi-select chips:
  - Science, History, Languages, Math, Medicine, Law, Art, Tech, Business, Music

**1.8 Sign Up**
- "Continue with Apple" button (primary)
- "Continue with Google" button
- "Continue with Email" link
- Terms & Privacy links

### 2. Main App (Tab Bar)

**Tab Bar Items:**
- Home (house.fill)
- Create (plus.circle.fill) — center, accent color
- Library (folder.fill)
- Explore (safari.fill)

**2.1 Home Screen**
- Greeting: "Good morning, {Name}"
- Today's Goal card: "0/20 cards reviewed"
- "Start Learning" button
- "Due Today" section with deck previews
- Streaks/stats (subtle, non-pressuring)

**2.2 Create Screen**
- Title: "Create Flashcards"
- Three input options (large cards):
  - 📷 Camera — Snap notes or textbook
  - 📄 PDF — Import documents
  - ✍️ Text — Paste or type
- "Create Manually" link at bottom

**2.3 Library Screen**
- Search bar
- Filter pills: All, Recent, Favorites
- Grid of deck cards (2 columns)
- Each deck shows: name, card count, progress ring

**2.4 Explore Screen**
- Search bar
- Categories: Popular, Languages, Science, etc.
- Featured decks from community
- "Create from topic" AI feature

### 3. Study Flow

**3.1 Study Setup**
- Deck name and info
- Card count
- Study mode selection:
  - 🎴 Flashcards — Classic flip cards
  - ❓ Quiz — Multiple choice
  - ✍️ Write — Type the answer
- "Start Session" button

**3.2 Flashcard Mode**
- Progress bar at top
- Card counter: "3 of 20"
- Large flip card (tap to flip)
- Front: Question/Term
- Back: Answer/Definition
- Rating buttons: Again, Hard, Good, Easy

**3.3 Quiz Mode**
- Progress bar
- Question card
- 4 answer options (glass cards)
- Immediate feedback (green/red)

**3.4 Session Complete**
- 🎉 Celebration animation
- Stats: Cards reviewed, Accuracy, Time spent
- "Great job!" message (encouraging, not pressuring)
- "Continue" or "Done" buttons

---

## Data Models

```swift
struct User {
    let id: UUID
    var name: String
    var email: String
    var goal: LearningGoal
    var dailyMinutes: Int
    var interests: [String]
    var createdAt: Date
}

enum LearningGoal: String, Codable {
    case exams, language, professional, general
}

struct Deck {
    let id: UUID
    var name: String
    var description: String
    var cards: [Flashcard]
    var color: String // hex
    var icon: String // SF Symbol
    var createdAt: Date
    var lastStudied: Date?
}

struct Flashcard {
    let id: UUID
    var front: String
    var back: String
    var fsrsData: FSRSData
    var createdAt: Date
}

struct FSRSData {
    var difficulty: Double
    var stability: Double
    var retrievability: Double
    var lastReview: Date?
    var nextReview: Date?
    var reps: Int
    var lapses: Int
}

struct StudySession {
    let id: UUID
    let deckId: UUID
    var cardsReviewed: Int
    var correctCount: Int
    var duration: TimeInterval
    var completedAt: Date
}
```

---

## Tech Stack Recommendations

- **UI:** SwiftUI
- **Architecture:** MVVM + Swift Concurrency
- **Storage:** SwiftData (local) + CloudKit (sync)
- **AI:** OpenAI API for card generation
- **Algorithm:** FSRS-5 (open source implementation available)
- **Analytics:** TelemetryDeck (privacy-focused)
- **Auth:** Sign in with Apple + Firebase Auth

---

## MVP Scope (v1.0)

### Must Have
- [ ] Onboarding flow (all 8 screens)
- [ ] Manual flashcard creation
- [ ] Basic study mode (flip cards)
- [ ] Rating system (Again/Hard/Good/Easy)
- [ ] Simple spaced repetition (SM-2 to start)
- [ ] Local storage with SwiftData
- [ ] Library with deck management

### Should Have
- [ ] AI card generation (camera/text)
- [ ] FSRS algorithm upgrade
- [ ] Quiz mode
- [ ] Daily goals and gentle reminders

### Nice to Have
- [ ] PDF import
- [ ] CloudKit sync
- [ ] Explore/community decks
- [ ] Widgets

---

## Design Reference Files

1. **HTML Prototype:** `index.html` (in same folder)
   - Open in browser to see all 16 screens
   - Inspect CSS for exact Liquid Glass values

2. **FigJam MVP Flow:**
   - https://www.figma.com/online-whiteboard/create-diagram/8a916e32-c12d-4a2b-a002-55c354e2c66f

3. **iOS 26 Liquid Glass UI Kit (Figma):**
   - https://www.figma.com/design/DXF5bi1XgFzpPYOyyHx6bf/flashcard?node-id=2-2
   - Contains ready-to-use components:
     - Liquid Glass buttons with shine effects
     - Glass cards (dark, colored, transparent variants)
     - Charts/graphs in glass style
     - Container cards with gradient backgrounds
     - Tab bar and navigation components
     - iPhone/iPad device frames

---

## Notes for Development

1. **Liquid Glass is key** — use `.ultraThinMaterial` + custom gradients
2. **Mesh gradients** — multiple blurred circles, not linear gradients
3. **No pressure UX** — avoid guilt-inducing language, celebrate small wins
4. **Smooth animations** — use `withAnimation(.spring())` liberally
5. **Haptics** — add subtle haptic feedback on card flips and selections

Good luck! 🚀
