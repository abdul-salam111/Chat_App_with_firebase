import 'package:chatapp/Authentication/Auth.dart';
import 'package:chatapp/constants/colors.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  String? userName, email;
  MyAccount({this.userName, this.email});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: mainColor),
              accountName: Text(
                widget.userName.toString(),
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text(widget.email.toString()),
              currentAccountPictureSize: const Size.square(50),
              currentAccountPicture: CircleAvatar(
                backgroundColor: TextFieldColor,
                child: Text(
                  widget.userName![0].toString().toUpperCase(),
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text(' My Course '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text(' Go Premium '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_label),
            title: const Text(' Saved Videos '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(' Edit Profile '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              auth.googleSignOut(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  AuthServices auth = AuthServices();
}
