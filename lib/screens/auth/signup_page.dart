import 'package:flutter/material.dart';
import 'package:pa/screens/home_screen.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';

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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
