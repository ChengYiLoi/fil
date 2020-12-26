import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fil/models/user.dart';

class DatabaseService {
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference userDailyIntakesCollection =
      FirebaseFirestore.instance.collection("dailyIntakes");

  final String uid = "BJSgTu0rpAfgZuywxpAwZq2GhX72";

  // final String uid;

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
  void editGoal(int value) {
    userCollection.doc(uid).update({"dailyGoal": value.toString()});
  }

  // updates to user daily intake
  void addIntake(int value) {
    userCollection.doc(uid).update({
      "dailyIntake": FieldValue.arrayUnion([value.toString()])
    });
  }

  // retrieves the user's reminders
  Stream<Map<String, dynamic>> queryReminders(String uid) {
    return userCollection.doc(uid).snapshots().map((snapshot) {
      return snapshot.data()['reminders'];
    });
  }

  // add a new reminder
  void addReminder(String time, String amount) {
    userCollection.doc(uid).update({"reminders.$time": {
      "amount" : amount,
      "isAlarm" : false
    }});
  }

  // updates the isAlarm boolean
  void updateIsAlarm(String time, bool boolean) {
    userCollection.doc(uid).update({"reminders.$time.isAlarm": boolean});
  }

  // update the reminder information
  void updateReminder(String oldTime, String newTime, String amount) {
    userCollection
        .doc(uid)
        .update({"reminders.$oldTime": FieldValue.delete()}).then(
            (_) => addReminder(newTime, amount));
  }
}
