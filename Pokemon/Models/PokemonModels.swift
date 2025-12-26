//
//  PokemonModels.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import Foundation

// Swift-friendly models that extend the KMP models

struct PokemonListItem: Identifiable {
    let id: Int
    let name: String
    let imageUrl: String

    var displayName: String {
        name.capitalized
    }

    var formattedId: String {
        String(format: "#%03d", id)
    }
}

struct PokemonDetail: Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let imageUrl: String
    let artworkUrl: String?
    let types: [PokemonTypeInfo]
    let stats: [PokemonStat]
    let abilities: [PokemonAbilityInfo]

    var displayName: String {
        name.capitalized
    }

    var formattedId: String {
        String(format: "#%03d", id)
    }

    var heightInMeters: String {
        let meters = Double(height) / 10.0
        return String(format: "%.1f m", meters)
    }

    var weightInKg: String {
        let kg = Double(weight) / 10.0
        return String(format: "%.1f kg", kg)
    }
}

struct PokemonTypeInfo: Identifiable {
    let id: String
    let name: String
    let slot: Int

    var displayName: String {
        name.capitalized
    }
}

struct PokemonStat: Identifiable {
    let id: String
    let name: String
    let baseStat: Int
    let maxStat: Int = 255

    var displayName: String {
        switch name {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Sp. Atk"
        case "special-defense": return "Sp. Def"
        case "speed": return "Speed"
        default: return name.capitalized
        }
    }

    var percentage: Double {
        Double(baseStat) / Double(maxStat)
    }
}

struct PokemonAbilityInfo: Identifiable {
    let id: String
    let name: String
    let isHidden: Bool

    var displayName: String {
        name.split(separator: "-")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
}

enum LoadingState<T> {
    case idle
    case loading
    case success(T)
    case error(String)
}
