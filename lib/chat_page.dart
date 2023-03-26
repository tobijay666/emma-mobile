import 'dart:math';

import 'package:emma01/models/chat_message_entity.dart';
import 'package:emma01/utils/chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  // final String userName;
  ChatPage({Key? key}) : super(key: key);

  final chatMessageController = TextEditingController();
  List<ChatMessageEntity> _messages = [
    ChatMessageEntity(
        text: "This is textC ",
        senderId: '1234',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: Author(name: 'John Doe')),
    ChatMessageEntity(
        text: "This is textB ",
        senderId: '1234',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: Author(name: 'Jane Doe')),
    ChatMessageEntity(
        text: "This is textC ",
        senderId: '1234',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: Author(name: 'John Doe')),
    ChatMessageEntity(
        text: "This is textB ",
        senderId: '1234',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: Author(name: 'Jane Doe')),
    ChatMessageEntity(
        text: "This is textC ",
        senderId: '1234',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: Author(name: 'John Doe'))
  ];

  void onSend() {
    print('Send');
    print('ChatMessage: ${chatMessageController.text}');
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
  Widget build(BuildContext context) {
    // TODO: implement build
    final userName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('EMMA'),
        // backgroundColor: Colors.teal.shade900,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/');
                // Navigator.maybePop(context);
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                    alignment: index % 2 == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    // 'Text Message test 0$index.');
                    entity: _messages[index]);
              },
              // children: [
              //   Align(
              //     alignment: Alignment.centerRight,
              //     child: Container(
              //       padding: EdgeInsets.all(10),
              //       margin: EdgeInsets.all(20),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text(
              //             'Text Message test 01.',
              //             style: TextStyle(fontSize: 15),
              //           ),
              //         ],
              //       ),
              //       decoration: BoxDecoration(
              //           color: Colors.blueGrey[100],
              //           borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(10),
              //             topRight: Radius.circular(10),
              //             bottomLeft: Radius.circular(10),
              //           )),
              //     ),
              //   ),
              //   Align(
              //     alignment: Alignment.centerLeft,
              //     child: Container(
              //       padding: EdgeInsets.all(10),
              //       margin: EdgeInsets.all(20),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text(
              //             'Text Message test 02.',
              //             style: TextStyle(fontSize: 15),
              //           ),
              //         ],
              //       ),
              //       decoration: BoxDecoration(
              //           color: Colors.green[200],
              //           borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(10),
              //             topRight: Radius.circular(10),
              //             bottomRight: Radius.circular(10),
              //           )),
              //     ),
              //   ),
              // Container(
              //   padding: EdgeInsets.all(10),
              //   margin: EdgeInsets.all(20),
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text(
              //         'Text Message test 01.',
              //         style: TextStyle(fontSize: 15),
              //       ),
              //     ],
              //   ),
              //   decoration: BoxDecoration(
              //       color: Colors.blueGrey[100],
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(10),
              //         topRight: Radius.circular(10),
              //         bottomLeft: Radius.circular(10),
            ),
          ),
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
                  ),
                ),
                IconButton(onPressed: onSend, icon: Icon(Icons.send_rounded))
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
