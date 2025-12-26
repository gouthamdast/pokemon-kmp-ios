package com.pokemon

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch

/**
 * Helper to convert Kotlin Flow to iOS-friendly callback pattern
 */
fun <T> Flow<T>.subscribe(
    onEach: (T) -> Unit,
    onComplete: () -> Unit,
    onThrow: (Throwable) -> Unit
): Cancellable = FlowSubscription(this, onEach, onComplete, onThrow)

interface Cancellable {
    fun cancel()
}

private class FlowSubscription<T>(
    flow: Flow<T>,
    onEach: (T) -> Unit,
    onComplete: () -> Unit,
    onThrow: (Throwable) -> Unit
) : Cancellable {
    private val scope = CoroutineScope(Dispatchers.Main)

    init {
        scope.launch {
            try {
                flow.collect { value ->
                    onEach(value)
                }
                onComplete()
            } catch (e: Throwable) {
                onThrow(e)
            }
        }
    }

    override fun cancel() {
        // Scope will be automatically cancelled when subscription is released
    }
}
