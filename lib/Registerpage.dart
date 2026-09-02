import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/Homepage.dart';
import 'package:todo/Loginpage.dart';


class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  Future<void> registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
      try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    emailController.clear();
    passwordController.clear();

    print("User registered successfully: ${userCredential.user?.email}");
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
  } on FirebaseAuthException catch (e) {
    print("Registration failed: ${e.code}");
  } catch (e) {
    print("Error: $e");
  }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration:  InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              autocorrect: false,
            ),
             SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration:InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              autocorrect: false,
            ),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Loginpage()),
                );
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        )
      ),
    );
  }
}