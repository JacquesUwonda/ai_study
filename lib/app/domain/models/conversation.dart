class Conversation {
  final int? id;
  final String topic;
  final List<Message> messages;

  Conversation({this.id, required this.topic, required this.messages});
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}
