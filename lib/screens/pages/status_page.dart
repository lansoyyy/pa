import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Pets').where('type',
              whereIn: ['Approved', 'Taken', 'Declined']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              );
            }

            final data = snapshot.requireData;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    for (int i = 0; i < data.docs.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: '${i + 1}.',
                              fontSize: 18,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              maxRadius: 25,
                              minRadius: 25,
                              backgroundImage:
                                  NetworkImage(data.docs[i]['img']),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 125,
                              child: TextWidget(
                                text: data.docs[i]['name'],
                                fontSize: 14,
                                align: TextAlign.start,
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(
                                width: 10,
                              ),
                            ),
                            TextWidget(
                              color: data.docs[i]['type'] == 'Declined' ||
                                      data.docs[i]['type'] == 'Taken'
                                  ? Colors.red
                                  : Colors.green,
                              text: data.docs[i]['type'] == 'Taken'
                                  ? 'Pet already taken'
                                  : data.docs[i]['type'],
                              fontSize: 14,
                              fontFamily: 'Bold',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
