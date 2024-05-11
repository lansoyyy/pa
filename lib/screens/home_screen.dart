import 'package:flutter/material.dart';
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
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
