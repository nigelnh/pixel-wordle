import SwiftUI

struct ScanlineView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,
                            themeManager.textColor.opacity(0.02),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 2)
                .offset(y: -1)
                .repeatEffect()
        }
        .allowsHitTesting(false)
    }
}

extension View {
    func repeatEffect() -> some View {
        self.modifier(RepeatViewModifier())
    }
}

struct RepeatViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<Int(geometry.size.height/2), id: \.self) { _ in
                    content
                }
            }
        }
    }
} 