import 'package:flutter/material.dart';
import 'package:pa/screens/auth/login_page.dart';
import 'package:pa/screens/pages/inquiry_page.dart';
import 'package:pa/screens/pages/status_page.dart';
import 'package:pa/screens/pages/upload_pet_page.dart';
import 'package:pa/widgets/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            'assets/images/Ellipse 6.png',
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UploadPetPage()));
                  },
                  child: TextWidget(
                    text: 'Upload pet',
                    fontSize: 16,
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const InquiryPage()));
                  },
                  child: TextWidget(
                    text: 'Inquiries',
                    fontSize: 16,
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const StatusPage()));
                  },
                  child: TextWidget(
                    text: 'Status',
                    fontSize: 16,
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(
                                'Logout Confirmation',
                                style: TextStyle(
                                    fontFamily: 'QBold',
                                    fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Are you sure you want to Logout?',
                                style: TextStyle(fontFamily: 'QRegular'),
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(
                                        fontFamily: 'QRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  },
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                        fontFamily: 'QRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ));
                  },
                  child: TextWidget(
                    text: 'Logout',
                    fontSize: 16,
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: 'Welcome to PET PAL',
              fontSize: 18,
              fontFamily: 'Bold',
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 100,
                        width: 175,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 75,
                        width: 175,
                        color: Colors.blue[200],
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'Owner: Jane Villarico',
                                fontSize: 13,
                              ),
                              TextWidget(
                                text: 'Location: Barangay 3 Magsaysay street',
                                fontSize: 11,
                              ),
                              TextWidget(
                                align: TextAlign.start,
                                maxLines: 2,
                                text:
                                    'I have to leave my apartment my cats left so looking for cat lovers.',
                                fontSize: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
