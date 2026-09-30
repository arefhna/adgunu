import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';

class StorageService {
  static const _key = 'events_v1';

  Future<List<Event>> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = json.decode(raw) as List;
    return list
        .map((e) => Event.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<Event> events) async {
    final sp = await SharedPreferences.getInstance();
    final raw = json.encode(events.map((e) => e.toJson()).toList());
    await sp.setString(_key, raw);
  }
}
