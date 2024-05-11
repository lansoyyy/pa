import 'package:flutter/material.dart';
import 'package:pa/services/add_pet.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';
import 'package:pa/widgets/toast_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class UploadPetPage extends StatefulWidget {
  const UploadPetPage({super.key});

  @override
  State<UploadPetPage> createState() => _UploadPetPageState();
}

class _UploadPetPageState extends State<UploadPetPage> {
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
            .ref('Pets/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Pets/$fileName')
            .getDownloadURL();

        setState(() {});

        Navigator.of(context).pop();
        showToast('Image uploaded!');
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

  final name = TextEditingController();
  final desc = TextEditingController();
  final age = TextEditingController();
  final sex = TextEditingController();
  final status = TextEditingController();
  final location = TextEditingController();
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
        title: TextWidget(
          text: 'Upload a Pet',
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Bold',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imageURL == ''
                    ? Container(
                        width: 300,
                        height: 175,
                        color: Colors.grey,
                      )
                    : Container(
                        width: 300,
                        height: 175,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              imageURL,
                            ),
                          ),
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    uploadPicture('gallery');
                  },
                  child: TextWidget(
                    text: 'Upload image',
                    fontSize: 14,
                    fontFamily: 'Bold',
                  ),
                ),
                TextFieldWidget(
                  width: 320,
                  controller: name,
                  label: 'Owner name',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFieldWidget(
                      width: 150,
                      inputType: TextInputType.number,
                      controller: age,
                      label: 'Age',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextFieldWidget(
                      width: 150,
                      controller: sex,
                      label: 'Sex',
                    ),
                  ],
                ),
                TextFieldWidget(
                  width: 320,
                  controller: status,
                  label: 'Status',
                ),
                TextFieldWidget(
                  width: 320,
                  controller: location,
                  label: 'Location',
                ),
                TextFieldWidget(
                  width: 320,
                  maxLine: 5,
                  height: 135,
                  controller: desc,
                  label: 'Description',
                ),
                ButtonWidget(
                  label: 'Upload',
                  onPressed: () {
                    addPet(imageURL, name.text, age.text, sex.text, status.text,
                        desc.text, location.text);
                    showToast('Pet uploaded');
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
