# MyLab Flutter UI - AI Coding Instructions

## Project Overview
Official Flutter web UI for MyLab API (mylab-api-go). Corporate Medical Report System with responsive design for desktop, tablet, and mobile.

## Core Technologies
- **Flutter 3.38.7** with Dart 3.10.7
- **Target**: Web (primary), with mobile/desktop capability
- **Responsive**: `responsive_framework` package for breakpoints
- **State**: `shared_preferences` for persistence
- **Formatting**: `intl` for date/time

## Architecture Pattern: Layout-Based (Laravel Blade Style)

### Base Layout Pattern
Flutter equivalent of Laravel Blade `@extends` and `@yield`:

```dart
// layouts/main_layout.dart - Base template
class MainLayout extends StatelessWidget {
  final Widget child;  // @yield('content')
  final String title;
  
  const MainLayout({required this.child, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: Row([
        if (isDesktop) buildSidebar(),
        Expanded(child: child),  // Page content injected here
      ]),
    );
  }
}

// pages/patients/patients_page.dart - Extends layout
class PatientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Patients',
      child: _buildContent(),  // Page-specific content
    );
  }
}
```

## Project Structure (Modular per Page)

```
lib/
├── main.dart (app entry, theme, routing)
├── responsive.dart (breakpoint constants)
├── layouts/
│   ├── main_layout.dart (authenticated pages base)
│   ├── auth_layout.dart (login/register/forgot password base)
│   └── error_layout.dart (API offline/error pages)
├── pageauth/
│   │   ├── login_page.dart (extends AuthLayout)
│   │   ├── forgot_password_page.dart (extends AuthLayout)
│   │   └── reset_password_page.dart (extends AuthLayout)
│   ├── error/
│   │   ├── api_offline_page.dart (API down/unreachable)
│   │   └── not_found_page.dart (404)
│   ├── s/
│   ├── welcome/
│   │   ├── welcome_page.dart (main page, extends MainLayout)
│   │   └── welcome_widgets.dart (cards, sections specific to welcome)
│   ├── patients/
│   │   ├── patients_page.dart (list view)
│   │   ├── patient_form.dart (create/edit form)
│   │   ├── patient_card.dart (list item widget)
│   │   └── patient_detail.dart (detail view)
│   ├── reports/
│   │   ├── reports_page.dart
│   │   ├── report_filters.dart
│   │   └── report_chart.dart
│   ├── auth_service.dart (login/logout/token management)
    └── storage_service.dart (shared_preferences wrapper)
│       └── dashboard_page.dart
├── widgets/ (global shared widgets only)
│   ├── theme_dropdown.dart
│   ├── app_bar.dart
│   └── sidebar.dart
└── services/
    ├── api_service.dart (HTTP client for mylab-api-go)
    └── auth_service.dart
```

## Folder Organization Rules

### 1. **Page Folder Structure**
Each page is a self-contained module:
```
pages/
  feature_name/
    feature_page.dart      # Main page (extends MainLayout)
    feature_form.dart      # Forms specific to this feature
    feature_card.dart      # List item widget
    feature_detail.dart    # Detail view
    widgets/               # If many small widgets, group in subfolder
      small_widget_1.dart
      small_widget_2.dart
```

### 2. **File Naming Conventions**
- Page main file: `{feature}_page.dart` (e.g., `patients_page.dart`)
- Forms: `{feature}_form.dart`
- Cards/Items: `{feature}_card.dart`
- Detail: `{feature}_detail.dart`
- Widgets: descriptive name (e.g., `report_chart.dart`)

### 3. **When to Create Page Folder**
- **Always**: Every distinct page gets its own folder
- **Subfolder `widgets/`**: When page has 3+ small supporting widgets
- **Keep flat**: If page only needs 1-2 widgets, keep them in page folder directly

### 4. **Global vs Page-Specific**
- **`lib/widgets/`**: Used by 2+ pages (AppBar, Sidebar, ThemeDropdown)
- **`pages/{feature}/`**: Only used within that feature
- **Move to global**: When 2nd page needs it

## Responsive Design

### Breakpoints (from `responsive.dart`)
```dart
const double kMobileBreakpoint = 600.0;
const double kTabletBreakpoint = 1024.0;

// Usage
final isDesktop = MediaQuery.of(context).size.width >= kTabletBreakpoint;
final isMobile = MediaQuery.of(context).size.width < kMobileBreakpoint;
```

### Responsive Layout Component
```dart
ResponsiveLayout(
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)
```

### Layout Patterns
- **Desktop**: Permanent sidebar (240px) + content area
- **Tablet/Mobile**: Drawer (hamburger menu) + full-width content
- **AppBar**: Always visible, responsive actions

## Theme & Styling

### Theme Presets (4 options)
Defined in `widgets/theme_dropdown.dart`:
- `AppTheme.light` (default, teal seed)
- `AppTheme.dark` (grey seed)
- `AppTheme.blue` (blue seed)
- `AppTheme.purple` (deepPurple seed)

### Theme Persistence
- Stored in `shared_preferences` with key `selected_theme`
- Restored on app startup
- Changed via `ThemeDropdown` widget in AppBar

### Typography & Spacing Guidelines (Professional & Compact)

**Font Sizes (Material 3 defaults - DO NOT override unless specified):**
- `displayLarge`: 57px (headlines only)
- `headlineMedium`: 28px (page titles)
- `titleLarge`: 22px (section headers)
- `bodyLarge`: 16px (default body text)
- `bodyMedium`: 14px (secondary text)
- `labelLarge`: 14px (buttons)

**Content Padding (Minimal & Professional):**
```dart
// Page content
Container(padding: EdgeInsets.all(16))  // 16px standard

// Cards
Card(
  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),  // Tight spacing
  child: Padding(padding: EdgeInsets.all(12))  // Compact internal
)

// Form inputs
TextField(
  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),  // Compact
)

// Buttons
ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),  // Standard
  )
)
```

**Layout Spacing:**
- Between sections: `SizedBox(height: 16)`
- Between form fields: `SizedBox(height: 12)`
- Between related items: `SizedBox(height: 8)`
- Inline horizontal: `SizedBox(width: 8)`

**Professional Style Rules:**
1. **No excessive padding** — use 8/12/16px standard
2. **Readable font weight** — regular (400) for body, medium (500) for emphasis, bold (700) for headers
3. **Contrast for readability** — use `Theme.of(context).colorScheme` for proper contrast
4. **Compact forms** — minimal vertical spacing, clear labels
5. **No giant text** — stick to Material 3 defaults unless specific reason

## State Management

### User Session
```dart
// Store user
final prefs = await SharedPreferences.getInstance();
await prefs.setString('user_name', userName);

// Retrieve user
final userName = prefs.getString('user_name');

// Clear (logout)
await prefs.remove('user_name');
```

### Date/Time Formatting
```dart
import 'package:intl/intl.dart';

final formatted = DateFormat('d MMM HH:mm').format(DateTime.now());
// Output: "17 Jan 15:30"
```

## Navigation Pattern

### Current: State-Based (Simple)
Using `setState` and switch/case in `main.dart`:
```dart
String _selectedPage = 'welcome';

Widget _getPageContent() {
  switch (_selectedPage) {
    case 'patients': return PatientsPage();
    default: return WelcomePage();
  }
}
```

### Future: Named Routes (Recommended)
When app grows, migrate to:
```dart
MaterialApp(
  routes: {
    '/welcome': (context) => WelcomePage(),
    '/patients': (context) => PatientsPage(),
    '/patients/new': (context) => PatientForm(),
  },
);
```

## API Integration (mylab-api-go Communication)

### API Service Pattern
```dart
// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const baseUrl = 'http://localhost:18080';  // mylab-api-go
  
  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/healthz')).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // Generic GET
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, response.body);
  }
  
  // Generic POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, response.body);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
}
```

### Error Handling (API Offline/Down)
Show friendly error page when API is unreachable:
```dart
// pages/error/api_offline_page.dart
class ApiOfflinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('API Server Offline', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 8),
            Text('Cannot connect to mylab-api-go', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () => retry(), child: Text('Retry')),
          ],
        ),
      ),
    );
  }
}
```

### Page Integration
```dart
class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Patient> patients = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadPatients();
  }
  
  Future<void> _loadPatients() async {
    final data = await ApiService().getPatients();
    setState(() {
      patients = data;
      isLoading = false;
    });
  }
}
```

## Development Workflow

### Hot Reload
- **Command**: `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 36883`
- **Key**: Press `r` in terminal for hot reload after file changes
- **Full restart**: Press `R` for hot restart (clears state)

### Run Port & Quick Check
- **Port**: UI serves on `http://localhost:36883`
- **Verify**:
  ```bash
  curl -s -o /dev/null -w "%{http_code}\n" http://localhost:36883/
  ```
  Expected `200` when the dev server is up.

### File Creation Checklist
1. Create page folder: `pages/{feature}/`
2. Main page file: `{feature}_page.dart`
3. Extend `MainLayout` for authenticated pages
4. Add to navigation switch/case in `main.dart`
5. Create supporting widgets in same folder
6. Move to `widgets/` only when used by 2+ pages

### Common Patterns

#### Form Page
```dart
class PatientForm extends StatefulWidget {
  final Patient? patient; // null = create, non-null = edit
  
  const PatientForm({this.patient});
}
```

#### List Page with Cards
```dart
class PatientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Patients',
      child: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) => PatientCard(patient: patients[index]),
      ),
    );
  }
}
```

#### Detail Page
```dart
class PatientDetail extends StatelessWidget {
  final String patientId;
  
  const PatientDetail({required this.patientId});
}
```

## Code Quality Rules

1. **Always use `const` for static widgets** (better performance)
2. **Extract repeated widgets** into separate files/classes
3. **Keep page files < 300 lines** (split if larger)
4. **Naming**: descriptive, no abbreviations (e.g., `PatientCard` not `PtCard`)
5. **Comments**: only for non-obvious business logic
6. **Formatting**: `dart format` before commit

## Testing Approach

- **Manual**: Web browser at `http://localhost:18088`
- **Responsive**: Browser DevTools responsive mode
- **Theme**: Switch via dropdown in AppBar
- **User flow**: Login → Navigate → Logout

## Dependencies (pubspec.yaml)
http: ^1.1.0  # API communication with mylab-api-go
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.3.2
  responsive_framework: ^1.4.0
  intl: ^0.19.0
  # Add API integration later:
  # http: ^1.1.0
```

## Common Issues & Solutions

### Issue: Layout overflow on small screens
**Solution**: Wrap with `SingleChildScrollView` and set `shrinkWrap: true` on lists

### Issue: State not updating after API call
**Solution**: Ensure `setState()` is called after data changes

### Issue: Theme not persisting
**Solution**: Check `_restoreTheme()` is called in `initState`

### Issue: Sidebar showing on mobile
**Solution**: Use conditional `drawer: isDesktop ? null : _buildDrawer()`

## Migration Path (Current → Target)

1. ✅ **Phase 1 (Current)**: Base layout with static pages
2. 🔄 **Phase 2**: Refactor into `MainLayout` + modular pages
3. ⏳ **Phase 3**: Add API integration with mylab-api-go
4. ⏳ **Phase 4**: Forms with validation
5. ⏳ **Phase 5**: Real authentication with JWT

## Related Documentation

- Flutter UI: `/var/www/mylab-ui-flutter/README.md`
- API Backend: `/var/www/mylab-api-go/.github/copilot-instructions.md`
- API Docs: `/var/www/mylab-api-go/Docs/api/`

## Summary for AI Assistant

When building new pages:
1. Create folder `pages/{feature}/`
2. Main file extends `MainLayout`
3. Page-specific widgets stay in page folder
4. Use responsive breakpoints for layout
5. Persist important state with `shared_preferences`
6. Follow Laravel Blade mental model: layout = base template, page child = content
