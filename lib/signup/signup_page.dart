import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui_helper.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var emailController = TextEditingController();

  var nameController = TextEditingController();

  var mobNoController = TextEditingController();

  var passController = TextEditingController();

  var confirmPassController = TextEditingController();

  bool isPasswordVisible = false;

  bool isConfirmPasswordVisible = false;

  bool isCreatingAccount = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FirebaseAuth? fireAuth;

  FirebaseFirestore? firebaseFirestore;
  CollectionReference? userRef;

  @override
  void initState() {
    super.initState();
    fireAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
    userRef = firebaseFirestore!.collection("users");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' Create Account', style: TextStyle(fontSize: 34)),
              SizedBox(height: 21),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                controller: nameController,
                decoration: myFieldDecoration(
                  hint: "Enter your name here..",
                  label: "Name",
                ),
              ),
              SizedBox(height: 11),
              TextFormField(
                onChanged: (value) {},
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
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mobile no";
                  }
                  if (value.length != 10) {
                    return "Please enter a valid mobile no";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: mobNoController,
                decoration: myFieldDecoration(
                  hint: "Enter your mobile no here..",
                  label: "Mobile No",
                ),
              ),
              SizedBox(height: 11),
              StatefulBuilder(
                builder: (context, ss) {
                  return TextFormField(
                    validator: (value) {
                      final bool passValid = RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                      ).hasMatch(value ?? "");

                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (!passValid) {
                        return "Please enter a valid password";
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Password must contain at least one uppercase letter, at least one lowercase letter, at least one digit, at least one special character (@\$!%*?&), minimum 8 characters in length.",
                ),
              ),
              SizedBox(height: 11),
              StatefulBuilder(
                builder: (context, ss) {
                  return TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please retype your password";
                      } else if (passController.text != value) {
                        return "Password does not match";
                      } else {
                        return null;
                      }
                    },
                    controller: confirmPassController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: myFieldDecoration(
                      hint: "Retype your password here..",
                      label: "Confirm Password",
                      isPassword: true,
                      isPasswordVisible: isConfirmPasswordVisible,
                      onPasswordVisibilityTap: () {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        ss(() {});
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 21),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if(formKey.currentState!.validate()){
                      try {
                        UserCredential userCred = await fireAuth!
                            .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passController.text,
                        );

                        if (userCred.user != null) {
                          Navigator.pop(context);
                          print(
                            "User Created Successfully with ID: ${userCred.user!.uid}",
                          );

                          DocumentReference newUser = userRef!.doc(
                            userCred.user!.uid,
                          );

                          newUser.set({
                            "name": nameController.text,
                            "email": emailController.text,
                            "mobile": mobNoController.text,
                            "created_at": DateTime.now().millisecondsSinceEpoch
                                .toString(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User Created Successfully!!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: Unable to create User.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: your password is weak.'),
                            ),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.code}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                      catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ),
              SizedBox(height: 11),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Login now..",
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
