import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa/screens/auth/login_page.dart';
import 'package:pa/screens/pages/inquiry_page.dart';
import 'package:pa/screens/pages/profile_page.dart';
import 'package:pa/screens/pages/status_page.dart';
import 'package:pa/screens/pages/upload_pet_page.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pa/widgets/toast_widget.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Users/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Users/$fileName')
            .getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'img': imageURL});

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: PopupMenuButton(
            icon: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset(
                'assets/images/Ellipse 6.png',
              ),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () {
                      uploadPicture('gallery');
                    },
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: userData,
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Loading'));
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          dynamic data = snapshot.data;
                          return Column(
                            children: [
                              CircleAvatar(
                                minRadius: 50,
                                maxRadius: 50,
                                backgroundImage: NetworkImage(data['img']),
                              ),
                              TextWidget(
                                text: 'Profile',
                                fontSize: 18,
                                fontFamily: 'Bold',
                              ),
                              const Divider(),
                            ],
                          );
                        })),
                PopupMenuItem(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UploadPetPage()));
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
                // PopupMenuItem(
                //   onTap: () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => const ProfilePage()));
                //   },
                //   child: TextWidget(
                //     text: 'Profile',
                //     fontSize: 16,
                //   ),
                // ),
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
          )),
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
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Pets')
                    .where('type', isEqualTo: 'Pending')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  return Expanded(
                    child: GridView.builder(
                      itemCount: data.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 225,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                data.docs[index]['img'],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 75,
                                          width: 175,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  text:
                                                      'Owner: ${data.docs[index]['name']}',
                                                  fontSize: 14,
                                                ),
                                                TextWidget(
                                                  text:
                                                      'Location: ${data.docs[index]['location']}',
                                                  fontSize: 12,
                                                ),
                                                TextWidget(
                                                  align: TextAlign.start,
                                                  maxLines: 2,
                                                  text:
                                                      '${data.docs[index]['desc']}',
                                                  fontSize: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: data.docs[index]['uid'] !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? [
                                            MaterialButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('Pets')
                                                    .doc(data.docs[index].id)
                                                    .update(
                                                        {'type': 'Inquired'});
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Inquire',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ]
                                        : [
                                            MaterialButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('Pets')
                                                    .doc(data.docs[index].id)
                                                    .delete();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UploadPetPage(
                                                              inEdit: true,
                                                              data: {
                                                                'name': data.docs[
                                                                        index]
                                                                    ['name'],
                                                                'desc': data.docs[
                                                                        index]
                                                                    ['desc'],
                                                                'age': data.docs[
                                                                        index]
                                                                    ['age'],
                                                                'sex': data.docs[
                                                                        index]
                                                                    ['sex'],
                                                                'status': data
                                                                            .docs[
                                                                        index]
                                                                    ['status'],
                                                                'location': data
                                                                            .docs[
                                                                        index][
                                                                    'location'],
                                                                'number': data
                                                                            .docs[
                                                                        index]
                                                                    ['number'],
                                                                'img': data.docs[
                                                                        index]
                                                                    ['img'],
                                                                'id': data
                                                                    .docs[index]
                                                                    .id
                                                              },
                                                            )));
                                              },
                                              child: const Text(
                                                'Edit',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ]);
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 125,
                                width: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      data.docs[index]['img'],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 75,
                                width: 200,
                                color: Colors.blue[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text:
                                            'Owner: ${data.docs[index]['name']}',
                                        fontSize: 13,
                                      ),
                                      TextWidget(
                                        text:
                                            'Location: ${data.docs[index]['location']}',
                                        fontSize: 11,
                                      ),
                                      TextWidget(
                                        align: TextAlign.start,
                                        maxLines: 2,
                                        text: '${data.docs[index]['desc']}',
                                        fontSize: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
