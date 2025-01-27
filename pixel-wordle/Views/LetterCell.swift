import SwiftUI

struct LetterCell: View {
    let letter: Character?
    let result: LetterResult
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .border(themeManager.textColor.opacity(0.3), width: 2)
                .aspectRatio(1, contentMode: .fit)
            
            if let letter = letter {
                Text(String(letter))
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(textColor)
            }
        }
    }
    
    private var backgroundColor: Color {
        switch result {
        case .empty:
            return themeManager.backgroundColor
        case .correct:
            return themeManager.correctColor
        case .wrongPosition:
            return themeManager.wrongPositionColor
        case .wrong:
            return themeManager.wrongColor
        }
    }
    
    private var textColor: Color {
        result == .empty ? themeManager.textColor : .white
    }
} 