import 'package:chatapp/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  String? chatRoomId;
  String? userName;
  String? status;

  ChatRoom({this.chatRoomId, this.userName, this.status});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final firebasefireStore = FirebaseFirestore.instance;
  final messageController = TextEditingController();

  void onSendMessage() async {
    if (messageController.text != null) {
      Map<String, dynamic> messages = {
        "sendBy": widget.userName,
        "Message": messageController.text,
        "time": FieldValue.serverTimestamp()
      };
      messageController.clear();
      await firebasefireStore
          .collection("chatRoom")
          .doc(widget.chatRoomId)
          .collection("chats")
          .add(messages);
    } else {
      print("enter some text");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userName);
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Row(
          children: [
            Text(widget.userName!),
            SizedBox(
              width: 5,
            ),
            widget.status == "online"
                ? Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                  )
                : const Center()
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: firebasefireStore
                    .collection("chatRoom")
                    .doc(widget.chatRoomId)
                    .collection("chats")
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            final DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];

                            return Container(
                              alignment:
                                  widget.userName == documentSnapshot["sendBy"]
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.userName ==
                                              documentSnapshot["sendBy"]
                                          ? Color.fromARGB(255, 52, 41, 150)
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          right: 5,
                                          left: 5),
                                      child: Text(
                                        documentSnapshot["Message"],
                                        style: TextStyle(
                                            color: widget.userName ==
                                                    documentSnapshot["sendBy"]
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )),
                              ),
                            );
                          })),
                    );
                  } else {
                    return Center();
                  }
                })),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: SizedBox(
                height: 40,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: messageController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            onSendMessage();
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white)),
                      hintText: "Message",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white))),
                )),
          ),
        ],
      ),
    );
  }
}
