class User {
  int id;
  String name;
  bool online;
  DateTime lastSeen;

  User({
    required this.id,
    required this.name,
    required this.online,
    required this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        online: json['online'] ?? false,
        lastSeen: DateTime.parse(json['last_seen'] ?? DateTime.now().toString()),
      );
}
