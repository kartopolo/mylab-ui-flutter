# Flutter Setup (Production-Ready)

This repo is intended to become a production-ready Flutter app.

## 0) Important: Secrets
Do **not** copy secrets from `/var/www/mylab/.env` into this repo.

Your `/var/www/mylab/.env` contains credentials and API keys (database password, WhatsApp token, OpenAI/Gemini keys, etc). Those must **never** be committed to Git.

Use:
- local-only files ignored by git (e.g. `.env.local`), or
- CI secrets (GitHub Actions Secrets), or
- build-time defines (`--dart-define`) for non-sensitive configuration.

## 1) Recommended Tooling

### Option A (recommended): FVM (Flutter Version Manager)
- Install FVM: https://fvm.app/
- Pin Flutter version per project so all devs/build agents are consistent.

Example:
- `fvm install 3.22.3`
- `fvm use 3.22.3`

### Option B: System Flutter SDK
- Install Flutter SDK: https://docs.flutter.dev/get-started/install

## 2) Create the Flutter app scaffold
Because Flutter SDK is not installed on this environment, generate the scaffold on a machine that has Flutter.

Recommended app folder name (Dart constraints): `mylab_ui_flutter` (underscores).
Repo folder name can remain: `mylab-ui-flutter`.

From inside `/var/www/mylab-ui-flutter`:

```bash
flutter create --org com.kartopolo mylab_ui_flutter
rsync -a mylab_ui_flutter/ ./
rm -rf mylab_ui_flutter/
```

Then:
```bash
flutter pub get
flutter analyze
flutter test
```

## 3) Environment Configuration (API base URL)
For production-ready behavior, keep environment values out of source code.

Recommended approach:
- Use `--dart-define=API_BASE_URL=https://...` at build/run time.
- Provide defaults for local dev only.

Example run:
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:18080
```

Example build:
```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com
```

## 4) Build Targets
- Android: `flutter build apk` / `flutter build appbundle`
- iOS: `flutter build ipa`
- Web (optional): `flutter build web`

## 5) Next steps after scaffold
- Add routing + state management conventions.
- Add API client layer to call MyLab Go API.
- Add authentication flow (X-User-Id header for now; later replace with real auth).
