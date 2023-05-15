import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emma01/utils/brandcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ChatPage extends StatefulWidget {
  // final User user;

  // const ChatPage({required this.user, Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDarkTheme = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  final ScrollController _scrollController = ScrollController();
  bool _isMe = false;
  var messagesCollectionx;
  bool _isWaitingForResponse = false;
  String _URL = "https://2258-220-247-221-156.ngrok-free.app";

  // AES Encryption
  static const secretOfEmma = AES_MOB_KEY;
  var key = encrypt.Key.fromUtf8(secretOfEmma);
  final iv = IV.fromLength(16);

  encryption(Smessage) {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(Smessage, iv: iv);
    return encrypted.base64;
  }

  decryption(Xmessage) {
    final encrypter = Encrypter(AES(key));
    Xmessage = Encrypted.fromBase64(Xmessage);
    final decrypted = encrypter.decrypt(Xmessage, iv: iv);
    return decrypted;
  }

  // get sender => null;

  void _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      prefs.setBool('isDarkTheme', _isDarkTheme);
    });
  }

  void _logOut() async {
    // signing out of firebase
    await FirebaseAuth.instance.signOut();
    // Then navigate to the login page
    Navigator.pushReplacementNamed(context, '/login2');
  }

  @override
  void initState() {
    super.initState();
    // _loadTheme();
    _getUserCredentials();
  }

  Future<void> _getUserCredentials() async {
    // User user = widget.user;
    _user = _auth.currentUser;
    if (_user != null) {
      _isMe = true;
    }
    messagesCollectionx = _messagesCollection.where('sender',
        isEqualTo: _auth.currentUser?.displayName);
    // if (user != null && user == _auth.currentUser) {
    //   setState(() {
    //     _user = user;
    //   });
    // } else {
    //   print("User is null. Logging out...");
    //   _logOut();
    // }

    print(_user?.email);
    print(_user?.displayName);
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    setState(() {
      _isDarkTheme = isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          color: _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, bottom: 20),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Divider(
                color: _isDarkTheme ? Colors.white : Colors.black,
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.brightness_6,
                    color: _isDarkTheme ? BrandColor.greenDark : Colors.black),
                title: Text(
                  _isDarkTheme ? 'Light Theme' : 'Dark Theme',
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  _toggleTheme();
                },
              ),
              Divider(
                color: _isDarkTheme ? Colors.white : Colors.black,
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.download,
                    color: _isDarkTheme ? BrandColor.greenDark : Colors.black),
                title: Text(
                  'Get Report',
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  _GenerateReport();
                },
              ),
              Divider(
                color: _isDarkTheme ? Colors.white : Colors.black,
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.logout,
                    color: _isDarkTheme ? BrandColor.greenDark : Colors.black),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  _logOut();
                },
              ),
              Divider(
                color: _isDarkTheme ? Colors.white : Colors.black,
                height: 1,
              ),
            ],
          ),
        ),
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'CHAT with EMMA',
          style: TextStyle(color: BrandColor.greenDark),
        ),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFF008F7A),
            width: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: BrandColor.greenDark),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // stream: messagesCollectionx.orderBy('timestamp').snapshots(),
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                  print('No data in the stream');
                }
                List<QueryDocumentSnapshot<Object?>>? messages =
                    snapshot.data?.docs;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages?.length,
                  itemBuilder: (context, index) {
                    if (index == messages?.length && _isWaitingForResponse) {
                      // If waiting for a response, show the waiting message bubble
                      if (_isWaitingForResponse) {
                        return _buildWaitingMessage();
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      String messageEnc = messages![index].get('message');
                      String message = decryption(messageEnc);

                      String sender = messages[index].get('sender');
                      String sentto = messages[index].get('sentto');
                      // bool isMe = sender == _user?.displayName;
                      bool isMe = _auth.currentUser != null &&
                          sender == _auth.currentUser!.displayName;
                      bool isSentToEmma =
                          sentto == _auth.currentUser!.displayName;
                      if (isSentToEmma || isMe) {
                        return Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? BrandColor.greenDark
                                      : Color.fromARGB(112, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isMe
                                        ? BrandColor.greenDark
                                        : BrandColor.greenDark,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sender,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isMe
                                            ? (_isDarkTheme
                                                ? Color.fromARGB(
                                                    255, 29, 29, 29)
                                                : Colors.white)
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      message,
                                      style: TextStyle(
                                        color: isMe
                                            ? (_isDarkTheme
                                                ? Color.fromARGB(
                                                    255, 29, 29, 29)
                                                : Colors.white)
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // return an empty container if the user is not logged in
                        return Container();
                      }
                    }
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
                  child: Stack(
                    children: [
                      TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                              color: _isDarkTheme
                                  ? BrandColor.greyLight
                                  : BrandColor.greyDark),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: _isDarkTheme
                                    ? BrandColor.greyLight
                                    : BrandColor.greyDark),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: _isDarkTheme
                                    ? BrandColor.greyLight
                                    : BrandColor.greyDark),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFF00A884)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      ),
                      if (_isWaitingForResponse)
                        Positioned(
                          right: 40.0,
                          bottom: 10.0,
                          child: SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send_rounded,
                    size: 30, color: BrandColor.greenDark),
                onPressed: () {
                  // setState(() {
                  //   _isWaitingForResponse = true;
                  // });
                  _sendMessage();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Send a message to the AI Agent

  // Create a new chat bubble widget to represent the waiting message bubble
  Widget _buildWaitingMessage() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  BrandColor.greenDark,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Sending message...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getResponse(String message, String sender) async {
    setState(() {
      _isWaitingForResponse = true;
    });
    String url = '$_URL/text';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, String> jsonBody = {'message': message, 'sender': sender};

    var response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(jsonBody));

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      String replyMessage = responseData['message'];
      String sender = responseData['sender'] ?? "EMMA";

      String encryptedMessage = encryption(replyMessage);
      await _messagesCollection.add({
        'message': encryptedMessage,
        'sender': sender,
        'sentto': _user?.displayName,
        'timestamp': FieldValue.serverTimestamp(),
      });
      // setState(() {
      //   _isTyping = false;
      // });
    } else {
      print('Error: ${response.reasonPhrase}');
      // setState(() {
      //   _isTyping = false;
      // });
    }
    setState(() {
      _isWaitingForResponse = false;
    });
  }

  void _GenerateReport() async {
    String? userName = _auth.currentUser?.displayName;
    String? email = _auth.currentUser?.email;

    if (userName == null || email == null) {
      return;
    } else {
      String url = '$_URL/report';
      Map<String, String> headers = {'Content-Type': 'application/json'};
      Map<String, String> jsonBody = {'username': userName, 'email': email};

      var response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(jsonBody));

      if (response.statusCode == 200) {
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Response'),
                content: Text(response.body),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });

        // setState(() {
        //   _isTyping = false;
        // });
      } else {
        print('Error: ${response.reasonPhrase}');
        // setState(() {
        //   _isTyping = false;
        // });
      }
    }
  }

  _sendMessage() async {
    String message = _textController.text.trim();
    if (message.isNotEmpty) {
      String? sender =
          _auth.currentUser?.displayName; // Replace with actual user name
      String encryptedMessage = encryption(message);
      await _messagesCollection.add({
        'message': encryptedMessage,
        'sender': sender,
        'sentto': 'EMMA',
        'timestamp': FieldValue.serverTimestamp(),
      });
      _textController.clear();
      _getResponse(message, sender!);
      // return true;
    }
  }
}
