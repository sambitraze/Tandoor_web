import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:uuid/uuid.dart';

final menuItemColRef = Firestore.instance.collection('MenuItems');

class ManageMenu extends StatefulWidget {
  @override
  _ManageMenuState createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
  bool isveg;
  TextEditingController itemName = TextEditingController();
  TextEditingController price = TextEditingController();
  String type;
  String id;
  bool loading = false;

  delitem(String idd){
    Firestore.instance.collection('MenuItems').document(idd).delete();
  }

  indlist(String type) {
    return Container(
      alignment: Alignment.center,
      height: 450,
      width: 300,
      child: StreamBuilder<QuerySnapshot>(
        stream: menuItemColRef
            .where("Item_Type", isEqualTo: type)
            .getDocuments()
            .asStream(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // count of events
          final int eventCount = snapshot.data.documents.length;
          print(eventCount);
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return new ListView.builder(
                itemCount: eventCount,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document =
                      snapshot.data.documents[index];
                  return new ListTile(
                    title: Text(document.data['Item_Name'].toString()),
                    trailing: Text('Rs ' + document.data['Price'].toString()),
                    leading: IconButton(icon: (Icon(Icons.cancel)), onPressed: (){
                      print(document.documentID);
                      delitem(document.documentID);
                    }),
                  );
                },
              );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/dashboard.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 100,
          right: 100,
          top: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black38,
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Manage\nMenu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black38,
                    ),
                    padding: EdgeInsets.all(12),
                    child: DigitalClock(
                      areaDecoration: BoxDecoration(color: Colors.transparent),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              indent: 05,
              endIndent: 20,
              height: 10,
              thickness: 5,
              color: Colors.white,
            ),
            Expanded(
              child: Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Color.fromRGBO(206, 206, 206, 1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 100,
                                  width: 250,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    controller: itemName,
                                    decoration: InputDecoration(
                                      focusColor: Colors.white,
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'Item Name',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: DropdownButton(
                                    value: type,
                                    focusColor: Colors.white,
                                    hint: Text('Menu Type'),
                                    items: [
                                      DropdownMenuItem(
                                        child: Text('Tandoor'),
                                        value: 'Tandoor',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Main Course'),
                                        value: 'Main Course',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Chinese Main Course'),
                                        value: 'Chinese Main Course',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Rice/Biryani'),
                                        value: 'Rice/Biryani',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Noodles'),
                                        value: 'Noodles',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Rolls and Momos'),
                                        value: 'Rolls and Momos',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Salads & Raita'),
                                        value: 'Salads & Raita',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Breads'),
                                        value: 'Breads',
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (this.mounted) {
                                        setState(() {
                                          type = value.toString();
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: EdgeInsets.all(8),
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: DropdownButton(
                                    focusColor: Colors.white,
                                    value: isveg,
                                    hint: Text('Veg/Non Veg'),
                                    items: [
                                      DropdownMenuItem(
                                        child: Text('Veg'),
                                        value: true,
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Non-Veg'),
                                        value: false,
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (this.mounted) {
                                        setState(() {
                                          isveg = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    controller: price,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.money_off),
                                      focusColor: Colors.white,
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'Price',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    print('sdadaf');
                                    id = Uuid().v4();
                                    print('use ' + id);
                                    menuItemColRef.document(id).setData({
                                      'Id': id.toString(),
                                      'Is_Veg': isveg,
                                      'Item_Name': itemName.text,
                                      'Item_Type': type,
                                      'Price': price.text,
                                      'Ratting': 5,
                                      'url': 'google.com'
                                    }).whenComplete(() {
                                      setState(() {
                                        loading = false;
                                      });
                                    });
                                    id = Uuid().v4();
                                    print('new ' + id);
                                  },
                                  child: Text(
                                    'Add Item',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  color: Colors.orange,
                                  padding: EdgeInsets.all(18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                loading
                                    ? CircularProgressIndicator()
                                    : Container(),
                                Icon(Icons.local_dining, size: 100)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.all(50.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        alignment: Alignment.center,
                                        color: Colors.orange[400],
                                        child: Text(
                                          'Tandoor',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      indlist('Tandoor')
                                    ],
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        alignment: Alignment.center,
                                        color: Colors.orange[400],
                                        child: Text(
                                          'Main Course',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      indlist('Main Course')
                                    ],
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        alignment: Alignment.center,
                                        color: Colors.orange[400],
                                        child: Text(
                                          'Chinese Main Course',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      indlist('Chinese Main Course')
                                    ],
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        alignment: Alignment.center,
                                        color: Colors.orange[400],
                                        child: Text(
                                          'Rice/Biryani',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      indlist('Rice/Biryani')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.all(50.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        alignment: Alignment.center,
                                        color: Colors.orange[400],
                                        child: Text(
                                          'Noodles',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      indlist('Noodles')
                                    ],
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        alignment: Alignment.center,
                                        color: Colors.orange[400],
                                        child: Text(
                                          'Breads',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      indlist('Breads')
                                    ],
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        alignment: Alignment.center,
                                        color: Colors.orange[400],
                                        child: Text(
                                          'Rolls and Momos',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      indlist('Rolls and Momos')
                                    ],
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        alignment: Alignment.center,
                                        color: Colors.orange[400],
                                        child: Text(
                                          'Salads & Raita',
                                          style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      indlist('Salads & Raita')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
