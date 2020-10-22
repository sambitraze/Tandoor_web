import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandoor_hut/billing.dart';
import 'package:tandoor_hut/dashboard.dart';
import 'package:tandoor_hut/login.dart';
import 'package:tandoor_hut/managemenu.dart';
import 'package:tandoor_hut/messages.dart';
import 'package:tandoor_hut/orders.dart';
import 'package:tandoor_hut/staffpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 4;
  PageController pageController = PageController(
    initialPage: 4,
    keepPage: true,
  );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Row(
        children: <Widget>[
          NavigationRail(
            backgroundColor: Colors.black,
            selectedIconTheme: IconThemeData(color: Colors.white, size: 35),
            unselectedIconTheme:
                IconThemeData(color: Colors.grey[50], size: 35),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(
                () {
                  _selectedIndex = index;
                },
              );
              pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 600),
                curve: Curves.ease,
              );
            },
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo.png',
                height: 65,
              ),
            ),
            trailing: Padding(
              padding: EdgeInsets.all(4),
              child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut().whenComplete(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  });
                },
              ),
            ),
            labelType: NavigationRailLabelType.selected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.timeline),
                selectedIcon: Icon(Icons.timeline),
                label: Text(
                  'DashBoard',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.folder_open),
                selectedIcon: Icon(Icons.folder_open),
                label: Text(
                  'Orders',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.message),
                selectedIcon: Icon(Icons.message),
                label: Text(
                  'Message',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.local_dining),
                selectedIcon: Icon(Icons.local_dining),
                label: Text(
                  'Manage Menu',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart),
                selectedIcon: Icon(Icons.shopping_cart),
                label: Text(
                  'Staff',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt),
                selectedIcon: Icon(Icons.receipt),
                label: Text(
                  'Bill Maker',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              
            ],
          ),
          Expanded(
            child: PageView(
              scrollDirection: Axis.vertical,
              physics: new NeverScrollableScrollPhysics(),
              children: [
                DashBoard(),
                Orders(),
                Messages(),
                ManageMenu(),
                Staffpage(),
                Billing(),
              ],
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
