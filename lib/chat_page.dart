import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<QueryDocumentSnapshot<Object?>>? messages =
                    snapshot.data?.docs;
                return ListView.builder(
                  itemCount: messages?.length,
                  itemBuilder: (context, index) {
                    String message = messages![index].get('message');
                    String sender = messages[index].get('sender');
                    return ListTile(
                      title: Text(message),
                      subtitle: Text(sender),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _sendMessage();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    String message = _textController.text.trim();
    if (message.isNotEmpty) {
      String sender = 'User'; // Replace with actual user name
      await _messagesCollection.add({
        'message': message,
        'sender': sender,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _textController.clear();
    }
  }
}
