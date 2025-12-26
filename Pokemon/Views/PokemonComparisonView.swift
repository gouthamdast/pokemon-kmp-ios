//
//  PokemonComparisonView.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import SwiftUI

struct PokemonComparisonView: View {
    let pokemon1: PokemonDetail
    @StateObject private var viewModel = PokemonComparisonViewModel()
    @State private var showPicker = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let pokemon2 = viewModel.pokemon2 {
                    // Header with both Pokemon
                    ComparisonHeader(pokemon1: pokemon1, pokemon2: pokemon2)

                    // Stats Comparison
                    StatsComparisonSection(pokemon1: pokemon1, pokemon2: pokemon2)

                    // Types Comparison
                    TypesComparisonSection(pokemon1: pokemon1, pokemon2: pokemon2)

                    // Physical Stats Comparison
                    PhysicalComparisonSection(pokemon1: pokemon1, pokemon2: pokemon2)

                    // Abilities Comparison
                    AbilitiesComparisonSection(pokemon1: pokemon1, pokemon2: pokemon2)

                    // Change comparison button
                    Button(action: {
                        showPicker = true
                    }) {
                        Label("Compare with Different Pokémon", systemImage: "arrow.triangle.2.circlepath")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else {
                    // Initial selection
                    VStack(spacing: 20) {
                        Image(systemName: "scale.3d")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)

                        Text("Compare with Another Pokémon")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Select a Pokémon to compare stats with \(pokemon1.displayName)")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)

                        Button(action: {
                            showPicker = true
                        }) {
                            Label("Select Pokémon", systemImage: "magnifyingglass")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                }
            }
            .padding()
        }
        .navigationTitle("Compare Pokémon")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPicker) {
            PokemonPickerView { selectedId in
                viewModel.loadPokemon2(id: selectedId)
            }
        }
        .onAppear {
            viewModel.pokemon1 = pokemon1
        }
    }
}

struct ComparisonHeader: View {
    let pokemon1: PokemonDetail
    let pokemon2: PokemonDetail

    var body: some View {
        HStack(spacing: 20) {
            PokemonComparisonCard(pokemon: pokemon1)

            Image(systemName: "arrow.left.arrow.right")
                .font(.title)
                .foregroundColor(.blue)

            PokemonComparisonCard(pokemon: pokemon2)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct PokemonComparisonCard: View {
    let pokemon: PokemonDetail

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: pokemon.artworkUrl ?? pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 100)

            Text(pokemon.formattedId)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(pokemon.displayName)
                .font(.headline)
                .multilineTextAlignment(.center)

            HStack(spacing: 4) {
                ForEach(pokemon.types.sorted(by: { $0.slot < $1.slot }).prefix(2)) { type in
                    TypeBadge(type: type, size: .small)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatsComparisonSection: View {
    let pokemon1: PokemonDetail
    let pokemon2: PokemonDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Base Stats Comparison")
                .font(.headline)

            VStack(spacing: 12) {
                ForEach(pokemon1.stats) { stat1 in
                    if let stat2 = pokemon2.stats.first(where: { $0.name == stat1.name }) {
                        ComparisonStatBar(stat1: stat1, stat2: stat2)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ComparisonStatBar: View {
    let stat1: PokemonStat
    let stat2: PokemonStat

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(stat1.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(width: 80, alignment: .leading)

                Spacer()

                HStack(spacing: 20) {
                    // Pokemon 1 stat
                    HStack(spacing: 4) {
                        Text("\(stat1.baseStat)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(stat1.baseStat > stat2.baseStat ? .green : (stat1.baseStat < stat2.baseStat ? .red : .primary))

                        if stat1.baseStat > stat2.baseStat {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                    .frame(width: 60, alignment: .trailing)

                    // VS separator
                    Text("vs")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    // Pokemon 2 stat
                    HStack(spacing: 4) {
                        if stat2.baseStat > stat1.baseStat {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                        }

                        Text("\(stat2.baseStat)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(stat2.baseStat > stat1.baseStat ? .green : (stat2.baseStat < stat1.baseStat ? .red : .primary))
                    }
                    .frame(width: 60, alignment: .leading)
                }
            }

            // Visual comparison bars
            GeometryReader { geometry in
                HStack(spacing: 4) {
                    // Pokemon 1 bar (reversed)
                    ZStack(alignment: .trailing) {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 6)

                        Rectangle()
                            .fill(stat1.baseStat > stat2.baseStat ? Color.green : Color.blue)
                            .frame(width: geometry.size.width * 0.48 * stat1.percentage, height: 6)
                    }
                    .frame(width: geometry.size.width * 0.48)

                    Divider()
                        .frame(width: 2)

                    // Pokemon 2 bar
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 6)

                        Rectangle()
                            .fill(stat2.baseStat > stat1.baseStat ? Color.green : Color.orange)
                            .frame(width: geometry.size.width * 0.48 * stat2.percentage, height: 6)
                    }
                    .frame(width: geometry.size.width * 0.48)
                }
            }
            .frame(height: 6)
        }
    }
}

struct TypesComparisonSection: View {
    let pokemon1: PokemonDetail
    let pokemon2: PokemonDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Types")
                .font(.headline)

            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(pokemon1.types.sorted(by: { $0.slot < $1.slot })) { type in
                        TypeBadge(type: type, size: .medium)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Divider()

                VStack(alignment: .trailing, spacing: 8) {
                    ForEach(pokemon2.types.sorted(by: { $0.slot < $1.slot })) { type in
                        TypeBadge(type: type, size: .medium)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PhysicalComparisonSection: View {
    let pokemon1: PokemonDetail
    let pokemon2: PokemonDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Physical Stats")
                .font(.headline)

            HStack(spacing: 0) {
                PhysicalStatColumn(
                    height: pokemon1.heightInMeters,
                    weight: pokemon1.weightInKg,
                    isWinner: pokemon1.height > pokemon2.height
                )

                Divider()
                    .padding(.horizontal)

                PhysicalStatColumn(
                    height: pokemon2.heightInMeters,
                    weight: pokemon2.weightInKg,
                    isWinner: pokemon2.height > pokemon1.height
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PhysicalStatColumn: View {
    let height: String
    let weight: String
    let isWinner: Bool

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "arrow.up.and.down")
                    .font(.title3)
                    .foregroundColor(.blue)
                Text(height)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Height")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 8) {
                Image(systemName: "scalemass")
                    .font(.title3)
                    .foregroundColor(.green)
                Text(weight)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Weight")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct AbilitiesComparisonSection: View {
    let pokemon1: PokemonDetail
    let pokemon2: PokemonDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Abilities")
                .font(.headline)

            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(pokemon1.abilities) { ability in
                        AbilityChip(ability: ability)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(pokemon2.abilities) { ability in
                        AbilityChip(ability: ability)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AbilityChip: View {
    let ability: PokemonAbilityInfo

    var body: some View {
        HStack {
            Text(ability.displayName)
                .font(.caption)
                .fontWeight(.medium)

            if ability.isHidden {
                Text("Hidden")
                    .font(.system(size: 9))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.purple)
                    .cornerRadius(6)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationView {
        PokemonComparisonView(
            pokemon1: PokemonDetail(
                id: 1,
                name: "bulbasaur",
                height: 7,
                weight: 69,
                imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                artworkUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                types: [
                    PokemonTypeInfo(id: "grass", name: "grass", slot: 1),
                    PokemonTypeInfo(id: "poison", name: "poison", slot: 2)
                ],
                stats: [
                    PokemonStat(id: "hp", name: "hp", baseStat: 45),
                    PokemonStat(id: "attack", name: "attack", baseStat: 49)
                ],
                abilities: [
                    PokemonAbilityInfo(id: "overgrow", name: "overgrow", isHidden: false)
                ]
            )
        )
    }
}
