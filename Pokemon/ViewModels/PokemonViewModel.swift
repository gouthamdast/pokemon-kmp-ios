//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import Foundation
import SwiftUI
import Combine
import shared

@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [PokemonListItem] = []
    @Published var loadingState: LoadingState<[PokemonListItem]> = .idle
    @Published var searchText: String = ""
    @Published var filterOptions: FilterOptions = FilterOptions()

    private let sdk = PokemonSDKiOS()

    var filteredPokemon: [PokemonListItem] {
        var result = pokemonList

        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        // Apply sorting
        switch filterOptions.sortOption {
        case .numberAscending:
            result = result.sorted { $0.id < $1.id }
        case .numberDescending:
            result = result.sorted { $0.id > $1.id }
        case .nameAscending:
            result = result.sorted { $0.name < $1.name }
        case .nameDescending:
            result = result.sorted { $0.name > $1.name }
        }

        return result
    }

    var activeFilterCount: Int {
        var count = 0
        if !filterOptions.selectedTypes.isEmpty {
            count += filterOptions.selectedTypes.count
        }
        if filterOptions.sortOption != .numberAscending {
            count += 1
        }
        return count
    }

    func loadPokemon(refresh: Bool = false) {
        loadingState = .loading

        sdk.getPokemonList(refresh: refresh, onSuccess: { [weak self] pokemonArray in
            guard let self = self else { return }

            let items = pokemonArray.map { pokemon in
                PokemonListItem(
                    id: Int(pokemon.id),
                    name: pokemon.name,
                    imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png"
                )
            }

            if refresh {
                self.pokemonList = items
            } else {
                self.pokemonList.append(contentsOf: items)
            }

            self.loadingState = .success(self.pokemonList)
        }, onError: { [weak self] errorMessage in
            self?.loadingState = .error(errorMessage)
        })
    }

    func loadMore() {
        loadPokemon(refresh: false)
    }
}
