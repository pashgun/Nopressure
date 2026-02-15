# Design Generation Prompt for No Pressure Flashcards

## App Overview
**Name:** No Pressure Flashcards
**Platform:** iOS Mobile App
**Design Style:** iOS 26 Liquid Glass + Dark Theme
**Core Concept:** Anti-burnout flashcard app with AI-powered card creation

---

## Visual Design Requirements

### Core Design Language
- **Dark Theme:** True black (#000000) background with mesh gradients
- **Liquid Glass Effect:** Frosted glass cards with subtle white borders, inner glow, and blur effects
- **Mesh Gradients:** Multiple blurred colored circles creating ambient lighting
- **Colors:**
  - Accent Purple: #BF5AF2
  - Accent Blue: #0A84FF
  - Accent Pink: #FF375F
  - Accent Green: #30D158
  - Accent Orange: #FF9F0A
  - Text Primary: White
  - Text Secondary: #8E8E93

### Glass Effect Specifications
- **Material:** Ultra-thin frosted glass with blur
- **Border:** 1-2px white stroke with 18-40% opacity
- **Inner Glow:** Subtle white gradient glow on top-left edge
- **Shadow:** Soft black shadow (40% opacity, 16px blur, 8px offset)
- **Corner Radius:** 24-32px continuous rounded corners
- **Background:** White gradient overlay (10% → 5% → 2% opacity from top-left to bottom-right)

### Mesh Background Pattern
```
Background Composition:
- Base: Pure black (#000000)
- Circle 1: Purple (#BF5AF2, 40% opacity, 100px blur, offset: -100x, -200y)
- Circle 2: Blue (#0A84FF, 30% opacity, 100px blur, offset: 100x, 200y)
- Circle 3: Pink (#FF375F, 20% opacity, 80px blur, offset: 0x, 0y)
```

### Typography
- **Title Large:** 34pt Bold, White
- **Title 1:** 28pt Bold, White
- **Title 2:** 22pt Bold, White
- **Headline:** 17pt Semibold, White
- **Body:** 17pt Regular, White
- **Subheadline:** 15pt Regular, #8E8E93
- **Caption:** 12pt Regular, #636366

---

## Screens to Design (16 total)

### 1. Onboarding Flow (8 Screens)

**Screen 1.1: Welcome**
```
Layout:
- Top 30%: Floating animated flashcards (glass effect, slight rotation)
- Center: App logo + "No Pressure Flashcards" in Title Large
- Below: "Learn without the pressure" in Body text (#8E8E93)
- Bottom 20%: Large "Get Started" button (liquid glass capsule, purple glow)
- Mesh gradient background (purple + blue circles)
```

**Screen 1.2: How It Works — Snap & Learn**
```
Layout:
- Top: Camera icon (large, 80pt, white with purple glow)
- Title 1: "Snap & Learn"
- Body: "AI creates flashcards from photos, PDFs, or text" (#8E8E93)
- Center: Mockup of camera scanning textbook → flashcards animation
- Bottom: "Continue" button (liquid glass)
- Progress dots at bottom (1/3 filled with purple)
```

**Screen 1.3: How It Works — No Guilt**
```
Layout:
- Top: Heart icon (80pt, pink glow)
- Title 1: "No Guilt, No Burnout"
- Body: "Miss a day? No problem. No streaks, no pressure." (#8E8E93)
- Center: Illustration of calendar with gentle checkmarks, no red X's
- Bottom: "Continue" button
- Progress dots (2/3 filled)
```

**Screen 1.4: How It Works — Smart Repetition**
```
Layout:
- Top: Brain icon (80pt, blue glow)
- Title 1: "Smart Repetition"
- Body: "FSRS algorithm shows cards at optimal time" (#8E8E93)
- Center: Animated cards appearing at timed intervals
- Bottom: "Continue" button
- Progress dots (3/3 filled)
```

**Screen 1.5: Personalization — Goal**
```
Layout:
- Title 2: "What's your goal?"
- Grid (2x2) of large glass selection cards:
  - "🎓 Ace my exams" (glass card, purple border when selected)
  - "🗣️ Learn a language" (glass card)
  - "💼 Professional growth" (glass card)
  - "🧠 General knowledge" (glass card)
- Each card: emoji (40pt) + text (17pt Semibold)
- Bottom: "Continue" button (disabled state until selection)
```

**Screen 1.6: Personalization — Time**
```
Layout:
- Title 2: "How much time per day?"
- Vertical stack of 4 glass cards:
  - "⚡ 5 min — Quick learner"
  - "☕ 15 min — Steady pace"
  - "📚 30 min — Dedicated"
  - "🚀 60 min — Power user"
- Each card has left-aligned emoji + text, right chevron
- Selected state: purple border glow
- Bottom: "Continue" button
```

**Screen 1.7: Personalization — Interests**
```
Layout:
- Title 2: "What interests you?"
- Subheadline: "Select all that apply" (#8E8E93)
- Wrapped pill chips (multi-select):
  - Science, History, Languages, Math, Medicine
  - Law, Art, Tech, Business, Music
- Each chip: glass effect, white border, purple fill when selected
- Bottom: "Continue" button (shows "3 selected")
```

**Screen 1.8: Sign Up**
```
Layout:
- Title 2: "Create your account"
- Large "Continue with Apple" button (black with Apple logo)
- "Continue with Google" button (white border, Google logo)
- "Continue with Email" link (text button, blue)
- Bottom: Small text links "Terms of Service" | "Privacy Policy" (#636366)
- Mesh background with all 3 color circles
```

### 2. Main App Screens (4 Tab Views)

**Screen 2.1: Home Tab**
```
Layout:
- Top: "Good morning, Alex" (Title 1)
- Large glass card: "Today's Goal"
  - Inside: Circular progress ring (0/20 cards, purple)
  - "Start Learning" button below
- Section: "Due Today" (Headline)
- Horizontal scroll of deck preview cards (3 visible):
  - Each: Glass card with deck icon, name, "12 cards due"
- Bottom: Tab bar (5 icons, Home selected in purple)
```

**Screen 2.2: Create Tab**
```
Layout:
- Title 1: "Create Flashcards"
- 3 large glass option cards (vertical stack):
  - "📷 Camera" — "Snap notes or textbook"
  - "📄 PDF" — "Import documents"
  - "✍️ Text" — "Paste or type"
- Each card: left emoji (60pt), title (17pt Semibold), subtitle (15pt #8E8E93)
- Bottom: "Create Manually" text link (blue)
- Tab bar (Create tab selected)
```

**Screen 2.3: Library Tab**
```
Layout:
- Top: Search bar (glass effect, rounded, magnifying glass icon)
- Filter pills: "All" (selected, purple) | "Recent" | "Favorites"
- Grid (2 columns) of deck cards:
  - Each card: glass effect, deck icon (top), name, "24 cards" counter
  - Progress ring around icon showing completion %
  - 6 decks visible in scrollable grid
- Tab bar (Library selected)
```

**Screen 2.4: Explore Tab**
```
Layout:
- Top: Search bar
- Headline: "Categories"
- Horizontal scroll of category chips (glass pills):
  - Popular, Languages, Science, History, Math
- Section: "Featured Decks"
- Vertical list of featured deck cards:
  - Glass card with deck preview, title, author, download count
  - "Add to Library" button on each
- Tab bar (Explore selected)
```

### 3. Study Flow (4 Screens)

**Screen 3.1: Study Setup**
```
Layout:
- Large deck preview card (glass, centered):
  - Deck icon (80pt)
  - Deck name (Title 2)
  - "24 cards to review" (Body, #8E8E93)
- Section: "Study Mode"
- 3 mode selector cards (horizontal):
  - "🎴 Flashcards" (selected, purple border)
  - "❓ Quiz"
  - "✍️ Write"
- Large "Start Session" button (purple glow, bottom)
```

**Screen 3.2: Flashcard Mode**
```
Layout:
- Top: Thin progress bar (purple gradient)
- Card counter: "3 of 20" (Caption, top-right)
- Center: Large flip card (glass effect):
  - Front shown: "What is the capital of France?" (Title 2, centered)
  - Tap icon hint at bottom of card
- Bottom: 4 rating buttons (horizontal):
  - "Again" (pink)
  - "Hard" (orange)
  - "Good" (blue)
  - "Easy" (green)
- Each button: glass capsule with colored border
```

**Screen 3.3: Quiz Mode**
```
Layout:
- Top: Progress bar + "Question 5 of 20" + "Score: 4/5"
- Question card (glass, large):
  - "What is the capital of France?" (Title 2)
- 4 answer option cards (glass, stacked):
  - "Paris" (selected, green border + checkmark)
  - "London" (gray)
  - "Berlin" (gray)
  - "Madrid" (gray)
- Bottom: "Next" button (appears after answer)
```

**Screen 3.4: Session Complete**
```
Layout:
- Top: 🎉 Celebration animation (confetti particles)
- Center glass card:
  - "Great job!" (Title 1)
  - Stats grid (3 columns):
    - "20" — "Cards reviewed"
    - "85%" — "Accuracy"
    - "12 min" — "Time spent"
- Bottom: Two buttons:
  - "Continue" (purple, primary)
  - "Done" (glass outline)
- Mesh background with all colors
```

---

## Export Specifications

**For Midjourney/AI Generation:**
```
Style: iOS 26 mobile app UI, liquid glass design, dark theme, frosted glass effects, ultra-thin material blur, mesh gradient background with purple blue pink circles, modern minimalist, high quality, professional mockup, dark mode, glassmorphism, SF Symbols icons

Aspect Ratio: 9:19.5 (iPhone screen)
Quality: High resolution, detailed UI elements
Lighting: Subtle inner glow on glass elements, ambient colored lighting from mesh gradients
```

**For Figma Design:**
- Create all screens as separate frames in single file
- Use Auto Layout for responsive components
- Create component library for glass cards, buttons, and chips
- Include interactive prototype with transitions
- Export at @3x for iPhone 15 Pro (1290x2796px)

---

## Key Design Principles

1. **Glass Over Solid:** All cards and containers use frosted glass effect, never solid fills
2. **Soft Shadows:** 16px blur, 8px Y-offset, 40% black opacity
3. **Continuous Corners:** All rounded corners use .continuous (smoother iOS style)
4. **Purple Accent:** Primary actions and selections use #BF5AF2
5. **No Pressure UX:** Gentle colors, encouraging copy, no red warnings or streak counters
6. **Subtle Animations:** Spring animations on card flips and button presses
7. **Haptic Feedback:** Visual indicators for tap states (slight scale + glow)

---

## Component Library Needed

- [ ] Glass Card (Large)
- [ ] Glass Card (Small)
- [ ] Liquid Button (Filled)
- [ ] Liquid Button (Outline)
- [ ] Selection Chip (Pill)
- [ ] Tab Bar Item
- [ ] Progress Ring
- [ ] Progress Bar
- [ ] Flip Card Animation
- [ ] Mesh Gradient Background (3 variants)

---

## Deliverables

1. **All 16 screens** designed in Figma or as high-res images
2. **Component library** with reusable glass elements
3. **Interactive prototype** showing screen transitions
4. **Design system documentation** with exact color codes, spacing, and effects
5. **Export assets** at @1x, @2x, @3x for iOS development

---

**Design Reference:**
- iOS 26 Liquid Glass UI Kit: https://www.figma.com/design/DXF5bi1XgFzpPYOyyHx6bf/flashcard
- HTML Prototype: See index.html in project folder
- Inspiration: Apple's iOS 26 design language, glassmorphism trend, ambient mesh gradients
