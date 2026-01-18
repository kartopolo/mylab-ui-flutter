import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu_item.dart';
import 'api_service.dart';

class MenuService {
  static const _menuKey = 'user_menu_items';
  final ApiService _apiService = ApiService();

  Future<List<MenuItem>> fetchMenuFromApi() async {
    // try backend menu endpoint; fall back to generic CRUD select if needed
    try {
      final response = await _apiService.get('/api/menu');
      final items = (response['data'] as List?) ?? [];
      return items.map((e) => MenuItem.fromJson(e)).toList();
    } catch (_) {
      final resp = await _apiService.post('/v1/crud/menu/select', {'page': 1, 'per_page': 200});
      final items = (resp['data'] as List?) ?? [];
      return items.map((e) => MenuItem.fromJson(e)).toList();
    }
  }

  Future<void> saveMenuLocal(List<MenuItem> menu) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(menu.map((e) => e.toJson()).toList());
    await prefs.setString(_menuKey, jsonStr);
  }

  Future<List<MenuItem>> getMenuLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_menuKey);
    if (jsonStr == null) return [];
    final items = jsonDecode(jsonStr) as List;
    return items.map((e) => MenuItem.fromJson(e)).toList();
  }
}
