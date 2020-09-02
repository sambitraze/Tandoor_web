import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tandoor_hut/homepage.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void initState() {
    FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: "tandoorhut@admin.com", password: "Tandoor@a2020")
                          .whenComplete(() {
                       Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      });
                        
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/sign in.png'), fit: BoxFit.cover),
          )),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                // image: DecorationImage(image: AssetImage('assets/sign in.png'),fit: BoxFit.cover),
                ),
            child: Container(
              alignment: Alignment.center,
              height: 500,
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: (){
                          Toast.show("Version 1.06", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 300,
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: email,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        focusColor: Colors.black26,
                        fillColor: Colors.black26,
                        filled: true,
                        hintText: 'Enter Email',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white30,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white30,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 300,
                    alignment: Alignment.center,
                    child: TextFormField(
                      obscureText: true,
                      controller: password,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.text_format,
                          color: Colors.white,
                        ),
                        focusColor: Colors.black26,
                        fillColor: Colors.black26,
                        filled: true,
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white30,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.white30,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      AuthResult result = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text)
                          .whenComplete(() {
                        setState(() {
                          isLoading = false;
                        });
                      });
                      print(result);
                      if (result.user != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    },
                    minWidth: 300,
                    padding: EdgeInsets.all(8),
                    color: Colors.orange,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  isLoading ? CircularProgressIndicator() : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
