import 'dart:async';
import 'package:fil/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn();


  // Check if user has already signed in
  StreamSubscription isUserSignedIn() {
    return _auth.userChanges().listen((User user) {
      return user;
    });
  }

  // sign in with email & password

  Future signIn(String email, String password) async {
    email = email.replaceAll(" ", "");
    password = password.replaceAll(" ", "");
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with Google

  Future googleSignin() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    UserCredential userCred = (await _auth.signInWithCredential(credential));
    User user = userCred.user;

    dynamic result = await DatabaseService().queryUser(user.uid);

    if (!result) {
      await DatabaseService()
          .createUserData(user.uid, user.email, user.metadata.creationTime);
    }
    return userCred;
  }

  // register with email & password
  Future signUp(String email, String password) async {
    // check if user email already exist
    dynamic result = await DatabaseService().queryUserEmail(email);
    if (result) {
      print("user already exist");
      return false;
    } else {
      try {
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User user = userCred.user;
        // UserObj userObj = UserObj(uid: user.uid, email: user.email);
        await DatabaseService()
            .createUserData(user.uid, user.email, user.metadata.creationTime);
        return user;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  // sign out
  Future singOut() async {
    await _auth.signOut();
  }
}
