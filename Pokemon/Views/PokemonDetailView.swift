//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemonId: Int
    @StateObject private var viewModel = PokemonDetailViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            if let pokemon = viewModel.pokemon {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with artwork
                        PokemonHeaderView(pokemon: pokemon)

                        // Types
                        TypesSection(types: pokemon.types)

                        // Physical Stats
                        PhysicalStatsSection(pokemon: pokemon)

                        // Base Stats
                        StatsSection(stats: pokemon.stats)

                        // Abilities
                        AbilitiesSection(abilities: pokemon.abilities)

                        // Type Effectiveness
                        TypeEffectivenessView(types: pokemon.types)

                        // Compare Button
                        NavigationLink(destination: PokemonComparisonView(pokemon1: pokemon)) {
                            Label("Compare with Another Pokémon", systemImage: "scale.3d")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                }
            }

            if case .loading = viewModel.loadingState {
                ProgressView("Loading...")
            }

            if case .error(let message) = viewModel.loadingState {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text("Error")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    Button("Retry") {
                        viewModel.loadPokemon(id: pokemonId)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadPokemon(id: pokemonId)
        }
    }
}

struct PokemonHeaderView: View {
    let pokemon: PokemonDetail

    var body: some View {
        VStack(spacing: 16) {
            Text(pokemon.formattedId)
                .font(.caption)
                .foregroundColor(.secondary)

            AsyncImage(url: URL(string: pokemon.artworkUrl ?? pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)

            Text(pokemon.displayName)
                .font(.system(size: 32, weight: .bold))
        }
    }
}

struct TypesSection: View {
    let types: [PokemonTypeInfo]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Types")
                .font(.headline)

            HStack(spacing: 12) {
                ForEach(types.sorted(by: { $0.slot < $1.slot })) { type in
                    TypeBadge(type: type, size: .medium)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PhysicalStatsSection: View {
    let pokemon: PokemonDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Physical Stats")
                .font(.headline)

            HStack(spacing: 32) {
                VStack(spacing: 8) {
                    Image(systemName: "arrow.up.and.down")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text(pokemon.heightInMeters)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Height")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Divider()

                VStack(spacing: 8) {
                    Image(systemName: "scalemass")
                        .font(.title2)
                        .foregroundColor(.green)
                    Text(pokemon.weightInKg)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Weight")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StatsSection: View {
    let stats: [PokemonStat]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Base Stats")
                .font(.headline)

            VStack(spacing: 12) {
                ForEach(stats) { stat in
                    StatBar(stat: stat)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StatBar: View {
    let stat: PokemonStat

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(stat.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(width: 80, alignment: .leading)

                Text("\(stat.baseStat)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(width: 40, alignment: .leading)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 8)
                            .cornerRadius(4)

                        Rectangle()
                            .fill(barColor(for: stat.baseStat))
                            .frame(width: geometry.size.width * stat.percentage, height: 8)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
            }
        }
    }

    private func barColor(for value: Int) -> Color {
        switch value {
        case 0..<50: return .red
        case 50..<80: return .orange
        case 80..<100: return .yellow
        case 100..<130: return .green
        default: return .blue
        }
    }
}

struct AbilitiesSection: View {
    let abilities: [PokemonAbilityInfo]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Abilities")
                .font(.headline)

            VStack(spacing: 8) {
                ForEach(abilities) { ability in
                    HStack {
                        Text(ability.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)

                        if ability.isHidden {
                            Text("Hidden")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.purple)
                                .cornerRadius(8)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationView {
        PokemonDetailView(pokemonId: 1)
    }
}
