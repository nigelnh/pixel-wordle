import SwiftUI

class PokemonViewModel: ObservableObject {
    @Published var spriteURL: URL?
    @Published var isLoading = false
    private let api = PokemonAPI()
    
    func fetchRandomPokemon() {
        isLoading = true
        Task {
            do {
                let urlString = try await api.getPokemonSprite()
                DispatchQueue.main.async {
                    self.spriteURL = URL(string: urlString)
                    self.isLoading = false
                }
            } catch {
                print("Error fetching Pokemon: \(error)")
                self.isLoading = false
            }
        }
    }
} 