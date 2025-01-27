import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:next_buy/app/modules/home/controllers/home_controller.dart';
import 'package:next_buy/Screens/home.dart';

import '../app/routes/app_routes.dart';
import 'forget.dart';
import 'signup_screen.dart';

class LabeledDivider extends StatelessWidget {
  final String text;
  final double indent;
  final double endIndent;
  final TextStyle? textStyle;

  const LabeledDivider({
    super.key,
    required this.text,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(indent: indent, endIndent: 5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(text, style: textStyle),
        ),
        Expanded(
          child: Divider(indent: 5, endIndent: endIndent),
        ),
      ],
    );
  }
}

class LoginScreen extends StatefulWidget {
  final HomeController? homeController;
  const LoginScreen({
    super.key,
    required this.homeController,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;
  bool isLoading = false;
  bool isLoginTrue = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? errorMessage;

  void loginUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        isLoginTrue = false;
      });

      try {
        User? user =
            await widget.homeController!.authService.signInWithEmailPassword(
          emailController.text,
          passwordController.text,
        );

        if (user != null) {
          Get.offAll(() => Home(homeController: widget.homeController));
          Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoginTrue = true;
        });

        String message = "An unexpected error occurred. Please try again.";
        switch (e.code) {
          case 'user-not-found':
            message = "No account found with that email. Please register.";
            break;
          case 'wrong-password':
            message = "Incorrect password. Click 'Forgot Password' to reset.";
            break;
          case 'too-many-requests':
            message = "Too many requests. Please try again later.";
            break;
          default:
            message = "Error: ${e.message}";
        }

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        setState(() {
          isLoginTrue = true;
        });
        Fluttertoast.showToast(
          msg: "A network issue occurred. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          Fluttertoast.showToast(msg: 'Sign in successful: ${user.email}');
          Get.offAll(() => Home(homeController: widget.homeController));
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to sign in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(Routes.home);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset("assets/images/playstore.png", width: 50),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      textFormFieldWidget(
                          emailController, "Email", Icons.email),
                      const SizedBox(height: 3),
                      passwordFormField(),
                      const SizedBox(height: 3),
                      loginButton(context),

                      // Forgot password text under the login button
                      TextButton(
                        onPressed: () {
                          Get.offAll(() => ForgotPassword(
                              homeController: Get.find<HomeController>()));
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      const LabeledDivider(
                        text: "or continue with",
                        endIndent: 18,
                        indent: 18,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Google sign-in button now placed under the divider
                      Align(
                        alignment: Alignment.topLeft,
                        child: buildSocialButton(
                          onTap: signInWithGoogle,
                          buttonType: ButtonType.google,
                          iconColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),

                      signUpOption(context),
                      const SizedBox(height: 20),
                      if (isLoading) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSocialButton({
    required void Function() onTap,
    required ButtonType buttonType,
    Color? iconColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),

          padding: const EdgeInsets.symmetric(vertical: 9), // Reduced height
        ),
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/images/google.png',
              height: 24.0,
            ),
            const SizedBox(width: 10),
            const Text(
              'Sign in with Google',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget signUpOption(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 18, color: Colors.black),
                children: <TextSpan>[
                  const TextSpan(text: "New Customer?"),
                  TextSpan(
                    text: ' Create account',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 114, 9, 9),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline, // Underline text
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(() => const SignUp());
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isLoginTrue)
          const Text(
            'User name and Password is Incorrect',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget textFormFieldWidget(
      TextEditingController controller, String hintText, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple.withOpacity(0.2),
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "$hintText is required";
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget passwordFormField() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple.withOpacity(0.2),
      ),
      child: TextFormField(
        controller: passwordController,
        obscureText: !isVisible,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password is required";
          } else if (value.length < 6) {
            return "Password must be at least 6 characters";
          }
          return null;
        },
        decoration: InputDecoration(
          icon: const Icon(Icons.lock),
          border: InputBorder.none,
          hintText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: isVisible ? Colors.deepPurple : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          loginUser();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
