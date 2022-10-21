import 'package:chatapp/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final firebaseAuth = FirebaseAuth.instance;
  void resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
              msg: "Verification has been successfully send to Gmail!")
          .then((value) {
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailcontoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: ScreenSize.width / 4,
              backgroundImage: const AssetImage("Assets/images/logo.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Email(),
                    NeumorphicButton(
                        margin: const EdgeInsets.only(top: 12),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            resetPassword(emailcontoller.text.trim());
                          }
                        },
                        style: const NeumorphicStyle(
                          depth: 1,
                          shadowLightColor: TextFieldColor,
                          color: mainColor,
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.stadium(),
                        ),
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Send Verification",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.send_sharp,
                              color: Colors.white,
                            ),
                          ],
                        )),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget Email() {
    return Neumorphic(
      style: const NeumorphicStyle(
        depth: 1,
        shadowLightColor: TextFieldColor,
        color: mainColor,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.stadium(),
      ),
      child: SizedBox(
        height: 50,
        child: TextFormField(
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value!.isEmpty) {
                return "Email can't be empty";
              } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return "Please enter valid email address";
              }
            },
            controller: emailcontoller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: InputBorder.none,
              label: Text("Email"),
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(
                Icons.email,
                color: TextFieldColor,
              ),
            )),
      ),
    );
  }
}
