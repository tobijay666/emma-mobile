import 'dart:convert';
import 'dart:math';

import 'package:emma01/models/chat_message_entity.dart';
import 'package:emma01/utils/chat_bubble.dart';
import 'package:emma01/utils/chat_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  // final String userName;
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatMessageController = TextEditingController();

  List<ChatMessageEntity> _messages = [
    // ChatMessageEntity(
    //     text: "This is textC ",
    //     senderId: '1234',
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     author: Author(name: 'John Doe')),
    // ChatMessageEntity(
    //     text: "This is textB ",
    //     senderId: '1234',
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     author: Author(name: 'Jane Doe')),
    // ChatMessageEntity(
    //     text: "This is textC ",
    //     senderId: '1234',
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     author: Author(name: 'John Doe')),
    // ChatMessageEntity(
    //     text: "This is textB ",
    //     senderId: '1234',
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     author: Author(name: 'Jane Doe')),
    // ChatMessageEntity(
    //     text: "This is textC ",
    //     senderId: '1234',
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     author: Author(name: 'John Doe'))
  ];

  _loadMessages() async {
    final response = await rootBundle.loadString('assets/mock_messages.json');

    final List<dynamic> decodedList = jsonDecode(response) as List;

    final List<ChatMessageEntity> _chatMessages = decodedList.map((e) {
      return ChatMessageEntity.fromJson(e);
    }).toList();

    // print(_chatMessages.length);

    setState(() {
      _messages = _chatMessages;
    });
  }

  void onSendButtonPressed() {
    final newMessage = ChatMessageEntity(
        text: chatMessageController.text,
        senderId: '1234',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: Author(name: "John Doe"));
    // print(newMessage);
    onMessageSend(newMessage);
  }

  onMessageSend(ChatMessageEntity entity) {
    _messages.add(entity);
    setState(() {
      chatMessageController.clear();
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
    _loadMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _loadMessages();
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
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                    alignment: _messages[index].author.name == 'Jane Doe'
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
