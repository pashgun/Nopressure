# No Pressure Flashcards - Детальная Спецификация для Дизайнера

## Дизайн-система

### Цвета
- **Primary Accent**: #009dff (Electric Blue) - основные кнопки, активные состояния, прогресс-бары
- **Background**: #FFFFFF (белый) - основной фон
- **Secondary Background**: #F2F2F7 (iOS System Gray 6) - разделение блоков
- **Text Primary**: #1C1C1E (почти черный)
- **Text Secondary**: #8E8E93 (серый)
- **Success**: #34C759 (зеленый)
- **Error**: #FF3B30 (красный)

### Типографика (SF Pro)
- **Display Large**: SF Pro Display Bold, 40pt - главные заголовки
- **Display**: SF Pro Display Bold, 34pt - заголовки экранов
- **Title 1**: SF Pro Display Semibold, 28pt - заголовки секций
- **Title 2**: SF Pro Display Semibold, 22pt - подзаголовки
- **Title 3**: SF Pro Display Semibold, 20pt - заголовки карточек
- **Body**: SF Pro Text Regular, 17pt - основной текст
- **Subhead**: SF Pro Text Regular, 15pt - вторичный текст
- **Caption**: SF Pro Text Regular, 12pt - мелкий текст

### Компоненты

#### Кнопки
**Primary Button** (Main CTA):
- Height: 56pt
- Corner Radius: 28pt (полное скругление)
- Background: #009dff
- Text: SF Pro Display Semibold 17pt, белый
- Shadow: 0px 4px 12px rgba(0,157,255,0.3)

**Secondary Button**:
- Height: 56pt
- Corner Radius: 28pt
- Background: прозрачный
- Border: 2pt solid #009dff
- Text: SF Pro Display Semibold 17pt, #009dff

**Pill Button** (для фильтров):
- Height: 36pt
- Corner Radius: 18pt
- Padding: 16pt horizontal
- Background (inactive): #F2F2F7
- Background (active): #009dff
- Text: SF Pro Text Semibold 15pt

#### Карточки
**Standard Card**:
- Corner Radius: 24pt
- Shadow: 0px 2px 8px rgba(0,0,0,0.08)
- Background: белый
- Padding: 20pt

**Photo Card** (для колод):
- Corner Radius: 24pt
- Shadow: 0px 8px 24px rgba(0,0,0,0.12)
- Aspect Ratio: 4:3 или 16:9
- Gradient Overlay: Linear от rgba(0,0,0,0) до rgba(0,0,0,0.6) снизу
- Text на градиенте: белый

**Swipe Card** (для обучения):
- Corner Radius: 32pt
- Shadow: 0px 10px 30px rgba(0,0,0,0.15)
- Width: 90% ширины экрана
- Photo Area: 60% высоты карточки
- Text Area: 40% высоты карточки

---

## Детальное описание экранов

### ЭКРАН 1: WELCOME (Приветствие)
**Задача**: Первое впечатление, вовлечение пользователя

**Компоненты**:
1. **Background Image** (Full Screen)
   - Фото: женщина 25-35 лет в кафе с ноутбуком и кофе
   - Lighting: теплый золотой свет (golden hour)
   - Style: lifestyle photography, shallow depth of field
   - Gradient overlay снизу: от transparent до rgba(0,0,0,0.4)

2. **Заголовок** (Center, 60% from top)
   - Text: "No Pressure Flashcards"
   - Font: SF Pro Display Bold 40pt
   - Color: белый
   - Shadow: 0px 2px 4px rgba(0,0,0,0.3)

3. **Подзаголовок** (12pt ниже заголовка)
   - Text: "Learn at your own pace"
   - Font: SF Pro Text Regular 17pt
   - Color: белый с 80% opacity

4. **CTA Button** (Fixed bottom, 60pt from bottom)
   - Text: "Get Started"
   - Style: Primary Button
   - Width: screen width - 48pt padding

**Навигация**: Переход на Onboarding Step 1

---

### ЭКРАН 2: ONBOARDING - Snap & Learn
**Задача**: Объяснить ключевую фичу - создание карточек из фото

**Layout**: Centered content на белом фоне

**Компоненты**:
1. **Photo Card** (Centered, 32pt from top)
   - Width: 90% screen width
   - Height: 400pt
   - Corner Radius: 24pt
   - Photo: Eiffel Tower на закате
   - Gradient overlay: rgba(0,0,0,0) → rgba(0,0,0,0.5) снизу

2. **Icon** (On photo, centered, 40% from card top)
   - Icon: 📷 или SF Symbol "camera.fill"
   - Size: 60pt
   - Color: белый
   - Glow: 0px 4px 16px rgba(255,255,255,0.4)

3. **Title on Photo** (16pt ниже иконки)
   - Text: "Snap & Learn"
   - Font: SF Pro Display Bold 28pt
   - Color: белый

4. **Description** (32pt ниже фото)
   - Text: "AI creates flashcards from photos, PDFs, or text"
   - Font: SF Pro Text Regular 17pt
   - Color: #1C1C1E
   - Width: 85% screen width
   - Text Align: Center
   - Line Height: 1.4

5. **Progress Dots** (60pt from bottom, centered)
   - 3 dots: ● ○ ○
   - Active dot: #009dff, 8pt diameter
   - Inactive dots: #C7C7CC, 8pt diameter
   - Spacing: 12pt между точками

**Навигация**: "Continue" button → Onboarding Step 2

---

### ЭКРАН 3: ONBOARDING - No Guilt
**Задача**: Донести философию "без стресса"

**Layout**: Аналогично Экрану 2

**Компоненты**:
1. **Photo Card**
   - Photo: Peaceful mountain/forest scene с утренним туманом
   - Colors: Soft greens, blues, white mist
   - Mood: Calm, serene

2. **Icon**
   - Icon: ❤️ или SF Symbol "heart.fill"
   - Size: 60pt
   - Color: #FF6B6B (coral)

3. **Title on Photo**
   - Text: "No Guilt, No Burnout"

4. **Description**
   - Text: "Miss a day? No problem. No streaks, no pressure."

5. **Progress Dots**: ○ ● ○ (второй активный)

**Навигация**: "Continue" → Onboarding Step 3

---

### ЭКРАН 4: ONBOARDING - Smart Repetition
**Задача**: Объяснить технологию FSRS

**Компоненты**:
1. **Photo Card**
   - Photo: Flat lay study desk (вид сверху) - организованные книги, блокноты
   - Style: Minimal, clean, organized
   - Colors: White desk, colorful book spines, blue accents

2. **Icon**
   - Icon: 🧠 или SF Symbol "brain.head.profile"
   - Size: 60pt
   - Color: #009dff

3. **Title on Photo**
   - Text: "Smart Repetition"

4. **Description**
   - Text: "FSRS algorithm shows cards at optimal time"

5. **Progress Dots**: ○ ○ ● (третий активный)

**Навигация**: "Get Started" → Goal Selection

---

### ЭКРАН 5: GOAL SELECTION (Выбор цели)
**Задача**: Персонализация опыта

**Layout**: Centered content

**Компоненты**:
1. **Header** (32pt from top)
   - Text: "What's your goal?"
   - Font: SF Pro Display Bold 28pt
   - Color: #1C1C1E
   - Align: Center

2. **Selection Grid** (2×2, 24pt ниже заголовка)
   - Gap: 16pt horizontal, 20pt vertical
   - Container padding: 24pt

3. **Goal Card** (каждая ячейка):
   - Size: 48% screen width × 140pt height
   - Corner Radius: 20pt
   - Background: белый
   - Border: 2pt solid #E5E5EA (normal)
   - Border: 2pt solid #009dff (selected)
   - Shadow: 0px 2px 8px rgba(0,0,0,0.08)
   - Selected state: background tint rgba(0,157,255,0.05)

   **Content Layout**:
   - Emoji: 40pt, centered, 24pt from top
   - Text: 17pt Semibold #1C1C1E, centered, 16pt ниже emoji

   **4 варианта**:
   - 🎓 "Ace my exams"
   - 🗣️ "Learn a language"
   - 💼 "Professional growth"
   - 🧠 "General knowledge"

4. **Continue Button** (Fixed bottom)
   - Disabled до выбора

**Навигация**: "Continue" → Time Selection

---

### ЭКРАН 6: TIME SELECTION (Время в день)
**Задача**: Понять commitment пользователя

**Компоненты**:
1. **Header** (32pt from top)
   - Text: "How much time per day?"
   - Font: SF Pro Display Bold 28pt
   - Align: Center

2. **Time Cards** (Vertical stack, 24pt ниже заголовка)
   - Spacing: 12pt между карточками
   - Width: 90% screen width

3. **Time Card** (каждая):
   - Height: 72pt
   - Corner Radius: 16pt
   - Background: белый
   - Border: 2pt solid #E5E5EA (normal)
   - Border: 2pt solid #009dff (selected)
   - Shadow: 0px 2px 8px rgba(0,0,0,0.08)
   - Selected: background tint rgba(0,157,255,0.05)

   **Content Layout**:
   - Emoji: 32pt, left 20pt from edge
   - Time duration: 17pt Bold #1C1C1E, 16pt right of emoji
   - Subtitle: 15pt Regular #8E8E93, 4pt ниже time
   - Chevron: 17pt #C7C7CC, right 20pt from edge → меняется на #009dff при selected

   **4 варианта**:
   - ⚡ "5 min" / "Quick learner"
   - ☕ "15 min" / "Steady pace"
   - 📚 "30 min" / "Dedicated"
   - 🚀 "60 min" / "Power user"

**Навигация**: "Continue" → Interests

---

### ЭКРАН 7: INTERESTS (Интересы)
**Задача**: Подобрать релевантный контент

**Компоненты**:
1. **Header** (32pt from top)
   - Text: "What interests you?"
   - Font: SF Pro Display Bold 28pt
   - Align: Center

2. **Subtitle** (8pt ниже заголовка)
   - Text: "Select all that apply"
   - Font: SF Pro Text Regular 15pt
   - Color: #8E8E93
   - Align: Center

3. **Pill Chips** (Wrapped flow, 24pt ниже subtitle)
   - Layout: Flex-wrap
   - Gap: 12pt horizontal, 12pt vertical
   - Container padding: 24pt horizontal

4. **Chip** (каждый):
   - Height: 40pt
   - Corner Radius: 20pt (full pill)
   - Padding: 16pt horizontal
   - Background (unselected): #F2F2F7
   - Background (selected): #009dff
   - Border (unselected): 1pt solid #E5E5EA
   - Text: 15pt Semibold
   - Text color (unselected): #1C1C1E
   - Text color (selected): белый
   - Shadow: 0px 1px 4px rgba(0,0,0,0.06)

   **10 вариантов**:
   Science, History, Languages, Math, Medicine, Law, Art, Tech, Business, Music

5. **Continue Button** (Fixed bottom)
   - Shows "X selected" when items selected

**Навигация**: "Continue" → Sign Up

---

### ЭКРАН 8: SIGN UP (Регистрация)
**Задача**: Создание аккаунта

**Компоненты**:
1. **Header** (80pt from top)
   - Text: "Create your account"
   - Font: SF Pro Display Bold 28pt
   - Align: Center

2. **Apple Button** (40pt ниже заголовка)
   - Width: 90% screen width
   - Height: 56pt
   - Corner Radius: 16pt
   - Background: #000000
   - Text: "Continue with Apple"
   - Text Font: 17pt Semibold белый
   - Icon: SF Symbol "apple.logo" белый, 24pt, left of text
   - Shadow: 0px 2px 8px rgba(0,0,0,0.15)

3. **Google Button** (16pt ниже Apple)
   - Width: 90% screen width
   - Height: 56pt
   - Corner Radius: 16pt
   - Background: белый
   - Border: 2pt solid #E5E5EA
   - Text: "Continue with Google"
   - Text Font: 17pt Semibold #1C1C1E
   - Icon: Google "G" logo (multicolor), left of text
   - Shadow: 0px 2px 8px rgba(0,0,0,0.08)

4. **Email Link** (24pt ниже Google button)
   - Text: "Continue with Email"
   - Font: 17pt Semibold
   - Color: #009dff
   - Style: Text link, no button
   - Align: Center

5. **Footer Links** (24pt from bottom, centered)
   - Text: "Terms of Service  |  Privacy Policy"
   - Font: 12pt Regular
   - Color: #C7C7CC
   - Separator: " | " между ссылками
   - Tappable area: 44×44pt minimum

**Навигация**: Любая кнопка → Home Tab

---

### ЭКРАН 9: HOME TAB (Главный экран)
**Задача**: Dashboard с текущим прогрессом и быстрым доступом

**Компоненты**:

1. **Status Bar** (Standard iOS)

2. **Greeting** (20pt from top safe area)
   - Text: "Good morning, Alex"
   - Font: SF Pro Display Bold 28pt
   - Color: #1C1C1E
   - Padding: 24pt horizontal

3. **Create Button** (20pt ниже greeting)
   - Width: screen width - 48pt
   - Height: 64pt
   - Background: #009dff
   - Corner Radius: 16pt
   - Shadow: 0px 4px 12px rgba(0,157,255,0.3)
   - Icon: "+" 24pt, white, left of text
   - Text: "Create New Cards", 17pt Semibold white

4. **Featured Deck Card** (24pt ниже button)
   - Width: screen width - 48pt
   - Height: 320pt
   - Corner Radius: 24pt
   - Shadow: 0px 8px 24px rgba(0,0,0,0.12)

   **Content**:
   - Background Photo: Mount Fuji at sunrise (landscape landmark)
   - Gradient overlay: rgba(0,0,0,0.4) на нижних 50%

   **Elements on Card**:
   - Deck name: "Japanese Basics" - 22pt Bold white, 24pt from bottom
   - Progress ring: 120pt diameter, #009dff stroke, centered
   - Card count: "0/20 cards" - 15pt Regular white, center of ring
   - Start button: 48pt height, white bg, #009dff text, bottom 20pt

5. **Section Header** (24pt ниже featured card)
   - Text: "Due Today"
   - Font: 17pt Semibold #1C1C1E
   - Padding: 24pt horizontal

6. **Due Cards Horizontal Scroll** (12pt ниже header)
   - ScrollView horizontal
   - Padding: 24pt left
   - Gap: 12pt между карточками

7. **Small Deck Card** (в scroll):
   - Width: 160pt
   - Height: 200pt
   - Corner Radius: 16pt
   - Shadow: 0px 4px 12px rgba(0,0,0,0.1)
   - Photo background: Thematic (beach для biology, architecture для history)
   - Gradient overlay: rgba(0,0,0,0.3) снизу
   - Deck name: 15pt Semibold white, bottom 12pt
   - Progress: "12/24" - 13pt Regular white 80%, bottom 8pt

8. **Tab Bar** (Bottom)
   - Height: 80pt (includes safe area)
   - Background: white с blur effect (ultraThinMaterial)
   - Border top: 1pt solid rgba(0,0,0,0.05)
   - 3 icons, равномерно распределены:
     - 🏠 Home (selected, #009dff)
     - 📚 Library (inactive, #8E8E93)
     - 🔍 Explore (inactive, #8E8E93)
   - Icon size: 24pt
   - Label: 10pt Regular под каждой иконкой

**Навигация**:
- Create Button → Create Options Modal
- Featured Card → Study Setup
- Small Card → Study Setup
- Tab Bar → соответствующие экраны

---

### ЭКРАН 10: CREATE OPTIONS (Модальное окно)
**Задача**: Выбор способа создания карточек

**Layout**: Modal sheet

**Компоненты**:

1. **Handle** (Top center)
   - Width: 36pt
   - Height: 5pt
   - Color: #C7C7CC
   - Corner Radius: 2.5pt
   - 12pt from top

2. **Header** (32pt from top)
   - Text: "How will you capture today?"
   - Font: SF Pro Display Bold 28pt
   - Color: #1C1C1E
   - Align: Center

3. **Option Cards** (Vertical stack, 24pt ниже header)
   - Width: screen width - 48pt
   - Spacing: 16pt между карточками

4. **Option Card** (каждая):
   - Height: 180pt
   - Corner Radius: 20pt
   - Shadow: 0px 6px 16px rgba(0,0,0,0.1)

   **Content**:
   - Background photo: Contextual to option
   - Gradient overlay: rgba(0,0,0,0) → rgba(0,0,0,0.6) на нижних 60%

   **Elements**:
   - Icon: 60pt emoji, centered horizontal, 40% from top, white
   - Title: 22pt Bold white, centered, 16pt ниже icon
   - Subtitle: 15pt Regular white 80%, centered, 8pt ниже title

   **3 варианта**:

   **Camera Card**:
   - Photo: Notebook with handwritten notes, pen, study materials
   - Icon: 📷
   - Title: "Camera"
   - Subtitle: "Snap notes or textbook"

   **PDF Card**:
   - Photo: PDF documents, papers
   - Icon: 📄
   - Title: "PDF"
   - Subtitle: "Import documents"

   **Text Card**:
   - Photo: Laptop, typing, text on screen
   - Icon: ✍️
   - Title: "Text"
   - Subtitle: "Paste or type"

5. **Manual Entry Link** (24pt ниже последней карточки, centered)
   - Text: "Manual Entry"
   - Font: 17pt Semibold
   - Color: #009dff
   - Underline on tap

**Навигация**:
- Any card → соответствующий импорт
- Manual Entry → Manual deck creation

---

### ЭКРАН 11: LIBRARY TAB (Библиотека)
**Задача**: Управление всеми колодами

**Компоненты**:

1. **Search Bar** (20pt from top safe area)
   - Width: screen width - 48pt
   - Height: 44pt
   - Background: #F2F2F7
   - Border: 1pt solid #E5E5EA
   - Corner Radius: 12pt
   - Placeholder: "Search decks..." - 17pt Regular #8E8E93
   - Icon: SF Symbol "magnifyingglass" - 16pt #8E8E93, left 16pt padding

2. **Filter Pills** (12pt ниже search)
   - Horizontal scroll если не влезают
   - Padding: 24pt horizontal
   - Gap: 8pt

3. **Filter Pill** (каждый):
   - Height: 32pt
   - Padding: 12pt horizontal
   - Corner Radius: 16pt
   - Background (inactive): #F2F2F7
   - Background (active): #009dff
   - Text: 15pt Semibold
   - Text (inactive): #1C1C1E
   - Text (active): white

   **Варианты**: All, Recent, Favorites

4. **Deck Grid** (20pt ниже filters)
   - 2 columns
   - Gap: 12pt
   - Padding: 24pt horizontal

5. **Deck Card** (в grid):
   - Width: 48% screen width
   - Height: 200pt
   - Corner Radius: 16pt
   - Shadow: 0px 4px 12px rgba(0,0,0,0.1)

   **Content**:
   - Photo: Full card background, thematic
   - Gradient overlay: rgba(0,0,0,0.3) на нижних 50%

   **Elements**:
   - Deck name: 17pt Bold white, 16pt from bottom
   - Progress: "12/24" - 13pt Regular white 80%, 12pt from bottom
   - Progress ring: Small 32pt diameter, top right corner, 12pt padding

   **Примеры**:
   - "Tropical Biology" - beach photo
   - "Indian History" - historical building
   - "Calculus 101" - math symbols
   - "Spanish Basics" - Spanish landscape

6. **Tab Bar** (Bottom, Library selected)

**Навигация**:
- Deck Card → Deck Detail
- Search → поиск
- Tab Bar → соответствующие экраны

---

### ЭКРАН 12: EXPLORE TAB (Исследование)
**Задача**: Найти новые готовые колоды

**Компоненты**:

1. **Search Bar** (20pt from top safe area)
   - Аналогично Library
   - Placeholder: "Search featured decks..."

2. **Category Chips** (12pt ниже search)
   - Horizontal scroll
   - Style: аналогично Filter Pills
   - Варианты: Popular, Languages, Science, History, Math, Travel...

3. **Section Header** (20pt ниже chips)
   - Text: "Featured Decks"
   - Font: 22pt Bold #1C1C1E
   - Padding: 24pt horizontal

4. **Featured Deck Cards** (Vertical scroll, 16pt ниже header)
   - Width: screen width - 48pt
   - Spacing: 20pt между карточками

5. **Featured Deck Card**:
   - Height: 280pt
   - Corner Radius: 20pt
   - Shadow: 0px 8px 20px rgba(0,0,0,0.1)

   **Layout**:
   - Photo: Top 65% (182pt)
   - White info section: Bottom 35% (98pt)
   - Gradient transition между photo и info

   **Photo Area**:
   - High quality photo, relevant to deck topic

   **Info Section** (white background):
   - Deck title: 20pt Bold #1C1C1E, 16pt padding horizontal/top
   - Author & stats: 13pt Regular #8E8E93, 8pt ниже title
     - Format: "by @username • X downloads"
   - Add button: 40pt height, blue border, #009dff text, bottom 12pt

   **Примеры**:
   - "Japanese Culture" by @studywithme • 1.2k downloads (Kyoto street photo)
   - "World Architecture" by @archi_learn • 890 downloads (Architecture photo)

6. **Tab Bar** (Bottom, Explore selected)

**Навигация**:
- Featured Card → Deck Preview
- Add button → добавляет в Library
- Tab Bar → соответствующие экраны

---

### ЭКРАН 13: STUDY SETUP (Настройка обучения)
**Задача**: Выбор режима обучения

**Компоненты**:

1. **Deck Preview Card** (40pt from top)
   - Width: screen width - 48pt
   - Height: 260pt
   - Corner Radius: 24px
   - Shadow: 0px 8px 24px rgba(0,0,0,0.12)

   **Content**:
   - Photo: Thematic landmark (e.g. Colosseum)
   - Gradient overlay: rgba(0,0,0,0.4) на нижних 60%

   **Elements**:
   - Deck icon: 🗺️ 60pt white, centered, 30% from top
   - Deck name: "World Landmarks" - 22pt Bold white, centered, 16pt ниже icon
   - Card count: "24 cards to review" - 15pt Regular white 80%, centered, 8pt ниже name

2. **Mode Label** (32pt ниже preview card)
   - Text: "Study Mode"
   - Font: 17pt Semibold #1C1C1E
   - Padding: 24pt horizontal

3. **Mode Selector Cards** (16pt ниже label)
   - Horizontal layout, 3 cards
   - Center alignment
   - Gap: 12pt

4. **Mode Card**:
   - Width: 30% screen width
   - Height: 100pt
   - Corner Radius: 16pt
   - Background: white
   - Border: 2pt solid #E5E5EA (inactive)
   - Border: 2pt solid #009dff (selected)
   - Shadow: 0px 2px 8px rgba(0,0,0,0.08)

   **Content**:
   - Emoji: 40pt, centered, 20pt from top
   - Label: 15pt Semibold #1C1C1E, centered, ниже emoji

   **3 варианта**:
   - 🎴 "Flashcards" (selected by default)
   - ❓ "Quiz"
   - ✍️ "Write"

5. **Start Button** (Fixed bottom, 60pt from bottom)
   - Text: "Start Session"
   - Style: Primary Button
   - Width: screen width - 48pt

**Навигация**:
- Start Button → соответствующий режим (Flashcard/Quiz/Write)

---

### ЭКРАН 14: FLASHCARD MODE (Режим карточек со свайпом)
**Задача**: Основной процесс обучения

**Компоненты**:

1. **Progress Bar** (Top edge)
   - Width: full width
   - Height: 4pt
   - Background: #E5E5EA
   - Fill: #009dff
   - Animated

2. **Counter** (Top right, 12pt from top safe area, 24pt from right)
   - Text: "3 of 20"
   - Font: 13pt Semibold #8E8E93

3. **Swipe Card** (Center of screen)
   - Width: 90% screen width
   - Height: 500pt
   - Corner Radius: 32pt
   - Shadow: 0px 10px 30px rgba(0,0,0,0.15)

   **Photo Area (60% высоты = 300pt)**:
   - Photo: Contextual (Eiffel Tower для French, Mount Fuji для Japanese)
   - Gradient overlay: rgba(0,0,0,0.5) для читаемости текста
   - Location badge: overlay, bottom left 16pt:
     - Background: ultraThinMaterial
     - Corner Radius: 12pt
     - Padding: 8pt
     - Icon: "mappin.and.ellipse" + text
     - Font: 12pt Semibold white

   **Text Area (40% высоты = 200pt, white background)**:
   - Front text: "Bonjour" - 42pt Bold #1C1C1E, centered
   - Divider: 40pt width, 4pt height, #009dff opacity 30%, centered
   - Back text (when flipped): "Hello / Good day" - 24pt Regular #1C1C1E, centered
   - Flip indicator: "Tap to flip" - 13pt Regular #8E8E93, bottom 20pt

   **Swipe Overlays** (появляются при свайпе):
   - "KNOW" label (right swipe):
     - Position: left, rotated -15deg
     - Font: 42pt Black
     - Color: #009dff
     - Border: 6pt solid #009dff
     - Opacity: зависит от offset

   - "RETRY" label (left swipe):
     - Position: right, rotated 15deg
     - Font: 42pt Black
     - Color: #FF3B30
     - Border: 6pt solid #FF3B30
     - Opacity: зависит от offset

4. **Rating Buttons** (Fixed bottom, 32pt from bottom)
   - 4 buttons, horizontal layout
   - Gap: 8pt
   - Width: каждая 22% screen width

   **Button Style**:
   - Height: 64pt
   - Background: white
   - Border: 2pt solid [color]
   - Corner Radius: 12pt
   - Shadow: 0px 2px 8px rgba(0,0,0,0.08)
   - Text: 15pt Semibold [color]

   **4 варианта**:
   - "Again" - #FF3B30 (красный)
   - "Hard" - #FF9F0A (оранжевый)
   - "Good" - #009dff (синий)
   - "Easy" - #34C759 (зеленый)

**Интеракции**:
- Tap на карточку → 3D flip animation (rotation3D по Y на 180°)
- Drag → offset + rotation + overlay opacity
- Swipe right (>150pt) → "Know", next card
- Swipe left (<-150pt) → "Retry", card goes to end
- Haptic feedback на threshold и completion

**Навигация**:
- Последняя карточка → Session Complete

---

### ЭКРАН 15: QUIZ MODE (Режим викторины)
**Задача**: Активный recall через выбор ответа

**Компоненты**:

1. **Progress Bar** (Top, аналогично Flashcard)

2. **Header** (12pt from top safe area)
   - Left: "Question 5 of 20" - 15pt Semibold #8E8E93
   - Right: "Score: 4/5" - 15pt Semibold #009dff
   - Padding: 24pt horizontal

3. **Question Card** (24pt ниже header)
   - Width: 90% screen width
   - Height: 180pt
   - Corner Radius: 20pt
   - Shadow: 0px 6px 16px rgba(0,0,0,0.1)

   **Content**:
   - Photo: Contextual (Eiffel Tower)
   - Gradient overlay: rgba(0,0,0,0.5)
   - Question text: "What is the capital of France?" - 22pt Bold white, centered

4. **Answer Cards** (Vertical stack, 20pt ниже question)
   - Width: 90% screen width
   - Spacing: 12pt
   - 4 карточки

5. **Answer Card**:
   - Height: 64pt
   - Corner Radius: 16pt
   - Background: white
   - Shadow: 0px 2px 8px rgba(0,0,0,0.08)
   - Text: 17pt Semibold #1C1C1E
   - Padding: 20pt horizontal

   **States**:
   - Normal: Border 2pt #E5E5EA
   - Selected (before reveal): Border 2pt #009dff, background tint rgba(0,157,255,0.05)
   - Correct (after reveal): Border 2pt #34C759, green checkmark icon right
   - Incorrect (after reveal): Border 2pt #FF3B30, red X icon right

   **4 варианта** (example):
   - "Paris" (correct, with ✓)
   - "London"
   - "Berlin"
   - "Madrid"

6. **Next Button** (появляется после выбора, fixed bottom 60pt)
   - Text: "Next"
   - Style: Primary Button
   - Width: screen width - 48pt

**Навигация**:
- Next Button → следующий вопрос
- Последний вопрос → Session Complete

---

### ЭКРАН 16: SESSION COMPLETE (Завершение сессии)
**Задача**: Celebration и мотивация

**Компоненты**:

1. **Background** (Full screen)
   - Photo: Mountain peak at sunset / inspirational nature
   - Lighting: Dramatic, golden hour
   - Mood: Achievement, success
   - Gradient overlay: rgba(0,0,0,0.6) full screen

2. **Congratulations Title** (30% from top, centered)
   - Text: "Great job, Alex!"
   - Font: SF Pro Display Bold 34pt
   - Color: white
   - Shadow: 0px 2px 4px rgba(0,0,0,0.3)

3. **Stats Card** (Centered)
   - Width: 85% screen width
   - Padding: 32pt
   - Background: white with 85% opacity (frosted glass effect)
   - Backdrop blur: 20pt
   - Corner Radius: 24pt
   - Shadow: 0px 16px 48px rgba(0,0,0,0.2)

   **Content Layout**:
   - Primary stat (top):
     - "25 cards reviewed"
     - Font: 22pt Bold #1C1C1E
     - Align: Center

   - Divider:
     - Width: 80% card width
     - Height: 1pt
     - Color: #E5E5EA
     - 24pt vertical spacing

   - Secondary stats (vertical stack, center aligned):
     - "15 minutes focused" - 17pt Regular #8E8E93
     - "90% accuracy" - 17pt Regular #8E8E93
     - Spacing: 16pt between stats

4. **Return Button** (32pt ниже stats card, centered)
   - Text: "Return to Home"
   - Style: Primary Button (но на прозрачном фоне, shadow более заметный)
   - Width: 85% screen width

5. **Confetti Animation** (Optional)
   - При появлении экрана
   - Падающее конфетти сверху
   - Colors: #009dff, #34C759, #FF9F0A

**Haptic**: Celebration feedback при появлении

**Навигация**:
- Return Button → Home Tab

---

## Дополнительные детали для дизайнера

### Анимации
1. **Screen Transitions**:
   - Push/Pop: 0.35s ease-in-out slide
   - Modal Present: 0.3s spring (dampingFraction: 0.85)

2. **Button Taps**:
   - Scale down to 0.95 на 0.15s
   - Haptic: light impact

3. **Card Swipes**:
   - Spring animation: response 0.4, dampingFraction 0.8
   - Rotation: max 15° based on offset
   - Haptic: selection на threshold, success/error на completion

4. **Card Flip**:
   - 3D rotation: rotation3DEffect по Y axis
   - Duration: 0.3s
   - Timing: easeInOut

5. **Progress Updates**:
   - Smooth transition: 0.5s ease-out

### Адаптация под разные размеры
- iPhone SE: Уменьшить padding до 16pt, размеры карточек пропорционально
- iPad: Использовать max-width 600pt для контента, центрировать
- Landscape: Для Swipe Card использовать horizontal layout (фото слева, текст справа)

### Accessibility
- Minimum touch target: 44×44pt
- Color contrast: WCAG AA (4.5:1 для текста)
- VoiceOver labels для всех интерактивных элементов
- Support Dynamic Type (шрифты должны масштабироваться)
- Reduce Motion: отключать 3D эффекты, использовать fade

### Пустые состояния (Empty States)
**Library (пустая)**:
- Illustration: Stack of cards
- Title: "No decks yet"
- Subtitle: "Create your first deck or explore featured content"
- CTA: "Get Started" button

**Search (no results)**:
- Icon: magnifyingglass
- Title: "No results found"
- Subtitle: "Try different keywords"

**Due Today (nothing due)**:
- Icon: checkmark.circle
- Title: "All caught up!"
- Subtitle: "Great job! Check back tomorrow"

---

## Навигация между экранами (Flow Chart)

```
Welcome
  ↓
Onboarding 1 → Onboarding 2 → Onboarding 3
  ↓
Goal Selection
  ↓
Time Selection
  ↓
Interests
  ↓
Sign Up
  ↓
╔════════════════════════════════════════╗
║           HOME TAB                     ║
║  • Featured Deck                       ║
║  • Due Today Cards                     ║
║  • Create Button → Create Options      ║
╚════════════════════════════════════════╝
       ↓                    ↓
   Study Setup         Library Tab
       ↓                    ↓
Flashcard Mode      Deck Detail
    Quiz Mode            ↓
   Write Mode       Study Setup
       ↓                ↓
Session Complete   [same modes]
       ↓
   Home Tab

Explore Tab → Deck Preview → Add to Library → Library Tab
```

---

## Ключевые файлы для разработки

После создания дизайна в Figma, экспортировать:

1. **Assets**:
   - Icons в PDF (vector, 1x 2x 3x)
   - Photos в JPG/WebP (оптимизированные для разных размеров)
   - Colors в Color Set (.colorset для Xcode)

2. **Specs**:
   - Spacing & Layout (Auto Layout parameters)
   - Typography (Font styles, sizes, weights)
   - Component variants (Button states, Card types)

3. **Prototypes**:
   - Swipe interactions для Flashcard Mode
   - Modal presentations
   - Tab navigation

---

Эта спецификация готова для передачи дизайнеру для создания макетов в Figma!
