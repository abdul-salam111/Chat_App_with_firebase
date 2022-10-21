import 'package:auth_buttons/auth_buttons.dart';
import 'package:chatapp/Authentication/Auth.dart';
import 'package:chatapp/Authentication/SignIn.dart';
import 'package:chatapp/constants/colors.dart';
import 'package:chatapp/screens/ChatScreen.dart';
import 'package:chatapp/screens/ForgotPassword.dart';
import 'package:chatapp/screens/Registration.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final userSignIn = SignInUser();
  final authServices = AuthServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailcontoller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _ispasswordVisible = true;
  @override
  void initState() {
    super.initState();
    _ispasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: CircleAvatar(
                radius: ScreenSize.width / 4,
                backgroundImage: const AssetImage("Assets/images/logo.png"),
              ),
            ),
            SizedBox(
              height: ScreenSize.height / 9,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Email(),
                  const SizedBox(
                    height: 20,
                  ),
                  Password(),
                  const SizedBox(
                    height: 20,
                  ),
                  NeumorphicButton(
                      margin: const EdgeInsets.only(top: 12),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          userSignIn.signIn(emailcontoller.text.trim(),
                              passwordcontroller.text.trim());
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
                            "SignIn",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const UserRegistration()));
                    },
                    child: const Text(
                      "Don't have an account?",
                      style: TextStyle(color: TextFieldColor),
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const ForgotPassword()));
                  },
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(color: TextFieldColor),
                  ),
                )
              ],
            ),
            const Center(
              child: Text(
                "Or",
                style: TextStyle(
                    color: TextFieldColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Neumorphic(
              style: const NeumorphicStyle(
                depth: 1,
                shadowLightColor: TextFieldColor,
                color: mainColor,
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.stadium(),
              ),
              child: GoogleAuthButton(
                onPressed: () async {
                  await authServices.signinWithGoogle(context);
                },
                style: const AuthButtonStyle(
                    splashColor: TextFieldColor,
                    shadowColor: TextFieldColor,
                    width: double.infinity,
                    borderRadius: 50,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    buttonColor: mainColor,
                    iconType: AuthIconType.secondary,
                    height: 50),
              ),
            ),
          ],
        ),
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

  Widget Password() {
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
                return "password can't be empty";
              } else if (RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])$')
                  .hasMatch(value)) {
                return "Password should be of 8 characters";
              } else {
                return null;
              }
            },
            obscureText: !_ispasswordVisible,
            controller: passwordcontroller,
            decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _ispasswordVisible = !_ispasswordVisible;
                    });
                  },
                  icon: Icon(
                    _ispasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: TextFieldColor,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.key,
                  color: TextFieldColor,
                ),
                label: const Text("Password"),
                border: InputBorder.none)),
      ),
    );
  }
}
