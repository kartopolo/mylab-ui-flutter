# mylab-ui-flutter

Flutter UI client for MyLab - Production-ready responsive web application.

## Status: ✅ Ready for Development

Project sudah di-setup dan siap untuk development dengan fokus web-first responsive design.

## Tech Stack
- **Flutter**: 3.38.7 (Stable)
- **Dart**: 3.10.7
- **Target Platform**: Web (Chrome/Chromium)
- **Backend API**: MyLab Go API (http://localhost:18080)

## Project Structure

```
mylab-ui-flutter/
├── lib/
│   ├── main.dart           # Entry point & responsive demo
│   └── responsive.dart     # ResponsiveLayout widget (breakpoints: 600px, 1024px)
├── test/                   # Unit & widget tests
├── web/                    # Web-specific files (index.html, manifest.json)
├── docs/
│   ├── SETUP.md           # Setup guide
│   ├── ARCHITECTURE.md    # Architecture patterns
│   └── CI.md              # CI/CD notes
├── pubspec.yaml           # Dependencies
└── analysis_options.yaml  # Linting rules (excludes flutter/ untuk performa)
```

## Responsive Breakpoints

Layout otomatis menyesuaikan berdasarkan lebar layar:

- **Mobile** (< 600px): Single column, stacked components
- **Tablet** (600-1024px): Two-column layout dengan cards
- **Desktop** (>= 1024px): Sidebar + main content area

## Quick Start

### Development (Web Server)
```bash
cd /var/www/mylab-ui-flutter
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 18088 --dart-define=API_BASE_URL=http://localhost:18080
```

Buka browser: **http://localhost:18088**

### Development (Chrome)
```bash
# Set Chrome path (sekali saja)
export CHROME_EXECUTABLE="/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"

cd /var/www/mylab-ui-flutter
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:18080
```

### Hot Reload
Saat aplikasi running, tekan `r` di terminal untuk hot reload setiap ada perubahan kode.

## Build untuk Production

### Web
```bash
flutter build web --release --dart-define=API_BASE_URL=https://api.example.com
```
Output: `build/web/`

### Android (requires Android SDK)
```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com
```

### iOS (macOS + Xcode only)
```bash
flutter build ipa --release --dart-define=API_BASE_URL=https://api.example.com
```

## Environment Variables

Gunakan `--dart-define` untuk konfigurasi tanpa hardcode:

```bash
--dart-define=API_BASE_URL=http://localhost:18080
--dart-define=ENV=dev
```

Akses di kode:
```dart
const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:18080');
```

## Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## Next Steps

1. **Routing**: Implementasi navigasi multi-page (go_router/auto_route)
2. **State Management**: Setup Provider/Riverpod/Bloc
3. **API Integration**: Service layer untuk MyLab Go API
4. **Authentication**: Login flow + token management
5. **Forms**: Input validation & data binding

## Docker Build (CI/CD)

Untuk build otomatis di Docker (Web only):

```bash
docker run --rm -v /var/www/mylab-ui-flutter:/app -w /app \
  ghcr.io/cirruslabs/flutter:3.22.3 \
  bash -lc "flutter pub get && flutter build web --release --dart-define=API_BASE_URL=https://api.example.com"
```

## Docs

- [docs/SETUP.md](docs/SETUP.md) — Setup lengkap Flutter & dependencies
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — Clean architecture pattern
- [docs/CI.md](docs/CI.md) — CI/CD pipeline

## Notes

- Package name: `mylab_ui_flutter` (underscore, Dart requirement)
- Dev port: **18088** (non-standard untuk avoid konflik)
- Tidak menyimpan secrets di repo (gunakan `--dart-define` atau CI secrets)
- Analysis excludes `flutter/**` folder untuk performa ringan
