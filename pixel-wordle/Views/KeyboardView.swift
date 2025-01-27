import SwiftUI

struct KeyboardView: View {
    @ObservedObject var wordleModel: WordleModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    let rows = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "DELETE"]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { key in
                        KeyboardButton(key: key) {
                            handleKeyPress(key)
                        }
                    }
                }
            }
        }
    }
    
    private func handleKeyPress(_ key: String) {
        switch key {
        case "ENTER":
            wordleModel.submitGuess()
        case "DELETE":
            wordleModel.removeLetter()
        default:
            wordleModel.addLetter(key)
        }
    }
}

struct KeyboardButton: View {
    let key: String
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Text(key)
                .font(.system(size: key.count > 1 ? 12 : 18, weight: .medium, design: .monospaced))
                .frame(minWidth: key.count > 1 ? 60 : 30, minHeight: 40)
                .background(themeManager.keyboardColor)
                .foregroundColor(themeManager.textColor)
                .cornerRadius(6)
        }
    }
} 