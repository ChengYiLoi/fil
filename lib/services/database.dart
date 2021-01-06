import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fil/models/user.dart';
import 'package:fil/services/uploader.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService with ChangeNotifier {
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference userDailyIntakesCollection =
      FirebaseFirestore.instance.collection("dailyIntakes");
  final CollectionReference markerCollection =
      FirebaseFirestore.instance.collection("markers");

  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection("recipes");

  final String uid;

  DatabaseService({this.uid});

  DocumentSnapshot lastDocument;

  getUid() {
    return this.uid;
  }

  // final String uid;

  Stream<UserObj> queryUserData() {
    print("Query user stream");
    return userCollection.doc(uid).snapshots().map((snapshot) {
      return UserObj(
          snapshot.data()['creationTime'],
          snapshot.data()['dailyGoal'],
          snapshot.data()['dailyIntake'],
          snapshot.data()['email'],
          snapshot.data()['recipeFavs'],
          snapshot.data()['reminders'],
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
  Stream<Map<String, dynamic>> queryReminders() {
    return userCollection.doc(uid).snapshots().map((snapshot) {
      return snapshot.data()['reminders'];
    });
  }

  // add a new reminder
  void addReminder(String time, String amount) {
    userCollection.doc(uid).update({
      "reminders.$time": {"amount": amount, "isAlarm": false}
    });
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

  // delete reminder
  void deleteReminder(String time) {
    userCollection.doc(uid).update({"reminders.$time": FieldValue.delete()});
  }

  // returns the list of refill station's lat & lng
  Stream getMarkers() {
    return markerCollection.snapshots();
  }

  // Create marker
  void createMarker(String description, LatLng location, File file) {
    if (description == "") {
      description = null;
    }
    markerCollection.add({
      "description": description,
      "lat": location.latitude,
      "lng": location.longitude
    }).then((value) {
      String markerId = value.id;
      Uploader uploader = Uploader(file: file, id: markerId);
      uploader.uploadImage();
    });
  }

  // Retrieve recepies
  Future<QuerySnapshot> getRecipes() async {
    print('get recipes ran');

    return await recipeCollection
        .orderBy('name')
        .limit(6)
        .get()
        .then((QuerySnapshot qSnapshot) {
      List<DocumentSnapshot> documents = qSnapshot.docs;
      lastDocument = documents[documents.length - 1];
      return qSnapshot;
    });
  }

  // Retrieve additional recepies
  Future<QuerySnapshot> getAdditionalRecipes(String id) {
    return recipeCollection
        .orderBy('name')
        .startAfterDocument(lastDocument)
        .limit(6)
        .get();
  }

  // Get the last recipe id (order by descending) so the pagination can check
  // if the last recipe in the ui matches with the last recipe id in the DB
  // if matches, the function to get additional recipes will not run
  Future<QuerySnapshot> getLastRecipe() {
    return recipeCollection.orderBy('name', descending: true).limit(1).get();
  }

  // Retrieve recipes that are favourite by the user
  Future<QuerySnapshot> getFavRecipes(List id) {
    return recipeCollection.where(FieldPath.documentId, whereIn: id).get();
  }

  // Update the user favourite recipe
  void updateFavRecipe(String id, String operation) {
    if (operation == 'delete') {
      userCollection.doc(uid).update({
        "recipeFavs": FieldValue.arrayRemove([id])
      });
    } else {
      userCollection.doc(uid).update({
        "recipeFavs": FieldValue.arrayUnion([id])
      });
    }
  }
}
