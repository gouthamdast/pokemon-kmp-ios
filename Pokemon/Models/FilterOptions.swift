//
//  FilterOptions.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import Foundation

struct FilterOptions: Equatable {
    var selectedTypes: Set<PokemonType> = []
    var sortOption: SortOption = .numberAscending

    var isActive: Bool {
        !selectedTypes.isEmpty
    }

    func reset() -> FilterOptions {
        FilterOptions()
    }
}

enum SortOption: String, CaseIterable, Identifiable {
    case numberAscending = "Number (Low to High)"
    case numberDescending = "Number (High to Low)"
    case nameAscending = "Name (A-Z)"
    case nameDescending = "Name (Z-A)"

    var id: String { rawValue }
}

enum PokemonType: String, CaseIterable, Identifiable {
    case normal = "normal"
    case fire = "fire"
    case water = "water"
    case electric = "electric"
    case grass = "grass"
    case ice = "ice"
    case fighting = "fighting"
    case poison = "poison"
    case ground = "ground"
    case flying = "flying"
    case psychic = "psychic"
    case bug = "bug"
    case rock = "rock"
    case ghost = "ghost"
    case dragon = "dragon"
    case dark = "dark"
    case steel = "steel"
    case fairy = "fairy"

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}

extension PokemonType {
    var color: (red: Double, green: Double, blue: Double) {
        switch self {
        case .normal: return (0.66, 0.66, 0.47)
        case .fire: return (0.93, 0.50, 0.19)
        case .water: return (0.39, 0.56, 0.93)
        case .electric: return (0.98, 0.82, 0.18)
        case .grass: return (0.47, 0.78, 0.30)
        case .ice: return (0.60, 0.85, 0.85)
        case .fighting: return (0.75, 0.19, 0.15)
        case .poison: return (0.64, 0.25, 0.64)
        case .ground: return (0.88, 0.75, 0.42)
        case .flying: return (0.66, 0.56, 0.95)
        case .psychic: return (0.98, 0.33, 0.45)
        case .bug: return (0.66, 0.73, 0.13)
        case .rock: return (0.72, 0.63, 0.22)
        case .ghost: return (0.44, 0.35, 0.60)
        case .dragon: return (0.44, 0.21, 0.98)
        case .dark: return (0.44, 0.35, 0.27)
        case .steel: return (0.72, 0.72, 0.82)
        case .fairy: return (0.85, 0.51, 0.68)
        }
    }
}
