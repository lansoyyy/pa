import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addPet(img, name, age, sex, status, desc, location) async {
  final docUser = FirebaseFirestore.instance.collection('Pets').doc();

  final json = {
    'img': img,
    'name': name,
    'age': age,
    'sex': sex,
    'status': status,
    'desc': desc,
    'type': 'Pending',
    'id': docUser.id,
    'location': location,
  };

  await docUser.set(json);
}