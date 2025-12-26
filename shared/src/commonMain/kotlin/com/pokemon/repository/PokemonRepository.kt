package com.pokemon.repository

import com.pokemon.models.*
import com.pokemon.network.ApiResult
import com.pokemon.network.PokemonApi
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

class PokemonRepository(private val api: PokemonApi = PokemonApi()) {
    private val cache = PokemonCache()
    private var currentOffset = 0
    private val pageSize = 20

    fun getPokemonList(refresh: Boolean = false): Flow<ApiResult<List<PokemonBasic>>> = flow {
        emit(ApiResult.Loading)

        if (refresh) {
            currentOffset = 0
        }

        when (val result = api.getPokemonList(limit = pageSize, offset = currentOffset)) {
            is ApiResult.Success -> {
                currentOffset += pageSize
                emit(ApiResult.Success(result.data.results))
            }
            is ApiResult.Error -> emit(result)
            is ApiResult.Loading -> emit(ApiResult.Loading)
        }
    }

    fun searchPokemon(query: String): Flow<ApiResult<List<PokemonBasic>>> = flow {
        emit(ApiResult.Loading)

        // Search first 1000 Pokemon (covers most common cases)
        when (val result = api.getPokemonList(limit = 1000, offset = 0)) {
            is ApiResult.Success -> {
                val filtered = result.data.results.filter {
                    it.name.contains(query, ignoreCase = true)
                }
                emit(ApiResult.Success(filtered))
            }
            is ApiResult.Error -> emit(result)
            is ApiResult.Loading -> emit(ApiResult.Loading)
        }
    }

    fun getPokemonDetail(id: Int, forceRefresh: Boolean = false): Flow<ApiResult<Pokemon>> = flow {
        emit(ApiResult.Loading)

        // Check cache first
        if (!forceRefresh) {
            cache.getPokemon(id)?.let {
                emit(ApiResult.Success(it))
                return@flow
            }
        }

        when (val result = api.getPokemon(id)) {
            is ApiResult.Success -> {
                cache.cachePokemon(result.data)
                emit(ApiResult.Success(result.data))
            }
            is ApiResult.Error -> emit(result)
            is ApiResult.Loading -> emit(ApiResult.Loading)
        }
    }

    fun getPokemonDetail(name: String, forceRefresh: Boolean = false): Flow<ApiResult<Pokemon>> = flow {
        emit(ApiResult.Loading)

        // Check cache first
        if (!forceRefresh) {
            cache.getPokemon(name)?.let {
                emit(ApiResult.Success(it))
                return@flow
            }
        }

        when (val result = api.getPokemon(name)) {
            is ApiResult.Success -> {
                cache.cachePokemon(result.data)
                emit(ApiResult.Success(result.data))
            }
            is ApiResult.Error -> emit(result)
            is ApiResult.Loading -> emit(ApiResult.Loading)
        }
    }

    fun getAbilityDetail(name: String): Flow<ApiResult<AbilityDetail>> = flow {
        emit(ApiResult.Loading)

        when (val result = api.getAbilityDetail(name)) {
            is ApiResult.Success -> emit(ApiResult.Success(result.data))
            is ApiResult.Error -> emit(result)
            is ApiResult.Loading -> emit(ApiResult.Loading)
        }
    }

    fun getTypeDetail(name: String): Flow<ApiResult<TypeDetail>> = flow {
        emit(ApiResult.Loading)

        when (val result = api.getTypeDetail(name)) {
            is ApiResult.Success -> emit(ApiResult.Success(result.data))
            is ApiResult.Error -> emit(result)
            is ApiResult.Loading -> emit(ApiResult.Loading)
        }
    }

    fun clearCache() {
        cache.clear()
        currentOffset = 0
    }

    fun close() {
        api.close()
    }
}
