//
//  PokemonService.swift
//  pokedex-ios
//
//  Created by Josua Friederichs on 09.07.25.
//

import Combine
import Foundation

public class PokemonService: ObservableObject {
    @Published var pokemon: [Pokemon] = []

    private var requests: AnyCancellable?
    private let urls: [URL] = (1...151).compactMap {
        URL(string: "https://pokeapi.co/api/v2/pokemon/\($0)")
    }

    public func loadPokemon() {
        print("[PokemonService] Starting to load Pokémon...")

        testConnection() // Optional connection test
        fetchPokemon()
    }

    private func testConnection() {
        let testURL = URL(string: "https://pokeapi.co/api/v2/pokemon/1")!
        URLSession.shared.dataTask(with: testURL) { data, response, error in
            if let error = error {
                print("[Network Test] Connection failed: \(error.localizedDescription)")
            } else if let data = data {
                print("[Network Test] Connection successful. Received \(data.count) bytes.")
            }
        }.resume()
    }

    private func fetchPokemon() {
        requests = pokemonPublisher(for: urls)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("[PokemonService] All Pokémon loaded successfully.")
                }
            }, receiveValue: { pokemons in
                self.pokemon = pokemons.sorted(by: { $0.id < $1.id })
                print("[PokemonService] Loaded \(self.pokemon.count) Pokémon.")
            })
    }

    private func pokemonPublisher(for urls: [URL]) -> AnyPublisher<Pokemon, Never> {
        Publishers.Sequence(sequence: urls.map { pokemonPublisher(for: $0) })
            .flatMap(maxPublishers: .max(5)) { $0 }
            .eraseToAnyPublisher()
    }

    private func pokemonPublisher(for url: URL) -> AnyPublisher<Pokemon, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                print("[PokemonService] Loaded Pokémon: \(pokemon.name) (ID: \(pokemon.id))")
                return pokemon
            }
            .catch { error -> Empty<Pokemon, Never> in
                print("[PokemonService] Failed to load from URL \(url.lastPathComponent): \(error.localizedDescription)")
                return Empty()
            }
            .eraseToAnyPublisher()
    }
}
