import Foundation
import SwiftData

// MARK: - Bundled Deck Model

struct BundledDeck: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let colorHex: String
    let category: String
    let cards: [(front: String, back: String)]
}

// MARK: - Bundled Decks Service

final class BundledDecksService {

    /// Check if a bundled deck was already imported
    static func isImported(bundledId: String, in decks: [Deck]) -> Bool {
        decks.contains { $0.name == bundledId || $0.deckDescription.contains("[bundled:\(bundledId)]") }
    }

    /// Import a bundled deck into SwiftData
    static func importDeck(_ bundled: BundledDeck, into context: ModelContext) {
        let deck = Deck(
            name: bundled.name,
            description: bundled.description + " [bundled:\(bundled.id)]",
            colorHex: bundled.colorHex,
            icon: bundled.icon
        )
        context.insert(deck)

        for card in bundled.cards {
            let flashcard = Flashcard(
                front: card.front,
                back: card.back,
                deck: deck
            )
            context.insert(flashcard)
        }

        try? context.save()
    }

    // MARK: - All Bundled Decks

    static let allDecks: [BundledDeck] = [
        essentialEnglish,
        spanishBasics,
        biologyFundamentals,
        mathFormulas,
        worldCapitals,
        chemistryBasics,
        programmingConcepts,
        worldHistory,
        psychology101,
        musicTheory
    ]

    // MARK: - 1. Essential English Vocabulary

    static let essentialEnglish = BundledDeck(
        id: "essential-english",
        name: "Essential English Vocabulary",
        description: "Core English words and definitions for everyday use",
        icon: "globe",
        colorHex: "#5533FF",
        category: "Languages",
        cards: [
            ("Ubiquitous", "Present, appearing, or found everywhere"),
            ("Ephemeral", "Lasting for a very short time"),
            ("Pragmatic", "Dealing with things sensibly and realistically"),
            ("Ambiguous", "Open to more than one interpretation"),
            ("Eloquent", "Fluent or persuasive in speaking or writing"),
            ("Resilient", "Able to recover quickly from difficulties"),
            ("Benevolent", "Well-meaning and kindly"),
            ("Meticulous", "Showing great attention to detail"),
            ("Candid", "Truthful and straightforward; frank"),
            ("Diligent", "Having or showing care in one's work or duties"),
            ("Tenacious", "Holding firmly to something; persistent"),
            ("Inevitable", "Certain to happen; unavoidable"),
            ("Paradox", "A seemingly contradictory statement that may be true"),
            ("Empathy", "The ability to understand and share the feelings of another"),
            ("Altruistic", "Showing unselfish concern for the welfare of others")
        ]
    )

    // MARK: - 2. Spanish Basics

    static let spanishBasics = BundledDeck(
        id: "spanish-basics",
        name: "Spanish Basics",
        description: "Essential Spanish phrases and vocabulary for beginners",
        icon: "flag.fill",
        colorHex: "#FF7A4D",
        category: "Languages",
        cards: [
            ("Hello / Goodbye", "Hola / Adiós"),
            ("Please / Thank you", "Por favor / Gracias"),
            ("How are you?", "¿Cómo estás?"),
            ("My name is...", "Me llamo..."),
            ("I don't understand", "No entiendo"),
            ("Where is the bathroom?", "¿Dónde está el baño?"),
            ("How much does it cost?", "¿Cuánto cuesta?"),
            ("Good morning", "Buenos días"),
            ("Good night", "Buenas noches"),
            ("I would like...", "Me gustaría..."),
            ("Yes / No", "Sí / No"),
            ("Excuse me", "Disculpe / Perdón")
        ]
    )

    // MARK: - 3. Biology Fundamentals

    static let biologyFundamentals = BundledDeck(
        id: "biology-fundamentals",
        name: "Biology Fundamentals",
        description: "Key biology concepts: cells, DNA, evolution, and ecosystems",
        icon: "leaf.fill",
        colorHex: "#30D158",
        category: "Science",
        cards: [
            ("What is a cell?", "The basic structural and functional unit of all living organisms"),
            ("What is DNA?", "Deoxyribonucleic acid — a molecule that carries genetic instructions for development and functioning"),
            ("What is mitosis?", "Cell division that results in two identical daughter cells, each with the same number of chromosomes"),
            ("What is meiosis?", "Cell division that produces four gamete cells, each with half the number of chromosomes"),
            ("What is photosynthesis?", "The process by which plants convert sunlight, water, and CO₂ into glucose and oxygen"),
            ("What is natural selection?", "The process where organisms with favorable traits are more likely to survive and reproduce"),
            ("What is an ecosystem?", "A community of living organisms interacting with their physical environment"),
            ("What is ATP?", "Adenosine triphosphate — the primary energy carrier in all living cells"),
            ("What is the difference between prokaryotes and eukaryotes?", "Prokaryotes lack a nucleus; eukaryotes have a membrane-bound nucleus"),
            ("What is homeostasis?", "The tendency of organisms to maintain stable internal conditions"),
            ("What are ribosomes?", "Cellular structures responsible for protein synthesis"),
            ("What is evolution?", "The change in heritable characteristics of populations over successive generations")
        ]
    )

    // MARK: - 4. Math Formulas

    static let mathFormulas = BundledDeck(
        id: "math-formulas",
        name: "Math Formulas",
        description: "Essential algebra, geometry, and calculus formulas",
        icon: "function",
        colorHex: "#64D2FF",
        category: "Mathematics",
        cards: [
            ("Quadratic Formula", "x = (-b ± √(b² - 4ac)) / 2a"),
            ("Pythagorean Theorem", "a² + b² = c²"),
            ("Area of a Circle", "A = πr²"),
            ("Circumference of a Circle", "C = 2πr"),
            ("Slope of a Line", "m = (y₂ - y₁) / (x₂ - x₁)"),
            ("Distance Formula", "d = √((x₂-x₁)² + (y₂-y₁)²)"),
            ("Volume of a Sphere", "V = (4/3)πr³"),
            ("Area of a Triangle", "A = ½ × base × height"),
            ("Derivative of xⁿ", "d/dx(xⁿ) = nxⁿ⁻¹"),
            ("Sum of Arithmetic Series", "S = n/2 × (a₁ + aₙ)")
        ]
    )

    // MARK: - 5. World Capitals

    static let worldCapitals = BundledDeck(
        id: "world-capitals",
        name: "World Capitals",
        description: "Capitals of countries around the world",
        icon: "map.fill",
        colorHex: "#FF9F0A",
        category: "Geography",
        cards: [
            ("Capital of France", "Paris"),
            ("Capital of Japan", "Tokyo"),
            ("Capital of Brazil", "Brasília"),
            ("Capital of Australia", "Canberra"),
            ("Capital of Egypt", "Cairo"),
            ("Capital of Canada", "Ottawa"),
            ("Capital of India", "New Delhi"),
            ("Capital of Germany", "Berlin"),
            ("Capital of South Korea", "Seoul"),
            ("Capital of Argentina", "Buenos Aires"),
            ("Capital of Turkey", "Ankara"),
            ("Capital of Nigeria", "Abuja"),
            ("Capital of Thailand", "Bangkok"),
            ("Capital of South Africa", "Pretoria (executive), Cape Town (legislative), Bloemfontein (judicial)"),
            ("Capital of Switzerland", "Bern")
        ]
    )

    // MARK: - 6. Chemistry Basics

    static let chemistryBasics = BundledDeck(
        id: "chemistry-basics",
        name: "Chemistry Basics",
        description: "Elements, reactions, and fundamental chemistry concepts",
        icon: "atom",
        colorHex: "#FF453A",
        category: "Science",
        cards: [
            ("What is an atom?", "The smallest unit of an element that retains its chemical properties"),
            ("What is a molecule?", "Two or more atoms bonded together (e.g., H₂O)"),
            ("What is the periodic table?", "An arrangement of chemical elements ordered by atomic number, electron configuration, and properties"),
            ("What is pH?", "A scale from 0-14 measuring acidity (0-7) or alkalinity (7-14); 7 is neutral"),
            ("What is an ion?", "An atom with a net electric charge due to gaining or losing electrons"),
            ("What is a chemical bond?", "A lasting attraction between atoms that enables the formation of molecules"),
            ("What is Avogadro's number?", "6.022 × 10²³ — the number of particles in one mole of a substance"),
            ("What is an exothermic reaction?", "A reaction that releases energy (heat) to its surroundings"),
            ("What is an endothermic reaction?", "A reaction that absorbs energy (heat) from its surroundings"),
            ("What are the three states of matter?", "Solid, liquid, and gas (plus plasma)"),
            ("What is a catalyst?", "A substance that speeds up a chemical reaction without being consumed"),
            ("What is oxidation?", "The loss of electrons by a molecule, atom, or ion")
        ]
    )

    // MARK: - 7. Programming Concepts

    static let programmingConcepts = BundledDeck(
        id: "programming-concepts",
        name: "Programming Concepts",
        description: "Core programming and computer science fundamentals",
        icon: "chevron.left.forwardslash.chevron.right",
        colorHex: "#5533FF",
        category: "Technology",
        cards: [
            ("What is a variable?", "A named storage location in memory that holds a value which can change during program execution"),
            ("What is a function?", "A reusable block of code that performs a specific task and can accept inputs and return outputs"),
            ("What is an algorithm?", "A step-by-step procedure for solving a problem or accomplishing a task"),
            ("What is O(n) time complexity?", "Linear time — the execution time grows proportionally with the input size"),
            ("What is OOP?", "Object-Oriented Programming — a paradigm based on objects containing data (properties) and behavior (methods)"),
            ("What is recursion?", "A technique where a function calls itself to solve smaller instances of the same problem"),
            ("What is an API?", "Application Programming Interface — a set of rules that allows software components to communicate"),
            ("What is a database?", "An organized collection of structured data stored electronically"),
            ("What is version control?", "A system that tracks changes to files over time (e.g., Git)"),
            ("What is a stack vs. a queue?", "Stack: LIFO (Last In, First Out). Queue: FIFO (First In, First Out)"),
            ("What is an array?", "An ordered collection of elements, each identified by an index"),
            ("What is a boolean?", "A data type with only two possible values: true or false")
        ]
    )

    // MARK: - 8. World History

    static let worldHistory = BundledDeck(
        id: "world-history",
        name: "World History",
        description: "Key events and dates in world history",
        icon: "clock.fill",
        colorHex: "#FFD60A",
        category: "History",
        cards: [
            ("When did World War I begin?", "1914 — triggered by the assassination of Archduke Franz Ferdinand"),
            ("When did World War II end?", "1945 — ended with the surrender of Germany (May) and Japan (September)"),
            ("When was the French Revolution?", "1789–1799 — overthrow of the monarchy, rise of democratic ideals"),
            ("When did the Roman Empire fall?", "476 AD — fall of the Western Roman Empire"),
            ("When was the Declaration of Independence signed?", "July 4, 1776 — declaring American independence from Britain"),
            ("When did the Industrial Revolution begin?", "Late 18th century (~1760s) — starting in Britain with mechanized manufacturing"),
            ("When was the Berlin Wall erected/demolished?", "Built in 1961, fell on November 9, 1989"),
            ("When was the Renaissance?", "14th–17th century — cultural rebirth starting in Italy"),
            ("When did the Cold War take place?", "1947–1991 — geopolitical tension between the US and the Soviet Union"),
            ("What was the Magna Carta?", "A 1215 charter establishing that the king was subject to law, foundation of constitutional governance"),
            ("When did humans first land on the Moon?", "July 20, 1969 — Apollo 11, Neil Armstrong and Buzz Aldrin"),
            ("When did the Soviet Union dissolve?", "December 26, 1991")
        ]
    )

    // MARK: - 9. Psychology 101

    static let psychology101 = BundledDeck(
        id: "psychology-101",
        name: "Psychology 101",
        description: "Fundamental psychology theories and concepts",
        icon: "brain.head.profile",
        colorHex: "#FF7A4D",
        category: "Social Science",
        cards: [
            ("What is classical conditioning?", "Learning through association — Pavlov's experiment where dogs learned to salivate at a bell sound"),
            ("What is operant conditioning?", "Learning through rewards and punishments — developed by B.F. Skinner"),
            ("What is cognitive dissonance?", "Mental discomfort from holding contradictory beliefs or values"),
            ("What is Maslow's hierarchy of needs?", "A 5-level pyramid: physiological → safety → belonging → esteem → self-actualization"),
            ("What is the placebo effect?", "Improvement in condition caused by the belief in receiving treatment, not the treatment itself"),
            ("What is confirmation bias?", "The tendency to search for information that confirms existing beliefs"),
            ("What is the Dunning-Kruger effect?", "A cognitive bias where people with low ability overestimate their competence"),
            ("What is short-term memory capacity?", "About 7 ± 2 items (Miller's Law)"),
            ("What is the bystander effect?", "The tendency for individuals to be less likely to help when others are present"),
            ("What is attachment theory?", "Theory by Bowlby that early bonds between children and caregivers affect social and emotional development")
        ]
    )

    // MARK: - 10. Music Theory

    static let musicTheory = BundledDeck(
        id: "music-theory",
        name: "Music Theory",
        description: "Notes, scales, chords, and musical fundamentals",
        icon: "music.note",
        colorHex: "#64D2FF",
        category: "Arts",
        cards: [
            ("What are the 7 notes in a major scale?", "C, D, E, F, G, A, B (in the key of C major)"),
            ("What is a chord?", "Three or more notes played simultaneously"),
            ("What is a major chord?", "Root + major third + perfect fifth (e.g., C-E-G)"),
            ("What is a minor chord?", "Root + minor third + perfect fifth (e.g., C-E♭-G)"),
            ("What is tempo?", "The speed or pace of a musical piece, measured in BPM (beats per minute)"),
            ("What is a time signature?", "A notation indicating how many beats are in each measure (e.g., 4/4, 3/4)"),
            ("What is an octave?", "The interval between one pitch and another at double its frequency"),
            ("What are sharps and flats?", "Sharp (♯) raises a note by a half step; flat (♭) lowers a note by a half step"),
            ("What is a key signature?", "The set of sharps or flats at the beginning of a staff indicating the key of the music"),
            ("What is harmony?", "The combination of simultaneously sounded musical notes to produce chords and chord progressions")
        ]
    )
}
