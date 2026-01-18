class MenuItem {
  final String name;
  final String icon;
  final String route;
  final bool enabled;

  MenuItem({
    required this.name,
    required this.icon,
    required this.route,
    this.enabled = true,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      route: json['route'] ?? '',
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon,
    'route': route,
    'enabled': enabled,
  };
}
