import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Pets')
              .where('type', isEqualTo: 'Inquired')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
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
                    for (int i = 0; i < data.docs.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        child: Row(
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
                              width: 100,
                              child: TextWidget(
                                  text: data.docs[i]['name'], fontSize: 12),
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
                              onPressed: () async {
                                showToast('Success!');
                                await FirebaseFirestore.instance
                                    .collection('Pets')
                                    .doc(data.docs[i].id)
                                    .update({'type': 'Approved'});
                              },
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ButtonWidget(
                              color: Colors.red,
                              radius: 100,
                              height: 35,
                              width: 50,
                              fontSize: 12,
                              label: 'Declined',
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('Pets')
                                    .doc(data.docs[i].id)
                                    .update({'type': 'Declined'});
                              },
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
