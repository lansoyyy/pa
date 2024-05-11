import 'package:flutter/material.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';
import 'package:pa/widgets/toast_widget.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      left: 25, right: 25, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: '$i.',
                        fontSize: 18,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const CircleAvatar(
                        maxRadius: 25,
                        minRadius: 25,
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      ButtonWidget(
                        color: Colors.green,
                        radius: 100,
                        height: 45,
                        width: 100,
                        fontSize: 12,
                        label: 'Approved',
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
