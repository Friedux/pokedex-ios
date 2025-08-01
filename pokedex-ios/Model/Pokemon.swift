//
//  Pokemon.swift
//  pokedex-ios
//
//  Created by Josua Friederichs on 09.07.25.
//

import Foundation

public class Pokemon: Decodable, Identifiable {
    internal init(name: String, id: Int, height: Int, weight: Int, types: [String], stats: [Stat], spriteUrl: String) {
        self.name = name
        self.id = id
        self.height = height
        self.weight = weight
        self.types = types
        self.stats = stats
        self.spriteUrl = spriteUrl
    }

    public let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [String]
    let stats: [Stat]
    let spriteUrl: String

    enum CodingKeys: String, CodingKey {
        case name, id, height, weight, types, stats, sprites
    }

    enum TypeElementKeys: String, CodingKey {
        case type
    }

    enum TypeKeys: String, CodingKey {
        case name
    }

    enum SpriteUrlKeys: String, CodingKey {
        case frontDefault = "front_default"
    }

    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)

        // Decode pokémon.types: [ { type: { name: String } } ]
        var typeArrayContainer = try container.nestedUnkeyedContainer(forKey: .types)
        var allTypes: [String] = []
        while !typeArrayContainer.isAtEnd {
            let typeContainer = try typeArrayContainer.nestedContainer(keyedBy: TypeElementKeys.self)
            let typeNameContainer = try typeContainer.nestedContainer(keyedBy: TypeKeys.self, forKey: .type)
            let typeName = try typeNameContainer.decode(String.self, forKey: .name)
            allTypes.append(typeName)
        }
        types = allTypes

        // Decoding pokémon.stats
        stats = try container.decode([Stat].self, forKey: .stats)

        // Decoding pokémon default sprite
        spriteUrl = try container.nestedContainer(keyedBy: SpriteUrlKeys.self, forKey: .sprites)
            .decode(String.self, forKey: .frontDefault)
    }

    // MARK: Static

    static let mock = Pokemon(
        name: "Charmander",
        id: 1,
        height: 80,
        weight: 150,
        types: ["Fire"],
        stats: [Stat(name: "speed", baseStat: 1)],
        spriteUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png"
    )
}
