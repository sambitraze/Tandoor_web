import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
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
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
          ),
          ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 100,
                ),
                title: Text('Item $index'),
              );
            },
          )
        ],
      ),
    );
  }
}
