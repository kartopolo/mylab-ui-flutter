import 'package:flutter/material.dart';

enum AppTheme { light, dark, blue, purple }

class ThemeDropdown extends StatelessWidget {
  final AppTheme current;
  final ValueChanged<AppTheme> onChanged;
  final bool disabled;

  const ThemeDropdown({
    super.key,
    required this.current,
    required this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final Map<AppTheme, (String, IconData)> entries = {
      AppTheme.light: ('Default', Icons.wb_sunny_outlined),
      AppTheme.dark: ('Dark', Icons.dark_mode_outlined),
      AppTheme.blue: ('Blue', Icons.water_drop_outlined),
      AppTheme.purple: ('Purple', Icons.auto_awesome_outlined),
    };

    return PopupMenuButton<AppTheme>(
      icon: Icon(entries[current]!.$2),
      tooltip: 'Theme',
      enabled: !disabled,
      onSelected: onChanged,
      itemBuilder: (context) => entries.entries.map((e) {
        return PopupMenuItem<AppTheme>(
          value: e.key,
          child: Row(
            children: [
              Icon(e.value.$2, size: 20),
              const SizedBox(width: 8),
              Text(e.value.$1),
            ],
          ),
        );
      }).toList(),
    );
  }
}

final Map<AppTheme, ThemeData> themePresets = {
  AppTheme.light: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
    brightness: Brightness.light,
  ),
  AppTheme.dark: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey, brightness: Brightness.dark),
    useMaterial3: true,
    brightness: Brightness.dark,
  ),
  AppTheme.blue: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    brightness: Brightness.light,
  ),
  AppTheme.purple: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    brightness: Brightness.light,
  ),
};
