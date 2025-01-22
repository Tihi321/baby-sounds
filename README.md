# baby-sounds

A Flutter application for playing soothing background sounds for babies. The app features continuous playback capability even when the screen is off or other apps are in focus, making it perfect for naptime and bedtime routines.

## Features

- 🎵 Background audio playback
- 📱 Cross-platform support (iOS & Android)
- 🔄 Loop functionality for continuous play
- 🎚️ Multiple sound options
- 💡 Screen-off playback support
- 🔊 High-quality audio files

## Prerequisites

- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- Android Studio / VS Code
- Physical Android/iOS devices or emulator for testing

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  just_audio: ^0.9.26
  just_audio_background: ^0.0.1
```

## Installation

1. Install dependencies

```bash
flutter pub get
```

2. Run the app

```bash
# Start an emulator or connect a physical device
flutter emulators --launch Pixel_9_API_35  # Or your preferred emulator
flutter run
```

## Development Mode

To run the app in development/emulator mode:

```bash
flutter run --dart-define=FORCE_EMULATOR=true
flutter run -d emulator-5554 --dart-define=FORCE_EMULATOR=true
flutter run -d emulator-5556 --dart-define=SERVER_ADDRESS=192.168.178.79
flutter run -d emulator-5556 | findstr /v "MESA"
```

## Building

### Debug Build

```bash
flutter build apk --debug
```

### Release Build

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

### Clean Build

```bash
flutter clean
flutter pub get
flutter build apk --release
```

## Build Output Location

### APK Location

After running `flutter build apk`, the APK file is located at:

```bash
build/app/outputs/flutter-apk/app-release.apk
```

## Project Structure

```
lib/
├── main.dart           # App entry point with audio player implementation
└── assets/
    └── audio/         # Sound files directory
        ├── waves.mp3
        └── white-noise.mp3
```

## Features in Detail

- **Background Playback**: Continue playing sounds even when the app is in the background
- **Loop Control**: Toggle looping for continuous playback
- **Simple Interface**: Easy-to-use controls for play/stop and loop functionality
- **Multiple Sounds**: Choose from different soothing sounds
- **Battery Efficient**: Optimized for long-running background playback

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
