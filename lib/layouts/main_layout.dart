import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../responsive.dart';
import '../widgets/theme_dropdown.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String title;
  final AppTheme currentTheme;
  final ValueChanged<AppTheme> onThemeChanged;
  final bool isLoadingTheme;

  const MainLayout({
    super.key,
    required this.child,
    required this.title,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.isLoadingTheme,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String? _userName;
  String _currentTime = '';
  Timer? _timer;
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadSidebarState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('d MMM HH:mm').format(DateTime.now());
    });
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name');
    });
  }

  Future<void> _loadSidebarState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sidebarExpanded = prefs.getBool('sidebar_expanded') ?? true;
    });
  }

  Future<void> _toggleSidebar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sidebarExpanded = !_sidebarExpanded;
    });
    await prefs.setBool('sidebar_expanded', _sidebarExpanded);
  }

  Future<void> _handleLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', 'Admin User');
    setState(() => _userName = 'Admin User');
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    setState(() => _userName = null);
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= kTabletBreakpoint;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(isDesktop && _sidebarExpanded ? Icons.menu_open : Icons.menu),
            onPressed: () {
              if (isDesktop) {
                _toggleSidebar();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            tooltip: isDesktop 
                ? (_sidebarExpanded ? 'Hide Sidebar' : 'Show Sidebar')
                : 'Open Menu',
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.medical_services, size: 24),
            const SizedBox(width: 8),
            Text(widget.title),
            const SizedBox(width: 16),
            Text(_currentTime, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        actions: [
          if (_userName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: PopupMenuButton<String>(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_circle),
                    const SizedBox(width: 4),
                    Text(_userName!),
                  ],
                ),
                onSelected: (value) {
                  if (value == 'logout') _handleLogout();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'profile', child: Text('Profile')),
                  const PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton.icon(
                onPressed: _handleLogin,
                icon: const Icon(Icons.login, size: 18),
                label: const Text('Login'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ThemeDropdown(
              current: widget.currentTheme,
              onChanged: widget.onThemeChanged,
              disabled: widget.isLoadingTheme,
            ),
          ),
        ],
      ),
      drawer: isDesktop ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _sidebarExpanded ? 240 : 72,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildMenuItem(Icons.home, 'Welcome', '/welcome'),
          _buildMenuItem(Icons.dashboard, 'Dashboard', '/dashboard'),
          _buildMenuItem(Icons.people, 'Patients', '/patients'),
          _buildMenuItem(Icons.assignment, 'Reports', '/reports'),
          _buildMenuItem(Icons.settings, 'Settings', '/settings'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.medical_services, size: 40, color: Colors.white),
                SizedBox(height: 8),
                Text('MyLab', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildMenuItem(Icons.home, 'Welcome', '/welcome'),
          _buildMenuItem(Icons.dashboard, 'Dashboard', '/dashboard'),
          _buildMenuItem(Icons.people, 'Patients', '/patients'),
          _buildMenuItem(Icons.assignment, 'Reports', '/reports'),
          _buildMenuItem(Icons.settings, 'Settings', '/settings'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String route) {
    final isSelected = ModalRoute.of(context)?.settings.name == route;
    
    if (!_sidebarExpanded) {
      return Tooltip(
        message: title,
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          selected: isSelected,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          onTap: () {
            Navigator.pushReplacementNamed(context, route);
          },
        ),
      );
    }
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
