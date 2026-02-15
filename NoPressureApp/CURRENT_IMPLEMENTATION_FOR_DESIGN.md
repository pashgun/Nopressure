# No Pressure Flashcards - Текущая Реализация для Дизайна

## Обзор

Этот документ описывает **реальную имплементацию** приложения NoPressureApp на основе анализа исходного кода. Используйте его для создания схемы экранов и составления детальных требований к дизайну.

---

## Дизайн-система (Реализовано в коде)

### Цвета

**Primary Colors** (из кода):
- **Accent Primary**: `#BF5AF2` - Фиолетовый (основной акцент, градиенты)
- **Accent Secondary**: `#0A84FF` - Синий (кнопки, прогресс)
- **Error/Negative**: `#FF375F` - Красный (рейтинг "Again", ошибки)
- **Warning**: `#FF9F0A` - Оранжевый (рейтинг "Hard")
- **Success**: `#30D158` - Зеленый (рейтинг "Easy", завершение)

**Text Colors**:
- **Primary Text**: `#FFFFFF` - Белый (основной текст на темном фоне)
- **Secondary Text**: `#8E8E93` - Серый (вторичный текст, подзаголовки)
- **Background**: `#000000` - Черный (основной фон приложения)

**Градиенты** (используются повсеместно):
```swift
LinearGradient(
    colors: [Color(hex: "#BF5AF2"), Color(hex: "#0A84FF")],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Типографика

**Реализованные размеры** (SF Pro System Font):
- **Display Large**: 42pt Bold - Заголовок Welcome screen
- **Display**: 34pt Bold - Заголовки экранов, "Good morning"
- **Title 1**: 28pt Semibold - Основные карточки
- **Title 2**: 22pt Bold - Секции ("Due Today", "Today's Goal")
- **Title 3**: 20pt Semibold - Подзаголовки в карточках
- **Body**: 17pt Regular/Semibold - Основной текст, кнопки
- **Subhead**: 15pt Regular/Semibold - Вторичный текст
- **Caption**: 14pt Regular - Мелкий текст
- **Small**: 12pt Regular - Timestamps

### Компоненты Liquid Glass (Реализованы)

#### 1. **liquidGlass(cornerRadius: CGFloat = 24)**
```swift
.background(.ultraThinMaterial)
.background(LinearGradient белый 10%→5%→2%)
.clipShape(RoundedRectangle(cornerRadius))
.overlay(RoundedRectangle stroke white 0.18)
.shadow(black 0.4, radius: 16, y: 8)
```
**Использование**: карточки, контейнеры, хедеры

#### 2. **glassCard()**
```swift
.background(.ultraThinMaterial)
.background(Color.white.opacity(0.2))
.clipShape(RoundedRectangle(cornerRadius: 32))
.overlay(RoundedRectangle stroke white 2pt)
```
**Использование**: большие карточки (flashcards, stats)

#### 3. **liquidButton()**
```swift
.background(.ultraThinMaterial)
.clipShape(Capsule)
.overlay(Capsule stroke white 0.4)
.overlay(Capsule inner glow gradient)
```
**Использование**: основные кнопки действий

#### 4. **MeshBackground**
```swift
ZStack {
    Color.black
    Circle #BF5AF2 blur(100) offset(-100, -200)
    Circle #0A84FF blur(100) offset(100, 200)
    Circle #FF375F blur(80) offset(0, 0)
}
```
**Использование**: фон всех экранов (единообразный градиентный фон)

---

## Структура приложения

### Навигация верхнего уровня

**MainTabView** - 4 таба:
1. **Home** (house.fill) - Tag 0
2. **Create** (plus.circle.fill) - Tag 1
3. **Library** (folder.fill) - Tag 2
4. **Explore** (safari.fill) - Tag 3

**Tab Bar**:
- Цвет акцента: `#BF5AF2`
- Иконки: SF Symbols 24pt
- Selected: акцентный цвет
- Inactive: `#8E8E93`

---

## Экраны приложения (Реализованные)

### 1. ONBOARDING FLOW

#### **Screen 1: WelcomeView**
**Компоненты**:
- **Background**: MeshBackground (черный с градиентными blur circles)
- **Logo Icon**: brain.head.profile, 80pt, gradient `#BF5AF2`→`#0A84FF`
- **Title**: "No Pressure\nFlashcards", 42pt Bold, белый, центрирован
- **Subtitle**: "Learn without the pressure", 20pt Regular, `#8E8E93`
- **CTA Button**: "Get Started", 17pt Semibold, белый, height 56pt, liquidButton modifier
  - Padding horizontal: 32pt
  - Fixed bottom: 60pt from bottom

**Навигация**: Кнопка "Get Started" → HowItWorksView

**Анимация**: spring(response: 0.5, dampingFraction: 0.7) на переходе

---

#### **Screen 2: HowItWorksView**
**Структура**: Карусель из 3 страниц

**Общий Layout**:
- Background: MeshBackground
- Page Indicator: точки внизу (3 точки)
- "Continue" кнопка: liquidButton style, 56pt height

**3 страницы** (предполагается):
1. **Snap & Learn**: Создание карточек из фото/PDF/текста
2. **No Guilt**: Обучение без стресса, пропуски разрешены
3. **Smart Repetition**: FSRS алгоритм интервального повторения

**Навигация**: "Continue" на последней странице → PersonalizationView

---

#### **Screen 3: PersonalizationView**
**Структура**: Multi-step форма (3 шага)

**Step 1: Goal Selection**
- Вопрос: "What's your goal?"
- Варианты: LearningGoal enum (4-6 опций)
- Layout: Grid cards с иконками

**Step 2: Daily Minutes**
- Вопрос: "How much time per day?"
- Варианты: Int minutes (5, 15, 30, 60)
- Layout: Vertical stack buttons

**Step 3: Interests**
- Вопрос: "What interests you?"
- Варианты: Set<String> (Science, History, Languages, etc.)
- Layout: Wrapped pill chips

**Навигация**: Последний шаг → SignUpView

---

#### **Screen 4: SignUpView**
**Компоненты**:
- **Background**: MeshBackground
- **Header**: "Create your account", 28pt Bold, белый
- **Auth Buttons** (3 кнопки):
  - Apple: черный bg, apple.logo icon, белый текст
  - Google: белый bg, Google G logo, черный текст
  - Email: text link, `#0A84FF` цвет
- **Footer**: "Terms | Privacy", 12pt Regular, `#C7C7CC`

**Функциональность**:
- Симуляция задержки (1 секунда)
- После "авторизации" → completeOnboarding()

**Навигация**: Любая кнопка → MainTabView (isOnboardingComplete = true)

---

### 2. HOME TAB

#### **HomeView** - Главный экран

**Header Section**:
- **Greeting**: "Good morning/afternoon/evening, {userName}"
  - Font: 34pt Bold, белый
  - Padding: 24pt horizontal, 20pt top
  - userName: Берется из SwiftData Query users.first?.name ?? "Friend"
- **Subtitle**: "Ready to learn something new?"
  - Font: 17pt Regular, `#8E8E93`

**Today's Goal Card**:
- **Layout**: glassCard modifier, padding 24pt
- **Left Section**:
  - Title: "Today's Goal", 22pt Bold, белый
  - Progress: "0/20 cards reviewed", 15pt Regular, `#8E8E93`
- **Right Section**:
  - Progress Ring: 60×60pt
    - Background stroke: white 0.2 opacity, 6pt width
    - Active stroke: gradient `#BF5AF2`→`#0A84FF`, 6pt width, lineCap: round
    - Center text: "0%", 14pt Bold, белый
- **Start Button**: "Start Learning" с play.fill icon
  - liquidButton style, 56pt height

**Due Today Section**:
- **Header**: "Due Today", 22pt Bold, белый
- **Horizontal ScrollView**: показывает первые 5 decks
- **DeckCardView** (каждая карточка):
  - Size: 180pt width
  - liquidGlass(cornerRadius: 20)
  - Padding: 20pt
  - **Top Row**:
    - Deck icon: SF Symbol с colorHex цветом
    - Card count: справа, 14pt Semibold, `#8E8E93`
  - **Title**: deck.name, 17pt Semibold, белый, lineLimit: 2

**Empty State** (когда decks.isEmpty):
- Icon: folder.badge.plus, 60pt, gradient
- Title: "No decks yet", 22pt Bold, белый
- Subtitle: "Create your first deck to start learning", 15pt Regular, `#8E8E93`

**Analytics**: Трекает "Home" screen view с FabrikaAnalytics

---

### 3. CREATE TAB

#### **CreateView** - Выбор способа создания

**Header**:
- Title: "Create Flashcards", 34pt Bold, белый
- Padding top: 60pt

**Create Options** (3 карточки):

1. **Camera**
   - Emoji: 📷
   - Icon: camera.fill
   - Title: "Camera", 20pt Semibold, белый
   - Subtitle: "Snap notes or textbook", 14pt Regular, `#8E8E93`

2. **PDF**
   - Emoji: 📄
   - Icon: doc.fill
   - Title: "PDF", 20pt Semibold, белый
   - Subtitle: "Import documents", 14pt Regular, `#8E8E93`

3. **Text**
   - Emoji: ✍️
   - Icon: text.alignleft
   - Title: "Text", 20pt Semibold, белый
   - Subtitle: "Paste or type", 14pt Regular, `#8E8E93`

**CreateOptionCard Component**:
- glassCard() modifier
- Padding: 24pt
- HStack: emoji 40pt, текст, chevron.right справа
- Spacing между карточками: 16pt

**Manual Entry Link**:
- "Create Manually", 15pt Semibold, `#0A84FF`
- Padding bottom: 100pt (над Tab Bar)

**Sheets** (модальные окна):
- CameraCaptureView
- PDFImportView
- TextImportView
- ManualCreateView

---

### 4. LIBRARY TAB

#### **LibraryView** - Библиотека колод

**Search Bar**:
- Height: 44pt
- liquidGlass(cornerRadius: 12)
- Padding: 12pt
- Icon: magnifyingglass, `#8E8E93`, слева
- Placeholder: "Search decks...", 17pt Regular, `#8E8E93`
- Text: белый

**Filter Pills** (Horizontal Scroll):
- Варианты: "All", "Recent", "Favorites"
- **Pill Style**:
  - Height: 32pt
  - Padding: 20pt horizontal, 10pt vertical
  - Capsule shape
  - **Active**: gradient bg `#BF5AF2`→`#0A84FF`, белый текст
  - **Inactive**: clear bg, white 0.2 stroke, `#8E8E93` текст
- Spacing: 12pt
- Padding top: 16pt

**Deck Grid**:
- LazyVGrid: 2 columns, spacing 16pt
- Padding: 24pt

**DeckGridCard** (каждая карточка):
- liquidGlass(cornerRadius: 16)
- Padding: 16pt
- **Top Row**:
  - Deck icon: 24pt SF Symbol, colorHex цвет
  - Progress Ring: 32×32pt, stroke white 0.2 (3pt), center: card count (10pt Bold)
- **Title**: deck.name, 17pt Semibold, белый, lineLimit: 2
- **Last Studied**:
  - "Last studied Xd/Xh ago", 12pt Regular, `#8E8E93`
  - OR "Not studied yet"

**Empty State**:
- Icon: folder.badge.plus, 60pt, gradient
- Title: "No decks yet", 22pt Bold
- Subtitle: "Create your first deck to start learning", 15pt Regular

**Navigation**:
- NavigationTitle: "Library"
- NavigationBarTitleDisplayMode: .large

---

### 5. EXPLORE TAB

#### **ExploreView** - Готовые колоды сообщества

**Статус**: Базовая структура (может требовать детализации)

**Ожидаемые компоненты**:
- Search Bar (аналогично Library)
- Category Chips (Popular, Languages, Science, History...)
- Featured Decks (вертикальный список)
- Deck Preview Cards с кнопками "Add to Library"

---

### 6. STUDY FLOW

#### **StudySessionView** - Сессия обучения

**Header**:
- **Close Button**: xmark icon, liquidGlass(12pt), left
- **Progress Counter**: "X / Y", 17pt Semibold, белый, liquidGlass(12pt), center
- **Spacer**: справа для симметрии

**StudyModeSelector**:
- 3 режима: Flashcard, Quiz, Write
- Segmented control style
- Padding top: 16pt

**Progress Bar** (общий для всех режимов):
- Height: 4pt
- Background: white 0.2 opacity
- Fill: gradient `#BF5AF2`→`#0A84FF`
- Padding: 16pt top, 24pt horizontal

---

#### **Mode 1: Flashcard Mode** (Default)

**FlipCard Component**:
- **Size**: Frame height 400pt
- **Style**: glassCard()
- **Padding**: 32pt horizontal
- **Animation**: rotation3DEffect по Y axis (90°)
- **Flip Timing**: spring(response: 0.5, dampingFraction: 0.7)

**Front Side**:
- Text: card.front, 28pt Semibold, белый, centered
- Footer: "Tap to reveal", 15pt Regular, `#8E8E93`

**Back Side**:
- Text: card.back, 28pt Semibold, белый, centered

**Rating Buttons** (показываются после flip):
- 4 кнопки: Again, Hard, Good, Easy
- Layout: HStack, spacing 12pt
- Padding: 24pt horizontal

**RatingButton Style**:
- Text: 15pt Semibold, белый
- Padding vertical: 16pt
- Background: цвет рейтинга
- Clip: RoundedRectangle(12pt)

**Цвета рейтингов**:
- Again: `#FF375F` (красный)
- Hard: `#FF9F0A` (оранжевый)
- Good: `#0A84FF` (синий)
- Easy: `#30D158` (зеленый)

**Функциональность**:
- FSRS алгоритм: FSRSService.processReview()
- Сохранение прогресса: modelContext.save()
- Analytics: FlashcardEvent.cardRated
- Анимация перехода: spring + delay 0.3s

---

#### **Mode 2: Quiz Mode**

**QuizModeView** (реализовано):
- Вопрос с 4 вариантами ответа
- 1 правильный, 3 случайных неправильных
- Immediate feedback (зеленая галочка / красный X)
- Score tracking
- FSRS integration
- "Next" button после ответа

---

#### **Mode 3: Write Mode**

**WriteModeView** (реализовано):
- Вопрос (front)
- TextField для ввода ответа
- Submit button
- Fuzzy matching (Levenshtein distance, 80% threshold)
- Показ правильного ответа если неправильно
- FSRS integration
- "Next" button

---

#### **SessionCompleteView** - Завершение сессии

**Layout**:
- Background: MeshBackground
- Centered content

**Success Icon**:
- checkmark.circle.fill, 80pt
- Gradient: `#30D158`→`#0A84FF`

**Content**:
- Title: "Great job!", 34pt Bold, белый
- Subtitle: "You reviewed X cards", 17pt Regular, `#8E8E93`
- Spacing: 12pt

**Done Button**:
- Text: "Done", 17pt Semibold, белый
- liquidButton style, 56pt height
- Padding: 32pt horizontal, 60pt bottom

---

## Модели данных (SwiftData)

### User
```swift
@Model
class User {
    var name: String
    var email: String?
    var goal: String?
    var dailyMinutes: Int?
    var interests: [String]
    var createdAt: Date
}
```

### Deck
```swift
@Model
class Deck {
    var name: String
    var icon: String // SF Symbol name
    var colorHex: String // e.g. "#BF5AF2"
    var cards: [Flashcard]
    var lastStudied: Date?
    var createdAt: Date
}
```

### Flashcard
```swift
@Model
class Flashcard {
    var front: String
    var back: String
    var deck: Deck?
    var fsrsData: FSRSData?
    var createdAt: Date
}
```

### FSRSData
```swift
@Model
class FSRSData {
    var difficulty: Double
    var stability: Double
    var retrievability: Double
    var lastReview: Date?
    var nextReview: Date?
    var repetitions: Int
    var lapses: Int
}
```

---

## Функциональные возможности

### ✅ Реализовано

1. **Onboarding Flow** (4 экрана)
   - Welcome → How It Works → Personalization → Sign Up
   - Сохранение preferences в SwiftData (User model)

2. **Main Navigation** (4 таба)
   - Home: Dashboard с прогрессом и due cards
   - Create: Выбор способа создания (Camera/PDF/Text/Manual)
   - Library: Все колоды с поиском и фильтрами
   - Explore: Featured decks (базовая структура)

3. **Card Creation**
   - Manual: ManualCreateView (форма создания)
   - Camera: CameraCaptureView (OCR → AI generation)
   - PDF: PDFImportView (PDFKit → AI generation)
   - Text: TextImportView (paste → AI generation)
   - Review Generated Cards: ReviewGeneratedCardsView (редактирование перед сохранением)

4. **Study Modes** (3 режима)
   - Flashcard: 3D flip карточки с 4 рейтингами
   - Quiz: Multiple choice с 4 вариантами
   - Write: Текстовый ввод с fuzzy matching

5. **FSRS Integration**
   - FSRSService: processReview(card, rating)
   - Automatic scheduling: nextReview calculation
   - Due cards filtering

6. **Analytics Integration**
   - FabrikaAnalytics tracking
   - События: screen views, study sessions, card ratings
   - Локальное хранение в SwiftData

7. **Design System**
   - Liquid Glass components (liquidGlass, glassCard, liquidButton)
   - MeshBackground (gradient blur circles)
   - Consistent color palette
   - SF Pro typography system

---

## Компоненты многоразового использования

### UI Components

1. **MeshBackground**
   - Черный фон с 3 blur circles
   - Используется на всех экранах

2. **liquidGlass(cornerRadius)**
   - Стекло эффект для карточек
   - Настраиваемый cornerRadius

3. **glassCard()**
   - Большие карточки с stronger glass effect
   - cornerRadius: 32pt

4. **liquidButton()**
   - Кнопки с inner glow
   - Capsule shape

5. **DeckCardView**
   - Компактная карточка колоды
   - Icon, название, count
   - Используется в Home tab

6. **DeckGridCard**
   - Карточка колоды для grid layout
   - Icon, название, progress ring, last studied
   - Используется в Library tab

7. **CreateOptionCard**
   - Карточка опции создания
   - Emoji, icon, title, subtitle, chevron
   - Используется в Create tab

8. **FlipCard**
   - 3D flip анимация
   - Front/back sides
   - CardSide subcomponent

9. **RatingButton**
   - Кнопка рейтинга карточки
   - Цветная, текст, action
   - 4 варианта: Again/Hard/Good/Easy

10. **StudyModeSelector**
    - Выбор режима обучения
    - 3 варианта: Flashcard/Quiz/Write

---

## Анимации и переходы

### Реализованные анимации

1. **Screen Transitions**
   - `.transition(.opacity)` - fade между onboarding screens
   - `.spring(response: 0.5, dampingFraction: 0.7)` - основная spring animation

2. **Card Flip**
   - `rotation3DEffect(.degrees(90), axis: (x: 0, y: 1, z: 0))`
   - Spring animation: response 0.5, damping 0.7

3. **Button Selection**
   - Filter pills: spring(response: 0.3, dampingFraction: 0.7)
   - Rating buttons: immediate response

4. **Progress Bar**
   - Smooth width transition
   - Gradient fill

5. **Card Rating Flow**
   - Flip animation → delay 0.3s → move to next card
   - Spring animation на всем flow

---

## Цветовая схема по функциям

### Feedback Colors

- **Negative** (Again): `#FF375F` - Красный
- **Warning** (Hard): `#FF9F0A` - Оранжевый
- **Neutral** (Good): `#0A84FF` - Синий
- **Positive** (Easy): `#30D158` - Зеленый
- **Success** (Complete): `#30D158` - Зеленый

### UI Element Colors

- **Primary Action**: Gradient `#BF5AF2`→`#0A84FF`
- **Secondary Action**: `#0A84FF` text link
- **Text Primary**: `#FFFFFF`
- **Text Secondary**: `#8E8E93`
- **Disabled**: `#C7C7CC`
- **Background**: `#000000`
- **Glass Overlay**: white с opacity 0.02-0.2

---

## Spacing System

### Padding Values (из кода)

- **Screen edge**: 24pt horizontal
- **Section spacing**: 32pt vertical
- **Component spacing**: 16pt-20pt
- **Button padding**: 16pt vertical
- **Card padding**: 20pt-24pt
- **Small spacing**: 8pt-12pt
- **Bottom safe area**: 60pt-100pt

### Corner Radius Values

- **Large cards**: 32pt (glassCard)
- **Standard cards**: 24pt (liquidGlass default)
- **Small cards**: 16pt-20pt
- **Buttons**: 12pt (rating buttons)
- **Capsule**: full radius (liquidButton)

---

## Technical Implementation Notes

### Services

1. **FSRSService**
   - `processReview(card: Flashcard, rating: AppRating, now: Date = Date()) -> FSRSData`
   - Использует swift-fsrs library v5.0.0
   - Алгоритм интервального повторения

2. **AIGenerationService** (Actor)
   - `generateFlashcards(from text: String) async throws -> [GeneratedFlashcard]`
   - OpenRouter API (Claude 3.5 Sonnet)
   - API key в Config.xcconfig (gitignored)
   - Error handling: AIError enum

3. **OCRService** (Actor)
   - `extractText(from image: UIImage) async throws -> String`
   - Vision framework: VNRecognizeTextRequest
   - Accurate recognition level

4. **UserService**
   - `getCurrentUser(context: ModelContext) -> User?`
   - `createUser(name, email, goal, dailyMinutes, interests, context) -> User`
   - CRUD helper для User model

5. **AnalyticsService** (FabrikaAnalytics)
   - `track(_ event: AnalyticsEvent, context: ModelContext?)`
   - SwiftData local storage
   - Amplitude + AppsFlyer integration (опционально)

---

## Empty States

### Реализованные пустые состояния

1. **Home - No Decks**
   - Icon: folder.badge.plus, gradient
   - "No decks yet"
   - "Create your first deck to start learning"

2. **Library - No Decks**
   - Icon: folder.badge.plus, gradient
   - "No decks yet"
   - "Create your first deck to start learning"

3. **Study - No Cards**
   - Text: "No cards to review"
   - 22pt Bold, белый

---

## Error Handling

### Реализованные алерты

1. **Study Session Errors**
   - `.alert("Error", isPresented: $showError)`
   - errorMessage: String с localizedDescription
   - Используется при save failures

2. **Data Persistence**
   - Все save operations обернуты в do-catch
   - Показывают alert при ошибке

---

## Для дизайнера: Задачи

На основе этого документа дизайнер должен:

### 1. Создать визуальную схему экранов
- Flow chart всех экранов
- Connections между экранами
- Модальные окна и sheets

### 2. Детализировать каждый экран
- Точные размеры и positioning
- Layout constraints
- Responsive behavior

### 3. Создать компонентную библиотеку
- Все UI компоненты как Figma components
- Variants для разных состояний
- Auto Layout настройки

### 4. Определить взаимодействия
- Tap areas
- Swipe gestures
- Long press actions
- Animation specs

### 5. Accessibility
- Touch targets (минимум 44×44pt)
- Color contrast (WCAG AA)
- VoiceOver labels
- Dynamic Type support

### 6. Edge Cases
- Loading states
- Error states
- Empty states (уже частично реализованы)
- Long text handling

### 7. Dark Mode
- Приложение уже в темной теме
- Убедиться в консистентности цветов

---

## Gaps & Recommendations

### Что может требовать дизайна

1. **Explore Tab Details**
   - Сейчас базовая структура
   - Нужен дизайн featured deck cards
   - Deck preview модальное окно

2. **Deck Detail View**
   - Экран не реализован
   - Нужен дизайн для просмотра всех карточек колоды
   - Edit/Delete actions

3. **Settings/Profile**
   - Не реализовано
   - Может понадобиться для User preferences
   - Privacy settings для Analytics

4. **Loading States**
   - AI generation loading indicators
   - OCR processing progress
   - Network request loaders

5. **Onboarding Illustrations**
   - How It Works 3 страницы используют placeholder content
   - Нужны иконки/иллюстрации для каждой фичи

6. **Manual Create Flow**
   - ManualCreateView реализовано
   - Может понадобиться улучшенный UX для множественного создания карточек

---

## Итог

Этот документ содержит **полный срез текущей реализации** NoPressureApp:
- ✅ Все реализованные экраны
- ✅ Все компоненты дизайн-системы
- ✅ Точные цвета и размеры из кода
- ✅ Функциональность каждого элемента
- ✅ Модели данных и сервисы

Используйте его для:
1. Создания визуальной схемы приложения
2. Составления детальных требований к дизайну
3. Разработки Figma компонентов
4. Планирования будущих улучшений

**Файл готов для передачи дизайн-агенту для дальнейшей работы.**
