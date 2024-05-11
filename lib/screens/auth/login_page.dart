import 'package:flutter/material.dart';
import 'package:pa/screens/auth/signup_page.dart';
import 'package:pa/screens/home_screen.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            TextFieldWidget(
              controller: email,
              label: 'Email',
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                TextFieldWidget(
                  showEye: true,
                  isObscure: true,
                  controller: password,
                  label: 'Password',
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {},
                      child: TextWidget(
                        text: 'Forgot Password?',
                        fontFamily: 'Bold',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ButtonWidget(
              width: 200,
              label: 'Login',
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignupPage()));
              },
              child: TextWidget(
                text: 'Signup',
                fontFamily: 'Bold',
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}