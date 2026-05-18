# Yes No App

A Flutter application that allows users to get a "Yes" or "No" answer to their questions.

## Getting Started

### Prerequisites

Before you begin, ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Angstromico/Flutter-Yes-No-App.git
   cd Flutter-Yes-No-App
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

## Running the App

You can run the app on various platforms. Make sure you have the appropriate emulator or physical device connected.

### Mobile (Android & iOS)
- Connect your device or start an emulator.
- Run the following command:
  ```bash
  flutter run
  ```
  *(If multiple devices are connected, use `flutter run -d <device_id>`)*

### Web
- Run the app in Chrome:
  ```bash
  flutter run -d chrome
  ```

### Desktop
Ensure desktop support is enabled for your OS:
- **Linux**: `flutter config --enable-linux-desktop`
- **macOS**: `flutter config --enable-macos-desktop`
- **Windows**: `flutter config --enable-windows-desktop`

Then run:
  ```bash
  flutter run -d linux # or macos / windows
  ```

## Project Structure
- `lib/`: Contains the application source code.
- `lib/presentation/`: UI screens and components.
- `assets/`: Images and other static resources.

## Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Learning Resources](https://docs.flutter.dev/reference/learning-resources)
