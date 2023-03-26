class ChatMessageEntity {
  String text;
  String senderId;
  int createdAt;
  Author author;

  ChatMessageEntity({
    required this.text,
    required this.senderId,
    required this.createdAt,
    required this.author,
  });
}

class Author {
  String name;
  // String avatarUrl;

  Author({
    required this.name,
    // required this.avatarUrl,
  });
}
