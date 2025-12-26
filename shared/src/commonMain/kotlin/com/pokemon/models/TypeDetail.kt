package com.pokemon.models

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TypeDetail(
    val id: Int,
    val name: String,
    @SerialName("damage_relations") val damageRelations: DamageRelations
)

@Serializable
data class DamageRelations(
    @SerialName("double_damage_from") val doubleDamageFrom: List<Type>,
    @SerialName("double_damage_to") val doubleDamageTo: List<Type>,
    @SerialName("half_damage_from") val halfDamageFrom: List<Type>,
    @SerialName("half_damage_to") val halfDamageTo: List<Type>,
    @SerialName("no_damage_from") val noDamageFrom: List<Type>,
    @SerialName("no_damage_to") val noDamageTo: List<Type>
)
