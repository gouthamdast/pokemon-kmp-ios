# Pokémon iOS App

A modern Pokémon information app built with **Kotlin Multiplatform** for shared business logic and **SwiftUI** for the iOS interface.

## Features

- 📱 **Modern iOS Design** - Clean SwiftUI interface following iOS design guidelines
- 🔍 **Search Functionality** - Search Pokémon by name
- 📋 **Paginated List** - Infinite scroll with automatic pagination
- 🔄 **Pull to Refresh** - Refresh Pokémon list data
- 📊 **Detailed Stats** - View HP, Attack, Defense, and other stats with visual bars
- 🎨 **Type Badges** - Color-coded type badges for all 18 Pokémon types
- ⚡ **Type Effectiveness** - See strengths and weaknesses
- 💪 **Abilities** - Display normal and hidden abilities
- 🖼️ **High-Quality Artwork** - Official Pokémon artwork and sprites
- 💾 **Smart Caching** - Reduces API calls with in-memory cache
- 🌐 **Offline-First Architecture** - KMP repository pattern with caching

## Architecture

### Kotlin Multiplatform Module (`shared/`)

The shared module contains all business logic and can target both iOS and Android:

- **Models** - Data classes for Pokémon, types, stats, abilities
- **Network Layer** - Ktor client for PokéAPI integration
- **Repository Pattern** - Handles data fetching, caching, and pagination
- **kotlinx.serialization** - JSON parsing
- **Coroutines & Flow** - Async operations and reactive streams

### iOS App (`Pokemon/`)

SwiftUI-based iOS application:

- **Views** - List view, detail view, type effectiveness chart
- **ViewModels** - Bridge between KMP SDK and SwiftUI
- **Models** - Swift-friendly wrappers around KMP models
- **Utilities** - Type colors, helpers, and extensions

## Prerequisites

- **macOS** with Xcode 15.0+
- **Gradle** 8.5+ (for building KMP framework)
- **JDK** 17+ (for Kotlin compilation)
- **iOS 16.0+** target

## Setup Instructions

### 1. Install Gradle (if not already installed)

```bash
# Using Homebrew
brew install gradle

# Or download from https://gradle.org/install/
```

### 2. Generate Gradle Wrapper

```bash
gradle wrapper --gradle-version 8.5
```

### 3. Build the KMP Framework

Build the shared Kotlin Multiplatform framework for iOS:

```bash
# Option 1: Use the build script
./build-framework.sh

# Option 2: Build manually with Gradle
./gradlew :shared:linkDebugFrameworkIosSimulatorArm64  # For M1/M2 Mac Simulator
./gradlew :shared:linkDebugFrameworkIosX64             # For Intel Mac Simulator
./gradlew :shared:linkDebugFrameworkIosArm64           # For physical iOS devices
```

The framework will be generated at:
```
shared/build/bin/iosSimulatorArm64/debugFramework/shared.framework
```

### 4. Add Framework to Xcode Project

1. Open `Pokemon.xcodeproj` in Xcode
2. Select the Pokemon project in the navigator
3. Select the Pokemon target
4. Go to "General" tab → "Frameworks, Libraries, and Embedded Content"
5. Click the "+" button
6. Click "Add Other..." → "Add Files..."
7. Navigate to `shared/build/bin/iosSimulatorArm64/debugFramework/`
8. Select `shared.framework` and click "Open"
9. Change "Embed" to "Embed & Sign"

### 5. Update Framework Search Paths

1. In Xcode, go to Build Settings
2. Search for "Framework Search Paths"
3. Add: `$(PROJECT_DIR)/shared/build/bin/iosSimulatorArm64/debugFramework`

### 6. Enable KMP Integration in ViewModels

Uncomment the KMP-related code in:
- `Pokemon/ViewModels/PokemonViewModel.swift`
- `Pokemon/ViewModels/PokemonDetailViewModel.swift`

Look for comments like:
```swift
// import shared  // Uncomment after building and adding KMP framework
```

### 7. Build and Run

1. Select a simulator or device
2. Press `Cmd + R` to build and run
3. The app will fetch real Pokémon data from PokéAPI!

## Project Structure

```
Pokemon/
├── shared/                          # Kotlin Multiplatform Module
│   ├── build.gradle.kts
│   └── src/
│       ├── commonMain/
│       │   └── kotlin/com/pokemon/
│       │       ├── models/          # Data models
│       │       ├── network/         # Ktor API client
│       │       ├── repository/      # Repository & caching
│       │       └── PokemonSDK.kt    # Main SDK entry point
│       └── iosMain/
│           └── kotlin/com/pokemon/
│               └── FlowHelpers.kt   # iOS Flow bridge
│
├── Pokemon/                         # iOS SwiftUI App
│   ├── Models/
│   │   └── PokemonModels.swift      # Swift models
│   ├── ViewModels/
│   │   ├── PokemonViewModel.swift
│   │   └── PokemonDetailViewModel.swift
│   ├── Views/
│   │   ├── PokemonListView.swift
│   │   ├── PokemonDetailView.swift
│   │   └── TypeEffectivenessView.swift
│   ├── Utilities/
│   │   └── PokemonTypeColors.swift
│   └── PokemonApp.swift
│
├── build.gradle.kts                 # Root Gradle config
├── settings.gradle.kts
├── gradle.properties
└── build-framework.sh               # Build script
```

## API Reference

The app uses [PokéAPI](https://pokeapi.co/) - a free RESTful Pokémon API.

### Main Endpoints Used:

- `GET /pokemon` - List of Pokémon (paginated)
- `GET /pokemon/{id}` - Pokémon details
- `GET /ability/{name}` - Ability details
- `GET /type/{name}` - Type effectiveness

## Development

### Running Tests

```bash
./gradlew :shared:test
```

### Rebuilding Framework

After making changes to the Kotlin code:

```bash
./gradlew :shared:clean
./build-framework.sh
# Then rebuild in Xcode
```

### Updating Dependencies

Edit `shared/build.gradle.kts` and update version numbers in the `sourceSets` section.

## Troubleshooting

### "Module 'shared' not found"

- Ensure the framework is built and added to Xcode
- Check Framework Search Paths in Build Settings
- Clean build folder in Xcode (Cmd + Shift + K)

### Gradle Build Fails

```bash
# Clean and rebuild
./gradlew clean
./gradlew :shared:build
```

### Framework Not Updated

```bash
# Clean Gradle cache
./gradlew :shared:clean
# Rebuild
./build-framework.sh
# Clean Xcode build
# Cmd + Shift + K in Xcode, then rebuild
```

### "Command not found: gradle"

Install Gradle first:
```bash
brew install gradle
```

## Future Enhancements

- [ ] Add Android support to KMP module
- [ ] Implement favorite Pokémon feature
- [ ] Add move details and animations
- [ ] Evolution chain visualization
- [ ] Compare two Pokémon
- [ ] Pokémon team builder
- [ ] Dark mode optimization
- [ ] iPad-optimized layout
- [ ] Offline mode with local database
- [ ] Unit and UI tests

## Technologies Used

### Backend (KMP)
- Kotlin 1.9.22
- Kotlin Multiplatform
- Ktor 2.3.7 (networking)
- kotlinx.serialization 1.6.2
- kotlinx.coroutines 1.7.3

### iOS
- Swift 5.9+
- SwiftUI
- iOS 16.0+
- Async/Await

## License

This project is for educational purposes. Pokémon and Pokémon character names are trademarks of Nintendo.

## Credits

- Pokémon data from [PokéAPI](https://pokeapi.co/)
- Pokémon sprites and artwork from [PokéAPI Sprites Repository](https://github.com/PokeAPI/sprites)
- Built with ❤️ using Kotlin Multiplatform and SwiftUI

## Author

Created by Goutham Das T

---

For questions or issues, please open an issue on GitHub.
