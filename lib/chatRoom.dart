import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatroomId;
  final TextEditingController msg = TextEditingController();
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  final FirebaseAuth authc = FirebaseAuth.instance;

  void onsendData() async {
    if (msg.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendby': authc.currentUser.displayName,
        'msg': msg.text,
        'time': FieldValue.serverTimestamp(),
      };

      await fs
          .collection('chatroom')
          .doc(chatroomId)
          .collection('chats')
          .add(messages);
      msg.clear();
    } else {
      print('Enter Some Text');
    }
  }

  chatRoom(this.chatroomId, this.userMap);
  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(userMap['name']),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              height: Size.height / 1.25,
              width: Size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: fs
                      .collection('chatroom')
                      .doc(chatroomId)
                      .collection('chats')
                      .orderBy('time', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return Text(snapshot.data.docs[index]['msg']);
                          });
                    } else {
                      return Container();
                    }
                  })),
          Container(
            height: Size.height / 10,
            width: Size.width,
            alignment: Alignment.center,
            child: Container(
              height: Size.height / 12,
              width: Size.width / 1.2,
              child: Row(
                children: <Widget>[
                  Container(
                    height: Size.height / 17,
                    width: Size.width / 1.5,
                    child: TextField(
                      controller: msg,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send), onPressed: onsendData),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
