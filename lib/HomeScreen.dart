import 'package:chat_app/chatRoom.dart';
import 'package:chat_app/mathods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> userMap;
  bool isloading = false;
  final TextEditingController search = TextEditingController();
  FirebaseAuth authc = FirebaseAuth.instance;
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void OnSearch() async {
    FirebaseFirestore fs = FirebaseFirestore.instance;
    setState(() {
      isloading = true;
    });
    await fs
        .collection('users')
        .where('email', isEqualTo: search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isloading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logOut(context),
          ),
        ],
      ),
      body: isloading
          ? Center(
              child: Container(
                height: Size.height / 20,
                width: Size.width / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  width: Size.width,
                  height: Size.height / 20,
                ),
                Container(
                  height: Size.height / 12,
                  width: Size.width / 1.2,
                  child: Container(
                    width: Size.width / 1.2,
                    height: Size.height / 10,
                    child: TextField(
                      controller: search,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Size.height / 50),
                ElevatedButton(
                  onPressed: OnSearch,
                  child: Text('Search'),
                ),
                SizedBox(
                  height: Size.height / 10,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          String roomId = chatRoomId(
                              authc.currentUser.displayName, userMap['name']);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => chatRoom(roomId, userMap),
                            ),
                          );
                        },
                        leading: Icon(Icons.account_box),
                        title: Text(
                          userMap['name'],
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(userMap['email']),
                        trailing: Icon(
                          Icons.chat,
                          color: Colors.blue,
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
