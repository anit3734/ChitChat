class Message {
  int id;
  int senderId;
  int receiverId;
  String content;
  DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
