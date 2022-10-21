import 'package:chatapp/constants/colors.dart';
import 'package:chatapp/screens/ChatRoom.dart';
import 'package:chatapp/widgets/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  bool? longPress = false;
  final CollectionReference Users =
      FirebaseFirestore.instance.collection("Registration");
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
    WidgetsBinding.instance.addObserver(this);
    setstate("online");
  }

  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setstate("online");
    } else {
      setstate("offline");
    }
  }

  String? userName;
  String? email;
  Map<String, dynamic>? data;
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  void getuserdata() async {
    var collection = FirebaseFirestore.instance.collection('Registration');
    var docSnapshot = await collection.doc(userUid).get();
    if (docSnapshot.exists) {
      data = docSnapshot.data()!;
      setState(() {
        if (mounted) {
          userName = data!['displayName'];
          email = data!["email"];
        }
      });
    }
  }

  var snackBar = const SnackBar(content: CircularProgressIndicator());
  bool isloading = false;
  final searchController = TextEditingController();
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  final firebaseSearch = FirebaseFirestore.instance;
  bool isSearch = false;
  String? idForDelete;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyAccount(
          userName: userName,
          email: email,
        ),
        appBar: AppBar(
          backgroundColor: mainColor,
          title: isSearch
              ? TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    setState(() {
                      searchController.text = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2))))
              : const Text("Let's Talk"),
          centerTitle: true,
          actions: [
            isSearch
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = false;
                      });
                    },
                    icon: const Icon(Icons.cancel))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = true;
                      });
                    },
                    icon: const Icon(Icons.search)),
            longPress!
                ? IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("chatRoom")
                          .doc(idForDelete)
                          .delete();
                      setState(() {
                        longPress = false;
                      });
                    },
                    icon: const Icon(Icons.delete),
                  )
                : const Center()
          ],
        ),
        body: isSearch
            ? StreamBuilder<QuerySnapshot>(
                stream: firebaseSearch.collection("Registration").snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (searchController.text.isEmpty) {
                    return const Center();
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          var data = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          if (data["displayName"]
                              .toString()
                              .toLowerCase()
                              .startsWith(
                                  searchController.text.toLowerCase())) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSearch = false;
                                });
                                String roomId =
                                    chatRoomId(userName!, data["displayName"]);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ChatRoom(
                                              chatRoomId: roomId,
                                              userName: data["displayName"] +
                                                  data["lastName"],
                                            )));
                              },
                              child: ListTile(
                                title: Text(data["displayName"]),
                                leading: const Icon(Icons.person),
                                subtitle: Text(data["email"]),
                                trailing: const Icon(Icons.chat_bubble),
                              ),
                            );
                          } else {
                            return const Center();
                          }
                        }));
                  }
                }))
            : Container(
                height: double.infinity,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Users.snapshots(),
                  builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Something went wrong"),
                      );
                    } else if (snapshot.hasData) {
                      return GestureDetector(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];
                              return GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    longPress = true;
                                  });
                                  idForDelete = chatRoomId(userName!,
                                      documentSnapshot["displayName"]);
                                },
                                onTap: () {
                                  String roomId = chatRoomId(userName!,
                                      documentSnapshot["displayName"]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => ChatRoom(
                                                userName: documentSnapshot[
                                                        "displayName"] +
                                                    documentSnapshot[
                                                        "lastName"],
                                                chatRoomId: roomId,
                                                status:
                                                    documentSnapshot["status"],
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 8, left: 8),
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: mainColor.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            documentSnapshot["displayName"] +
                                                " " +
                                                documentSnapshot["lastName"],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          documentSnapshot["status"] == "online"
                                              ? Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                )
                                              : const Center()
                                        ],
                                      ),
                                      leading: CircleAvatar(
                                          backgroundColor: mainColor,
                                          child: Text(
                                            documentSnapshot["displayName"][0],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      subtitle: Text(
                                        documentSnapshot["email"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      trailing: const Icon(
                                        Icons.chat_bubble,
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: const CircularProgressIndicator());
                    } else {
                      return const Center(
                        child: const Text("sorry"),
                      );
                    }
                  }),
                )));
  }
}
