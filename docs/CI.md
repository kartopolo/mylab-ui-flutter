# CI (GitHub Actions)

This repo includes a CI skeleton that runs:
- `flutter --version`
- `flutter pub get`
- `flutter analyze`
- `flutter test`

Notes:
- The workflow will only work after the Flutter scaffold exists (pubspec.yaml must exist).
- Add caching to speed up builds once stable.

## Secrets
Do not hardcode API URLs or tokens in the workflow file.
Use GitHub Actions Secrets if you must.
