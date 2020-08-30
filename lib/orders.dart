import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

stat(int a) {
  if (a == 0)
    return "placed";
  else if (a > 0 && a < 10)
    return "Confirmed";
  else
    return "Out for";
}

class _OrdersState extends State<Orders> {
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
            padding: EdgeInsets.all(20),
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('BillList')
                        .orderBy("date", descending: true)
                        .limit(20)
                        .snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.amber, strokeWidth: 1),
                          );
                        default:
                          return ListView.builder(
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ListTile(
                                  leading: Text(
                                    'Order No: ' +
                                        snapshot
                                            .data.documents[index]['bill_no']
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  title: Text(snapshot
                                      .data.documents[index]['item']
                                      .toString()),
                                  subtitle: Text('delivery to'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(snapshot
                                          .data.documents[index]['total']
                                          .toString()),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text('payment : ' +
                                          snapshot
                                              .data.documents[index]['payment']
                                              .toString()),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      RaisedButton.icon(
                                        label: Text(
                                            'Delivery boy: ${stat(index)}'),
                                        icon: Icon(Icons.delivery_dining),
                                        onPressed: () {},
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      RaisedButton.icon(
                                        label: Text('Status: ${stat(index)}'),
                                        icon: Icon(Icons.settings_phone_sharp),
                                        onPressed: () {},
                                        color: Colors.blueAccent,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      RaisedButton(
                                        onPressed: () {},
                                        child: Text('cancel'),
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                      }
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
