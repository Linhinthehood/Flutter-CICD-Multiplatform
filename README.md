# Flutter Note App with CI/CD Pipeline

A cross-platform Flutter note-taking application demonstrating a production-ready CI/CD workflow with automated testing, multi-platform builds, and GitHub Releases integration.

### Key Highlights
- 🚀 **Automated CI/CD**: GitHub Actions workflow with testing, building, and releasing
- 📦 **GitHub Releases**: Automatic release creation with macOS and Windows builds
- 🔄 **Multi-platform Builds**: Android, macOS, and Windows
- 🔥 **Firebase Integration**: Automated deployment to Firebase App Distribution

### Application Features
- 📝 Rich text editing with formatting support
- 🖼️ Image insertion and management
- 🎵 Audio playback integration
- ✅ Todo item management
- 🔍 Semantic search functionality
- 💾 Local database storage with SQLite
- 🎨 Modern and intuitive UI

## Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## Getting Started

### Prerequisites

- Flutter SDK (3.35.2 or higher)
- Dart SDK (3.5.0 or higher)
- For iOS/macOS: Xcode
- For Android: Android Studio

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd note_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## CI/CD Pipeline

This project uses GitHub Actions for automated testing, building, and deployment with GitHub Releases.

### Automated Workflows

- ✅ **Testing**: Runs on every push to `main` and `develop`
- ✅ **Code Analysis**: Format checking and static analysis
- ✅ **Multi-platform Builds**: Android, macOS, and Windows
- ✅ **GitHub Releases**: Automatic release creation with desktop builds
- ✅ **Firebase App Distribution**: Automatic deployment to testers (Android)

### Build Artifacts

**On push to `main` branch:**
- Android: APK and App Bundle (stored as artifacts for 30 days)
- macOS: .app bundle (stored as artifacts for 30 days)
- Windows: Executable with dependencies (stored as artifacts for 30 days)
- Android builds deployed to Firebase App Distribution

**On version tag push (e.g., `v1.0.0`):**
- All above builds are created
- **GitHub Release is automatically created** with:
  - ✅ macOS .app bundle (zipped)
  - ✅ Windows executable (zipped)
- Release appears in the **Releases tab** for public download

## Creating a Release

To create a new release with macOS and Windows builds:

### Option 1: Using Git Tags (Recommended)

```bash
# 1. Make sure you're on the latest main branch
git checkout main
git pull origin main

# 2. Create a version tag (semantic versioning)
git tag v1.0.0

# 3. Push the tag to trigger the release workflow
git push origin v1.0.0
```

### Option 2: Using GitHub Web Interface

1. Go to your repository on GitHub
2. Click **"Releases"** → **"Create a new release"**
3. Click **"Choose a tag"** → Type `v1.0.0` → **"Create new tag"**
4. Select target: `main` branch
5. Click **"Publish release"**

### What Happens Next:

1. ✅ GitHub Actions runs all tests
2. ✅ Builds Android, macOS, and Windows versions
3. ✅ Creates a GitHub Release with macOS and Windows builds
4. ✅ Release appears in the **Releases tab** for download
5. ✅ Android builds deployed to Firebase App Distribution

**Note**: You don't need new code changes to create a release. Tags work with your current code!

### Workflow Summary

| Action | Tests Run? | Builds Created? | Release Created? |
|--------|-----------|-----------------|------------------|
| Push to `develop` | ✅ Yes | ❌ No | ❌ No |
| Push to `main` | ✅ Yes | ✅ Yes (artifacts only) | ❌ No |
| Push tag `v*` | ✅ Yes | ✅ Yes | ✅ Yes (macOS + Windows) |

## Firebase App Distribution Setup

To enable automatic deployment to Firebase App Distribution:

1. **Read the setup guide**: [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md)
2. **Quick reference**: [SECRETS_REFERENCE.md](SECRETS_REFERENCE.md)

### Quick Setup

```bash
# 1. Login to Firebase
firebase login:ci

# 2. Add secrets to GitHub:
# - FIREBASE_TOKEN
# - FIREBASE_APP_ID_ANDROID
# - FIREBASE_APP_ID_IOS

# 3. Push to main branch
git push origin main
```

See [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md) for detailed instructions.

## Development

### Project Structure

```
lib/
├── data/           # Data layer (models, services)
├── helpers/        # Helper utilities
├── models/         # Data models
├── presentation/   # Presentation layer (pages, providers, widgets)
├── providers/      # State management
├── screens/        # App screens
├── services/       # Business logic services
└── widgets/        # Reusable widgets
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Code Quality

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Check for issues
flutter analyze --fatal-infos
```

## Using Fastlane

### Android

```bash
cd android

# Deploy to Firebase
bundle exec fastlane deploy_to_firebase

# Run tests
bundle exec fastlane test

# Build only
bundle exec fastlane build
```

### iOS

```bash
cd ios

# Deploy to Firebase
bundle exec fastlane deploy_to_firebase

# Run tests
bundle exec fastlane test

# Build only
bundle exec fastlane build
```

## Building for Release

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS (requires macOS)
flutter build ios --release
```

### macOS

```bash
# Build for macOS (requires macOS)
flutter build macos --release
```

### Windows

```bash
# Build for Windows (requires Windows)
flutter build windows --release
```

### Linux

```bash
# Build for Linux (requires Linux)
flutter build linux --release
```

### Web

```bash
# Build for Web
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [GitHub Actions](https://docs.github.com/en/actions)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
