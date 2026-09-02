import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/AuthWrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: MyApp.web,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAsTL0FlMJQWez_sb-x2zO_77wc7LWpw9Y',
    appId: '1:152199450594:web:10043ae9581a0dd6e933bb',
    messagingSenderId: '152199450594',
    projectId: 'todo-22364',
    authDomain: 'todo-22364.firebaseapp.com',
    storageBucket: 'todo-22364.firebasestorage.app',
    measurementId: 'G-02MK1GJF9X',
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Authwrapper(),
      ),
    );
  }
}