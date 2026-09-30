import 'guest.dart';

class Event {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<Guest> guests;

  const Event({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.guests,
  });

  double get totalAmount =>
      guests.fold(0.0, (sum, g) => sum + g.amount);

  int get totalPeople =>
      guests.fold(0, (sum, g) => sum + g.count);

  int get guestEntries => guests.length;

  Event copyWith({String? title, List<Guest>? guests}) {
    return Event(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      guests: guests ?? this.guests,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'guests': guests.map((g) => g.toJson()).toList(),
      };

  factory Event.fromJson(Map<String, dynamic> j) => Event(
        id: j['id'] as String,
        title: j['title'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        guests: (j['guests'] as List)
            .map((e) => Guest.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
