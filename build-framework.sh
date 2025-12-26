#!/bin/bash

# Build script for iOS framework
# This script builds the KMP shared module into an iOS framework

set -e

echo "Building iOS framework..."

# Build for iOS Simulator (ARM64 for M1/M2 Macs)
./gradlew :shared:linkDebugFrameworkIosSimulatorArm64

# Build for iOS Simulator (X64 for Intel Macs)
./gradlew :shared:linkDebugFrameworkIosX64

# Build for iOS Device (ARM64)
./gradlew :shared:linkDebugFrameworkIosArm64

echo "Framework built successfully!"
echo "Location: shared/build/bin/"
echo ""
echo "To use in Xcode:"
echo "1. Open Pokemon.xcodeproj"
echo "2. Add the framework to your project"
echo "3. Make sure to add the framework to 'Frameworks, Libraries, and Embedded Content'"
