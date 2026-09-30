import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../models/guest.dart';
import '../services/storage_service.dart';

class EventProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final List<Event> _events = [];
  bool _ready = false;

  List<Event> get events => List.unmodifiable(_events);
  bool get ready => _ready;

  Future<void> init() async {
    _events
      ..clear()
      ..addAll(await _storage.load());
    _ready = true;
    notifyListeners();
  }

  String _newId() {
    final r = Random();
    return '${DateTime.now().microsecondsSinceEpoch}_${r.nextInt(9999)}';
  }

  Future<void> addEvent(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    _events.insert(
      0,
      Event(
        id: _newId(),
        title: trimmed,
        createdAt: DateTime.now(),
        guests: const [],
      ),
    );
    await _storage.save(_events);
    notifyListeners();
  }

  Future<void> renameEvent(String eventId, String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx == -1) return;
    _events[idx] = _events[idx].copyWith(title: trimmed);
    await _storage.save(_events);
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    _events.removeWhere((e) => e.id == eventId);
    await _storage.save(_events);
    notifyListeners();
  }

  Event? eventById(String eventId) {
    for (final e in _events) {
      if (e.id == eventId) return e;
    }
    return null;
  }

  Future<void> addGuest(String eventId, Guest guest) async {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx == -1) return;
    final updated = [..._events[idx].guests, guest];
    _events[idx] = _events[idx].copyWith(guests: updated);
    await _storage.save(_events);
    notifyListeners();
  }

  Future<void> updateGuest(String eventId, Guest guest) async {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx == -1) return;
    final guests = [..._events[idx].guests];
    final gIdx = guests.indexWhere((g) => g.id == guest.id);
    if (gIdx == -1) return;
    guests[gIdx] = guest;
    _events[idx] = _events[idx].copyWith(guests: guests);
    await _storage.save(_events);
    notifyListeners();
  }

  Future<void> removeGuest(String eventId, String guestId) async {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx == -1) return;
    final guests = [..._events[idx].guests]
      ..removeWhere((g) => g.id == guestId);
    _events[idx] = _events[idx].copyWith(guests: guests);
    await _storage.save(_events);
    notifyListeners();
  }

  String newGuestId() => _newId();
}
