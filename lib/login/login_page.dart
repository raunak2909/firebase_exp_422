import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_exp_422/home_page.dart';
import 'package:firebase_exp_422/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();

  var passController = TextEditingController();

  bool isPasswordVisible = false;

  bool isLoading = false;

  bool isLogin = true;

  FirebaseAuth? fireAuth;

  GlobalKey<FormState> mKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fireAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: mKey,
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' Hi, Welcome back', style: TextStyle(fontSize: 34)),
              SizedBox(height: 21),
              TextFormField(
                validator: (value) {
                  final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value ?? "");

                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  } else if (!emailValid) {
                    return "Please enter a valid email";
                  } else {
                    return null;
                  }
                },
                controller: emailController,
                decoration: myFieldDecoration(
                  hint: "Enter your email here..",
                  label: "Email",
                ),
              ),
              SizedBox(height: 11),
              StatefulBuilder(
                builder: (context, ss) {
                  return TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else {
                        return null;
                      }
                    },
                    controller: passController,
                    obscureText: !isPasswordVisible,
                    decoration: myFieldDecoration(
                      hint: "Enter your password here..",
                      label: "Password",
                      isPassword: true,
                      isPasswordVisible: isPasswordVisible,
                      onPasswordVisibilityTap: () {
                        isPasswordVisible = !isPasswordVisible;
                        ss(() {});
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 21),
              ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCred = await fireAuth!
                        .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passController.text,
                        );

                    if (userCred.user != null) {
                      print(
                        "User Logged-in Successfully with ID: ${userCred.user!.uid}",
                      );
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("userId", userCred.user!.uid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User Logged-in Successfully!!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: Unable to login User.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: Invalid credentials..'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(height: 11),
              Center(
                child: InkWell(
                  onTap: () {
                    isLogin = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Create now..",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
