import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emma01/models/chat_message_entity.dart';
import 'package:emma01/utils/chat_bubble.dart';
import 'package:emma01/utils/chat_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatPage2 extends StatefulWidget {
  ChatPage2({Key? key}) : super(key: key);

  @override
  State<ChatPage2> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage2> {
  final TextEditingController _textController = TextEditingController();
  late CollectionReference<Map<String, dynamic>> _messagesRef;
  late Query<Map<String, dynamic>> _query;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  List<Map<String, dynamic>> _messages = [];

  // void logOut() {
  //   try {
  //     _auth.signOut();
  //     print("Logged out");
  //     Navigator.popAndPushNamed(context, '/login');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _messagesRef = FirebaseFirestore.instance.collection('Messages');
    _query = _messagesRef.orderBy('createdAt');
    _stream = _query.snapshots();
  }

  Widget _buildChatList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');

        _messages = snapshot.data!.docs.map((doc) => doc.data()).toList();

        return ListView.builder(
          itemCount: _messages.length,
          itemBuilder: (BuildContext context, int index) {
            final message = _messages[index];
            final sender = message['sender'];
            final text = message['text'];
            if (text == null) {
              return const SizedBox.shrink();
            }
            final isMe = sender == 'test@tes.com';
            // final created = message['createdAt'];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: <Widget>[
                  if (!isMe)
                    CircleAvatar(
                      radius: 20,
                      child: Text(sender[0]),
                      backgroundColor: Colors.green[900],
                    ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          sender,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.green : Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: isMe
                                  ? Radius.circular(15)
                                  : Radius.circular(0),
                              bottomRight: isMe
                                  ? Radius.circular(0)
                                  : Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMe)
                    CircleAvatar(
                      radius: 20,
                      child: Text(sender[0]),
                      backgroundColor: Colors.green[900],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page 2'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildChatList()),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final messageText = _textController.text;
                    _textController.clear();

                    await _messagesRef.add({
                      'createdAt': Timestamp.now(),
                      'sender': 'Alice',
                      'text': messageText,
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
