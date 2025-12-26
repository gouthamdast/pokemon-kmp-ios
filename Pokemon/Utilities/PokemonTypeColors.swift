//
//  PokemonTypeColors.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import SwiftUI

extension PokemonTypeInfo {
    var color: Color {
        switch name.lowercased() {
        case "normal":
            return Color(red: 0.66, green: 0.66, blue: 0.47)
        case "fire":
            return Color(red: 0.93, green: 0.50, blue: 0.19)
        case "water":
            return Color(red: 0.39, green: 0.56, blue: 0.93)
        case "electric":
            return Color(red: 0.98, green: 0.82, blue: 0.18)
        case "grass":
            return Color(red: 0.47, green: 0.78, blue: 0.30)
        case "ice":
            return Color(red: 0.60, green: 0.85, blue: 0.85)
        case "fighting":
            return Color(red: 0.75, green: 0.19, blue: 0.15)
        case "poison":
            return Color(red: 0.64, green: 0.25, blue: 0.64)
        case "ground":
            return Color(red: 0.88, green: 0.75, blue: 0.42)
        case "flying":
            return Color(red: 0.66, green: 0.56, blue: 0.95)
        case "psychic":
            return Color(red: 0.98, green: 0.33, blue: 0.45)
        case "bug":
            return Color(red: 0.66, green: 0.73, blue: 0.13)
        case "rock":
            return Color(red: 0.72, green: 0.63, blue: 0.22)
        case "ghost":
            return Color(red: 0.44, green: 0.35, blue: 0.60)
        case "dragon":
            return Color(red: 0.44, green: 0.21, blue: 0.98)
        case "dark":
            return Color(red: 0.44, green: 0.35, blue: 0.27)
        case "steel":
            return Color(red: 0.72, green: 0.72, blue: 0.82)
        case "fairy":
            return Color(red: 0.85, green: 0.51, blue: 0.68)
        default:
            return Color.gray
        }
    }
}

struct TypeBadge: View {
    let type: PokemonTypeInfo
    let size: BadgeSize

    enum BadgeSize {
        case small
        case medium
        case large

        var fontSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 14
            case .large: return 16
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .medium: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .large: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            }
        }
    }

    var body: some View {
        Text(type.displayName)
            .font(.system(size: size.fontSize, weight: .semibold))
            .foregroundColor(.white)
            .padding(size.padding)
            .background(type.color)
            .cornerRadius(size == .small ? 12 : 16)
    }
}
