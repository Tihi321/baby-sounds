# Baby Sounds

A Flutter mobile application designed to soothe and calm babies through a curated collection of lullabies, white noise, and children's songs. Perfect for naptime, bedtime routines, and creating a peaceful environment for your little one.

## Overview

Baby Sounds is a thoughtfully crafted mobile app designed to help parents create a calming and soothing atmosphere for their babies. Understanding that consistent, gentle sounds can significantly improve sleep quality and reduce stress in infants, our app offers a carefully curated selection of audio content. From classical lullabies that have soothed generations of babies to scientifically-designed white noise that mimics womb sounds, each audio track is specifically chosen for its calming properties.

The app features continuous playback capability even when the screen is off or other apps are in focus, making it perfect for naptime and bedtime routines. Parents can easily create customized playlists combining different types of sounds - perhaps starting with gentle children's songs during the wind-down routine, transitioning to a calming lullaby, and finally maintaining peaceful white noise throughout the night. This flexibility helps establish consistent sleep routines, which sleep experts recognize as crucial for healthy infant development.

What sets Baby Sounds apart is its focus on both functionality and simplicity. While packed with features like background playback and playlist management, the interface remains intuitive enough to operate even during those challenging middle-of-the-night moments. The app is optimized for battery efficiency during long playback sessions, ensuring it can reliably run throughout naps and nighttime sleep without draining your device.

## Available Sounds

### 🎵 Lullabies

- Calm and Focused Lullaby
- Mozart-Brahms Lullaby Collection
- Soothing Classical Arrangements

### 🌊 White Noise

- Gentle Ocean Waves
- Soothing White Noise

### 🎼 Children's Songs

- Collection of gentle and calming children's music
- Carefully selected songs for young listeners
- Multi-language song options

## Key Features

- 🎵 Background audio playback - continues playing when using other apps
- 💤 Screen-off playback support - perfect for sleeping time
- 🔄 Loop functionality for continuous play
- 📱 Cross-platform support (iOS & Android)
- 🎚️ Simple, intuitive controls
- 🔊 High-quality audio files

## Technical Details

### Prerequisites

- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- Android Studio / VS Code
- Physical Android/iOS devices or emulator for testing

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  just_audio: ^0.9.26
  just_audio_background: ^0.0.1
```

### Installation

1. Install dependencies:

```bash
flutter pub get
```

2. Run the app:

```bash
flutter run
```

### Building

For Android:

```bash
dart run flutter_launcher_icons
flutter build apk --release
```

For iOS:

```bash
flutter build ios --release
```

The release APK can be found at:

```
build/app/outputs/flutter-apk/app-release.apk
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
├── screens/                     # App screens
├── services/                    # Audio player service
├── widgets/                     # UI components
└── assets/
    └── audio/                  # Sound files
        ├── lullaby/            # Lullaby tracks
        ├── noise/              # White noise sounds
        └── pjesme/             # Children's songs
```

## Features in Detail

- **Smart Background Playback**: Continues playing even when the app is in the background or screen is locked
- **Battery Optimization**: Efficient background playback for extended use
- **Customizable Experience**: Choose from various sound categories
- **Simple Interface**: Easy-to-use controls for all functions
- **Playlist Support**: Create custom playlists of favorite sounds

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
