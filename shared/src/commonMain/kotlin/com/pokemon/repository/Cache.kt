package com.pokemon.repository

import com.pokemon.models.Pokemon

class PokemonCache {
    private val pokemonCache = mutableMapOf<Int, Pokemon>()
    private val pokemonNameCache = mutableMapOf<String, Int>()

    fun getPokemon(id: Int): Pokemon? = pokemonCache[id]

    fun getPokemon(name: String): Pokemon? {
        val id = pokemonNameCache[name.lowercase()] ?: return null
        return pokemonCache[id]
    }

    fun cachePokemon(pokemon: Pokemon) {
        pokemonCache[pokemon.id] = pokemon
        pokemonNameCache[pokemon.name.lowercase()] = pokemon.id
    }

    fun clear() {
        pokemonCache.clear()
        pokemonNameCache.clear()
    }

    fun size(): Int = pokemonCache.size
}
