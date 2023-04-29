import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emma01/utils/brandcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadTheme();
    _getUserCredentials();
  }

  Future<void> _getUserCredentials() async {
    // User user = widget.user;
    User? user = _auth.currentUser;
    // if (user != null && user == _auth.currentUser) {
    //   setState(() {
    //     _user = user;
    //   });
    // } else {
    //   print("User is null. Logging out...");
    //   _logOut();
    // }
    print(user?.email);
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
                    bool isMe = sender == _auth.currentUser!.displayName;
                    return Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
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
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                message,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFF00A884)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      // suffixIcon: IconButton(
                      //   icon: Icon(Icons.send, color: Color(0xFF00A884)),
                      //   onPressed: _sendMessage,
                      // ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send_rounded,
                    size: 30, color: BrandColor.greenDark),
                onPressed: () {
                  _sendMessage();
                },
              ),
            ],
          ),
        ],
      ),
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
                leading: Icon(Icons.brightness_6),
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
                leading: Icon(Icons.logout),
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
    );
  }

  void _sendMessage() async {
    String message = _textController.text.trim();
    if (message.isNotEmpty) {
      String? sender =
          _auth.currentUser?.displayName; // Replace with actual user name
      await _messagesCollection.add({
        'message': message,
        'sender': sender,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _textController.clear();
    }
  }
}
