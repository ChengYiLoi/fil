import 'package:fil/models/user.dart';
import 'package:fil/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj base on FirebaseUser

  // sign in with email & password

  Future signIn(String email, String password) async {
    try {
      dynamic result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      dynamic user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      dynamic user = result.user;
      // UserObj userObj = UserObj(uid: user.uid, email: user.email);
      await DatabaseService().createUserData(user.uid, user.email);
      return true;
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future singOut() async {
    await _auth.signOut();
  }
}
