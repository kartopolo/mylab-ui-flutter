import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'responsive.dart';
import 'widgets/theme_dropdown.dart';
import 'layouts/main_layout.dart';
import 'pages/welcome/welcome_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/patients/patients_page.dart';
import 'pages/reports/reports_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/auth/login_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTheme _currentTheme = AppTheme.light;
  bool _isLoadingTheme = true;
  bool _isLoggedIn = false;
  final _authService = AuthService();

  static const _prefsKey = 'selected_theme';

  ThemeData get _themeData => themePresets[_currentTheme]!;

  void _handleThemeChange(AppTheme theme) {
    setState(() => _currentTheme = theme);
    _persistTheme(theme);
  }

  @override
  void initState() {
    super.initState();
    _restoreTheme();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await _authService.isLoggedIn();
    if (!mounted) return;
    setState(() => _isLoggedIn = loggedIn);
  }

  Future<void> _restoreTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    final restored = AppTheme.values.firstWhere(
      (t) => t.name == stored,
      orElse: () => AppTheme.light,
    );

    if (!mounted) return;
    setState(() {
      _currentTheme = restored;
      _isLoadingTheme = false;
    });
  }

  Future<void> _persistTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, theme.name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyLab UI Flutter',
      theme: _themeData,
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: BouncingScrollWrapper.builder(context, child!),
          breakpoints: const [
            Breakpoint(start: 0, end: kMobileBreakpoint, name: MOBILE),
            Breakpoint(start: kMobileBreakpoint, end: kTabletBreakpoint, name: TABLET),
            Breakpoint(start: kTabletBreakpoint, end: 2460, name: DESKTOP),
          ],
        );
      },
      home: _isLoggedIn
          ? MyHomePage(
              currentTheme: _currentTheme,
              onThemeChanged: _handleThemeChange,
              isLoadingTheme: _isLoadingTheme,
            )
          : WelcomeAuthPage(
              currentTheme: _currentTheme,
              onThemeChanged: _handleThemeChange,
            ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => MyHomePage(
          currentTheme: _currentTheme,
          onThemeChanged: _handleThemeChange,
          isLoadingTheme: _isLoadingTheme,
          initialPage: (ModalRoute.of(context)?.settings.arguments as String?) ?? 'welcome',
        ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.isLoadingTheme,
    this.initialPage = 'welcome',
  });

  final AppTheme currentTheme;
  final ValueChanged<AppTheme> onThemeChanged;
  final bool isLoadingTheme;
  final String initialPage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final String _selectedPage = widget.initialPage;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'MyLab',
      currentTheme: widget.currentTheme,
      onThemeChanged: widget.onThemeChanged,
      isLoadingTheme: widget.isLoadingTheme,
      child: _getPageContent(),
    );
  }

  Widget _getPageContent() {
    switch (_selectedPage) {
      case 'welcome':
        return const WelcomePage();
      case 'dashboard':
        return const DashboardPage();
      case 'patients':
        return const PatientsPage();
      case 'reports':
        return const ReportsPage();
      case 'settings':
        return const SettingsPage();
      default:
        return const WelcomePage();
    }
  }
}

// Welcome page for non-logged in users
class WelcomeAuthPage extends StatelessWidget {
  final AppTheme currentTheme;
  final ValueChanged<AppTheme> onThemeChanged;

  const WelcomeAuthPage({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Row(
          children: [
            Icon(Icons.medical_services, size: 24),
            SizedBox(width: 8),
            Text('MyLab'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ThemeDropdown(
              current: currentTheme,
              onChanged: onThemeChanged,
              disabled: false,
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.medical_services,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to MyLab',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Corporate Medical Report System',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                icon: const Icon(Icons.login),
                label: const Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
