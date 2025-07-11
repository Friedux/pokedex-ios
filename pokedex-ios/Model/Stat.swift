//
//  Stat.swift
//  pokedex-ios
//
//  Created by Josua Friederichs on 11.07.25.
//

import Foundation

struct Stat: Decodable {
    let name: String
    let baseStat: Int

    init(name: String, baseStat: Int) {
        self.name = name
        self.baseStat = baseStat
    }

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }

    enum StatKeys: String, CodingKey {
        case name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseStat = try container.decode(Int.self, forKey: .baseStat)

        let statContainer = try container.nestedContainer(keyedBy: StatKeys.self, forKey: .stat)
        name = try statContainer.decode(String.self, forKey: .name)
    }
}
