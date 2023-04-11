import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emma01/models/chat_message_entity.dart';
import 'package:emma01/utils/chat_bubble.dart';
import 'package:emma01/utils/chat_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// cloud firestore

class ChatPage extends StatefulWidget {
  // final String userName;
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _firestore = FirebaseFirestore.instance;
  final chatMessageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var userEmail = "";

  String messageText = '';

  List<ChatBubble> messageWidgets = [];

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        User userX = user;
        userEmail = userX.email!;
        print(userX.email);

        // Navigator.pushReplacementNamed(context, '/chat');
        // loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('Messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('Messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  List<ChatMessageEntity> _messages = [];

  // _loadMessages() async {
  //   final response = await rootBundle.loadString('assets/mock_messages.json');

  //   final List<dynamic> decodedList = jsonDecode(response) as List;

  //   final List<ChatMessageEntity> _chatMessages = decodedList.map((e) {
  //     return ChatMessageEntity.fromJson(e);
  //   }).toList();

  //   // print(_chatMessages.length);

  //   setState(() {
  //     _messages = _chatMessages;
  //   });
  // }

  void onSendButtonPressed() {
    _firestore.collection('Messages').add({
      'text': chatMessageController.text,
      'sender': userEmail,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    // final newMessage = ChatMessageEntity(
    //     text: chatMessageController.text,
    //     senderId: '1234',
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     author: Author(name: "John Doe"));
    // print(newMessage);
    // onMessageSend(newMessage);
  }

  void logOut() {
    try {
      _auth.signOut();
      print("Logged out");
      Navigator.popAndPushNamed(context, '/login');
    } catch (e) {
      print(e);
    }
  }

  onMessageSend(ChatMessageEntity entity) {
    _messages.add(entity);
    setState(() {
      chatMessageController.clear();
      getChatBubble(Alignment.centerRight, entity.text);
    });
  }

  Widget getChatBubble(alignment, message) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$message',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            )),
      ),
    );
  }

  @override
  void initState() {
    // _loadMessages();
    super.initState();
    getCurrentUser();
    // getMessages();
    messagesStream();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // _loadMessages();
    // final userName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('EMMA'),
        // backgroundColor: Colors.teal.shade900,
        actions: [
          IconButton(
              onPressed: logOut,
              //() {
              //   Navigator.popAndPushNamed(context, '/login');
              //   // Navigator.maybePop(context);
              // },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('Messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageSender = message['sender'];

                    final messageWidget = ChatMessageEntity(
                      text: messageText,
                      // senderId: '01',
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                      author: Author(name: userEmail),
                    );
                    // final messageWidget =
                    //     Text('$messageText from $messageSender');
                    _messages.add(messageWidget);
                  }
                }

                return ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                        alignment: _messages[index].author.name == userEmail
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        entity: _messages[index]);
                  },
                );
//
                // var messageWidgets;
                // return ListView.builder(
                //   itemCount: _messages.length,
                //   itemBuilder: (context, index) {
                //     return ChatBubble(
                //         alignment: _messages[index].author.name == userEmail
                //             ? Alignment.centerRight
                //             : Alignment.centerLeft,
                //         entity: _messages[index]);
                //   },
                // );
              },
            ),

            // return Column(
            //   children: messageWidgets,
            // );

            // return ListView.builder(
            //   itemCount: _messages.length,
            //   itemBuilder: (context, index) {
            //     return ChatBubble(
            //         alignment: _messages[index].author.name == 'Jane Doe'
            //             ? Alignment.centerRight
            //             : Alignment.centerLeft,
            //         entity: _messages[index]);
            //   },
            // );

            // final messages = snapshot.data!.docs.reversed;
            // List<ChatBubble> messageWidgets = [];
            // for (var message in messages) {
            //   final messageText = chatMessageController.text;
            //   final messageSender = userEmail;
            //   final currentUser = userEmail;

            //   final messageWidget = ChatBubble(
            //     alignment: currentUser == messageSender
            //         ? Alignment.centerRight
            //         : Alignment.centerLeft,
            //     entity: ChatMessageEntity(
            //         text: messageText,
            //         senderId: '01',
            //         createdAt: DateTime.now().millisecondsSinceEpoch,
            //         author: Author(name: userEmail)),
            //   );
            // }

            // child: ListView.builder(
            //   itemCount: _messages.length,
            //   itemBuilder: (context, index) {
            //     return ChatBubble(
            //         alignment: _messages[index].author.name == 'Jane Doe'
            //             ? Alignment.centerLeft
            //             : Alignment.centerRight,
            //         // 'Text Message test 0$index.');
            //         entity: _messages[index]);
            //   },
            //   // children: [
            //   //   Align(
            //   //     alignment: Alignment.centerRight,
            //   //     child: Container(
            //   //       padding: EdgeInsets.all(10),
            //   //       margin: EdgeInsets.all(20),
            //   //       child: Column(
            //   //         mainAxisSize: MainAxisSize.min,
            //   //         children: [
            //   //           Text(
            //   //             'Text Message test 01.',
            //   //             style: TextStyle(fontSize: 15),
            //   //           ),
            //   //         ],
            //   //       ),
            //   //       decoration: BoxDecoration(
            //   //           color: Colors.blueGrey[100],
            //   //           borderRadius: BorderRadius.only(
            //   //             topLeft: Radius.circular(10),
            //   //             topRight: Radius.circular(10),
            //   //             bottomLeft: Radius.circular(10),
            //   //           )),
            //   //     ),
            //   //   ),
            //   //   Align(
            //   //     alignment: Alignment.centerLeft,
            //   //     child: Container(
            //   //       padding: EdgeInsets.all(10),
            //   //       margin: EdgeInsets.all(20),
            //   //       child: Column(
            //   //         mainAxisSize: MainAxisSize.min,
            //   //         children: [
            //   //           Text(
            //   //             'Text Message test 02.',
            //   //             style: TextStyle(fontSize: 15),
            //   //           ),
            //   //         ],
            //   //       ),
            //   //       decoration: BoxDecoration(
            //   //           color: Colors.green[200],
            //   //           borderRadius: BorderRadius.only(
            //   //             topLeft: Radius.circular(10),
            //   //             topRight: Radius.circular(10),
            //   //             bottomRight: Radius.circular(10),
            //   //           )),
            //   //     ),
            //   //   ),
            //   // Container(
            //   //   padding: EdgeInsets.all(10),
            //   //   margin: EdgeInsets.all(20),
            //   //   child: Column(
            //   //     mainAxisSize: MainAxisSize.min,
            //   //     children: [
            //   //       Text(
            //   //         'Text Message test 01.',
            //   //         style: TextStyle(fontSize: 15),
            //   //       ),
            //   //     ],
            //   //   ),
            //   //   decoration: BoxDecoration(
            //   //       color: Colors.blueGrey[100],
            //   //       borderRadius: BorderRadius.only(
            //   //         topLeft: Radius.circular(10),
            //   //         topRight: Radius.circular(10),
            //   //         bottomLeft: Radius.circular(10),
            // ),
          ),
          // ChatInput(onSubmit: onMessageSend),
          Container(
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
                        hintStyle: TextStyle(color: Colors.lightGreen[100]),
                        border: InputBorder.none),
                    // onSubmitted: (text) {
                    //   final newMessage = ChatMessageEntity(
                    //       text: chatMessageController.text,
                    //       senderId: '1234',
                    //       createdAt: DateTime.now().millisecondsSinceEpoch,
                    //       author: Author(name: "John Doe"));
                    //   setState(() {
                    //     _messages.add(newMessage);
                    //     chatMessageController.clear();
                    //   });
                    // },
                  ),
                ),
                IconButton(
                    onPressed: onSendButtonPressed,
                    icon: Icon(Icons.send_rounded))
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[700],
    );
  }
}
