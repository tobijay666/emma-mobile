import 'package:emma01/utils/spaces.dart';
import 'package:emma01/utils/textfield_styles.dart';
import 'package:emma01/widgets/login_textfield.dart';
import 'package:flutter/material.dart';

import 'package:emma01/chat_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  void loginUser(context) {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/chat',
          arguments: '${userNameController.text}');

      print('Login');
      print(userNameController.text);
      print(passwordController.text);
    } else {
      print('Invalid');
    }
  }

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

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
              'Test 01 this is just to check the text width according to the UI',
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
                  loginUser(context);
                },
                child: const Text("Sign In")),
            InkWell(
              splashColor: Colors.indigoAccent,
              onTap: () {
                print("daymn");
              },
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
        )));
  }
}
