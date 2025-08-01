//
//  ListItem.swift
//  pokedex-ios
//
//  Created by Josua Friederichs on 09.07.25.
//

import SwiftUI

struct ListItemView: View {
    // TODO: Durch die Daten von der API austauschen
    var pokemon: Pokemon

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(pokemon.name)
                        .foregroundStyle(Color.white)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text("#\(pokemon.id)")
                        .foregroundStyle(Color.black.opacity(0.2))
                        .fontWeight(.semibold)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(pokemon.types.prefix(2), id: \.self) { type in
                            Text(type.capitalized)
                                .fixedSize(horizontal: true, vertical: true)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(20)
                        }
                    }
                    .foregroundColor(.white)
                    .font(.caption2)

                    Spacer()

                    ZStack {
                        Image("pokeball")
                            .resizable()
                            .offset(x: 35, y: 20)
                            .scaledToFit()
                            .opacity(0.08)
                        AsyncImage(url: URL(string: pokemon.spriteUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                            case .failure:
                                Image(systemName: "xmark")
                                    .foregroundStyle(.red)
                                    .frame(width: 80, height: 80)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .offset(x: 10)
                    }
                    .frame(width: 100, height: 90)
                }
            }
            .padding(5)
        }
        .background(TypeColor(rawValue: pokemon.types.first!.lowercased())?.color ?? .gray)
        .cornerRadius(12)
        .shadow(radius: 10, x: 0, y: 0)
    }
}

#Preview {
    HStack {
        ListItemView(pokemon: .mock)
        ListItemView(pokemon: .mock)
    }
}
