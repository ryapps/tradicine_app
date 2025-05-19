class Message {
  final int? id;
  final String sender;
  final String message;
  final String timestamp;

  Message({this.id, required this.sender, required this.message, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      sender: map['sender'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
