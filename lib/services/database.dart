import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fil/models/user.dart';

class DatabaseService {
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference userDailyIntakesCollection =
      FirebaseFirestore.instance.collection("dailyIntakes");

  Stream<UserObj> queryUserData(String uid) {
    return userCollection.doc(uid).snapshots().map((snapshot) {
      return UserObj(
          snapshot.data()['creationTime'],
          snapshot.data()['dailyGoal'],
          snapshot.data()['dailyIntake'],
          snapshot.data()['email'],
          snapshot.data()['uid']);
    });
  }

  // creates a new daily entry list
  Future createNewEntry(
      String uid, String now, Map<String, dynamic> obj) async {
    obj[now] = {};
    userDailyIntakesCollection.doc(uid).set(obj);
  }

  Future checkCurrentDate(String uid, String now) async {
    DocumentSnapshot query = await userDailyIntakesCollection.doc(uid).get();
    if (!query.data().containsKey(now)) {
      createNewEntry(uid, now, query.data());
    }
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

  // updates the user daily goal
  void editGoal(String uid, String value) {
    userCollection.doc(uid).update({
      "dailyGoal" : value
    });

  }
}
