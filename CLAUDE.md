# CLAUDE.md - Pokemon KMP/iOS Project Guide

This document provides essential information for Claude Code when working on this project.

---

## Bash Commands

### Kotlin Multiplatform (KMP) - Shared Module

- `./gradlew clean`: Clean build artifacts
- `./gradlew :shared:build`: Build the shared KMP module
- `./gradlew :shared:linkDebugFrameworkIosSimulatorArm64`: Build framework for iOS Simulator (M1/M2 Macs)
- `./gradlew :shared:linkDebugFrameworkIosX64`: Build framework for iOS Simulator (Intel Macs)
- `./gradlew :shared:linkDebugFrameworkIosArm64`: Build framework for iOS Device
- `./build-framework.sh`: Build all iOS framework variants at once

### iOS (Xcode)

- `xcodebuild -project Pokemon.xcodeproj -scheme Pokemon -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' build`: Build iOS app for simulator
- `xcodebuild test -project Pokemon.xcodeproj -scheme Pokemon -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15'`: Run unit tests
- `xcodebuild test -project Pokemon.xcodeproj -scheme Pokemon -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:PokemonTests/PokemonTests/testExample`: Run single test

---

## Code Style

### Kotlin (KMP Shared Module)

- Use Kotlin conventions: camelCase for functions/properties, PascalCase for classes
- Leverage data classes for immutable models
- Use sealed classes for type-safe state (e.g., `ApiResult<T>`)
- Mark models with `@Serializable` for JSON parsing
- Prefer `Flow` over callbacks for async operations in shared code
- Use explicit nullability (`?` for nullable types)
- Use `suspend` functions for async operations
- Keep repository logic in `PokemonRepository`, network calls in `PokemonApi`
- Use `private` visibility by default, expose only what's needed
- Document public APIs with KDoc comments

**Example:**
```kotlin
@Serializable
data class Pokemon(
    val id: Int,
    val name: String,
    val height: Int?
)

suspend fun getPokemon(id: Int): ApiResult<Pokemon>
```

### Swift (iOS Layer)

- Use Swift conventions: camelCase for properties/methods, PascalCase for types
- Use `struct` for value types (models), `class` for reference types (ViewModels)
- Mark ViewModels with `@MainActor` for thread safety
- Use `@Published` for observable properties in ViewModels
- Prefer `guard let` for early returns with optionals
- Use SwiftUI property wrappers: `@StateObject`, `@ObservedObject`, `@State`, `@Binding`
- Keep views focused: extract complex UI into separate components
- Use computed properties for derived state
- Leverage Swift's type inference but be explicit when it aids readability

**Example:**
```swift
@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemon: [PokemonListItem] = []
    @Published var loadingState: LoadingState<Void> = .idle

    func loadPokemon(refresh: Bool = false) {
        // Implementation
    }
}
```

### General Principles

- **Separation of Concerns**: Keep network logic in KMP, UI logic in Swift
- **DRY**: Don't repeat yourself - extract reusable logic into shared code
- **Single Responsibility**: Each class/function should have one clear purpose
- **Immutability**: Prefer immutable data structures where possible
- **Error Handling**: Always handle errors gracefully with user-friendly messages

---

## Architecture Patterns

### KMP Layer
- **Pattern**: Clean Architecture + Repository Pattern
- **Flow**: `PokemonSDK` (Facade) → `PokemonRepository` (Data) → `PokemonApi` (Network) + `PokemonCache` (Cache)
- **Models**: Located in `shared/src/commonMain/kotlin/com/pokemon/models/`
- **Network**: Ktor HTTP client in `shared/src/commonMain/kotlin/com/pokemon/network/`
- **Repository**: Data coordination in `shared/src/commonMain/kotlin/com/pokemon/repository/`

### iOS Layer
- **Pattern**: MVVM (Model-View-ViewModel)
- **Flow**: `SwiftUI Views` → `ViewModels` (@Published) → `PokemonSDKiOS` (Bridge) → `PokemonSDK` (KMP)
- **Models**: Swift-friendly DTOs in `Pokemon/Models/`
- **ViewModels**: State management in `Pokemon/ViewModels/`
- **Views**: SwiftUI components in `Pokemon/Views/`

### Bridge Layer
- **PokemonSDKiOS**: Converts Kotlin `Flow<T>` to Swift callback pattern
- **FlowHelpers**: Provides `Flow.subscribe()` extension for callback adaptation
- **Threading**: All callbacks run on Main dispatcher (@MainActor compatible)

---

## Workflow

### Making Code Changes

1. **Identify the layer**: Determine if changes belong in KMP (shared logic) or iOS (UI)
2. **Read before modifying**: Always read the file before making changes
3. **Follow existing patterns**: Match the coding style and architecture of existing code
4. **Update both layers if needed**: KMP model changes may require iOS model updates

### Building & Testing

1. **Build KMP framework first**: Run `./build-framework.sh` after KMP changes
2. **Rebuild iOS project**: Build iOS app to ensure framework integration works
3. **Test incrementally**: Test small changes frequently rather than large batches
4. **Run specific tests**: Use `-only-testing` for faster iteration
5. **Check both platforms**: Verify changes work on simulator and consider device testing

### Common Workflows

#### Adding a new API endpoint
1. Add endpoint method to `PokemonApi.kt` (KMP)
2. Add model class if needed in `models/` package
3. Add repository method in `PokemonRepository.kt`
4. Expose via `PokemonSDK.kt` facade
5. Add iOS bridge method in `PokemonSDKiOS.kt`
6. Create/update Swift models in `PokemonModels.swift`
7. Update ViewModel to call the new method
8. Update SwiftUI view to display the data
9. Rebuild framework and test end-to-end

#### Modifying UI
1. Identify the affected View and ViewModel
2. Update ViewModel state if needed (`@Published` properties)
3. Modify SwiftUI View components
4. Test on simulator with various states (loading, error, success)
5. Verify responsiveness on different device sizes

#### Fixing a bug
1. Reproduce the bug and identify the layer (KMP or iOS)
2. Read related code to understand the issue
3. Write a fix in the appropriate layer
4. Test the fix thoroughly
5. Consider if the bug exists in other similar code paths
6. Rebuild framework if KMP was modified

### Performance Considerations

- **Cache-first**: Detail views use cache for instant loading
- **Pagination**: List views load 20 items at a time
- **Lazy rendering**: Use LazyVStack/LazyHStack in SwiftUI for lists
- **Image loading**: SwiftUI AsyncImage handles async loading automatically
- **Search**: Client-side filtering is used (loads up to 1000 pokemon)

### Debugging

- **KMP**: Use `println()` statements (logs appear in Xcode console)
- **Network**: Ktor logging plugin shows HTTP requests/responses
- **iOS**: Use `print()` statements or Xcode debugger breakpoints
- **Flow issues**: Check PokemonSDKiOS callback handling
- **Threading**: Ensure UI updates happen on @MainActor

---

## Project Structure

```
Pokemon/
├── shared/                      # Kotlin Multiplatform Module
│   └── src/
│       ├── commonMain/          # Shared Kotlin code
│       │   └── kotlin/com/pokemon/
│       │       ├── models/      # Data models
│       │       ├── network/     # Ktor HTTP client
│       │       ├── repository/  # Data layer
│       │       └── PokemonSDK.kt
│       └── iosMain/             # iOS-specific Kotlin code
│           └── kotlin/com/pokemon/
│               ├── PokemonSDKiOS.kt
│               └── FlowHelpers.kt
│
├── Pokemon/                     # iOS SwiftUI App
│   ├── Models/                  # Swift models
│   ├── ViewModels/              # MVVM ViewModels
│   ├── Views/                   # SwiftUI Views
│   ├── Utilities/               # Helper code
│   ├── PokemonApp.swift         # App entry point
│   └── ContentView.swift
│
├── PokemonTests/                # iOS Unit Tests
├── PokemonUITests/              # iOS UI Tests
├── build.gradle.kts             # Gradle build config
└── build-framework.sh           # KMP framework build script
```

---

## Dependencies

### KMP (Kotlin)
- Kotlin 2.1.0
- Ktor 3.0.1 (HTTP client)
- kotlinx.serialization 1.7.3 (JSON parsing)
- kotlinx.coroutines 1.9.0 (Async)

### iOS (Swift)
- Swift 5.9+
- SwiftUI (UI framework)
- iOS 16.0+ deployment target

### External
- PokéAPI v2 (https://pokeapi.co/api/v2)

---

## Key Files to Know

- `shared/src/commonMain/kotlin/com/pokemon/PokemonSDK.kt`: Main KMP public API
- `shared/src/commonMain/kotlin/com/pokemon/repository/PokemonRepository.kt`: Data management logic
- `shared/src/commonMain/kotlin/com/pokemon/network/PokemonApi.kt`: Network calls
- `shared/src/iosMain/kotlin/com/pokemon/PokemonSDKiOS.kt`: iOS bridge layer
- `Pokemon/ViewModels/PokemonViewModel.swift`: Main list screen state
- `Pokemon/ViewModels/PokemonDetailViewModel.swift`: Detail screen state
- `Pokemon/Views/PokemonListView.swift`: List UI
- `Pokemon/Views/PokemonDetailView.swift`: Detail UI
- `Pokemon/Models/PokemonModels.swift`: Swift data models

---

## Tips for Claude Code

- **Don't over-engineer**: Keep solutions focused and simple
- **Match existing patterns**: Follow the established architecture
- **Test thoroughly**: Especially when touching the KMP/Swift bridge
- **Update both layers**: Model changes often require updates in both KMP and Swift
- **Cache matters**: Remember the caching strategy when adding new endpoints
- **Threading is handled**: PokemonSDKiOS ensures Main thread execution
- **Read first**: Always read files before suggesting modifications
