# Clean Flutter
flutter clean

# Remove pubspec.lock and .flutter-plugins
Remove-Item -Path "pubspec.lock" -ErrorAction SilentlyContinue
Remove-Item -Path ".flutter-plugins" -ErrorAction SilentlyContinue
Remove-Item -Path ".flutter-plugins-dependencies" -ErrorAction SilentlyContinue

# Clean iOS specific files
if (Test-Path "ios") {
    Write-Host "Cleaning iOS build files..."
    Set-Location "ios"
    
    # Remove Pods directory and related files
    Remove-Item -Recurse -Force "Pods" -ErrorAction SilentlyContinue
    Remove-Item -Force "Podfile.lock" -ErrorAction SilentlyContinue
    Remove-Item -Force "Podfile" -ErrorAction SilentlyContinue
    
    # Clean Xcode derived data
    Remove-Item -Recurse -Force "${env:HOME}/Library/Developer/Xcode/DerivedData" -ErrorAction SilentlyContinue
    
    Set-Location ".."
}

# Clean Android specific files
if (Test-Path "android") {
    Write-Host "Cleaning Android build files..."
    Set-Location "android"
    
    # Clean Gradle cache
    if (Test-Path ".gradle") {
        Remove-Item -Recurse -Force ".gradle" -ErrorAction SilentlyContinue
    }
    
    # Clean build files
    .\gradlew clean --stacktrace
    
    Set-Location ".."
}

# Get dependencies
Write-Host "Getting Flutter dependencies..."
flutter pub get

# For iOS, install pods if on macOS
if ($IsMacOS -or $IsLinux) {
    if (Test-Path "ios/Podfile") {
        Write-Host "Installing iOS pods..."
        Set-Location "ios"
        pod deintegrate
        pod repo update
        pod install --repo-update
        Set-Location ".."
    }
}

# Run build runner
Write-Host "Running build runner..."
flutter pub run build_runner build --delete-conflicting-outputs

Write-Host "Clean and restore completed!"
