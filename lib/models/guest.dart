class Guest {
  final String id;
  final String name;
  final int count;
  final double amount;

  const Guest({
    required this.id,
    required this.name,
    required this.count,
    required this.amount,
  });

  Guest copyWith({String? name, int? count, double? amount}) {
    return Guest(
      id: id,
      name: name ?? this.name,
      count: count ?? this.count,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'count': count,
        'amount': amount,
      };

  factory Guest.fromJson(Map<String, dynamic> j) => Guest(
        id: j['id'] as String,
        name: j['name'] as String,
        count: (j['count'] as num).toInt(),
        amount: (j['amount'] as num).toDouble(),
      );
}
