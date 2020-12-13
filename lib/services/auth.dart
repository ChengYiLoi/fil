import 'package:fil/models/user.dart';
import 'package:fil/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

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
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User user = result.user;
        // UserObj userObj = UserObj(uid: user.uid, email: user.email);
        await DatabaseService()
            .createUserData(user.uid, user.email, user.metadata.creationTime);
        return result;
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
