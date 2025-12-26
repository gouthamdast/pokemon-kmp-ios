package com.pokemon

import com.pokemon.models.*
import com.pokemon.network.ApiResult
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * iOS-friendly wrapper around PokemonSDK with callback-based API
 */
class PokemonSDKiOS {
    private val sdk = PokemonSDK()
    private val scope = CoroutineScope(Dispatchers.Main)

    fun getPokemonList(
        refresh: Boolean,
        onSuccess: (List<PokemonBasic>) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            sdk.getPokemonList(refresh).collect { result ->
                when (result) {
                    is ApiResult.Success -> onSuccess(result.data)
                    is ApiResult.Error -> onError(result.message)
                    is ApiResult.Loading -> {
                        // Loading state handled in Swift
                    }
                }
            }
        }
    }

    fun getPokemonDetail(
        id: Int,
        forceRefresh: Boolean,
        onSuccess: (Pokemon) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            sdk.getPokemonDetail(id, forceRefresh).collect { result ->
                when (result) {
                    is ApiResult.Success -> onSuccess(result.data)
                    is ApiResult.Error -> onError(result.message)
                    is ApiResult.Loading -> {
                        // Loading state handled in Swift
                    }
                }
            }
        }
    }

    fun searchPokemon(
        query: String,
        onSuccess: (List<PokemonBasic>) -> Unit,
        onError: (String) -> Unit
    ) {
        scope.launch {
            sdk.searchPokemon(query).collect { result ->
                when (result) {
                    is ApiResult.Success -> onSuccess(result.data)
                    is ApiResult.Error -> onError(result.message)
                    is ApiResult.Loading -> {
                        // Loading state handled in Swift
                    }
                }
            }
        }
    }

    fun clearCache() {
        sdk.clearCache()
    }

    fun dispose() {
        sdk.dispose()
    }
}
