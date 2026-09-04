import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/Registerpage.dart';
import 'package:todo/homepage.dart';

class Loginpage extends StatefulWidget {

  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isDarkMode = false;
  // ================= LOGIN LOGIC =================
  // Firebase authentication logic kept unchanged.
  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      print("Please enter email and password");
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print("Login successful");
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("Login failed: ${e.message}");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ================= TEXT FIELD =================

  InputDecoration inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,

      filled: true,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode
          ? ThemeData(
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.deepPurple,
              useMaterial3: true,
            )
          : ThemeData(
              brightness: Brightness.light,
              colorSchemeSeed: Colors.deepPurple,
              useMaterial3: true,
            ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 430,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ================= TOP BAR =================
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            // TaskNova Logo
                            Container(
                              height: 58,
                              width: 58,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            // Theme Button
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: IconButton(
                                tooltip: isDarkMode
                                    ? "Light mode"
                                    : "Dark mode",
                                onPressed: () {
                                  setState(() {
                                    isDarkMode = !isDarkMode;
                                  });
                                },
                                icon: Icon(
                                  isDarkMode
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_rounded,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 42),
                        // ================= WELCOME =================
                        Text(
                          "Welcome back 👋",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Login to continue managing your tasks\nwith TaskNova.",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                        ),
                        const SizedBox(height: 35),
                        // ================= LOGIN CARD =================
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Login",
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 22),
                                // ================= EMAIL =================
                                TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  decoration: inputDecoration(
                                    label: "Email",
                                    hint: "Enter your email",
                                    icon: Icons.email_outlined,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                // ================= PASSWORD =================
                                TextField(
                                  controller: passwordController,
                                  obscureText: !isPasswordVisible,
                                  autocorrect: false,
                                  decoration: inputDecoration(
                                    label: "Password",
                                    hint: "Enter your password",
                                    icon: Icons.lock_outline_rounded,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible = !isPasswordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons
                                                .visibility_rounded
                                            : Icons
                                                .visibility_off_rounded,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // ================= LOGIN BUTTON =================
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: loginUser,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:  FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward_rounded,),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        // ================= REGISTER =================
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,MaterialPageRoute(builder: (context) =>const Registerpage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        // ================= FOOTER =================
                        Center(
                          child: Text(
                            "Stay organized. Stay productive. 🚀",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}