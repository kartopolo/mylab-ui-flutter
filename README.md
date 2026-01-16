# mylab-ui-flutter

Flutter UI client for MyLab (target: production-ready).

## Current Status
This repo is initialized and ready, but the Flutter app scaffold is not generated yet (Flutter SDK is not installed in this environment).

## Docs
- [docs/SETUP.md](docs/SETUP.md) — Flutter/FVM setup + environment config (no secrets)
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — proposed clean architecture
- [docs/CI.md](docs/CI.md) — CI notes

## Next Step: Generate Flutter Scaffold
Run on a machine with Flutter installed:

```bash
cd /var/www/mylab-ui-flutter
flutter create --org com.kartopolo mylab_ui_flutter
rsync -a mylab_ui_flutter/ ./
rm -rf mylab_ui_flutter/

flutter pub get
flutter analyze
flutter test
```

## Notes
- Repo name contains hyphens (`mylab-ui-flutter`), but Flutter/Dart package names must use underscores (e.g., `mylab_ui_flutter`).
- Do not copy secrets from `/var/www/mylab/.env` into this repo.
