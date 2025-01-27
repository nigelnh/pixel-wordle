import Foundation

class WordleModel: ObservableObject {
    @Published var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 5)
    @Published var currentRow = 0   
    @Published var currentCol = 0
    @Published var gameOver = false
    @Published var targetWord = ""
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showHint = false
    @Published var hint: String = ""
    @Published var currentScore = 0
    @Published var highScore: Int {
        didSet {
            UserDefaults.standard.set(highScore, forKey: "highScore")
            UserDefaults.standard.synchronize()
        }
    }
    @Published var showHighScore = false
    @Published var gameWon = false
    @Published var usedHints: Set<Int> = []
    
    let api = WordAPI()
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "highScore")
        Task {
            await fetchNewWord()
        }
    }
    
    func fetchNewWord() async {
        do {
            resetGame()
            targetWord = try await api.getRandomWord().uppercased()
        } catch {
            targetWord = "SWIFT" // Fallback word
        }
    }
    
    func resetGame() {
        guesses = Array(repeating: Array(repeating: nil, count: 5), count: 5)
        currentRow = 0
        currentCol = 0
        gameOver = false
        gameWon = false
        showHighScore = false
        usedHints = []
        showHint = false
    }
    
    func addLetter(_ letter: String) {
        guard currentCol < 5 && currentRow < 5 else { return }
        guesses[currentRow][currentCol] = Character(letter)
        currentCol += 1
    }
    
    func removeLetter() {
        guard currentCol > 0 else { return }
        currentCol -= 1
        guesses[currentRow][currentCol] = nil
    }
    
    func submitGuess() {
        guard currentCol == 5 else {
            showError = true
            errorMessage = "Not enough letters"
            return
        }
        
        let guess = String(guesses[currentRow].compactMap { $0 })
        
        if guess == targetWord {
            currentScore += 1
            gameWon = true
            gameOver = true
            if currentScore > highScore {
                highScore = currentScore
            }
            return
        }
        
        currentRow += 1
        currentCol = 0
        
        if currentRow == 5 {
            gameOver = true
            showHighScore = true
            currentScore = 0
        }
    }
    
    func letterColor(at position: (row: Int, column: Int)) -> LetterResult {
        guard let letter = guesses[position.row][position.column] else {
            return .empty
        }
        
        if position.row >= currentRow {
            return .empty
        }
        
        let guess = String(guesses[position.row].compactMap { $0 })
        let targetLetters = Array(targetWord)
        
        if letter == targetLetters[position.column] {
            return .correct
        } else if targetWord.contains(letter) {
            return .wrongPosition
        } else {
            return .wrong
        }
    }
    
    func generateHint() {
        if currentRow == 0 && currentCol == 0 {
            usedHints = []
        }
        
        let targetLetters = Array(targetWord)
        var unguessedPositions: [Int] = []
        
        for (index, letter) in targetLetters.enumerated() {
            var isGuessed = false
            for row in 0..<currentRow {
                if let guessedLetter = guesses[row][index], guessedLetter == letter {
                    isGuessed = true
                    break
                }
            }
            if !isGuessed && !usedHints.contains(index) {
                unguessedPositions.append(index)
            }
        }
        
        if unguessedPositions.isEmpty {
            usedHints = []
            hint = "No more hints available!"
            return
        }
        
        let randomPosition = unguessedPositions.randomElement()!
        usedHints.insert(randomPosition)
        
        let letter = targetLetters[randomPosition]
        let position = randomPosition + 1
        hint = "Letter '\(letter)' is at position \(position)!"
    }
    
    func resetHighScore() {
        highScore = 0
    }
}

enum LetterResult {
    case empty
    case correct
    case wrongPosition
    case wrong
} 
