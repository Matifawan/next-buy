import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:next_buy/Auth/loginscreen.dart';
import 'package:next_buy/app/modules/home/controllers/home_controller.dart';
import 'package:next_buy/Screens/home.dart';
import 'services.dart';

class SignUp extends StatefulWidget {
  final HomeController? controller;

  const SignUp({super.key, this.controller});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fullnameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isLoading = false;

  final AuthService authService = AuthService();

  void signupUser() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await authService.signUpWithEmailPassword(
          emailController.text,
          passwordController.text,
        );

        if (mounted) {
          Get.offAll(() => Home(
              homeController: widget.controller ?? Get.find<HomeController>()));
        }
        Fluttertoast.showToast(
          msg: "Registered Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } on FirebaseAuthException catch (e) {
        String message = "An unexpected error occurred. Please try again.";
        if (e.code == 'weak-password') {
          message = "The password provided is too weak.";
        } else if (e.code == 'email-already-in-use') {
          message = "The account already exists for that email.";
        } else {
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
        Fluttertoast.showToast(
          msg: "A Network Issue. Please try again.",
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          Fluttertoast.showToast(msg: 'Sign in successful: ${user.email}');
          Get.offAll(() => Home(
              homeController: widget.controller ?? Get.find<HomeController>()));
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to sign in with Google: $e');
    }
  }

  Widget _buildTextFormField(
      TextEditingController controller, String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordFormField(
      TextEditingController controller, String hintText, IconData icon) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: !isVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        } else if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : signupUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(86, 107, 115, 1.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Text(
                'Sign Up',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildLoginOption() {
    return TextButton(
      onPressed: () {
        Get.offAll(
            () => LoginScreen(homeController: Get.find<HomeController>()));
      },
      child: const Text('Already have an account? Log In',
          style: TextStyle(fontSize: 18.0, color: Colors.black)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AbsorbPointer(
            absorbing: isLoading,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child:
                          Image.asset("assets/images/playstore.png", width: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ListTile(
                            title: Text(
                              "Register New Customer?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildTextFormField(
                              fullnameController, "Full Name", Icons.person),
                          const SizedBox(height: 10),
                          _buildTextFormField(
                              emailController, "Email", Icons.email),
                          const SizedBox(height: 10),
                          _buildPasswordFormField(
                              passwordController, "Password", Icons.lock),
                          const SizedBox(height: 10),
                          _buildConfirmPasswordFormField(),
                          const SizedBox(height: 20),
                          _buildSignUpButton(),
                          const SizedBox(height: 20),
                          const Text("or continue with"),
                          const SizedBox(height: 10),
                          buildSocialButton(
                            onTap: signInWithGoogle,
                            buttonType: ButtonType.google,
                            iconColor: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          _buildLoginOption(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
