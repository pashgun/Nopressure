# No Pressure Flashcards — Development Flow Specification
## Для агента разработки

---

## 1. ОБЩАЯ АРХИТЕКТУРА

### Платформа
- iOS 17+
- SwiftUI + SwiftData
- FSRS (Free Spaced Repetition Scheduler) алгоритм

### Навигация
- **TabView с 3 табами:**
  - Tab 1: `My Decks` (главный экран)
  - Tab 2: `Library` (публичные колоды)
  - Tab 3: `Profile` (настройки, статистика)

### Цветовая схема
- Primary Purple: `#BF5AF2`
- Primary Blue: `#0A84FF`
- Background: Dark/Light mode support
- Accent: Gradient purple-blue

---

## 2. ONBOARDING FLOW (6 экранов)

### 2.1 Splash Screen
```
Путь: App Launch → Splash
Длительность: 2 секунды
Элементы:
- Лого приложения (анимация появления)
- Название "No Pressure"
- Фоновый градиент
Переход: → Welcome (автоматически)
```

### 2.2 Welcome Screen
```
Путь: Splash → Welcome
Элементы:
- Hero изображение/иллюстрация
- Заголовок: "Learn without pressure"
- Подзаголовок: ценностное предложение
- Кнопка "Get Started"
Переход: → Who We Are
```

### 2.3 Who We Are Screen
```
Путь: Welcome → Who We Are
Элементы:
- Иллюстрация продукта
- Текст о философии "без давления"
- 3 bullet points преимуществ
- Кнопка "Continue"
- Skip button (→ Main App)
Переход: → Experience
```

### 2.4 Experience Screen
```
Путь: Who We Are → Experience
Элементы:
- Вопрос: "What's your experience with flashcards?"
- 3 опции (single select):
  - "New to flashcards"
  - "Used them before"
  - "Flashcard pro"
- Влияет на: начальные рекомендации
Переход: → Goals
```

### 2.5 Goals Screen
```
Путь: Experience → Goals
Элементы:
- Вопрос: "What do you want to learn?"
- Multi-select категории:
  - Languages
  - Science
  - History
  - Professional skills
  - Other
- Влияет на: рекомендации в Library
Переход: → Paywall
```

### 2.6 Paywall Screen
```
Путь: Goals → Paywall
Элементы:
- Feature comparison (Free vs Pro)
- Pricing: Monthly / Yearly
- "Start Free Trial" CTA
- "Continue with Free" link
Переход: → Main App (My Decks tab)
```

---

## 3. MAIN APP — TAB 1: MY DECKS

### 3.1 My Decks List Screen
```
Путь: Tab Bar → My Decks
Состояние Empty:
- Иллюстрация
- Текст: "No decks yet"
- CTA: "Create your first deck"

Состояние With Decks:
- Header: "My Decks" + Search icon
- Stats bar: Today's streak, Due cards
- List of DeckCard components:
  - Deck thumbnail/color
  - Deck name
  - Card count
  - Progress indicator
  - Last studied date
- FAB: "+" (Create new deck)

Действия:
- Tap deck → Deck View
- Long press → Context menu (Edit, Delete, Share)
- Tap "+" → Create Flow
```

### 3.2 Deck View Screen
```
Путь: My Decks → [Tap Deck]
Элементы:
- Header: Deck name + Edit button
- Progress ring (% mastered)
- Stats: Total cards, Due today, New cards
- Algorithm badge (SM-2 / Leitner / Simple)
- Card list preview (first 5 cards)
- Buttons:
  - "Study Now" (primary)
  - "Browse All Cards"
  - "Settings"

Действия:
- "Study Now" → Study Session
- "Browse All Cards" → Card List
- "Settings" → Deck Settings
```

### 3.3 Deck Settings Screen
```
Путь: Deck View → Settings
Элементы:
- Deck name (editable)
- Deck color/icon
- Algorithm selector:
  - SM-2 (рекомендуется)
  - Leitner (простой)
  - Simple (без интервалов)
- Daily limits:
  - New cards per day (slider 0-50)
  - Review limit (slider 0-200)
- Notifications toggle
- Export deck
- Delete deck

Сохранение: автоматическое
```

### 3.4 Card List Screen
```
Путь: Deck View → Browse All Cards
Элементы:
- Search bar
- Filter: All / New / Learning / Review / Mastered
- Sort: Created / Alphabetical / Due date
- Card items:
  - Front preview (truncated)
  - Status badge
  - Next review date
- "Add Card" button

Действия:
- Tap card → Card Edit
- Swipe left → Delete
```

### 3.5 Card Edit Screen
```
Путь: Card List → [Tap Card] OR "Add Card"
Элементы:
- Front side input (rich text)
- Back side input (rich text)
- Image attachment (optional)
- Audio attachment (optional)
- Tags input
- Preview toggle
- Save / Cancel buttons

Валидация:
- Front не может быть пустым
- Back не может быть пустым
```

---

## 4. MAIN APP — TAB 2: LIBRARY

### 4.1 Library Browse Screen
```
Путь: Tab Bar → Library
Элементы:
- Search bar
- Category filters (horizontal scroll):
  - All
  - Languages
  - Science
  - History
  - Professional
  - Popular
- Featured section: "Staff Picks"
- Grid of public decks:
  - Deck thumbnail
  - Name
  - Author
  - Card count
  - Download count
  - Rating

Действия:
- Tap deck → Library Deck Preview
- Search → Search Results
```

### 4.2 Library Deck Preview Screen
```
Путь: Library → [Tap Deck]
Элементы:
- Deck cover image
- Name + Author
- Description
- Card count + Download count
- Rating (stars)
- Sample cards preview (3-5 cards)
- "Add to My Decks" button
- "Preview Full Deck" button

Действия:
- "Add to My Decks" → копирует в My Decks
- Показать toast: "Deck added!"
```

---

## 5. MAIN APP — TAB 3: PROFILE

### 5.1 Profile Screen
```
Путь: Tab Bar → Profile
Элементы:
- User avatar + name
- Subscription status (Free / Pro)
- Statistics section:
  - Current streak (🔥 X days)
  - Total cards studied
  - Total time spent
  - Accuracy rate
- Settings links:
  - Account Settings
  - Notifications
  - Appearance (Dark/Light/System)
  - Algorithm Preferences
  - Export All Data
  - Help & Support
  - About
- "Upgrade to Pro" (if Free)
- Sign Out button
```

### 5.2 Statistics Detail Screen
```
Путь: Profile → [Tap Statistics]
Элементы:
- Calendar heatmap (GitHub style)
- Weekly chart (cards studied)
- Monthly trends
- Per-deck breakdown
- Achievements/badges
```

---

## 6. STUDY SESSION FLOW

### 6.1 Session Start Screen
```
Путь: Deck View → "Study Now"
Элементы:
- Deck name
- Cards due: X review + Y new
- Session goal selector:
  - Quick (5 min)
  - Normal (15 min)
  - Extended (30 min)
  - All due cards
- "Start Session" button

Логика:
- FSRS выбирает карточки по приоритету
- Сначала review, потом new (если лимит позволяет)
```

### 6.2 Study Card Screen
```
Путь: Session Start → Study
Состояние Front:
- Progress bar (X / Total)
- Card front content
- "Show Answer" button
- Swipe hint

Состояние Back (после tap/swipe):
- Card front (сверху, мельче)
- Card back content
- Rating buttons:
  - "Again" (красный) — забыл
  - "Hard" (оранжевый) — сложно
  - "Good" (зелёный) — нормально
  - "Easy" (синий) — легко
- Показывать next interval для каждой кнопки

Жесты:
- Swipe up → Show answer
- Swipe left → Again
- Swipe right → Good
- Tap rating → следующая карточка
```

### 6.3 Session Complete Screen
```
Путь: Study → [Last Card Rated]
Элементы:
- Celebration animation
- Session stats:
  - Cards studied
  - Accuracy (% correct)
  - Time spent
  - Streak updated
- "Great job!" message
- Buttons:
  - "Continue Studying" (if more due)
  - "Back to Deck"
  - "Share Progress"
```

---

## 7. CREATE FLOW

### 7.1 Create Options Screen
```
Путь: My Decks → "+" FAB
Элементы:
- Header: "Create New Deck"
- 3 options:
  1. "Create Manually" — пустая колода
  2. "Generate with AI" — Google Stitch API
  3. "Import" — из файла

Действия:
- Option 1 → Manual Create
- Option 2 → AI Generation
- Option 3 → Import Flow
```

### 7.2 Manual Create Screen
```
Путь: Create Options → "Create Manually"
Элементы:
- Deck name input
- Deck description (optional)
- Color picker
- Algorithm selector (default: SM-2)
- "Create Deck" button

После создания: → Deck View (empty deck)
```

### 7.3 AI Generation Screen
```
Путь: Create Options → "Generate with AI"
Шаг 1 - Topic:
- Topic input: "What do you want to learn?"
- Examples: "Spanish vocabulary", "Biology terms"
- "Generate" button

Шаг 2 - Generating:
- Loading animation
- "Generating cards..."
- API: Google Stitch

Шаг 3 - Preview:
- Generated cards list (editable)
- Edit individual cards
- Delete unwanted cards
- Card count: "X cards generated"
- "Add More" button
- "Save Deck" button

После сохранения: → Deck View
```

### 7.4 Import Flow Screen
```
Путь: Create Options → "Import"
Supported formats:
- CSV (column mapping UI)
- TXT (one card per line, separator)
- Anki export (.apkg) — future
- Quizlet export — future

Шаги:
1. Select file
2. Preview & map columns
3. Confirm import
4. → Deck View
```

---

## 8. iOS WIDGETS

### 8.1 Small Widget (2x2)
```
Название: "Quick Study"
Элементы:
- App icon (small)
- Streak count: "🔥 X"
- Due today: "X cards due"
- Tap action: → Study Session (first deck with due cards)
```

### 8.2 Medium Widget (4x2)
```
Название: "Deck Preview"
Элементы:
- Selected deck name
- Progress ring
- Due cards count
- Next review: "in X hours"
- Tap action: → Deck View

Настройка:
- User выбирает deck в widget configuration
```

---

## 9. DATA MODELS (SwiftData)

### Deck
```swift
@Model
class Deck {
    var id: UUID
    var name: String
    var description: String?
    var color: String // hex
    var algorithm: Algorithm // enum
    var dailyNewLimit: Int
    var dailyReviewLimit: Int
    var createdAt: Date
    var lastStudiedAt: Date?

    @Relationship(deleteRule: .cascade)
    var cards: [Card]
}
```

### Card
```swift
@Model
class Card {
    var id: UUID
    var front: String
    var back: String
    var imageData: Data?
    var audioURL: URL?
    var tags: [String]
    var createdAt: Date

    // FSRS fields
    var difficulty: Double
    var stability: Double
    var state: CardState // new, learning, review, relearning
    var due: Date
    var lastReview: Date?
    var reps: Int
    var lapses: Int

    @Relationship
    var deck: Deck
}
```

### StudySession
```swift
@Model
class StudySession {
    var id: UUID
    var deckId: UUID
    var startedAt: Date
    var endedAt: Date?
    var cardsStudied: Int
    var correctCount: Int
}
```

### UserStats
```swift
@Model
class UserStats {
    var currentStreak: Int
    var longestStreak: Int
    var totalCardsStudied: Int
    var totalTimeSpent: TimeInterval
    var lastStudyDate: Date?
}
```

---

## 10. FSRS ALGORITHM IMPLEMENTATION

### Параметры по умолчанию
```swift
struct FSRSParameters {
    let w: [Double] = [0.4, 0.6, 2.4, 5.8, 4.93, 0.94, 0.86, 0.01, 1.49, 0.14, 0.94, 2.18, 0.05, 0.34, 1.26, 0.29, 2.61]
    let requestRetention: Double = 0.9
    let maximumInterval: Int = 36500
}
```

### Rating → Interval Logic
```
Again (1): reset stability, short interval
Hard (2): slight increase
Good (3): normal increase based on stability
Easy (4): larger increase, boost stability
```

---

## 11. NAVIGATION SUMMARY

```
App Launch
    └── Splash → Welcome → Who We Are → Experience → Goals → Paywall
                                                                 │
                                                                 ▼
    ┌──────────────────── Tab Bar ────────────────────┐
    │                                                   │
    ▼                    ▼                    ▼
My Decks            Library              Profile
    │                    │                    │
    ├── Deck View        ├── Deck Preview     ├── Statistics
    │   ├── Study        │   └── Add to       ├── Settings
    │   │   └── Complete │       My Decks     └── Account
    │   ├── Card List    │
    │   │   └── Card Edit│
    │   └── Settings     │
    │                    │
    └── Create ──────────┘
        ├── Manual
        ├── AI Generate
        └── Import
```

---

## 12. ПРИОРИТЕТЫ РАЗРАБОТКИ

### MVP (Phase 1)
1. ✅ Basic navigation (3 tabs)
2. ✅ Deck CRUD
3. ✅ Card CRUD
4. ✅ Basic Study Session
5. ✅ FSRS algorithm
6. ⬜ Onboarding flow
7. ⬜ Local persistence (SwiftData)

### Phase 2
- AI card generation (Google Stitch)
- Library with public decks
- User accounts & sync
- Widgets

### Phase 3
- Import/Export
- Sharing
- Advanced statistics
- Apple Watch companion

---

*Документ для агента разработки*
*Версия: 2.0*
*Дата: Февраль 2026*
