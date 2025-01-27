import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:next_buy/Auth/signup_screen.dart';
import 'package:next_buy/app/modules/home/controllers/home_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, required HomeController homeController});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: mailController.text);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Password Reset Email has been sent!",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      } on FirebaseAuthException catch (e) {
        var errorMessage = "An error occurred while sending the reset email.";
        if (e.code == "user-not-found") {
          errorMessage = "No user found for that email.";
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 20.0),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Password Recovery!",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: mailController,
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                        hintStyle:
                            TextStyle(fontSize: 18.0, color: Colors.black45),
                        prefixIcon: Icon(Icons.email,
                            color: Colors.black87, size: 30.0),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    GestureDetector(
                      onTap: resetPassword,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 18),
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(86, 107, 115, 1.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Send Email",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                        const SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text("Create",
                              style: TextStyle(
                                  color: Color.fromARGB(224, 65, 0, 5),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
