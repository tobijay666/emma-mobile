import 'package:emma01/models/chat_message_entity.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(ChatMessageEntity) onSubmit;
  ChatInput({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
//   @override
  final chatMessageController = TextEditingController();

  void onSendButtonPressed() {
    final newMessage = ChatMessageEntity(
        text: chatMessageController.text,
        // senderId: '1234',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: Author(name: "John Doe"));
    // print(newMessage);
    widget.onSubmit(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 40,
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              controller: chatMessageController,
              decoration: InputDecoration(
                hintText: "Tell something to EMMA...",
                hintStyle: TextStyle(color: Colors.grey[300]),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
              onPressed: onSendButtonPressed, icon: Icon(Icons.send_rounded))
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    );
  }
}

// void onSubmit(ChatMessageEntity newMessage) {}
