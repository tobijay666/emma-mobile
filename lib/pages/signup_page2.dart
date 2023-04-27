import 'package:emma01/routes/routes.dart';
import 'package:emma01/utils/brandcolor.dart';
import 'package:emma01/utils/spaces.dart';
import 'package:emma01/utils/underline_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool _confirmObscureText = true;
  bool _isDarkMode = false;
  final _formKey = GlobalKey<FormState>();
  var errorText;

  navigateToLogin2(context) {
    Navigator.of(context).pushReplacementNamed(Routes.login2);
  }

  confirmPassword(context) {
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String? errorText;

    if (password != confirmPassword) {
      errorText = 'Passwords do not match';
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
    } else {
      _signUp(context);
    }
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('User signed up with UID: ${userCredential.user!.uid}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'New User Signed Up!',
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
      // Navigate to a new page or show a success message.
      Navigator.of(context).pushReplacementNamed(Routes.login2);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorText = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorText = 'The account already exists for that email.';
      }
      // Show an error message.
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
      print(e);
      // Show an error message.
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
              'Create an account',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
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
                  ),
                  verticleSpace(20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    obscureText: _obscureText,
                    style: TextStyle(color: BrandColor.backgroundLight),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
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
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _confirmPasswordController,
                    obscureText: _confirmObscureText,
                    style: TextStyle(color: BrandColor.backgroundLight),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                          _confirmObscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: BrandColor.backgroundLight,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmObscureText = !_confirmObscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
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
                      onPressed: () => confirmPassword(context),
                      style: ElevatedButton.styleFrom(
                        primary: BrandColor.backgroundLight,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: BrandColor.greenLight,
                        ),
                      ),
                    ),
                  ),
                  verticleSpace(40),
                  InkWell(
                    onTap: () => navigateToLogin2(context),
                    child: DecoratedBox(
                      decoration: UnderlineDecoration(
                        decorationColor: BrandColor.backgroundLight,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                      child: Text(
                        'Already have an account? Log In',
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
