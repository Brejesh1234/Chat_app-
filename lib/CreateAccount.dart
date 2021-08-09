import 'package:chat_app/HomeScreen.dart';
import 'package:chat_app/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'mathods.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return Scaffold(
      body: isloading
          ? Center(
              child: Container(
                height: Size.height / 20,
                width: Size.width / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: Size.height / 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: Size.width / 1.3,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
                  ),
                  SizedBox(
                    height: Size.height / 20,
                  ),
                  Container(
                    width: Size.width / 1.1,
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: Size.width / 1.1,
                    child: Text(
                      'Create Account to Continue',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Size.height / 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: field(Size, 'Name', Icons.person, _name),
                  ),
                  SizedBox(height: Size.height / 50),
                  Container(
                    alignment: Alignment.center,
                    child: field(Size, 'Enter Username/Email',
                        Icons.account_box, _email),
                  ),
                  SizedBox(height: Size.height / 50),
                  Container(
                    alignment: Alignment.center,
                    child:
                        field(Size, 'Enter Password ', Icons.lock, _password),
                  ),
                  SizedBox(
                    height: Size.height / 15,
                  ),
                  customButton(Size),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
        onTap: () {
          if (_name.text.isNotEmpty &&
              _email.text.isNotEmpty &&
              _password.text.isNotEmpty) {
            setState(() {
              isloading = true;
            });

            createAccount(_name.text, _email.text, _password.text).then((user) {
              if (user != null) {
                setState(() {
                  isloading = false;
                });
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              } else {
                print('Registration Failed');
              }
            });
          } else {
            print('Please Enter Fields ');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          alignment: Alignment.center,
          height: size.height / 14,
          width: size.width / 2.2,
          child: Text(
            'Create Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      width: size.width / 1.1,
      height: size.height / 15,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
