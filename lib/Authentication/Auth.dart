import 'package:chatapp/screens/ChatScreen.dart';
import 'package:chatapp/screens/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  handleState() {
    try {
      return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("something went wrong"),
              );
            } else if (snapshot.hasData) {
              return ChatScreen();
            } else {
              return SignIn();
            }
          });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  signinWithGoogle(context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn(scopes: <String>["email"]).signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (err) {
      Fluttertoast.showToast(msg: err.message!);
    }
  }

  googleSignOut(context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Fluttertoast.showToast(msg: "SignOut", toastLength: Toast.LENGTH_LONG);
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }
}
