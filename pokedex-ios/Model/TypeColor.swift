//
//  PokeColor.swift
//  pokedex-ios
//
//  Created by Josua Friederichs on 01.08.25.
//

import Foundation
import SwiftUI

enum TypeColor: String, CaseIterable {
    case normal, fire, water, electric, grass
    case ice, fighting, poison, ground, flying
    case psychic, bug, rock, ghost, dragon
    case dark, steel, fairy

    var color: Color {
        switch self {
        case .normal: return Color(hex: "#AAB09F")
        case .fire: return Color(hex: "#EA7A3C")
        case .water: return Color(hex: "#539AE2")
        case .electric: return Color(hex: "#E5C531")
        case .grass: return Color(hex: "#71C558")
        case .ice: return Color(hex: "#70CBD4")
        case .fighting: return Color(hex: "#CB5F48")
        case .poison: return Color(hex: "#B468B7")
        case .ground: return Color(hex: "#CC9F4F")
        case .flying: return Color(hex: "#7DA6DE")
        case .psychic: return Color(hex: "#E5709B")
        case .bug: return Color(hex: "#94BC4A")
        case .rock: return Color(hex: "#B2A061")
        case .ghost: return Color(hex: "#846AB6")
        case .dragon: return Color(hex: "#6A7BAF")
        case .dark: return Color(hex: "#736C75")
        case .steel: return Color(hex: "#89A1B0")
        case .fairy: return Color(hex: "#E397D1")
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r: UInt64
        let g: UInt64
        let b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1.0
        )
    }
}
