import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {




  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future createUserData(String uid, String email) async {
    return await userCollection.doc(uid).set({
      "uid" : uid,
      "email" : email
    });

  }
}
