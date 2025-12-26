package com.pokemon.network

import com.pokemon.models.*
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.logging.*
import io.ktor.client.request.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

class PokemonApi {
    companion object {
        private const val BASE_URL = "https://pokeapi.co/api/v2"
    }

    private val client = HttpClient {
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true
                isLenient = true
                prettyPrint = true
            })
        }

        install(Logging) {
            logger = Logger.DEFAULT
            level = LogLevel.INFO
        }

        install(HttpTimeout) {
            requestTimeoutMillis = 30000
            connectTimeoutMillis = 30000
        }

        defaultRequest {
            url {
                protocol = io.ktor.http.URLProtocol.HTTPS
                host = "pokeapi.co"
                pathSegments = listOf("api", "v2", "")
            }
        }
    }

    suspend fun getPokemonList(limit: Int = 20, offset: Int = 0): ApiResult<PokemonListResponse> {
        return try {
            val response: PokemonListResponse = client.get("pokemon") {
                parameter("limit", limit)
                parameter("offset", offset)
            }.body()
            ApiResult.Success(response)
        } catch (e: Exception) {
            ApiResult.Error("Failed to fetch Pokemon list", e)
        }
    }

    suspend fun getPokemon(id: Int): ApiResult<Pokemon> {
        return try {
            val response: Pokemon = client.get("pokemon/$id").body()
            ApiResult.Success(response)
        } catch (e: Exception) {
            ApiResult.Error("Failed to fetch Pokemon details", e)
        }
    }

    suspend fun getPokemon(name: String): ApiResult<Pokemon> {
        return try {
            val response: Pokemon = client.get("pokemon/${name.lowercase()}").body()
            ApiResult.Success(response)
        } catch (e: Exception) {
            ApiResult.Error("Failed to fetch Pokemon details", e)
        }
    }

    suspend fun getAbilityDetail(name: String): ApiResult<AbilityDetail> {
        return try {
            val response: AbilityDetail = client.get("ability/${name.lowercase()}").body()
            ApiResult.Success(response)
        } catch (e: Exception) {
            ApiResult.Error("Failed to fetch ability details", e)
        }
    }

    suspend fun getTypeDetail(name: String): ApiResult<TypeDetail> {
        return try {
            val response: TypeDetail = client.get("type/${name.lowercase()}").body()
            ApiResult.Success(response)
        } catch (e: Exception) {
            ApiResult.Error("Failed to fetch type details", e)
        }
    }

    fun close() {
        client.close()
    }
}
