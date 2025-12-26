//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import Foundation
import SwiftUI
import Combine
import shared

@MainActor
class PokemonDetailViewModel: ObservableObject {
    @Published var loadingState: LoadingState<PokemonDetail> = .idle
    @Published var pokemon: PokemonDetail?

    private let sdk = PokemonSDKiOS()

    func loadPokemon(id: Int) {
        loadingState = .loading

        sdk.getPokemonDetail(id: Int32(id), forceRefresh: false, onSuccess: { [weak self] data in
            guard let self = self else { return }

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

            let detail = PokemonDetail(
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

            self.pokemon = detail
            self.loadingState = .success(detail)
        }, onError: { [weak self] errorMessage in
            self?.loadingState = .error(errorMessage)
        })
    }
}
