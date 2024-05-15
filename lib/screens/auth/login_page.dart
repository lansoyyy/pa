import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa/screens/auth/signup_page.dart';
import 'package:pa/screens/home_screen.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';
import 'package:pa/widgets/toast_widget.dart';

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
        child: SingleChildScrollView(
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: ((context) {
                              final formKey = GlobalKey<FormState>();
                              final TextEditingController emailController =
                                  TextEditingController();

                              return AlertDialog(
                                title: TextWidget(
                                  text: 'Forgot Password',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFieldWidget(
                                        hint: 'Email',
                                        textCapitalization:
                                            TextCapitalization.none,
                                        inputType: TextInputType.emailAddress,
                                        label: 'Email',
                                        controller: emailController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an email address';
                                          }
                                          final emailRegex = RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                          if (!emailRegex.hasMatch(value)) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: (() {
                                      Navigator.pop(context);
                                    }),
                                    child: TextWidget(
                                      text: 'Cancel',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: (() async {
                                      if (formKey.currentState!.validate()) {
                                        try {
                                          Navigator.pop(context);
                                          await FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: emailController.text);
                                          showToast(
                                              'Password reset link sent to ${emailController.text}');
                                        } catch (e) {
                                          String errorMessage = '';

                                          if (e is FirebaseException) {
                                            switch (e.code) {
                                              case 'invalid-email':
                                                errorMessage =
                                                    'The email address is invalid.';
                                                break;
                                              case 'user-not-found':
                                                errorMessage =
                                                    'The user associated with the email address is not found.';
                                                break;
                                              default:
                                                errorMessage =
                                                    'An error occurred while resetting the password.';
                                            }
                                          } else {
                                            errorMessage =
                                                'An error occurred while resetting the password.';
                                          }

                                          showToast(errorMessage);
                                          Navigator.pop(context);
                                        }
                                      }
                                    }),
                                    child: TextWidget(
                                      text: 'Continue',
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          );
                        },
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
                  login(context);
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
      ),
    );
  }

  login(context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
      showToast('Success!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast("No user found with that email.");
      } else if (e.code == 'wrong-password') {
        showToast("Wrong password provided for that user.");
      } else if (e.code == 'invalid-email') {
        showToast("Invalid email provided.");
      } else if (e.code == 'user-disabled') {
        showToast("User account has been disabled.");
      } else {
        showToast("An error occurred: ${e.message}");
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
