import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Staff extends StatefulWidget {
  @override
  _StaffState createState() => _StaffState();
}

TextEditingController name = TextEditingController();
TextEditingController phone = TextEditingController();

class _StaffState extends State<Staff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/dashboard.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black38,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 100,
              right: 100,
              top: 50,
            ),
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 300,
                  width: 800,
                  child: Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 25),
                          child: Text(
                            'Add Staff',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ttform(
                              "Enter Name",
                              name,
                            ),
                            ttform(
                              "Enter Phone No",
                              phone,
                            ),
                          ],
                        ),
                        Center(
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: () {},
                            color: Colors.green,
                            height: 55,
                            minWidth: 300,
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  child:Card( color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: StreamBuilder(
                          stream: Firestore.instance.collection('staff').snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.amber, strokeWidth: 1),
                                );
                              default:
                                return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: ListTile(
                                        title: Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                                      ),
                                    );
                                  },
                                );
                            }
                          },
                        ),
                  ),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }
}

ttform(String hint, TextEditingController tc) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 30),
    width: 280,
    child: TextFormField(
      controller: tc,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.text_fields,
          color: Colors.white,
        ),
        focusColor: Colors.black26,
        fillColor: Colors.black26,
        filled: true,
        hintText: hint,
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
  );
}
