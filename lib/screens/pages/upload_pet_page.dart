import 'package:flutter/material.dart';
import 'package:pa/widgets/button_widget.dart';
import 'package:pa/widgets/text_widget.dart';
import 'package:pa/widgets/textfield_widget.dart';
import 'package:pa/widgets/toast_widget.dart';

class UploadPetPage extends StatefulWidget {
  const UploadPetPage({super.key});

  @override
  State<UploadPetPage> createState() => _UploadPetPageState();
}

class _UploadPetPageState extends State<UploadPetPage> {
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
                Container(
                  width: 300,
                  height: 175,
                  color: Colors.grey,
                ),
                TextButton(
                  onPressed: () {},
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
                  maxLine: 5,
                  height: 135,
                  controller: desc,
                  label: 'Description',
                ),
                ButtonWidget(
                  label: 'Upload',
                  onPressed: () {
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
