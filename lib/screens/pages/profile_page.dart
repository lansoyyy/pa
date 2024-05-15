import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pa/widgets/toast_widget.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final name = TextEditingController();
  final address = TextEditingController();
  final number = TextEditingController();
  final bday = TextEditingController();
  final email = TextEditingController();

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
      body: StreamBuilder<DocumentSnapshot>(
          stream: userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            dynamic data = snapshot.data;

            name.text = data['name'];
            email.text = data['email'];
            number.text = data['number'];
            address.text = data['address'];
            bday.text = data['bday'];
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      maxRadius: 50,
                      minRadius: 50,
                      backgroundImage: NetworkImage(data['img']),
                    ),
                    TextButton(
                      onPressed: () {
                        uploadPicture('gallery');
                      },
                      child: TextWidget(
                        text: 'Change Profile',
                        fontSize: 14,
                        fontFamily: 'Bold',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextWidget(
                      text: name.text,
                      fontSize: 18,
                      fontFamily: 'Bold',
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: email.text,
                      fontSize: 12,
                      fontFamily: 'M,edium',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      width: 325,
                      controller: name,
                      label: 'Fullname',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFieldWidget(
                          inputType: TextInputType.number,
                          width: 150,
                          controller: number,
                          label: 'Contact Number',
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextFieldWidget(
                          width: 150,
                          controller: bday,
                          label: 'Birthday',
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      width: 325,
                      controller: address,
                      label: 'Address',
                    ),
                    TextFieldWidget(
                      isEnabled: false,
                      width: 325,
                      controller: email,
                      label: 'Email',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      width: 200,
                      label: 'Save',
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(data.id)
                            .update({
                          'name': name.text,
                          'address': address.text,
                          'number': number.text,
                          'bday': bday.text,
                        });
                        showToast('Changes saved!');
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
