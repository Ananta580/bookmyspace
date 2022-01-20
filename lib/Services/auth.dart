import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      var user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('user', [
          user.displayName ?? user.email!,
          user.photoURL ??
              "https://static.platzi.com/media/tmp/class-files/git/curso-flutter-platzi/Curso-de-Flutter-en-Platzi-6.ImagenRedonda/platzi_trips_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png"
        ]);
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "User with this credential doesn't exist");
        return false;
      }
      Fluttertoast.showToast(msg: ex.message.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      var user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('user', [
          user.displayName ?? user.email!,
          user.photoURL ?? "shorturl.at/brzH1"
        ]);
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (ex) {
      Fluttertoast.showToast(msg: ex.message.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      var _googleSignIn = GoogleSignIn();
      GoogleSignInAccount? res = await _googleSignIn.signIn();
      if (res != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('user', [res.displayName!, res.photoUrl!]);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  void signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      var _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (error) {}
  }
}
