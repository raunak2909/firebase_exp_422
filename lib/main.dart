import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_exp_422/firebase_options.dart';
import 'package:firebase_exp_422/login/login_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

///1. Setup Node.js
///2. npm install -g firebase-tools
///3. firebase login
///4. dart pub global activate flutterfire_cli
///5. set the pub-cache/bin path in env user variable
///6. flutterfire configure
///7. select the project you created to link in this app
///8. flutter pub add firebase_core
///9. add await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); before runApp
///10. make your main func async
///11. because we are making main func as async add  WidgetsFlutterBinding.ensureInitialized(); before anything.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
    );
  }
}

