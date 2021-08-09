import 'package:chat_app/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<User> createAccount(String name, String email, String password) async {
  FirebaseAuth authc = FirebaseAuth.instance;
  FirebaseFirestore fs = FirebaseFirestore.instance;

  try {
    User user = (await authc.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("Account Created Succesfull");
      user.updatePhotoURL(name);

      fs.collection('users').doc(authc.currentUser.uid).set({
        "name": name,
        "email": email,
        "status": 'unavailable',
      });
      return user;
    } else {
      print('Account Creation failed');
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User> login(String email, String password) async {
  FirebaseAuth authc = FirebaseAuth.instance;
  try {
    User user = (await authc.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("Login Successfull");
      return user;
    } else {
      print('Login failed');
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth authc = FirebaseAuth.instance;

  try {
    await authc.signOut().then((user) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  } catch (e) {
    print('error');
  }
}
