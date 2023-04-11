class ChatMessageEntity {
  String text;
  // String senderId;
  int createdAt;
  Author author;

  ChatMessageEntity({
    required this.text,
    // required this.senderId,
    required this.createdAt,
    required this.author,
  });

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
        text: json['text'],
        // senderId: json['senderId'],
        createdAt: json['createdAt'],
        author: Author.fromJson(json['author']));
  }
}

class Author {
  String name;
  // String avatarUrl;

  Author({
    required this.name,
    // required this.avatarUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'],
      // avatarUrl: json['avatarUrl'],
    );
  }
}
