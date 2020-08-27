import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
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
                    color: Colors.white60,
                  ), 
                  Container(
                    alignment: Alignment.center,
child: Image.asset('assets/cons.png',height: 500,fit: BoxFit.cover,),
                  )

        ],
      ),
    );
  }
}