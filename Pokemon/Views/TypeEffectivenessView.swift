//
//  TypeEffectivenessView.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import SwiftUI

struct TypeEffectivenessView: View {
    let types: [PokemonTypeInfo]

    // Simplified type effectiveness data
    // In a real app, this would come from the KMP TypeDetail API
    private let typeWeaknesses: [String: [String]] = [
        "normal": ["fighting"],
        "fire": ["water", "ground", "rock"],
        "water": ["electric", "grass"],
        "electric": ["ground"],
        "grass": ["fire", "ice", "poison", "flying", "bug"],
        "ice": ["fire", "fighting", "rock", "steel"],
        "fighting": ["flying", "psychic", "fairy"],
        "poison": ["ground", "psychic"],
        "ground": ["water", "grass", "ice"],
        "flying": ["electric", "ice", "rock"],
        "psychic": ["bug", "ghost", "dark"],
        "bug": ["fire", "flying", "rock"],
        "rock": ["water", "grass", "fighting", "ground", "steel"],
        "ghost": ["ghost", "dark"],
        "dragon": ["ice", "dragon", "fairy"],
        "dark": ["fighting", "bug", "fairy"],
        "steel": ["fire", "fighting", "ground"],
        "fairy": ["poison", "steel"]
    ]

    private let typeResistances: [String: [String]] = [
        "fire": ["fire", "grass", "ice", "bug", "steel", "fairy"],
        "water": ["fire", "water", "ice", "steel"],
        "grass": ["water", "electric", "grass", "ground"],
        "electric": ["electric", "flying", "steel"],
        "ice": ["ice"],
        "fighting": ["bug", "rock", "dark"],
        "poison": ["grass", "fighting", "poison", "bug", "fairy"],
        "ground": ["poison", "rock"],
        "flying": ["grass", "fighting", "bug"],
        "psychic": ["fighting", "psychic"],
        "bug": ["grass", "fighting", "ground"],
        "rock": ["normal", "fire", "poison", "flying"],
        "ghost": ["poison", "bug"],
        "dragon": ["fire", "water", "electric", "grass"],
        "dark": ["ghost", "dark"],
        "steel": ["normal", "grass", "ice", "flying", "psychic", "bug", "rock", "dragon", "steel", "fairy"],
        "fairy": ["fighting", "bug", "dark"]
    ]

    var effectiveAgainst: Set<String> {
        var effective = Set<String>()
        for type in types {
            // This would ideally come from TypeDetail API
            // For now, using simplified logic
            switch type.name.lowercased() {
            case "fire": effective.formUnion(["grass", "ice", "bug", "steel"])
            case "water": effective.formUnion(["fire", "ground", "rock"])
            case "grass": effective.formUnion(["water", "ground", "rock"])
            case "electric": effective.formUnion(["water", "flying"])
            default: break
            }
        }
        return effective
    }

    var weakAgainst: Set<String> {
        var weak = Set<String>()
        for type in types {
            if let weaknesses = typeWeaknesses[type.name.lowercased()] {
                weak.formUnion(weaknesses)
            }
        }
        return weak
    }

    var resistantTo: Set<String> {
        var resistant = Set<String>()
        for type in types {
            if let resistances = typeResistances[type.name.lowercased()] {
                resistant.formUnion(resistances)
            }
        }
        return resistant
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Type Effectiveness")
                .font(.headline)

            if !weakAgainst.isEmpty {
                EffectivenessRow(
                    title: "Weak Against",
                    types: Array(weakAgainst),
                    color: .red
                )
            }

            if !resistantTo.isEmpty {
                EffectivenessRow(
                    title: "Resistant To",
                    types: Array(resistantTo),
                    color: .green
                )
            }

            if !effectiveAgainst.isEmpty {
                EffectivenessRow(
                    title: "Effective Against",
                    types: Array(effectiveAgainst),
                    color: .blue
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct EffectivenessRow: View {
    let title: String
    let types: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            } icon: {
                Image(systemName: iconName)
                    .foregroundColor(color)
            }

            FlowLayout(spacing: 8) {
                ForEach(types.sorted(), id: \.self) { typeName in
                    TypeBadge(
                        type: PokemonTypeInfo(id: typeName, name: typeName, slot: 0),
                        size: .small
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var iconName: String {
        switch title {
        case "Weak Against": return "exclamationmark.triangle.fill"
        case "Resistant To": return "shield.fill"
        case "Effective Against": return "bolt.fill"
        default: return "circle.fill"
        }
    }
}

// Simple flow layout for wrapping type badges
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                     y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    TypeEffectivenessView(types: [
        PokemonTypeInfo(id: "grass", name: "grass", slot: 1),
        PokemonTypeInfo(id: "poison", name: "poison", slot: 2)
    ])
    .padding()
}
