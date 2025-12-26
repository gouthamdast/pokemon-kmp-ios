//
//  PokemonComparisonViewModel.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import Foundation
import SwiftUI
import Combine
import shared

@MainActor
class PokemonComparisonViewModel: ObservableObject {
    @Published var pokemon1: PokemonDetail?
    @Published var pokemon2: PokemonDetail?
    @Published var searchResults: [PokemonListItem] = []
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false

    private let sdk = PokemonSDKiOS()

    func loadPokemon1(id: Int) {
        sdk.getPokemonDetail(id: Int32(id), forceRefresh: false, onSuccess: { [weak self] data in
            self?.pokemon1 = self?.convertToPokemonDetail(data)
        }, onError: { error in
            print("Error loading pokemon1: \(error)")
        })
    }

    func loadPokemon2(id: Int) {
        sdk.getPokemonDetail(id: Int32(id), forceRefresh: false, onSuccess: { [weak self] data in
            self?.pokemon2 = self?.convertToPokemonDetail(data)
        }, onError: { error in
            print("Error loading pokemon2: \(error)")
        })
    }

    func searchPokemon() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true

        // Search in the first 1000 Pokemon
        sdk.getPokemonList(refresh: false, onSuccess: { [weak self] pokemonArray in
            guard let self = self else { return }

            let filtered = pokemonArray.filter { pokemon in
                pokemon.name.contains(self.searchText.lowercased())
            }

            self.searchResults = filtered.prefix(10).map { pokemon in
                PokemonListItem(
                    id: Int(pokemon.id),
                    name: pokemon.name,
                    imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png"
                )
            }

            self.isSearching = false
        }, onError: { [weak self] error in
            print("Search error: \(error)")
            self?.isSearching = false
        })
    }

    private func convertToPokemonDetail(_ data: Pokemon) -> PokemonDetail {
        let types = data.types.map { typeSlot in
            PokemonTypeInfo(
                id: typeSlot.type.name,
                name: typeSlot.type.name,
                slot: Int(typeSlot.slot)
            )
        }

        let stats = data.stats.map { statSlot in
            PokemonStat(
                id: statSlot.stat.name,
                name: statSlot.stat.name,
                baseStat: Int(statSlot.baseStat)
            )
        }

        let abilities = data.abilities.map { abilitySlot in
            PokemonAbilityInfo(
                id: abilitySlot.ability.name,
                name: abilitySlot.ability.name,
                isHidden: abilitySlot.isHidden
            )
        }

        return PokemonDetail(
            id: Int(data.id),
            name: data.name,
            height: Int(data.height),
            weight: Int(data.weight),
            imageUrl: data.sprites.frontDefault ?? "",
            artworkUrl: data.sprites.other?.officialArtwork?.frontDefault,
            types: types,
            stats: stats,
            abilities: abilities
        )
    }
}
