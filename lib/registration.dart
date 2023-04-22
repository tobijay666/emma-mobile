import 'package:emma01/utils/spaces.dart';
import 'package:emma01/widgets/login_textfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final _formKey = GlobalKey<FormState>();

void regUser(context, _auth) async {
  // setState(() {
  //   showSpinner = true;
  // });
  if (_formKey.currentState!.validate()) {
    print('Register');
    print(userNameController.text);
    print(passwordController.text);
    try {
      final User newUser = await _auth.createUserWithEmailAndPassword(
          email: userNameController.text, password: passwordController.text);
      if (newUser != null) {
        Navigator.pushReplacementNamed(context, '/chat');
      }
    } catch (e) {
      print(e);
    }
  } else {
    print('Invalid');
  }
}

final userNameController = TextEditingController();
final passwordController = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  // User loggedInUser = "";

  @override
  void initState() {
    super.initState();
    // getCurrentUser();
  }

  // void getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser;
  //     if (user != null) {
  //       print(user.email);
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
            'Sign Up',
            style: TextStyle(fontSize: 40, color: Colors.teal),
          )),
          Text(
            'Sign Up With your E-mail and Password',
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
                regUser(context, _auth);
              },
              child: const Text("Sign Up")),
          InkWell(
            splashColor: Colors.indigoAccent,
            onTap: () {
              print("daymn");
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Column(
              children: [
                Text(
                  "Click here if you already have an account",
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
