import 'package:chatapp/Modals/registrationModal.dart';
import 'package:chatapp/constants/colors.dart';
import 'package:chatapp/screens/ChatScreen.dart';
import 'package:chatapp/screens/SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({Key? key}) : super(key: key);
  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  bool? ispasswordVisible;
  bool? isconpasswordVisible;
  @override
  void initState() {
    super.initState();
    ispasswordVisible = false;
    isconpasswordVisible = false;
  }

  bool isverified = false;

  Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    user!.sendEmailVerification();
    setState(() {
      isverified = true;
    });
    user.reload();
    if (user.emailVerified) {
      user.reload();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (builder) => const ChatScreen()));

      setState(() {
        isverified = false;
      });
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final emailcontoller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();

  Widget FirstName() {
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
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value!.isEmpty) {
              return "First name can't be empty";
            } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
              return "correct your first name";
            } else {
              return null;
            }
          },
          controller: firstnamecontroller,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person,
              color: TextFieldColor,
            ),
            border: InputBorder.none,
            hintText: "First Name",
            hintStyle: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget LastName() {
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
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value!.isEmpty) {
              return "Last name can't be empty*";
            } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
              return "correct your last name";
            } else {
              return null;
            }
          },
          controller: lastnamecontroller,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: TextFieldColor,
            ),
            hintText: "Last Name",
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.white),
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
          style: TextStyle(color: Colors.white),
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
          controller: passwordcontroller,
          obscureText: !ispasswordVisible!,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    ispasswordVisible = !ispasswordVisible!;
                  });
                },
                icon: Icon(
                  ispasswordVisible! ? Icons.visibility : Icons.visibility_off,
                  color: TextFieldColor,
                )),
            prefixIcon: const Icon(
              Icons.key,
              color: TextFieldColor,
            ),
            hintText: "Password",
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget ConfirmPassword() {
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
          style: TextStyle(color: Colors.white),
          obscureText: !isconpasswordVisible!,
          validator: (value) {
            if (passwordcontroller.text != value) {
              return "Passwords are not matching";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isconpasswordVisible = !isconpasswordVisible!;
                  });
                },
                icon: Icon(
                  ispasswordVisible! ? Icons.visibility : Icons.visibility_off,
                  color: TextFieldColor,
                )),
            prefixIcon: const Icon(
              Icons.key,
              color: TextFieldColor,
            ),
            hintText: "Password",
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          controller: confirmpasswordcontroller,
        ),
      ),
    );
  }

  Future postUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      User? user = _auth.currentUser;
      RegistrationModal registrationModal = RegistrationModal();
      registrationModal.id = user!.uid;
      registrationModal.displayName = firstnamecontroller.text.trim();
      registrationModal.lastName = lastnamecontroller.text.trim();
      registrationModal.email = emailcontoller.text.trim();
      registrationModal.password = passwordcontroller.text.trim();
      registrationModal.confirmPassword = confirmpasswordcontroller.text.trim();
      await firestore
          .collection("Registration")
          .doc(user.uid)
          .set(registrationModal.toMap())
          .then((value) {});
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

  Future SignUP(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        postUserData();
      }).then((value) {});
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    emailcontoller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.maybeOf(context)!.size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainColor,
        body: isverified
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: MediaQuery.of(context).size.width / 4,
                      backgroundImage: AssetImage('Assets/images/logo.png'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              FirstName(),
                              const SizedBox(
                                height: 10,
                              ),
                              LastName(),
                              const SizedBox(
                                height: 10,
                              ),
                              Email(),
                              const SizedBox(
                                height: 10,
                              ),
                              Password(),
                              const SizedBox(
                                height: 10,
                              ),
                              ConfirmPassword(),
                              SizedBox(height: screenSize.height / 10),
                              NeumorphicButton(
                                margin: const EdgeInsets.only(top: 12),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    SignUP(emailcontoller.text.trim(),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Register",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    Icon(
                                      Icons.app_registration_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => SignIn()));
                                  },
                                  child: Text(
                                    "Already have an account?SignIn.",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ))
                  ],
                ),
              ),
      ),
    );
  }
}
