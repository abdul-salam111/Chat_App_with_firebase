import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInUser {
  final firebase = FirebaseAuth.instance;
  Future<void> signIn(email, password) async {
    try {
      await firebase.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.TOP);
    }
  }
}
