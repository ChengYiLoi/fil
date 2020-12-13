import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference userDailyIntakesCollection =
      FirebaseFirestore.instance.collection("dailyIntakes");

  Future<dynamic> queryUserData(String uid) async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    if (doc.exists) {
      print("document exist");
      Map obj = doc.data();
      obj['dailyIntakes'] = await getIntakeHistory(uid);
      return obj;
    }
    print("document does not exist");
    return "";
  }

  // create user data in the firestore db
  Future createUserData(String uid, String email, creationTime) async {
    return await userCollection.doc(uid).set({
      "uid": uid,
      "email": email,
      "creationTime": creationTime,
      "dailyGoal": 0,
      "dailyIntake": 0
    });
  }

  // get the user daily intake history
  Future getIntakeHistory(String uid) async {
    Map<String, dynamic> createDummy(int value, String type) {
      DateTime current = new DateTime.now();
      String dateTime = type == "s"
          ? current.subtract(new Duration(days: value)).toIso8601String()
          : current.add(new Duration(days: value)).toIso8601String();
      return {"amount": "0", "dateTime": dateTime, "uid": uid};
    }

    QuerySnapshot query =
        await userDailyIntakesCollection.where("uid", isEqualTo: uid).get();
    List<Map<String, dynamic>> list =
        query.docs.map((QueryDocumentSnapshot doc) {
      return doc.data();
    }).toList();
    if (list.length < 3) {
      list.insert(0, createDummy(2, "s"));
      list.insert(1, createDummy(1, "s"));
    }
    list.add(createDummy(1, "a"));
    list.add(createDummy(2, "a"));
    print(list);
    return list;
  }

  // Query if the user already exist in the db via uid
  Future queryUser(String uid) async {
    return await userCollection
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print("user exist");
        return true;
      }
      print("user does not exist");
      return false;
    });
  }

  Future queryUserEmail(String email) async {
    dynamic query = userCollection.where("email", isEqualTo: email);
    if (query != null) {
      return true;
    }
    return false;
  }
}
