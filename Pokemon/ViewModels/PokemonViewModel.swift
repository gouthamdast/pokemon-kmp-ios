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

    private let sdk = PokemonSDKiOS()

    var filteredPokemon: [PokemonListItem] {
        if searchText.isEmpty {
            return pokemonList
        }
        return pokemonList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
