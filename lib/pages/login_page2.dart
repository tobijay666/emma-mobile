import 'package:emma01/routes/routes.dart';
import 'package:emma01/utils/brandcolor.dart';
import 'package:emma01/utils/spaces.dart';
import 'package:emma01/utils/underline_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage2 extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage2> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isDarkMode = false;
  final _formKey = GlobalKey<FormState>();
  var errorText;

  navigateToRegister2(context) {
    Navigator.of(context).pushReplacementNamed(Routes.register2);
  }

  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Login successful, navigate to home page or wherever you want to go
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login successful!',
            style: TextStyle(
              color: BrandColor.backgroundLight,
            ),
          ),
          backgroundColor: BrandColor.greyBackground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: BrandColor.backgroundLight),
          ),
        ),
      );
      try {
        Navigator.of(context).pushNamed(Routes.chat);
      } catch (e) {
        // Handle the error
        print("login error: $e");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Handle user not found error
        errorText = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorText = 'Wrong password provided for that user.';
      }
      // Handle incorrect password error
      if (errorText != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorText,
              style: TextStyle(
                color: BrandColor.errorRed,
              ),
            ),
            backgroundColor: BrandColor.greyBackground,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: BrandColor.errorRed),
            ),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColor.greenLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80),
            Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: BrandColor.backgroundLight,
              ),
            ),
            verticleSpace(40),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: BrandColor.backgroundLight),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: BrandColor.backgroundLight),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: BrandColor.backgroundLight),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: BrandColor.backgroundLight),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    obscureText: _obscureText,
                    style: TextStyle(color: BrandColor.backgroundLight),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: BrandColor.backgroundLight),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: BrandColor.backgroundLight),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: BrandColor.backgroundLight),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: BrandColor.backgroundLight,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  Text(
                    _formKey.currentState?.validate() == false
                        ? 'Please correct the errors above'
                        : '',
                    style: TextStyle(color: Colors.red),
                  ),
                  verticleSpace(60),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => login(context),
                      style: ElevatedButton.styleFrom(
                        primary: BrandColor.backgroundLight,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: BrandColor.greenLight,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: BrandColor.backgroundLight,
                      ),
                    ),
                  ),
                  verticleSpace(40),
                  InkWell(
                    onTap: () => navigateToRegister2(context),
                    child: DecoratedBox(
                      decoration: UnderlineDecoration(
                        decorationColor: BrandColor.backgroundLight,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                      child: Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          color: BrandColor.backgroundLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
