import 'package:flutter/material.dart';
import '../../models/menu_item.dart';
import '../../services/menu_service.dart';

class MenuManagerPage extends StatefulWidget {
  const MenuManagerPage({super.key});

  @override
  State<MenuManagerPage> createState() => _MenuManagerPageState();
}

class _MenuManagerPageState extends State<MenuManagerPage> {
  final _menuService = MenuService();
  List<MenuItem> _menuItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    try {
      final items = await _menuService.fetchMenuFromApi();
      setState(() {
        _menuItems = items;
        _isLoading = false;
      });
      await _menuService.saveMenuLocal(items);
    } catch (e) {
      final local = await _menuService.getMenuLocal();
      setState(() {
        _menuItems = local;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Manager')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMenu,
              child: _menuItems.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 48),
                        Center(child: Text('No menu items found')),
                      ],
                    )
                  : ListView.builder(
                      itemCount: _menuItems.length,
                      itemBuilder: (context, idx) {
                        final item = _menuItems[idx];
                        return ListTile(
                          leading: const Icon(Icons.menu),
                          title: Text(item.name),
                          subtitle: Text(item.route),
                          trailing: Switch(
                            value: item.enabled,
                            onChanged: (val) async {
                              setState(() => _menuItems[idx] = MenuItem(
                                    name: item.name,
                                    icon: item.icon,
                                    route: item.route,
                                    enabled: val,
                                  ));
                              // optimistic save locally; persist in background
                              await _menuService.saveMenuLocal(_menuItems);
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
