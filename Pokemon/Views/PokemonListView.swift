//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonViewModel()
    @State private var selectedPokemon: PokemonListItem?
    @State private var showFilterSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredPokemon) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemonId: pokemon.id)) {
                                PokemonListCard(pokemon: pokemon)
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
                .refreshable {
                    viewModel.loadPokemon(refresh: true)
                }
                .searchable(text: $viewModel.searchText, prompt: "Search Pokémon")

                if case .loading = viewModel.loadingState, viewModel.pokemonList.isEmpty {
                    ProgressView("Loading Pokémon...")
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
                            viewModel.loadPokemon(refresh: true)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
            .navigationTitle("Pokédex")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showFilterSheet = true
                    }) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: viewModel.activeFilterCount > 0 ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                .font(.title3)
                                .foregroundColor(viewModel.activeFilterCount > 0 ? .blue : .primary)

                            if viewModel.activeFilterCount > 0 {
                                Text("\(viewModel.activeFilterCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterView(filterOptions: $viewModel.filterOptions)
            }
            .onAppear {
                if viewModel.pokemonList.isEmpty {
                    viewModel.loadPokemon(refresh: true)
                }
            }
        }
    }
}

struct PokemonListCard: View {
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
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(pokemon.formattedId)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(pokemon.displayName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    PokemonListView()
}
