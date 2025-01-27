//
//  ContentView.swift
//  pixel-wordle
//
//  Created by Nhân Nguyễn on 1/26/25.
//

import SwiftUI

struct SpeechBubble: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Bubble content
            Text(message)
                .font(.system(size: 12, design: .monospaced))
                .padding(6)
                .background(Color.white)
                .foregroundColor(.black)
                .fixedSize(horizontal: true, vertical: false)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black, lineWidth: 1)
                )
            
            // Bubble tail
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 6, y: 6))
                path.addLine(to: CGPoint(x: 12, y: 0))
                path.closeSubpath()
            }
            .fill(Color.white)
            .frame(width: 12, height: 6)
            .overlay(
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 6, y: 6))
                    path.addLine(to: CGPoint(x: 12, y: 0))
                }
                .stroke(Color.black, lineWidth: 1)
            )
            .offset(x: -6)
        }
        .fixedSize()
    }
}

struct ContentView: View {
    @StateObject private var wordleModel = WordleModel()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var pokemonVM = PokemonViewModel()
    
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            
            VStack {
                // Header
                HStack {
                    HStack(spacing: 4) {
                        Text("PIXEL WORDLE")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                        
                        // Pokemon sprite with hint
                        ZStack(alignment: .top) {
                            AsyncImage(url: pokemonVM.spriteURL) { image in
                                image
                                    .resizable()
                                    .interpolation(.none)
                                    .frame(width: 32, height: 32)
                                    .overlay(alignment: .top) {
                                        if wordleModel.showHint {
                                            SpeechBubble(message: wordleModel.hint)
                                                .offset(y: -20)
                                                .transition(.scale.combined(with: .opacity))
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            wordleModel.generateHint()
                                            wordleModel.showHint.toggle()
                                        }
                                    }
                            } placeholder: {
                                Color.clear
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .frame(width: 32, height: 32)
                    }
                    
                    Spacer()
                    
                    // Add score display
                    VStack(alignment: .trailing) {
                        Text("Score: \(wordleModel.currentScore)")
                            .font(.system(size: 16, design: .monospaced))
                        Text("Best: \(wordleModel.highScore)")
                            .font(.system(size: 12, design: .monospaced))
                            .opacity(0.7)
                    }
                    
                    Button(action: {
                        themeManager.toggleTheme()
                    }) {
                        Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 20))
                    }
                }
                .foregroundColor(themeManager.textColor)
                .padding()
                
                // Game Grid
                VStack(spacing: 8) {
                    ForEach(0..<5) { row in
                        HStack(spacing: 8) {
                            ForEach(0..<5) { column in
                                LetterCell(
                                    letter: wordleModel.guesses[row][column],
                                    result: wordleModel.letterColor(at: (row: row, column: column))
                                )
                                    .environmentObject(themeManager)
                            }
                        }
                    }
                }
                .padding()
                
                // Keyboard
                KeyboardView(wordleModel: wordleModel)
                    .environmentObject(themeManager)
                    .padding()
            }
        }
        .alert("Game Over", isPresented: $wordleModel.showHighScore) {
            Button("New Game") {
                Task {
                    await wordleModel.fetchNewWord()
                    pokemonVM.fetchRandomPokemon()
                }
            }
            .font(.system(.body, design: .monospaced))
        } message: {
            VStack {
                Text("The word was: \(wordleModel.targetWord)")
                Text("High Score: \(wordleModel.highScore)")
            }
            .font(.system(.body, design: .monospaced))
        }
        .alert("Congratulations!", isPresented: $wordleModel.gameWon) {
            Button("Next Word") {
                Task {
                    await wordleModel.fetchNewWord()
                    pokemonVM.fetchRandomPokemon()
                }
            }
            .font(.system(.body, design: .monospaced))
        } message: {
            Text("Current Score: \(wordleModel.currentScore)")
                .font(.system(.body, design: .monospaced))
        }
        .onAppear {
            pokemonVM.fetchRandomPokemon() // Fetch initial Pokemon
        }
        .alert("Error", isPresented: $wordleModel.showError) {
            Button("OK") { }
        } message: {
            Text(wordleModel.errorMessage)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
