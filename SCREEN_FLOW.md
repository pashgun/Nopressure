# No Pressure — Screen Flow

```mermaid
flowchart TB
    subgraph ONBOARDING["🚀 ONBOARDING"]
        Splash["Splash<br>1.5s auto"] --> Welcome["Welcome<br>Get Started"]
        Welcome --> WhoWeAre["Who We Are<br>Philosophy"]
        WhoWeAre --> Experience["Experience<br>Да/Нет"]
        Experience --> Goals["Goals<br>Multi-select"]
        Goals --> Paywall["Paywall<br>Free vs Pro"]
    end

    Paywall --> MainApp

    subgraph MainApp["📱 MAIN APP"]
        TabBar["Tab Bar"]
        TabBar --> Home["🏠 Home"]
        TabBar --> Library["🏛 Library"]
        TabBar --> Profile["👤 Profile"]
    end

    subgraph HomeTab["HOME TAB"]
        Home --> HeroCard["Hero Deck Card"]
        Home --> Stats["Stats Pills<br>Streak / Mastered"]
        Home --> Collections["My Collections"]
        Home --> FAB["FAB (+)"]
        FAB --> CreateMenu["Create Menu Sheet"]
    end

    subgraph CreateFlow["✨ CREATE FLOW"]
        CreateMenu --> Manual["📝 Вручную<br>ManualCreateView"]
        CreateMenu --> AI["✨ AI генерация<br>AIGenerationView"]
        CreateMenu --> Import["📥 Импорт<br>ImportDeckView"]
        CreateMenu --> Sheets["🔗 Google Sheets<br>GoogleSheetsView"]
    end

    subgraph LibraryTab["LIBRARY TAB"]
        Library --> Search["Search Bar"]
        Library --> Categories["Category Chips"]
        Library --> DeckGrid["Deck Grid 2x"]
        DeckGrid --> StudySetup
    end

    Collections --> DeckDetail["Deck Detail"]
    DeckDetail --> StudySession

    subgraph StudyFlow["📚 STUDY SESSION"]
        StudySetup["Study Setup<br>Mode Selector"] --> StudySession["Study Session<br>Swipe Cards"]
        StudySession --> Rating["FSRS Rating<br>Again/Hard/Good/Easy"]
        Rating --> |"next card"| StudySession
        Rating --> |"last card"| Complete["Session Complete<br>🎉 Stats"]
    end

    subgraph Modes["STUDY MODES"]
        StudySetup --> Flashcard["🎴 Flashcard"]
        StudySetup --> Quiz["❓ Quiz"]
        StudySetup --> Write["✍️ Write"]
    end

    Complete --> Home

    style ONBOARDING fill:#e8f4ff,stroke:#009dff
    style MainApp fill:#f0fff0,stroke:#34c759
    style StudyFlow fill:#fff0f5,stroke:#ff6b6b
    style CreateFlow fill:#fffde7,stroke:#ffc107
```

---

## Простая текстовая схема

```
┌─────────────────────────────────────────────────────────────────┐
│                         ONBOARDING                               │
│  Splash → Welcome → WhoWeAre → Experience → Goals → Paywall     │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      MAIN TAB BAR                                │
│                                                                  │
│     🏠 Home          🏛 Library          👤 Profile              │
│        │                 │                   │                   │
│        ▼                 ▼                   ▼                   │
│   ┌─────────┐      ┌──────────┐      ┌───────────┐              │
│   │Hero Card│      │Search    │      │User Info  │              │
│   │Stats    │      │Categories│      │Statistics │              │
│   │My Decks │      │Deck Grid │      │Settings   │              │
│   │FAB (+)  │      └──────────┘      └───────────┘              │
│   └─────────┘                                                    │
└─────────────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│                       CREATE MENU                                │
│                                                                  │
│   📝 Вручную    →  ManualCreateView                             │
│   ✨ AI генерация →  AIGenerationView                           │
│   📥 Импорт     →  ImportDeckView (Anki, Quizlet, CSV)         │
│   🔗 Google Sheets →  GoogleSheetsView                          │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      STUDY SESSION                               │
│                                                                  │
│   Deck Detail → Study Setup → Study Session → Complete          │
│                      │                │                          │
│                      ▼                ▼                          │
│               ┌──────────┐    ┌─────────────┐                   │
│               │Flashcard │    │FSRS Rating  │                   │
│               │Quiz      │    │Again | Hard │                   │
│               │Write     │    │Good  | Easy │                   │
│               └──────────┘    └─────────────┘                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Переходы (для разработчика)

| Откуда | Действие | Куда | Код |
|--------|----------|------|-----|
| Splash | auto 1.5s | Welcome | `currentScreen = 1` |
| Welcome | tap "Get Started" | WhoWeAre | `currentScreen = 2` |
| Paywall | any CTA | MainTabView | `isOnboardingComplete = true` |
| Home | tap deck row | DeckDetailView | `NavigationLink` |
| Home | tap FAB (+) | CreateMenuSheet | `.sheet(isPresented:)` |
| DeckDetail | tap "Учить" | StudySessionView | `.fullScreenCover` |
| Library | tap deck card | StudySetupView | `NavigationLink` |
| StudySetup | tap "Start" | StudySessionView/Quiz/Write | `navigationDestination` |
| StudySession | rate card | next card / Complete | `rateCard(rating:)` |
| Complete | tap "Return" | Home | `dismiss()` |
