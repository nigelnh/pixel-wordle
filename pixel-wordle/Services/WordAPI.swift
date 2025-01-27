import Foundation

class WordAPI {
    func getRandomWord() async throws -> String {
        let url = URL(string: "https://random-word-api.herokuapp.com/word?length=5")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let words = try JSONDecoder().decode([String].self, from: data)
        return words[0]
    }
} 