import 'package:flutter/material.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';
import 'package:pa/widgets/toast_widget.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              'assets/images/Ellipse 6.png',
              height: 45,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Owner',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      TextWidget(
                        text: 'Status',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              for (int i = 1; i < 20; i++)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      TextWidget(
                        text: '$i.',
                        fontSize: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const CircleAvatar(
                        maxRadius: 25,
                        minRadius: 25,
                      ),
                      const Expanded(
                        child: SizedBox(
                          width: 10,
                        ),
                      ),
                      ButtonWidget(
                        color: Colors.green,
                        radius: 100,
                        height: 35,
                        width: 50,
                        fontSize: 12,
                        label: 'Approved',
                        onPressed: () {},
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ButtonWidget(
                        color: Colors.red,
                        radius: 100,
                        height: 35,
                        width: 50,
                        fontSize: 12,
                        label: 'Taken',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
