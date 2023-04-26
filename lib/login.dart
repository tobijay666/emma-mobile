import 'package:emma01/routes/routes.dart';
import 'package:emma01/utils/spaces.dart';
import 'package:emma01/utils/textfield_styles.dart';
import 'package:emma01/widgets/login_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:emma01/chat_page.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final _formKey = GlobalKey<FormState>();

final userNameController = TextEditingController();

navigateToChat(context) {
  Navigator.of(context).pushReplacementNamed(Routes.chat);
}

final passwordController = TextEditingController();

void loginUser(context, _auth) async {
  if (_formKey.currentState!.validate()) {
    print('Login');
    print(userNameController.text);
    print(passwordController.text);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: userNameController.text, password: passwordController.text);
      print("Login Success");
      User user = userCredential.user!;
      if (user != null) {
        navigateToChat(context);
      }
    } catch (e) {
      print(e);
    }
  } else {
    print('Invalid');
  }
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  navigateToRegister(context) {
    Navigator.of(context).pushReplacementNamed(Routes.register);
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://2a0a-116-206-246-22.ngrok-free.app/sayhi');
    final response = await http.get(url);
    print(response.body);
  }

  @override
  void initState() {
    super.initState();
    // getCurrentUser();
    // fetchData();
  }

  // void getCurrentUser() async {
  //   try {
  //     final userX = await _auth.currentUser;
  //     if (userX != null) {
  //       print(userX.email);
  //       Navigator.pushReplacementNamed(context, '/chat');
  //       // loggedInUser = user;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      // drawer: Drawer(),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   print('Button Clicked');
      // }),
      // body: Text(
      //   'Hey! Before you start Please Sign In.',
      //   style: TextStyle(
      //       fontSize: 25, color: Colors.cyanAccent[800], letterSpacing: 0.5),
      // ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
            'Sign In',
            style: TextStyle(fontSize: 40, color: Colors.teal),
          )),
          Text(
            'Sign In With your E-mail and Password',
            textAlign: TextAlign.center,
          ),

          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: LoginTextField(
                    controller: userNameController,
                    hintText: 'Enter Your Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  // child: TextFormField(
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter your email';
                  //     } else if (!value.contains('@')) {
                  //       return 'Please enter a valid email';
                  //     }
                  //     return null;
                  //   },
                  //   controller: userNameController,
                  //   decoration: InputDecoration(
                  //     hintText: 'Enter Your Email',
                  //     hintStyle: ThemeTextStyle.loginHiddenTextFieldStyle,
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10)),
                  //   ),
                  // ),
                ),
                verticleSpace(10),
                SizedBox(
                  width: 300,
                  child: LoginTextField(
                    controller: passwordController,
                    hintText: 'Enter Your Password',
                    hasAsterisk: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // TextFormField(
                  //   controller: passwordController,
                  //   obscureText: true,
                  //   decoration: InputDecoration(
                  //     hintText: 'Enter Your Password',
                  //     hintStyle: ThemeTextStyle.loginHiddenTextFieldStyle,
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10)),
                  //   ),
                  // ),
                ),
              ],
            ),
          ),

          ElevatedButton(
              onPressed: () {
                setState(() {
                  showSpinner = true;
                });
                loginUser(context, _auth);
                setState(() {
                  showSpinner = false;
                });
              },
              child: const Text("Sign In")),
          InkWell(
            splashColor: Colors.indigoAccent,
            onTap: () => navigateToRegister(context),
            // onTap: () {
            //   // print("daymn");
            //   Navigator.pushReplacementNamed(context, '/register');
            // },
            child: Column(
              children: [
                Text(
                  "Click here if you don't have an account",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
          // Container(
          //   height: 200,
          //   width: 200,
          //   // padding: const EdgeInsets.all(50),
          //   decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: AssetImage('assets/images/EMAlogo.png')),
          //       color: Colors.grey.shade50,
          //       borderRadius: BorderRadius.circular(10)),
          // )
        ],
      )),
    );
  }
}
