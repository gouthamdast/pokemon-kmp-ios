package com.pokemon

import com.pokemon.models.*
import com.pokemon.network.ApiResult
import com.pokemon.repository.PokemonRepository
import kotlinx.coroutines.flow.Flow

/**
 * Main entry point for the Pokemon SDK
 * This class provides access to all Pokemon-related functionality
 */
class PokemonSDK {
    private val repository = PokemonRepository()

    /**
     * Get a paginated list of Pokemon
     * @param refresh If true, resets pagination and starts from the beginning
     * @return Flow of ApiResult containing list of Pokemon
     */
    fun getPokemonList(refresh: Boolean = false): Flow<ApiResult<List<PokemonBasic>>> {
        return repository.getPokemonList(refresh)
    }

    /**
     * Search Pokemon by name
     * @param query Search query string
     * @return Flow of ApiResult containing filtered list of Pokemon
     */
    fun searchPokemon(query: String): Flow<ApiResult<List<PokemonBasic>>> {
        return repository.searchPokemon(query)
    }

    /**
     * Get detailed information about a specific Pokemon by ID
     * @param id Pokemon ID
     * @param forceRefresh If true, bypasses cache
     * @return Flow of ApiResult containing Pokemon details
     */
    fun getPokemonDetail(id: Int, forceRefresh: Boolean = false): Flow<ApiResult<Pokemon>> {
        return repository.getPokemonDetail(id, forceRefresh)
    }

    /**
     * Get detailed information about a specific Pokemon by name
     * @param name Pokemon name
     * @param forceRefresh If true, bypasses cache
     * @return Flow of ApiResult containing Pokemon details
     */
    fun getPokemonDetailByName(name: String, forceRefresh: Boolean = false): Flow<ApiResult<Pokemon>> {
        return repository.getPokemonDetail(name, forceRefresh)
    }

    /**
     * Get detailed information about an ability
     * @param name Ability name
     * @return Flow of ApiResult containing ability details
     */
    fun getAbilityDetail(name: String): Flow<ApiResult<AbilityDetail>> {
        return repository.getAbilityDetail(name)
    }

    /**
     * Get detailed information about a type including effectiveness
     * @param name Type name
     * @return Flow of ApiResult containing type details
     */
    fun getTypeDetail(name: String): Flow<ApiResult<TypeDetail>> {
        return repository.getTypeDetail(name)
    }

    /**
     * Clear all cached data
     */
    fun clearCache() {
        repository.clearCache()
    }

    /**
     * Clean up resources
     */
    fun dispose() {
        repository.close()
    }
}
