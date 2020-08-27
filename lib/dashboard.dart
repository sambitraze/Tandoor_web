import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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