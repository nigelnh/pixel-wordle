import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") private(set) var isDarkMode: Bool = false
    
    var backgroundColor: Color {
        isDarkMode ? .black : .white
    }
    
    var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    var correctColor: Color {
        Color("correct")
    }
    
    var wrongPositionColor: Color {
        Color("wrongPosition")
    }
    
    var wrongColor: Color {
        Color("wrong")
    }
    
    var keyboardColor: Color {
        isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2)
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
} 