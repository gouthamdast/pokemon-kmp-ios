//
//  PokemonPickerView.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import SwiftUI

struct PokemonPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PokemonViewModel()
    let onSelect: (Int) -> Void

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.pokemonList.isEmpty {
                    if case .loading = viewModel.loadingState {
                        ProgressView("Loading Pokémon...")
                    } else {
                        ProgressView("Loading Pokémon...")
                            .onAppear {
                                viewModel.loadPokemon(refresh: true)
                            }
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredPokemon) { pokemon in
                                Button(action: {
                                    onSelect(pokemon.id)
                                    dismiss()
                                }) {
                                    PokemonPickerCard(pokemon: pokemon)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    if pokemon.id == viewModel.pokemonList.last?.id {
                                        viewModel.loadMore()
                                    }
                                }
                            }

                            if case .loading = viewModel.loadingState, !viewModel.pokemonList.isEmpty {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding()
                    }
                    .searchable(text: $viewModel.searchText, prompt: "Search Pokémon")
                }

                if case .error(let message) = viewModel.loadingState {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        Text("Error")
                            .font(.headline)
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            viewModel.loadPokemon(refresh: true)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
            .navigationTitle("Select Pokémon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PokemonPickerCard: View {
    let pokemon: PokemonListItem

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.formattedId)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(pokemon.displayName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    PokemonPickerView { id in
        print("Selected Pokemon ID: \(id)")
    }
}
