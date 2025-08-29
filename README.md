# rehearsal_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## CI

This project uses a GitHub Actions workflow defined in `.github/workflows/flutter.yml`.
On pushes and pull requests to the `main` branch the workflow runs:

- `flutter pub get`
- `flutter analyze`
- `flutter test --coverage`
- `flutter build web`

The resulting `build/web` directory is uploaded as a job artifact for easy preview.
