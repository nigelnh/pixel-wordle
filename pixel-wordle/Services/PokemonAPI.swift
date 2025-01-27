import Foundation

class PokemonAPI {
    func getPokemonSprite() async throws -> String {
        let pokemonId = Int.random(in: 1...151)
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let pokemon = try JSONDecoder().decode(PokemonResponse.self, from: data)
        return pokemon.sprites.frontDefault
    }
}

struct PokemonResponse: Codable {
    let sprites: Sprites
}

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
} 