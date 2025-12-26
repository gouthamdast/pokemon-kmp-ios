import org.jetbrains.kotlin.gradle.plugin.mpp.apple.XCFramework

plugins {
    kotlin("multiplatform")
    kotlin("plugin.serialization")
}

kotlin {
    val xcf = XCFramework()

    iosX64 {
        binaries.framework {
            baseName = "shared"
            xcf.add(this)
            isStatic = true
        }
    }

    iosArm64 {
        binaries.framework {
            baseName = "shared"
            xcf.add(this)
            isStatic = true
        }
    }

    iosSimulatorArm64 {
        binaries.framework {
            baseName = "shared"
            xcf.add(this)
            isStatic = true
        }
    }

    sourceSets {
        val ktorVersion = "3.0.1"
        val coroutinesVersion = "1.9.0"
        val serializationVersion = "1.7.3"

        commonMain.dependencies {
            // Ktor for networking
            implementation("io.ktor:ktor-client-core:$ktorVersion")
            implementation("io.ktor:ktor-client-content-negotiation:$ktorVersion")
            implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")
            implementation("io.ktor:ktor-client-logging:$ktorVersion")

            // Kotlinx Serialization
            implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:$serializationVersion")

            // Coroutines
            implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:$coroutinesVersion")
        }

        iosMain.dependencies {
            implementation("io.ktor:ktor-client-darwin:$ktorVersion")
        }
    }
}
