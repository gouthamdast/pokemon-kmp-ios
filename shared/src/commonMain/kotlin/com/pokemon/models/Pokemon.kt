package com.pokemon.models

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PokemonListResponse(
    val count: Int,
    val next: String?,
    val previous: String?,
    val results: List<PokemonBasic>
)

@Serializable
data class PokemonBasic(
    val name: String,
    val url: String
) {
    // Extract ID from URL (e.g., "https://pokeapi.co/api/v2/pokemon/1/" -> 1)
    val id: Int
        get() = url.trimEnd('/').split('/').last().toInt()
}

@Serializable
data class Pokemon(
    val id: Int,
    val name: String,
    val height: Int,
    val weight: Int,
    val sprites: Sprites,
    val types: List<TypeSlot>,
    val stats: List<StatSlot>,
    val abilities: List<AbilitySlot>,
    @SerialName("base_experience") val baseExperience: Int?
)

@Serializable
data class Sprites(
    @SerialName("front_default") val frontDefault: String?,
    @SerialName("front_shiny") val frontShiny: String?,
    val other: OtherSprites? = null
)

@Serializable
data class OtherSprites(
    @SerialName("official-artwork") val officialArtwork: OfficialArtwork? = null
)

@Serializable
data class OfficialArtwork(
    @SerialName("front_default") val frontDefault: String?
)

@Serializable
data class TypeSlot(
    val slot: Int,
    val type: Type
)

@Serializable
data class Type(
    val name: String,
    val url: String
)

@Serializable
data class StatSlot(
    @SerialName("base_stat") val baseStat: Int,
    val effort: Int,
    val stat: Stat
)

@Serializable
data class Stat(
    val name: String,
    val url: String
)

@Serializable
data class AbilitySlot(
    @SerialName("is_hidden") val isHidden: Boolean,
    val slot: Int,
    val ability: Ability
)

@Serializable
data class Ability(
    val name: String,
    val url: String
)
