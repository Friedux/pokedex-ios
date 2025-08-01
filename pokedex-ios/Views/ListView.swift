import SwiftUI

struct ListView: View {
    @StateObject private var pokemonService = PokemonService()
    @State private var searchText = ""

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var filteredPokemon: [Pokemon] {
        if searchText.isEmpty {
            return pokemonService.pokemon
        } else {
            return pokemonService.pokemon.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemBackground).ignoresSafeArea()

            if pokemonService.pokemon.isEmpty {
                ProgressView("Load pokémon...")
            } else if filteredPokemon.isEmpty {
                Text("No Pokémon found")
                    .foregroundStyle(.secondary)
                    .padding(.top, 50)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        headerView

                        LazyVGrid(
                            columns: columns,
                            spacing: 12,
                            content: {
                                ForEach(filteredPokemon.indices, id: \.self) { index in
                                    let pokemon = filteredPokemon[index]
                                    ListItemView(pokemon: pokemon)
                                        .onAppear {
                                            if index == filteredPokemon.count - 1 {
                                                pokemonService.loadNextPokemon()
                                            }
                                        }
                                }
                            }
                        )
                        .padding(.horizontal, 12)
                    }
                    .padding(.top)
                }
                .searchable(text: $searchText, prompt: "Search for Pokémon")
            }
        }
        .onAppear {
            if pokemonService.pokemon.isEmpty {
                pokemonService.loadNextPokemon()
            }
        }
    }

    private var headerView: some View {
        HStack {
            Text("Pokédex")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading, 16)

            Spacer()

            Image("pokeball")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .opacity(0.1)
                .offset(x: 0, y: -20)
        }
    }
}

#Preview {
    ListView()
}
