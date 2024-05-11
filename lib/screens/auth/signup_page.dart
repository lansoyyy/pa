import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa/screens/auth/login_page.dart';
import 'package:pa/screens/home_screen.dart';
import 'package:pa/services/signup.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';
import 'package:pa/widgets/toast_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Ellipse 6.png',
              height: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: 'PET PAL',
              fontSize: 32,
              fontFamily: 'Bold',
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: 'Create Account',
              fontSize: 18,
              fontFamily: 'Medium',
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              controller: email,
              label: 'Email',
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              showEye: true,
              isObscure: true,
              controller: password,
              label: 'Password',
            ),
            const SizedBox(
              height: 30,
            ),
            ButtonWidget(
              width: 200,
              label: 'Signup',
              onPressed: () {
                register(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  register(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      signup(email.text);
      showToast("Registered Successfully!");

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showToast('The email address is not valid.');
      } else {
        showToast(e.toString());
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
