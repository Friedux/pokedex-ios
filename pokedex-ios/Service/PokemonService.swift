//
//  PokemonService.swift
//  pokedex-ios
//
//  Created by Josua Friederichs on 09.07.25.
//

import Combine
import Foundation

public class PokemonService: ObservableObject {

    // MARK: Public

    @Published public var pokemon: [Pokemon] = []

    public func loadNextPokemon() {
        print("[PokemonService] Starting to load Pokémon...")
        fetchNextBatch()
    }

    // MARK: Private

    private var requests: Set<AnyCancellable> = []
    private var currentIndex = 1
    private let batchSize = 20
    private let maxCount = 1025
    private var isLoading = false

    private func fetchNextBatch() {
        guard !isLoading else { return }
        isLoading = true

        let endIndex = min(currentIndex + batchSize - 1, maxCount)
        let urls: [URL] = stride(from: currentIndex, to: endIndex + 1, by: 1).compactMap {
            URL(string: "https://pokeapi.co/api/v2/pokemon/\($0)")
        }

        Publishers.MergeMany(
            urls.map {
                pokemonPublisher(for: $0)
            }
        )
        .collect()
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { _ in
                self.isLoading = false
                self.currentIndex = endIndex + 1
            },
            receiveValue: { newPokemon in
                self.pokemon.append(contentsOf: newPokemon)
                print("[PokemonService] Loaded \(newPokemon.count) new Pokémon.")
                self.pokemon.sort(by: { $0.id < $1.id })
            }
        )
        .store(in: &requests)
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
